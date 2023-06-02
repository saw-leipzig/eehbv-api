import json
import os
import threading
import solver
from datetime import datetime
from flask import request, current_app, Response, jsonify

from ..decimalencoder import DecimalEncoder
from app import db
from ..decorators import permission_required
from ..models import ProblemWrapper, LossFuncWrapper, Variants, components, \
    Requests, Restrictions, VariantsRestrictions, TARGET_FUNC, Permission, ProblemType  # , TargetFuncWrapper
from . import api

FINISHED = '/finished'
FAILED = '/failed'
RESULT = '/result.json'
REQUEST = '/problem.json'

problems = ProblemWrapper()
# targetFunctions = TargetFuncWrapper()
lossFunctions = LossFuncWrapper()


@api.route('/problems/result/<timestamp>', methods=['GET'])
def get_result(timestamp):
    req = Requests.query.filter(Requests.timestamp == timestamp).first()
    if req is None:
        return Response('{"status": "failed"}', 404, mimetype='application/json')
    if req.status == 0:
        return Response('{"status": "pending"}', 200, mimetype='application/json')
    resp = json.loads(req.result)
    resp['status'] = 'Finished' if req.status == 2 else 'Processing'
    resp['request'] = json.loads(req.request)
    return Response(json.dumps(resp, cls=DecimalEncoder), 200, mimetype='application/json')


# ToDo: pageable, starting at last
@api.route('/problems/results')
def get_results():
    reqs = Requests.query.filter(Requests.status == 2).all()
    json_comp = json.dumps({'requests': [single_request(r) for r in reqs]}, cls=DecimalEncoder)
    return Response(json_comp, mimetype='application/json')


# ToDo: pageable, starting at last
@api.route('/problems/<int:cId>/results')
def get_results_by_process(cId):
    reqs = Requests.query.filter(Requests.processes_id == cId, Requests.status == 2).all()
    json_comp = json.dumps({'requests': [single_request(r) for r in reqs]}, cls=DecimalEncoder)
    return Response(json_comp, mimetype='application/json')


def single_request(r):
    req = json.loads(r.request)
    return {'timestamp': r.timestamp, 'description': req['description'], 'process': req['process'],
            'costs_opt': req['result_settings']['costs_opt']['exec'],
            'variants': [v['name'] for v in req['variants_conditions']]}


@api.route('/problems/results/<timestamp>', methods=['DELETE'])
@permission_required(Permission.DATA)
def delete_result(timestamp):
    req = Requests.query.filter(Requests.timestamp == timestamp).first()
    db.session.delete(req)
    db.session.commit()
    return jsonify({
        'status': 'ok',
        'table': 'requests',
        'deleted': timestamp
    })


@api.route('/problems/<int:cId>', methods=['POST'])
def handle_problem(cId):
    model = request.get_json()
    print(json.dumps(model))
    date_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    req_dict = {'processes_id': cId, 'request': json.dumps(model), 'timestamp': date_time, 'status': 0, 'result': ''}
    p = Requests(**req_dict)
    db.session.add(p)
    db.session.commit()
    try:
        solve(cId, model['process']['api_name'], model, date_time)
    except Exception:
        return Response('Wrong arguments', 400, mimetype='text/plain')
    return Response(date_time, 202, mimetype='text/plain',
                    headers={'Content-Location': '/problems/result/' + date_time})


def solve(cId, process, model, date_time):
    app = current_app._get_current_object()
    solver_thread = threading.Thread(target=threaded_solve, name='solver-' + date_time,
                                     args=[app, cId, process, model, date_time])
    solver_thread.start()


def persist_variant_json(date_time, res, finished, status_file=None):
    req = Requests.query.filter(Requests.timestamp == date_time).first()
    if req is None:
        pass    # ToDo: logging/error message
    else:
        if req.status == 0:
            req.result = json.dumps({'status': '...', 'result': [res]})
        else:
            old_resp = json.loads(req.result)
            req.result = json.dumps(old_resp['result'].apppend(res))
        req.status = 2 if finished else 1
        db.session.commit()


