from math import *
import copy

current_losses = {}
weighted_losses = {}
indices = {}
opt_indices = {}
opt_value = -1
opts = []
cost_opts = []


def call_solver(target_func, loss_func, tf_sig, model, data):
    # ToDo: as class
    global current_losses, weighted_losses, indices, opt_indices, opt_value, opts, cost_opts
    # reset -  problematic for several parallel requests
    current_losses = {}
    weighted_losses = {}
    indices = {}
    opt_indices = {}
    opt_value = -1
    opts = []
    cost_opts = []

    components = model['components']
    # ToDo: eval dependent variables!
    wander_tree(1, model, components, {}, target_func, loss_func, tf_sig, data)
    print('OPT')
    print(opt_indices)
    print(opt_value)
    return opt_indices, opt_value, opts, cost_opts, 'no special remarks'


def wander_tree(depth, model, components, combination, tf, lfs, tf_sig, data):
    current_comp_type = data[components[0]['component_api_name']]
    global indices
    print('wander_tree - ' + str(depth))
    # select new component
    for index, comp in enumerate(current_comp_type):
        var_name = components[0]['variable_name']
        indices[var_name] = index
        new_combination = {**combination, var_name: comp}
        if conditions_satisfied(model, new_combination, data):
            update_losses(data, model, new_combination, lfs, depth)
            # recursive decision
            if len(components) > 1:
                new_components = copy.copy(components)
                new_components.pop(0)
                wander_tree(depth + 1, model, new_components, new_combination, tf, lfs, tf_sig, data)
            else:
                eval_target_func(model, new_combination, tf, tf_sig, data)


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


def conditions_satisfied(model, combination, data):
    # noinspection DuplicatedCode
    for data_key in data.keys():
        exec(data_key + ' = data["' + data_key + '"]')
    for comb_key in combination.keys():
        exec(comb_key + ' = combination["' + comb_key + '"]')
    for general_key in model['general_parameters']:
        exec(general_key + ' = model["general_parameters"]["' + general_key + '"]')
    global current_losses
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
    # ToDo: check implicit conditions
    return True


def eval_target_func(model, combination, target_func, tf_sig, data):
    # new part
    global current_losses
    print('EVAL_TARGET_FUNC')
    total = sum_losses(model)
    # costs optimization
    acquisition_costs = update_cost_opts(model, combination, total) if model['result_settings']['costs_opt'][
        'exec'] else None
    # sort current combination in optimal solutions
    update_opts(model, total, acquisition_costs)
    # old part
    # noinspection DuplicatedCode
    for data_key in data.keys():
        exec(data_key + ' = data["' + data_key + '"]')
    for comb_key in combination.keys():
        exec(comb_key + ' = combination["' + comb_key + '"]')
    for general_key in model['general_parameters']:
        exec(general_key + ' = model["general_parameters"]["' + general_key + '"]')
    global opt_value
    global opt_indices
    global indices
    val = [0]
    for parameter_set in model['process_profiles']:
        for pp in parameter_set.keys():
            exec(pp + ' = parameter_set["' + pp + '"]')
        exec('val[0] = val[0] + portion * ' + tf_sig)
    # interpret portion as hours
    # val[0] = val[0] * kw_price
    if val[0] > -1 and (val[0] < opt_value or opt_value == -1):
        opt_value = val[0]
        opt_indices = {**indices}


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
    acquisition_costs = sum(combination['price']) + model['result_settings']['costs_opt']
    energy_costs = total * model['result_settings']['costs_opt']['price_kwh'] * model['result_settings']['costs_opt'][
        'amortization_time']
    if len(cost_opts) == 0:
        cost_opts.append(build_cost_opt(model, total, acquisition_costs, energy_costs))
    for pos, old_opt in enumerate(cost_opts):
        if old_opt['total_costs'] > acquisition_costs + energy_costs:
            cost_opts.insert(pos, build_cost_opt(model, total, acquisition_costs, energy_costs))
            if len(cost_opts) > model['result_settings']['n_list']:
                cost_opts.pop()
            break
    return acquisition_costs


def build_cost_opt(model, total, acquisition_costs, energy_costs):
    global weighted_losses
    global indices
    return {'total_costs': acquisition_costs + energy_costs,
            'acquisition_costs': acquisition_costs,
            'energy_costs': energy_costs,
            'total': total,
            'partials': {description_from_variable(model, key): weighted_losses[key] for key in
                         weighted_losses.keys()},
            'indices': indices}


def update_opts(model, total, acquisition_costs):
    global opts
    if len(opts) == 0:
        opts.append(build_opt(model, total, acquisition_costs))
        return
    for pos, old_opt in enumerate(opts):
        if old_opt['total'] > total:
            opts.insert(pos, build_opt(model, total, acquisition_costs))
            if len(opts) > model['result_settings']['n_list']:
                opts.pop()
            break


def build_opt(model, total, acquisition_costs):
    global weighted_losses
    global indices
    return {'acquisition_costs': acquisition_costs,
            'total': total,
            'partials': {description_from_variable(model, key): weighted_losses[key] for key in
                         weighted_losses.keys()},
            'indices': indices}


def description_from_variable(model, var):
    return next(lf for lf in model['loss_functions'] if lf['variable_name'] == var)['description']
