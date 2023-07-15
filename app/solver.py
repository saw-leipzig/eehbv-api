import copy
import time
from math import *  # for exec calls of conditions


def call_solver(loss_func, model, data):
    solver = DependentAggregatesSolver(loss_func, model, data)
    return solver.solve()


class IndependentAggregatesSolver:

    def __init__(self, loss_func, model, data):
        self.loss_func = loss_func
        self.model = model
        self.data = data
        self.cl = {}
        self.weighted_losses = {}
        self.weighted_losses_per_profile = {}
        self.indices = {}
        self.opts = []
        self.cost_opts = []
        self.selects = 0
        self.satisfied = 0
        self.timing = 0.0
        self.deepest_failed_restriction = {'depth': 0, 'restriction': ''}
        self.parameters = {}
        for general_key in model['general_parameters']:
            self.parameters[general_key] = model["general_parameters"][general_key]

    def solve(self):
        tic = time.perf_counter()
        components = self.model['components']
        self.update_losses({}, 0)
        self.wander_tree(1, components, {})
        print('selected')
        print(self.selects)
        print('satisfied')
        print(self.satisfied)
        self.timing += time.perf_counter() - tic
        print('timing')
        print(self.timing)
        return self.opts, self.cost_opts, self.deepest_failed_restriction, 'no special remarks'

    def wander_tree(self, depth, components, combination):
        current_comp_type = self.data[components[0]['component_api_name']]
        # print('wander_tree - ' + str(depth))
        # select new component
        for index, comp in enumerate(current_comp_type):
            var_name = components[0]['variable_name']
            self.indices[var_name] = index
            new_combination = {**combination, var_name: comp}
            self.selects += 1
            cd = self.conditions_satisfied(new_combination, depth)
            if cd:
                self.update_losses(new_combination, depth)
                # recursive decision
                if len(components) > 1:
                    new_components = copy.copy(components)
                    new_components.pop(0)
                    self.wander_tree(depth + 1, new_components, new_combination)
                else:
                    self.summarize_and_check_results(new_combination)

    def update_losses(self, combinations, depth):
        lfs = self.loss_func
        if depth > 0:
            self.satisfied += 1
        # unpack variables
        p = self.parameters
        # eval losses to evaluated after newly selected component
        for lf in self.model['loss_functions']:
            if lf['eval_after_position'] == depth:
                exec('self.cl["' + lf['variable_name'] + '"] = []')  # reset loss list
                for pos in range(len(self.model['process_profiles'])):
                    for parameter_key in self.model['process_profiles'][pos].keys():
                        p[parameter_key] = self.model["process_profiles"][pos][parameter_key]
                    # unpack previously evaluated losses
                    l = {}
                    for current_losses_key in self.cl.keys():
                        if current_losses_key != lf['variable_name']:
                            l[current_losses_key] = self.cl[current_losses_key][pos]
                    # eval current loss
                    # print('EXEC ' + lf['variable_name'] + ' = ' + lf['function_call'])
                    try:
                        exec(lf['variable_name'] + ' = ' + lf['function_call'])
                    except Exception as ex:
                        passed_vars = passed_parameters(lf['function_call'], False, p, l, combinations)
                        raise Exception('Error in evaluating function {fd} - "{fc}"; passed parameters: {pp}; error: {err}'.
                                        format(fd=lf['description'], fc=lf['function_call'], pp=passed_vars, err=str(ex)))
                    # ToDo: view group
                    # pack current loss for deeper levels
                    exec('self.cl["' + lf['variable_name'] + '"].append(' + lf['variable_name'] + ')')

    def conditions_satisfied(self, combinations, depth):
        # noinspection DuplicatedCode
        p = self.parameters
        # check request conditions
        for pos in range(len(self.model['process_profiles'])):  # conditions have to be fulfilled for all profiles
            for parameter_key in self.model['process_profiles'][pos].keys():
                p[parameter_key] = self.model["process_profiles"][pos][parameter_key]
            l = {}
            for current_losses_key in self.cl.keys():
                l[current_losses_key] = self.cl[current_losses_key][pos]
            for cond in self.model['conditions']:
                try:
                    result = eval(cond)
                    if not result:
                        # print('Condition evaluated to False: ' + cond)
                        return False
                except NameError as ex:  # conditions with missing vars have to be evaluated at a deeper level
                    pass    # print('Condition parameter not defined: ' + ex.args[0])
                except Exception as ex:
                    passed_vars = passed_parameters(cond, True, p, l, combinations)
                    raise Exception('Error in evaluating condition "{fd}"; parameters: {pp}; error: {err}'.
                                    format(fd=cond, pp=passed_vars, err=str(ex)))
            # check implicit conditions
            for restr in self.model['restrictions']:
                if depth == restr['eval_after_position']:
                    try:
                        result = eval(restr['restriction'])
                        if not result:
                            if depth > self.deepest_failed_restriction['depth']:
                                self.deepest_failed_restriction['depth'] = depth
                                self.deepest_failed_restriction['restriction'] = restr['description']
                            return False
                    except NameError as ex:
                        print('Condition parameter not defined: ' + ex.args[0])
                    except Exception as ex:
                        passed_vars = passed_parameters(restr['restriction'], True, p, l, combinations)
                        raise Exception('Error in evaluating restriction {fd} - "{fc}"; parameters: {pp}; error: {err}'.
                                        format(fd=restr['description'], fc=restr['restriction'], pp=passed_vars, err=str(ex)))
        return True

    def summarize_and_check_results(self, combination):
        # new part
        total = self.sum_losses()
        # costs optimization
        acquisition_costs = self.update_cost_opts(combination, total) if self.model['result_settings']['costs_opt'][
            'exec'] else None
        # sort current combination in optimal solutions
        self.update_opts(total, acquisition_costs)

    def sum_losses(self):
        total = 0
        for current_losses_key in self.cl.keys():
            if self.function_is_loss(current_losses_key):
                self.weighted_losses_per_profile[current_losses_key] = [clk * profile['portion'] / 1000. for clk, profile     # to kWh
                                                                        in zip(self.cl[current_losses_key], self.model['process_profiles'])]
                self.weighted_losses[current_losses_key] = sum(self.weighted_losses_per_profile[current_losses_key])
                # self.weighted_losses[current_losses_key] = sum(clk * profile['portion'] / 1000. for clk, profile     # to kWh
                #                                                in zip(self.cl[current_losses_key], self.model['process_profiles']))
                total += self.weighted_losses[current_losses_key]
        return total

    def update_cost_opts(self, combination, total):
        acquisition_costs = sum(comp['price'] for comp in combination.values()) + self.model['result_settings']['costs_opt']['assembly_costs']
        energy_costs = total * self.model['result_settings']['costs_opt']['price_kwh'] * self.model['result_settings']['costs_opt']['amortisation_time']
        inserted = False
        for pos, old_opt in enumerate(self.cost_opts):
            if old_opt['total_costs'] > acquisition_costs + energy_costs:
                self.cost_opts.insert(pos, self.build_cost_opt(total, acquisition_costs, energy_costs))
                inserted = True
                if len(self.cost_opts) > int(self.model['result_settings']['n_list']):
                    self.cost_opts.pop()
                break
        if len(self.cost_opts) < int(self.model['result_settings']['n_list']) and not inserted:
            self.cost_opts.append(self.build_cost_opt(total, acquisition_costs, energy_costs))
        return acquisition_costs

    def build_cost_opt(self, total, acquisition_costs, energy_costs):
        return {'total_costs': acquisition_costs + energy_costs,
                'acquisition_costs': acquisition_costs,
                'energy_costs': energy_costs,
                'total': total,
                'partials': {val[1]: {'value': val[0], 'aggregate': val[2]} for val in
                             self.partial_generator()},
                'indices': copy.copy(self.indices)}

    def update_opts(self, total, acquisition_costs):
        inserted = False
        for pos, old_opt in enumerate(self.opts):
            if old_opt['total'] > total:
                self.opts.insert(pos, self.build_opt(total, acquisition_costs))
                inserted = True
                if len(self.opts) > int(self.model['result_settings']['n_list']):
                    self.opts.pop()
                break
        if len(self.opts) < int(self.model['result_settings']['n_list']) and not inserted:
            self.opts.append(self.build_opt(total, acquisition_costs))

    def build_opt(self, total, acquisition_costs):
        return {'acquisition_costs': acquisition_costs,
                'total': round(total),
                'partials': {val[1]: {'value': round(val[0]), 'aggregate': val[2], 'per_profile': [round(pp) for pp in val[3]]} for val in
                             self.partial_generator()},
                'indices': copy.copy(self.indices)}

    def description_and_aggregate_from_variable(self, var):
        function_by_var = next(lf for lf in self.model['loss_functions'] if lf['variable_name'] == var)
        return [function_by_var['description'], function_by_var['aggregate']]

    def function_is_loss(self, var):
        return all(lf['is_loss'] for lf in self.model['loss_functions'] if lf['variable_name'] == var)

    def partial_generator(self):
        for key in self.weighted_losses.keys():
            yield [self.weighted_losses[key]] + self.description_and_aggregate_from_variable(key) +\
                  [self.weighted_losses_per_profile[key]]

    def get_remarks(self):
        if len(self.model['process_profiles']) > 1 and 'p_feed_speed' in self.model['process_profiles'][0]:
            return 'p_feed_speed'
        return 'no special remarks'