def persist_variant_opts(variant_name, opts, cost_opts, info, date_time, finished):
    res_dict = wrap_result(variant_name, opts, cost_opts, info)
    persist_variant_json(date_time, res_dict, finished)


def wrap_result(variant_name, opts, cost_opts, info):
    return {
        'variant': variant_name,
        'opts': opts,
        'cost_opts': cost_opts,
        'info': info
    }


def threaded_solve(cApp, cId, process, model, date_time):
    try:
        with cApp.app_context():  # provide context for this thread
            load_data_and_solve(cId, process, model, date_time)
    except BaseException as e:
        req = Requests.query.filter(Requests.timestamp == date_time).first()
        req.status = -1
        db.session.commit()


def load_data_and_solve(cId, process, model, date_time):
    problem = ProblemType.query.filter_by(processes_id=cId).first()
    if problem is None:
        raise Exception('Problem not defined')
    variants = Variants.query. \
        filter(Variants.processes_id == cId, Variants.id.in_((v['id'] for v in model['variants_conditions']))).all()
    names, data = load_data(variants)
    component_keys = ['component_api_name', 'variable_name', 'description']
    counter = 0
    for v in variants:
        counter += 1
        loss_functions = lossFunctions.get_functions(process, v)
        print(loss_functions)
        restrictions = load_restrictions(v.id)
        lf_model = [{'description': lf.description,
                     'eval_after_position': lf.eval_after_position,
                     'function_call': TARGET_FUNC + '_' + str(lf.loss_functions_id) + lf.parameter_list,
                     'position': lf.position,
                     'variable_name': lf.variable_name,
                     'aggregate': lf.aggregate,
                     'is_loss': lf.is_loss}
                    for lf in
                    sorted(v.variants_loss_functions, key=lambda ll: ll.position)]
        variant_model = {'process_profiles': model['process_profiles'],
                         'general_parameters': model['general_parameters'],
                         'result_settings': model['result_settings'],
                         'conditions': next(vv for vv in model['variants_conditions'] if vv['id'] == v.id)[
                             'conditions'],
                         'restrictions': restrictions,
                         'components': [{key: c.as_dict()[key] for key in component_keys} for c in
                                        sorted(v.variant_components, key=lambda cc: cc.position)],
                         'loss_functions': lf_model
                         }
        variant_comp_types = set(map(lambda c: c.component_api_name, v.variant_components))
        if problem.use_solver:
            opts, cost_opts, info = problems.call_solver(cId, problem.code, process, loss_functions, variant_model,
                                                         {key: data[key] for key in variant_comp_types})  # pass only necessary data
        else:
            opts, cost_opts, info = solver.call_solver(loss_functions, variant_model,
                                                       {key: data[key] for key in variant_comp_types})  # pass only necessary data
        # extract model/manufacturer from index
        for opt in opts:
            opt['indices'] = get_component_names_by_indices(opt['indices'], variant_model['components'], names)
        for cost_opt in cost_opts:
            cost_opt['indices'] = get_component_names_by_indices(cost_opt['indices'], variant_model['components'],
                                                                 names)
        print(opts)
        persist_variant_opts(v.name, opts, cost_opts, info, date_time, counter == len(variants))


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


def load_restrictions(variant_id):
    restrictions_ids = (restr.restrictions_id for restr
                        in VariantsRestrictions.query.filter(VariantsRestrictions.variants_id == variant_id).all())
    return ({'restriction': r.restriction, 'eval_after_position': r.eval_after_position}
            for r in Restrictions.query.filter(Restrictions.id.in_(restrictions_ids)).all())


def get_component_names_by_indices(ids, comps, names):
    return {comp['description']: names[comp['component_api_name']][ids[comp['variable_name']]] for comp in comps}
