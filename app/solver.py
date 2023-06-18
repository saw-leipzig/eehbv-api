from math import *
import copy
import time

cl = {}     # current_losses
weighted_losses = {}
indices = {}
opts = []
cost_opts = []
selects = 0
satisfied = 0
deepest_failed_restriction = {}
timing = 0.0


def call_solver(loss_func, model, data):
    # ToDo: as class
    global cl, weighted_losses, indices, opts, cost_opts, selects, satisfied, timing, deepest_failed_restriction
    # reset -  problematic for several parallel requests
    cl = {}
    weighted_losses = {}
    indices = {}
    opts = []
    cost_opts = []
    selects = 0
    satisfied = 0
    timing = 0.0
    deepest_failed_restriction = {'depth': 0, 'restriction': ''}

    tic = time.perf_counter()
    components = model['components']
    update_losses(model, {}, loss_func, 0)
    wander_tree(1, model, components, {}, loss_func, data)
    print('selected')
    print(selects)
    print('satisfied')
    print(satisfied)
    timing += time.perf_counter() - tic
    print('timing')
    print(timing)
    return opts, cost_opts, deepest_failed_restriction, 'no special remarks'


def wander_tree(depth, model, components, combination, lfs, data):
    current_comp_type = data[components[0]['component_api_name']]
    global indices, selects
#    print('wander_tree - ' + str(depth))
    # select new component
    for index, comp in enumerate(current_comp_type):
        var_name = components[0]['variable_name']
        indices[var_name] = index
        new_combination = {**combination, var_name: comp}
        selects += 1
        cd = conditions_satisfied(model, new_combination, depth)
        if cd:
            update_losses(model, new_combination, lfs, depth)
            # recursive decision
            if len(components) > 1:
                new_components = copy.copy(components)
                new_components.pop(0)
                wander_tree(depth + 1, model, new_components, new_combination, lfs, data)
            else:
                summarize_and_check_results(model, new_combination)


def update_losses(model, combinations, lfs, depth):
    global cl, satisfied
    if depth > 0:
        satisfied += 1
    # unpack variables
    p = {}
    for general_key in model['general_parameters']:
        p[general_key] = model["general_parameters"][general_key]
    # eval losses to evaluated after newly selected component
    for lf in model['loss_functions']:
        if lf['eval_after_position'] == depth:
            exec('cl["' + lf['variable_name'] + '"] = []')  # reset loss list
            for pos in range(len(model['process_profiles'])):
                for parameter_key in model['process_profiles'][pos].keys():
                    p[parameter_key] = model["process_profiles"][pos][parameter_key]
                # unpack previously evaluated losses
                l = {}
                for current_losses_key in cl.keys():
                    if current_losses_key != lf['variable_name']:
                        l[current_losses_key] = cl[current_losses_key][pos]
                # eval current loss
                # print('EXEC ' + lf['variable_name'] + ' = ' + lf['function_call'])
                exec(lf['variable_name'] + ' = ' + lf['function_call'])
                # ToDo: view group
                # pack current loss for deeper levels
                exec('cl["' + lf['variable_name'] + '"].append(' + lf['variable_name'] + ')')


def conditions_satisfied(model, combinations, depth):
    # noinspection DuplicatedCode
    p = {}
    for general_key in model['general_parameters']:
        p[general_key] = model["general_parameters"][general_key]
    global cl, deepest_failed_restriction, timing
    # check request conditions
    for pos in range(len(model['process_profiles'])):  # conditions have to be fulfilled for all profiles
        for parameter_key in model['process_profiles'][pos].keys():
            p[parameter_key] = model["process_profiles"][pos][parameter_key]
        l = {}
        for current_losses_key in cl.keys():
            l[current_losses_key] = cl[current_losses_key][pos]
        for cond in model['conditions']:
            try:
                result = eval(cond)
                if not result:
                    # print('Condition evaluated to False: ' + cond)
                    return False
            except NameError as ex:  # conditions with missing vars have to be evaluated at a deeper level
                pass    # print('Condition parameter not defined: ' + ex.args[0])
        # check implicit conditions
        for restr in model['restrictions']:
            if depth == restr['eval_after_position']:
                try:
                    result = eval(restr['restriction'])
                    if not result:
                        if depth > deepest_failed_restriction['depth']:
                            deepest_failed_restriction['depth'] = depth
                            deepest_failed_restriction['restriction'] = restr['description']
                        return False
                except NameError as ex:
                    print('Condition parameter not defined: ' + ex.args[0])
    return True