class DependentAggregatesSolver:

    def __init__(self, loss_func, model, data):
        self.loss_func = loss_func
        self.model = model
        self.data = data
        self.cl = {}
        self.weighted_losses = {}
        self.weighted_losses_per_profile = {}
        self.indices = {}
        self.opts = []
        self.cost_opts = []
        self.selects = 0
        self.satisfied = 0
        self.timing = 0.0
        self.deepest_failed_restriction = {'depth': 0, 'restriction': ''}
        self.parameters = {}
        for general_key in model['general_parameters']:
            self.parameters[general_key] = model["general_parameters"][general_key]

    def solve(self):
        tic = time.perf_counter()
        components = self.model['components']
        self.update_losses({}, 0)
        self.wander_tree(1, components, {})
        print('selected')
        print(self.selects)
        print('satisfied')
        print(self.satisfied)
        self.timing += time.perf_counter() - tic
        print('timing')
        print(self.timing)
        return self.opts, self.cost_opts, self.deepest_failed_restriction, 'no special remarks'

    def wander_tree(self, depth, components, combination):
        current_comp_type = self.data[components[0]['component_api_name']]
        # print('wander_tree - ' + str(depth))
        # select new component
        for index, comp in enumerate(current_comp_type):
            var_name = components[0]['variable_name']
            self.indices[var_name] = index
            new_combination = {**combination, var_name: comp}
            self.selects += 1
            cd = self.conditions_satisfied(new_combination, depth)
            if cd:
                self.update_losses(new_combination, depth)
                # recursive decision
                if len(components) > 1:
                    new_components = copy.copy(components)
                    new_components.pop(0)
                    self.wander_tree(depth + 1, new_components, new_combination)
                else:
                    self.summarize_and_check_results(new_combination)

    def update_losses(self, combinations, depth):
        lfs = self.loss_func
        if depth > 0:
            self.satisfied += 1
        # unpack variables
        p = self.parameters
        # eval losses to evaluated after newly selected component
        for lf in self.model['loss_functions']:
            if lf['eval_after_position'] == depth:
                exec('self.cl["' + lf['variable_name'] + '"] = []')  # reset loss list
                for pos in range(len(self.model['process_profiles'])):
                    for parameter_key in self.model['process_profiles'][pos].keys():
                        p[parameter_key] = self.model["process_profiles"][pos][parameter_key]
                    # unpack previously evaluated losses
                    l = {}
                    for current_losses_key in self.cl.keys():
                        if current_losses_key != lf['variable_name']:
                            l[current_losses_key] = self.cl[current_losses_key][pos]
                    # eval current loss
                    try:
                        exec(lf['variable_name'] + ' = ' + lf['function_call'])
                    except Exception as ex:
                        passed_vars = passed_parameters(lf['function_call'], False, p, l, combinations)
                        raise Exception('Error in evaluating function {fd} - "{fc}"; passed parameters: {pp}; error: {err}'.
                                        format(fd=lf['description'], fc=lf['function_call'], pp=passed_vars, err=str(ex)))
                    # ToDo: view group
                    # pack current loss for deeper levels
                    exec('self.cl["' + lf['variable_name'] + '"].append(' + lf['variable_name'] + ')')

    def conditions_satisfied(self, combinations, depth):
        # noinspection DuplicatedCode
        p = self.parameters
        # check request conditions
        for pos in range(len(self.model['process_profiles'])):  # conditions have to be fulfilled for all profiles
            for parameter_key in self.model['process_profiles'][pos].keys():
                p[parameter_key] = self.model["process_profiles"][pos][parameter_key]
            l = {}
            for current_losses_key in self.cl.keys():
                l[current_losses_key] = self.cl[current_losses_key][pos]
            for cond in self.model['conditions']:
                try:
                    result = eval(cond)
                    if not result:
                        # print('Condition evaluated to False: ' + cond)
                        return False
                except NameError as ex:  # conditions with missing vars have to be evaluated at a deeper level
                    pass    # print('Condition parameter not defined: ' + ex.args[0])
                except Exception as ex:
                    passed_vars = passed_parameters(cond, True, p, l, combinations)
                    raise Exception('Error in evaluating condition "{fd}"; parameters: {pp}; error: {err}'.
                                    format(fd=cond, pp=passed_vars, err=str(ex)))
            # check implicit conditions
            for restr in self.model['restrictions']:
                if depth == restr['eval_after_position']:
                    try:
                        result = eval(restr['restriction'])
                        if not result:
                            if depth > self.deepest_failed_restriction['depth']:
                                self.deepest_failed_restriction['depth'] = depth
                                self.deepest_failed_restriction['restriction'] = restr['description']
                            return False
                    except NameError as ex:
                        print('Condition parameter not defined: ' + ex.args[0])
                    except Exception as ex:
                        passed_vars = passed_parameters(restr['restriction'], True, p, l, combinations)
                        raise Exception('Error in evaluating restriction {fd} - "{fc}"; parameters: {pp}; error: {err}'.
                                        format(fd=restr['description'], fc=restr['restriction'], pp=passed_vars, err=str(ex)))
        return True

    def summarize_and_check_results(self, combination):
        # new part
        total = self.sum_losses()
        # costs optimization
        acquisition_costs = self.update_cost_opts(combination, total) if self.model['result_settings']['costs_opt'][
            'exec'] else None
        # sort current combination in optimal solutions
        self.update_opts(total, acquisition_costs)

    def sum_losses(self):
        total = 0
        for current_losses_key in self.cl.keys():
            if self.function_is_loss(current_losses_key):
                self.weighted_losses_per_profile[current_losses_key] = [clk * profile['portion'] / 1000. for clk, profile     # to kWh
                                                                        in zip(self.cl[current_losses_key], self.model['process_profiles'])]
                self.weighted_losses[current_losses_key] = sum(self.weighted_losses_per_profile[current_losses_key])
                # self.weighted_losses[current_losses_key] = sum(clk * profile['portion'] / 1000. for clk, profile     # to kWh
                #                                                in zip(self.cl[current_losses_key], self.model['process_profiles']))
                total += self.weighted_losses[current_losses_key]
        return total

    def update_cost_opts(self, combination, total):
        acquisition_costs = sum(comp['price'] for comp in combination.values()) + self.model['result_settings']['costs_opt']['assembly_costs']
        energy_costs = total * self.model['result_settings']['costs_opt']['price_kwh'] * self.model['result_settings']['costs_opt']['amortisation_time']
        inserted = False
        for pos, old_opt in enumerate(self.cost_opts):
            if old_opt['total_costs'] > acquisition_costs + energy_costs:
                self.cost_opts.insert(pos, self.build_cost_opt(total, acquisition_costs, energy_costs))
                inserted = True
                if len(self.cost_opts) > int(self.model['result_settings']['n_list']):
                    self.cost_opts.pop()
                break
        if len(self.cost_opts) < int(self.model['result_settings']['n_list']) and not inserted:
            self.cost_opts.append(self.build_cost_opt(total, acquisition_costs, energy_costs))
        return acquisition_costs

    def build_cost_opt(self, total, acquisition_costs, energy_costs):
        return {'total_costs': acquisition_costs + energy_costs,
                'acquisition_costs': acquisition_costs,
                'energy_costs': energy_costs,
                'total': total,
                'partials': {val[1]: {'value': val[0], 'aggregate': val[2]} for val in
                             self.partial_generator()},
                'indices': copy.copy(self.indices)}

    def update_opts(self, total, acquisition_costs):
        inserted = False
        for pos, old_opt in enumerate(self.opts):
            if old_opt['total'] > total:
                self.opts.insert(pos, self.build_opt(total, acquisition_costs))
                inserted = True
                if len(self.opts) > int(self.model['result_settings']['n_list']):
                    self.opts.pop()
                break
        if len(self.opts) < int(self.model['result_settings']['n_list']) and not inserted:
            self.opts.append(self.build_opt(total, acquisition_costs))

    def build_opt(self, total, acquisition_costs):
        return {'acquisition_costs': acquisition_costs,
                'total': round(total),
                'partials': {val[1]: {'value': round(val[0]), 'aggregate': val[2], 'per_profile': [round(pp) for pp in val[3]]} for val in
                             self.partial_generator()},
                'indices': copy.copy(self.indices)}

    def description_and_aggregate_from_variable(self, var):
        function_by_var = next(lf for lf in self.model['loss_functions'] if lf['variable_name'] == var)
        return [function_by_var['description'], function_by_var['aggregate']]

    def function_is_loss(self, var):
        return all(lf['is_loss'] for lf in self.model['loss_functions'] if lf['variable_name'] == var)

    def partial_generator(self):
        for key in self.weighted_losses.keys():
            yield [self.weighted_losses[key]] + self.description_and_aggregate_from_variable(key) +\
                  [self.weighted_losses_per_profile[key]]

    def get_remarks(self):
        if len(self.model['process_profiles']) > 1 and 'p_feed_speed' in self.model['process_profiles'][0]:
            return 'p_feed_speed'
        return 'no special remarks'


def passed_parameters(call, cond, p, l, combinations):
    par_pos = call.find("(")
    parts = [s for s in call.split(" ")] if cond else [s for s in call[par_pos + 1:-1].split(", ")]
    passed = []
    for part in parts:
        if part.startswith("l[") or part.startswith("p["):
            par = part[3:-2] + "=" + str(eval(part))
            passed.append(par)
        elif part.startswith("combinations["):
            p_par = part[14:].split('"]')
            par = p_par[0] + p_par[1] + "=" + str(eval(part))
            passed.append(par)
    return ", ".join(passed)
