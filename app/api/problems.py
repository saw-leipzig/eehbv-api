import json
import os
import threading
from datetime import datetime
from flask import request, current_app, Response

from ..models import ProblemWrapper, TargetFuncWrapper, Variants, components
from . import api

FINISHED = '/finished'
FAILED = '/failed'

problems = ProblemWrapper()
targetFunctions = TargetFuncWrapper()


@api.route('/problems/result/<timestamp>', methods=['GET'])
def get_result(timestamp):
    path = current_app.config['DATA_PATH'] + '/' + timestamp
    if not (os.path.exists(path + FAILED)) and not (os.path.exists(path + FINISHED)):
        return Response('{"status": "pending"}', 200, mimetype='application/json')
    with open(path + '/result.html', 'r') as f:
        result = f.read()
    return Response(result, 200 if os.path.exists(path + FINISHED) else 500, mimetype='text/plain')


@api.route('/problems/<int:cId>', methods=['POST'])
def handle_problem(cId):
    model = request.get_json()
    print(json.dumps(model))
    date_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    path = current_app.config['DATA_PATH'] + '/' + date_time
    os.mkdir(path)
    with open(path + '/problem.json', 'w') as f:
        json.dump(model, f)
    try:
        solve(cId, model['process']['api_name'], model, path)
    except:
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


def persist_variant(variant_name, result, combination, info, path):
    res_str = format_result(result, variant_name, combination, info)
    persist_outcome(path, res_str)


def end_solver(status_file):
    open(status_file, 'a').close()


def format_result(result, name, combination, info):
    # ToDo: Include Infos about variant, info, component's description ...
    lines = '<p>'\
            + '</p><p>'.\
                join(['<em>{type}</em>: {man} - {model}'.format(type=item[0], man=item[1]['manufacturer'], model=item[1]['name'])
                      for item in combination.items()])\
            + '</p>'
    return '<h2>{name}</h2><div>Ergebnis: {res}</div><div>{lines}</div><div>{info}</div>'.\
        format(name=name,
               res=result,
               lines=lines,
               info=info)


def threaded_solve(cApp, cId, process, model, path):
    result_file = path + '/result.html'
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
        target_func = targetFunctions.get_func(cId, v.id, process, v)
        signature = get_signature(v.target_func)
        variant_model = {'process_parameters': model['process_parameters'],
                         'conditions': next(vv for vv in model['variants_conditions'] if vv['id'] == v.id)[
                             'conditions'],
                         'components': [{key: c.as_dict()[key] for key in component_keys} for c in
                                        sorted(v.variant_components, key=lambda cc: cc.position)]}
        variant_comp_types = set(map(lambda c: c.component_api_name, v.variant_components))
        indices, variant_result, info = \
            problems.call_solver(cId, process, target_func, signature, variant_model,
                                 {key: data[key] for key in variant_comp_types})  # pass only necessary data
        # ToDo: extract model/manufacturer from index
        opt_combination = get_component_names_by_indices(indices, variant_model['components'], names)
        persist_variant(v.name, variant_result, opt_combination, info, path)


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


def get_signature(target_func):
    for line in target_func.splitlines():
        if line.startswith('def target_func('):
            start = line.index('t')
            end = line.index(')')
            return line[start:end + 1]
    raise SyntaxError('Definition of target function not found')


def get_component_names_by_indices(ids, comps, names):
    return {comp['description']: names[comp['component_api_name']][ids[comp['variable_name']]] for comp in comps}
