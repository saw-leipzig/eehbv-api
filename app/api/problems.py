import json
import os
import threading
import solver
from datetime import datetime
from flask import request, current_app, Response

from ..models import ProblemWrapper, TargetFuncWrapper, LossFuncWrapper, Variants, components, \
    TARGET_FUNC
from . import api

FINISHED = '/finished'
FAILED = '/failed'
RESULT = '/result.json'
REQUEST = '/problem.json'

problems = ProblemWrapper()
targetFunctions = TargetFuncWrapper()
lossFunctions = LossFuncWrapper()


@api.route('/problems/result/<timestamp>', methods=['GET'])
def get_result(timestamp):
    path = current_app.config['DATA_PATH'] + '/' + timestamp
    if not (os.path.exists(path + FAILED)) and not (os.path.exists(path + FINISHED)):
        return Response('{"status": "pending"}', 200, mimetype='application/json')
    with open(path + RESULT, 'r') as f:
        result = f.read()
    return Response(result, 200 if os.path.exists(path + FINISHED) else 500, mimetype='application/json')


@api.route('/problems/request/<timestamp>', methods=['GET'])
def get_request(timestamp):
    request_file = current_app.config['DATA_PATH'] + '/' + timestamp + REQUEST
    if not (os.path.exists(request_file)):
        return Response('{"status": "Request not found"}', 404, mimetype='application/json')
    with open(request_file, 'r') as f:
        req = f.read()
    return Response(req, 200, mimetype='application/json')


@api.route('/problems/<int:cId>', methods=['POST'])
def handle_problem(cId):
    model = request.get_json()
    print(json.dumps(model))
    date_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    path = current_app.config['DATA_PATH'] + '/' + date_time
    os.mkdir(path)
    with open(path + REQUEST, 'w') as f:
        json.dump(model, f)
    try:
        solve(cId, model['process']['api_name'], model, path)
    except Exception:
        return Response('Wrong arguments', 400, mimetype='text/plain')
    return Response(date_time, 202, mimetype='text/plain',
                    headers={'Content-Location': '/problems/result/' + date_time})


def solve(cId, process, model, path):
    app = current_app._get_current_object()
    solver_thread = threading.Thread(target=threaded_solve, name='solver-' + path,
                                     args=[app, cId, process, model, path])
    solver_thread.start()


def persist_outcome(result_file, msg, status_file=None):
    if os.path.exists(result_file):
        with open(result_file, 'a') as f:
            f.write('\n')
            f.write(msg)
    else:
        with open(result_file, 'w') as f:
            f.write(msg)
    if status_file is not None:
        end_solver(status_file)


def end_solver(status_file):
    open(status_file, 'a').close()


def persist_variant_json(result_file, res, status_file=None):
    if os.path.exists(result_file):
        f = open(result_file)
        prev = json.load(f)
        f.close()
        with open(result_file, 'w') as f:
            json.dump(prev['result'].apppend(res), f)
    else:
        with open(result_file, 'w') as f:
            json.dump({'status': '...', 'result': [res]}, f)
    if status_file is not None:
        end_solver(status_file)


def persist_variant_opts(variant_name, opts, cost_opts, info, path):
    res_dict = wrap_result(variant_name, opts, cost_opts, info)
    persist_variant_json(path, res_dict)


def wrap_result(variant_name, opts, cost_opts, info):
    return {
        'variant': variant_name,
        'opts': opts,
        'cost_opts': cost_opts,
        'info': info
    }


def threaded_solve(cApp, cId, process, model, path):
    result_file = path + RESULT
    try:
        with cApp.app_context():  # provide context for this thread
            load_data_and_solve(cId, process, model, result_file)
        end_solver(path + FINISHED)
    except BaseException as e:
        persist_outcome(result_file, e.args[0] + '\n', path + FAILED)


def load_data_and_solve(cId, process, model, path):
    variants = Variants.query. \
        filter(Variants.processes_id == cId, Variants.id.in_((v['id'] for v in model['variants_conditions']))).all()
    names, data = load_data(variants)
    component_keys = ['component_api_name', 'variable_name', 'description']
    for v in variants:
        loss_functions = lossFunctions.get_functions(process, v)
        print(loss_functions)
        lf_model = [{'description': lf.description,
                     'eval_after_position': lf.eval_after_position,
                     'function_call': TARGET_FUNC + '_' + str(lf.loss_functions_id) + lf.parameter_list,
                     'position': lf.position,
                     'variable_name': lf.variable_name,
                     'aggregate': lf.aggregate}
                    for lf in
                    sorted(v.variants_loss_functions, key=lambda ll: ll.position)]
        variant_model = {'process_profiles': model['process_profiles'],
                         'general_parameters': model['general_parameters'],
                         'result_settings': model['result_settings'],
                         'conditions': next(vv for vv in model['variants_conditions'] if vv['id'] == v.id)[
                             'conditions'],
                         'components': [{key: c.as_dict()[key] for key in component_keys} for c in
                                        sorted(v.variant_components, key=lambda cc: cc.position)],
                         'loss_functions': lf_model
                         }
        variant_comp_types = set(map(lambda c: c.component_api_name, v.variant_components))
        opts, cost_opts, info = solver.call_solver(
                    loss_functions, variant_model, {key: data[key] for key in variant_comp_types})  # pass only necessary data
#        opts, cost_opts, info = problems.call_solver(cId,
#                                                     process, loss_functions, variant_model,
#                                                     {key: data[key] for key in variant_comp_types})  # pass only necessary data
        # extract model/manufacturer from index
        for opt in opts:
            opt['indices'] = get_component_names_by_indices(opt['indices'], variant_model['components'], names)
        for cost_opt in cost_opts:
            cost_opt['indices'] = get_component_names_by_indices(cost_opt['indices'], variant_model['components'],
                                                                 names)
        print(opts)
        persist_variant_opts(v.name, opts, cost_opts, info, path)


def load_data(variants):
    names = {}
    data = {}
    for v in variants:
        for c in v.variant_components:
            comp_name = c.component_api_name
            if comp_name not in names:
                comps = components[comp_name].query.all()
                names[comp_name] = [{'name': cc.name, 'manufacturer': cc.manufacturer} for cc in comps]
                keys = [k for k in comps[0].as_dict().keys() if k not in ['id', 'name', 'manufacturer']]
                data[comp_name] = [{key: cc.as_dict()[key] for key in keys} for cc in comps]
    return names, data


def get_component_names_by_indices(ids, comps, names):
    return {comp['description']: names[comp['component_api_name']][ids[comp['variable_name']]] for comp in comps}
