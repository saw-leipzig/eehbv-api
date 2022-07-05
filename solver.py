from math import *
import copy


indices = {}
opt_indices = {}
opt_value = -1


def call_solver(target_func, tf_sig, model, data):
    components = model['components']
    wander_tree(1, model, components, {}, target_func, tf_sig, data)
    print('OPT')
    print(opt_indices)
    print(opt_value)
    return opt_indices, opt_value, 'no special remarks'


def wander_tree(depth, model, components, combination, tf, tf_sig, data):
    current_comp_type = data[components[0]['component_api_name']]
    global indices
    for index, comp in enumerate(current_comp_type):
        var_name = components[0]['variable_name']
        indices[var_name] = index
        new_combination = {**combination, var_name: comp}
        if conditions_satisfied(model, new_combination, data):
            if len(components) > 1:
                new_components = copy.copy(components)
                new_components.pop(0)
                wander_tree(depth + 1, model, new_components, new_combination, tf, tf_sig, data)
            else:
                eval_target_func(model, new_combination, tf, tf_sig, data)


def conditions_satisfied(model, combination, data):
    for data_key in data.keys():
        exec(data_key + ' = data["' + data_key + '"]')
    for comb_key in combination.keys():
        exec(comb_key + ' = combination["' + comb_key + '"]')
    for parameter_set in model['process_profiles']:
        for parameter_key in parameter_set.keys():
            exec(parameter_key + ' = parameter_set["' + parameter_key + '"]')
        for cond in model['conditions']:
            try:
                result = eval(cond)
                if not result:
                    return False
            except NameError as ex:     # conditions with missing vars have to be evaluated at a deeper level
                print('Condition parameter not defined: ' + ex.args[0])
    # ToDo: check implicit conditions
    return True


def eval_target_func(model, combination, target_func, tf_sig, data):
    for data_key in data.keys():
        exec(data_key + ' = data["' + data_key + '"]')
    for comb_key in combination.keys():
        exec(comb_key + ' = combination["' + comb_key + '"]')
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