def summarize_and_check_results(model, combination):
    # new part
    total = sum_losses(model)
    # costs optimization
    acquisition_costs = update_cost_opts(model, combination, total) if model['result_settings']['costs_opt'][
        'exec'] else None
    # sort current combination in optimal solutions
    update_opts(model, total, acquisition_costs)


def sum_losses(model):
    global cl
    global weighted_losses
    total = 0
    for current_losses_key in cl.keys():
        if function_is_loss(model, current_losses_key):
            weighted_losses[current_losses_key] = sum(clk * profile['portion'] / 1000. for clk, profile     # to kWh
                                                      in zip(cl[current_losses_key], model['process_profiles']))
            total += weighted_losses[current_losses_key]
    return total


def update_cost_opts(model, combination, total):
    global cost_opts
    global indices
    acquisition_costs = sum(comp['price'] for comp in combination.values()) + model['result_settings']['costs_opt']['assembly_costs']
    energy_costs = total * model['result_settings']['costs_opt']['price_kwh'] * model['result_settings']['costs_opt']['amortisation_time']
    inserted = False
    for pos, old_opt in enumerate(cost_opts):
        if old_opt['total_costs'] > acquisition_costs + energy_costs:
            cost_opts.insert(pos, build_cost_opt(model, total, acquisition_costs, energy_costs))
            inserted = True
            if len(cost_opts) > int(model['result_settings']['n_list']):
                cost_opts.pop()
            break
    if len(cost_opts) < int(model['result_settings']['n_list']) and not inserted:
        cost_opts.append(build_cost_opt(model, total, acquisition_costs, energy_costs))
    return acquisition_costs


def build_cost_opt(model, total, acquisition_costs, energy_costs):
    global weighted_losses
    global indices
    return {'total_costs': acquisition_costs + energy_costs,
            'acquisition_costs': acquisition_costs,
            'energy_costs': energy_costs,
            'total': total,
            'partials': {val[1]: {'value': val[0], 'aggregate': val[2]} for val in
                         partial_generator(model)},
            'indices': copy.copy(indices)}


def update_opts(model, total, acquisition_costs):
    global opts
    inserted = False
    for pos, old_opt in enumerate(opts):
        if old_opt['total'] > total:
            opts.insert(pos, build_opt(model, total, acquisition_costs))
            inserted = True
            if len(opts) > int(model['result_settings']['n_list']):
                opts.pop()
            break
    if len(opts) < int(model['result_settings']['n_list']) and not inserted:
        opts.append(build_opt(model, total, acquisition_costs))


def build_opt(model, total, acquisition_costs):
    global weighted_losses
    global indices
    return {'acquisition_costs': acquisition_costs,
            'total': round(total),
            'partials': {val[1]: {'value': round(val[0]), 'aggregate': val[2]} for val in
                         partial_generator(model)},
            'indices': copy.copy(indices)}


def description_and_aggregate_from_variable(model, var):
    function_by_var = next(lf for lf in model['loss_functions'] if lf['variable_name'] == var)
    return [function_by_var['description'], function_by_var['aggregate']]


def function_is_loss(model, var):
    return all(lf['is_loss'] for lf in model['loss_functions'] if lf['variable_name'] == var)


def partial_generator(model):
    global weighted_losses
    for key in weighted_losses.keys():
        yield [weighted_losses[key]] + description_and_aggregate_from_variable(model, key)
