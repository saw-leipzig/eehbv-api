from math import *
import copy

current_losses = {}
weighted_losses = {}
indices = {}
opts = []
cost_opts = []


def call_solver(loss_func, model, data):
    # ToDo: as class
    global current_losses, weighted_losses, indices, opts, cost_opts
    # reset -  problematic for several parallel requests
    current_losses = {}
    weighted_losses = {}
    indices = {}
    opts = []
    cost_opts = []

    components = model['components']
    # ToDo: eval dependent variables!
    update_losses(data, model, {}, loss_func, 0)
    wander_tree(1, model, components, {}, loss_func, data)
    return opts, cost_opts, 'no special remarks'


def wander_tree(depth, model, components, combination, lfs, data):
    current_comp_type = data[components[0]['component_api_name']]
    global indices
#    print('wander_tree - ' + str(depth))
    # select new component
    for index, comp in enumerate(current_comp_type):
        var_name = components[0]['variable_name']
        indices[var_name] = index
        new_combination = {**combination, var_name: comp}
        if conditions_satisfied(model, new_combination, data, depth):
            update_losses(data, model, new_combination, lfs, depth)
            # recursive decision
            if len(components) > 1:
                new_components = copy.copy(components)
                new_components.pop(0)
                wander_tree(depth + 1, model, new_components, new_combination, lfs, data)
            else:
                summarize_and_check_results(model, new_combination)


def update_losses(data, model, combination, lfs, depth):
    global current_losses
    # unpack variables and previous components
    for general_key in model['general_parameters']:
        exec(general_key + ' = model["general_parameters"]["' + general_key + '"]')
    for data_key in data.keys():
        exec(data_key + ' = data["' + data_key + '"]')
    for comb_key in combination.keys():
        exec(comb_key + ' = combination["' + comb_key + '"]')
    for lf_key in lfs.keys():
        exec('target_func_' + str(lf_key) + ' = lfs[' + str(lf_key) + ']')
    # eval losses to evaluated after newly selected component
    for lf in model['loss_functions']:
        if lf['eval_after_position'] == depth:
            exec('current_losses["' + lf['variable_name'] + '"] = []')  # reset loss list
            for pos in range(len(model['process_profiles'])):
                parameter_set = model['process_profiles'][pos]
                for parameter_key in parameter_set.keys():
                    # exec(parameter_key + ' = parameter_set["' + parameter_key + '"]')
                    exec(parameter_key + ' = model["process_profiles"][' + str(pos) + ']["' + parameter_key + '"]')
                # unpack previously evaluated losses
                for current_losses_key in current_losses.keys():
                    if current_losses_key != lf['variable_name']:
                        exec(current_losses_key + ' = current_losses["' + current_losses_key + '"][' + str(pos) + ']')
                # eval current loss
                print('EXEC ' + lf['variable_name'] + ' = ' + lf['function_call'])
                exec(lf['variable_name'] + ' = ' + lf['function_call'])
                # ToDo: view group
                # pack current loss for deeper levels
                exec('current_losses["' + lf['variable_name'] + '"].append(' + lf['variable_name'] + ')')


def conditions_satisfied(model, combination, data, depth):
    # noinspection DuplicatedCode
    for data_key in data.keys():
        exec(data_key + ' = data["' + data_key + '"]')
    for comb_key in combination.keys():
        exec(comb_key + ' = combination["' + comb_key + '"]')
    for general_key in model['general_parameters']:
        exec(general_key + ' = model["general_parameters"]["' + general_key + '"]')
    global current_losses
    # check request conditions
    for pos in range(len(model['process_profiles'])):  # conditions have to be fulfilled for all profiles
        for parameter_key in model['process_profiles'][pos].keys():
            exec(parameter_key + ' = model["process_profiles"][' + str(pos) + ']["' + parameter_key + '"]')
        for current_losses_key in current_losses.keys():
            exec(current_losses_key + ' = current_losses["' + current_losses_key + '"][' + str(pos) + ']')
        for cond in model['conditions']:
            try:
                result = eval(cond)
                if not result:
                    return False
            except NameError as ex:  # conditions with missing vars have to be evaluated at a deeper level
                print('Condition parameter not defined: ' + ex.args[0])
    # check implicit conditions
    for restr in model['restrictions']:
        if depth == restr['eval_after_position']:
            try:
                result = eval(restr['restriction'])
                if not result:
                    return False
            except NameError as ex:
                print('Condition parameter not defined: ' + ex.args[0])
    return True


def summarize_and_check_results(model, combination):
    # new part
    global current_losses
    total = sum_losses(model)
    # costs optimization
    acquisition_costs = update_cost_opts(model, combination, total) if model['result_settings']['costs_opt'][
        'exec'] else None
    # sort current combination in optimal solutions
    update_opts(model, total, acquisition_costs)


def sum_losses(model):
    global current_losses
    global weighted_losses
    total = 0
    for current_losses_key in current_losses.keys():
        weighted_losses[current_losses_key] = sum(clk * profile['portion'] for clk, profile
                                                  in zip(current_losses[current_losses_key], model['process_profiles']))
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
            'total': total,
            'partials': {val[1]: {'value': val[0], 'aggregate': val[2]} for val in
                         partial_generator(model)},
            'indices': copy.copy(indices)}


def description_and_aggregate_from_variable(model, var):
    function_by_var = next(lf for lf in model['loss_functions'] if lf['variable_name'] == var)
    return [function_by_var['description'], function_by_var['aggregate']]


def partial_generator(model):
    global weighted_losses
    for key in weighted_losses.keys():
        yield [weighted_losses[key]] + description_and_aggregate_from_variable(model, key)
