import json
from flask import jsonify, request, Response
from . import api
from .problems import problem_dict, loss_function_dict
from ..models import Processes, ProcessParameters, LossFunctions, VariantsLossFunctions, InfoTexts, Variants,\
    VariantComponents, Restrictions, VariantSelection, ProblemType, Permission, ProcessSources, ColumnInfo, Components
from app import db
from ..decorators import permission_required


@api.route('/processes/<int:cId>', methods=['DELETE'])
@permission_required(Permission.OPT)
def delete_process(cId):
    proc = get_process_raw(cId)
    if proc is None:
        return jsonify({
            'status': 'not found',
            'table': 'processes',
            'id': cId
        }), 204
    variants = Variants.query.filter_by(processes_id=cId)
    for variant in variants:
        db.session.delete(variant)
    db.session.delete(proc)
    db.session.commit()
    problem_dict.remove_function(cId)
    loss_function_dict.remove_functions(cId)
    return jsonify({
        'status': 'ok',
        'table': 'processes',
        'deleted': cId
    })


@api.route('/processes')
def get_processes():
    processes = Processes.query.all()
    return jsonify({'processes': [{**process.as_dict(),
                                   'parameters': [p.as_dict() for p in process.process_parameters]} for process in processes]})


@api.route('/processes/<int:cId>')
def get_process(cId):
    process = get_process_raw(cId)
    return jsonify({**process.as_dict(), 'parameters': [p.as_dict() for p in process.process_parameters]})


def get_process_raw(cId):
    return Processes.query.filter_by(id=cId).first()


@api.route('/processes', methods=['POST'])
@permission_required(Permission.OPT)
def create_process():
    proc = request.get_json()
    proc_dict = {key: proc['process'][key] for key in ['view_name', 'api_name', 'variant_tree']}
    p = Processes(**proc_dict)
    db.session.add(p)
    db.session.commit()
    funcs = {}
    for func in proc['functions']:
        func_dict = {**func, 'processes_id': p.id}
        f = LossFunctions(**func_dict)
        db.session.add(f)
        db.session.commit()
        funcs[f.description] = f.id
    for param in proc['process']['process_parameters']:
        param_dict = {**param, 'processes_id': p.id}
        # needed_param_entries = {key: param[key] for key in ['name', 'unit', 'variable_name', 'material_properties_id', 'defaults', 'general']}
        # param_dict = {**needed_param_entries, 'processes_id': p.id}
        pp = ProcessParameters(**param_dict)
        db.session.add(pp)
    db.session.commit()
    for variant in proc['variants']:
        var_dict = {'name': variant['name'], 'processes_id': p.id}
        v = Variants(**var_dict)
        db.session.add(v)
        db.session.commit()
        for component in variant['variant_components']:
            comp_dict = {**component, 'variants_id': v.id}
            c = VariantComponents(**comp_dict)
            db.session.add(c)
        for lf in variant['variant_functions']:
            needed_lf_entries = {key: lf[key] for key in ['parameter_list', 'variable_name', 'description', 'eval_after_position', 'position', 'aggregate', 'is_loss']}
            lf_dict = {**needed_lf_entries, 'variants_id': v.id, 'loss_functions_id': funcs[lf['loss_function_description']]}
            loss_func = VariantsLossFunctions(**lf_dict)
            db.session.add(loss_func)
        for r in variant['variant_restrictions']:
            needed_r_entries = {key: r[key] for key in ['description', 'eval_after_position', 'restriction']}
            r_dict = {**needed_r_entries, 'variants_id': v.id}
            restr = Restrictions(**r_dict)
            db.session.add(restr)
            db.session.commit()
    var_select_dict = {'processes_id': p.id, 'selection': json.dumps(proc['variant_selection'])}
    vs = VariantSelection(**var_select_dict)
    db.session.add(vs)
    solver_dict = {'processes_id': p.id, 'code': proc['solver']['code'], 'use_solver': proc['solver']['use_solver']}
    s = ProblemType(**solver_dict)
    db.session.add(s)
    for info_text in proc['infoTexts']:
        info_dict = {**info_text, 'processes_id': p.id}
        i = InfoTexts(**info_dict)
        db.session.add(i)
    db.session.commit()
    process_source = {'processes_id': p.id, 'request': json.dumps(proc)}
    ps = ProcessSources(**process_source)
    db.session.add(ps)
    db.session.commit()
    new_process = get_process_raw(p.id)
    return Response(json.dumps(new_process.as_dict()), mimetype='application/json')


@api.route('/processes<int:cId>', methods=['PUT'])
@permission_required(Permission.OPT)
def update_process(cId):
    proc = request.get_json()
    old_p = get_process_raw(cId)
    for key in ['view_name', 'api_name', 'variant_tree']:
        setattr(old_p, key, proc[key])
    funcs = {}
    old_funcs = LossFunctions.query.filter_by(processes_id=cId)
    func_ids = [func['id'] for func in proc['functions'] if 'id' in func]
    for old_func in old_funcs:
        if old_func.id not in func_ids:
            db.session.delete(old_func)
    old_params = ProcessParameters.query.filter_by(processes_id=cId)
    param_ids = [param['id'] for param in proc['process']['process_parameters'] if 'id' in param]
    for old_param in old_params:
        if old_param.id not in param_ids:
            db.session.delete(old_param)
    old_vars = Variants.query.filter_by(processes_id=cId)
    vars_ids = [v['id'] for v in proc['variants'] if 'id' in v]
    for old_var in old_vars:
        if old_var.id not in vars_ids:
            db.session.delete(old_var)
    for func in proc['functions']:
        if 'id' in func:
            for old_func in old_funcs:
                if old_func.id == func['id']:
                    for key in ['func', 'description', 'doc']:
                        setattr(old_func, key, func[key])
            funcs[func['description']] = func['id']
        else:
            func_dict = {**func, 'processes_id': cId}
            f = LossFunctions(**func_dict)
            db.session.add(f)
            db.session.commit()
            funcs[f.description] = f.id
    for param in proc['process']['process_parameters']:
        if 'id' in param:
            for old_param in old_params:
                if old_param.id == param['id']:
                    for key in ['name', 'unit', 'variable_name', 'material_properties_id', 'defaults', 'general']:
                        setattr(old_param, key, param[key])
        else:
            param_dict = {**param, 'processes_id': cId}
            pp = ProcessParameters(**param_dict)
            db.session.add(pp)
    for variant in proc['variants']:
        if 'id' in variant:
            v_id = variant['id']
            for old_var in old_vars:
                if old_var.id == variant['id']:
                    setattr(old_var, 'name', variant['name'])
        else:
            var_dict = {'name': variant['name'], 'processes_id': cId}
            v = Variants(**var_dict)
            db.session.add(v)
            db.session.commit()
            v_id = v.id
        old_comps = VariantComponents.query.filter_by(variants_id=v_id)
        for component in variant['variant_components']:
            if 'id' in component:
                for old_comp in old_comps:
                    if old_comp.id == component['id']:
                        for key in ['position', 'component_api_name', 'variable_name', 'description', 'aggregate']:
                            setattr(old_comp, key, component[key])
            else:
                comp_dict = {**component, 'variants_id': v_id}
                c = VariantComponents(**comp_dict)
                db.session.add(c)
        old_lfs = VariantsLossFunctions.query.filter_by(variants_id=v_id)
        for lf in variant['variant_functions']:
            needed_lf_entries = {key: lf[key] for key in ['parameter_list', 'variable_name', 'description', 'eval_after_position', 'position', 'aggregate', 'is_loss']}
            if 'id' in lf:
                for old_lf in old_lfs:
                    if old_lf.id == lf['id']:
                        for key in needed_lf_entries:
                            setattr(old_lf, key, lf[key])
            else:
                lf_dict = {**needed_lf_entries, 'variants_id': v_id, 'loss_functions_id': funcs[lf['loss_function_description']]}
                loss_func = VariantsLossFunctions(**lf_dict)
                db.session.add(loss_func)
        old_res = Restrictions.query.filter_by(variants_id=v_id)
        for r in variant['variant_restrictions']:
            needed_r_entries = {key: r[key] for key in ['description', 'eval_after_position', 'restriction']}
            if 'id' in r:
                for old_re in old_res:
                    if old_re.id == r['id']:
                        for key in needed_r_entries:
                            setattr(old_re, key, r[key])
            else:
                r_dict = {**needed_r_entries, 'variants_id': v_id}
                restr = Restrictions(**r_dict)
                db.session.add(restr)
        db.session.commit()
    old_vs = VariantSelection.query.filter_by(processes_id=cId).first()
    setattr(old_vs, 'selection', json.dumps(proc['variant_selection']))
    old_solver = ProblemType.query.filter_by(processes_id=cId).first()
    setattr(old_solver, 'code', proc['solver']['code'])
    setattr(old_solver, 'use_solver', proc['solver']['use_solver'])
    old_its = InfoTexts.query.filter_by(processes_id=cId)
    for info_text in proc['infoTexts']:
        for old_it in old_its:
            if old_it.id == info_text['id']:
                setattr(old_it, 'text', info_text['text'])
    db.session.commit()
    problem_dict.remove_function(cId)
    loss_function_dict.remove_functions(cId)
    process_source = {'processes_id': cId, 'request': json.dumps(proc)}
    ps = ProcessSources(**process_source)
    db.session.add(ps)
    db.session.commit()
    new_process = get_process_raw(cId)
    return Response(json.dumps(new_process.as_dict()), mimetype='application/json')


@api.route('/processes/<int:cId>/full')
def get_process_details(cId):
    process = get_process_raw(cId)
    variants = Variants.query.filter_by(processes_id=cId)
    data_models = component_column_data()
    return jsonify({'process': {**process.as_dict(), 'process_parameters': [p.as_dict() for p in process.process_parameters]},
                    'functions': [lf.as_dict() for lf in process.loss_functions],
                    'variants': [
                        {'name': v.name,
                         'id': v.id,
                         'variant_components': [vc.as_dict() for vc in v.variant_components],
                         'variant_functions': [{**vlf.as_dict(),
                                                'loss_function_description': next(lf.description for lf in process.loss_functions
                                                                                  if lf.id == vlf.loss_functions_id),
                                                'parameter_list_model': functions_model(vlf.parameter_list[1:-1].split(", "),
                                                                                        v.variant_components,
                                                                                        process.process_parameters,
                                                                                        v.variants_loss_functions,
                                                                                        data_models)}
                                               for vlf in v.variants_loss_functions],
                         'variant_restrictions': [{**vr.as_dict(),
                                                  'restriction_model': restrictions_model(vr.restriction[2:].split(" "),
                                                                                          v.variant_components,
                                                                                          process.process_parameters,
                                                                                          v.variants_loss_functions,
                                                                                          data_models)}
                                                  for vr in v.restrictions]}
                        for v in variants
                    ],
                    'variant_selection': json.loads(process.variant_selection[0].selection) | {'id': process.variant_selection[0].id},
                    'solver': [s.as_dict() for s in process.process_solvers],
                    'infoTexts': [it.as_dict() for it in process.info_texts]})


def restrictions_model(item_list, components, parameters, funcs, data_model):
    return [{'formula': item, 'view': model_view_value(item, components, parameters, funcs, data_model),
             'state': model_view_state(item)} for item in item_list]


def functions_model(item_list, components, parameters, funcs, data_model):
    return [{'name': model_view_value(item, components, parameters, funcs, data_model), 'value': item} for item in item_list]


def component_column_data():
    infos = ColumnInfo.query.all()
    components = Components.query.all()
    return {c.api_name: {ci.column_name: ci.view_name for ci in infos if ci.component_id == c.id} for c in components}


def model_view_value(item, components, parameters, funcs, data_model):
    if item.startswith("p_"):
        return next(p.name for p in parameters if p.variable_name == item)
    if item.startswith("c_"):
        parts = item.split("[")
        component = next(c for c in components if c.variable_name == parts[0])
        column = data_model[component.component_api_name][parts[1][1:-2]]
        return component.description + "['" + column + "']"
    if item.startswith("l_"):
        return next(f.description for f in funcs if f.variable_name == item)
    if item == '<':
        return 'LT'
    if item == '<=':
        return 'LE'
    if item == '==':
        return 'EQ'
    if item == '>=':
        return 'GE'
    if item == '>':
        return 'GT'
    return item


def model_view_state(item):
    if '(' in item:
        return 'O'
    if item == ')':
        return 'C'
    if item == '-' or item == '+' or item == '*' or item == '/':
        return 'B'
    if item.startswith('p_') or item.startswith('c_') or item.startswith('l_') or item == '^2' or item == 'e'\
            or item == 'pi' or any(char.isdigit() for char in item):
        return 'V'
    return ''


@api.route('/processes/<int:cId>/variants')
def get_variants(cId):
    variants = Variants.query.filter_by(processes_id=cId)
    return jsonify(
        {'variants': [{**variant.as_dict(),
                       'components': [c.as_dict() for c in variant.variant_components],
                       'loss_functions': [lf.as_dict() for lf in variant.variants_loss_functions]}
                      for variant in variants]})


@api.route('/variants/<int:cId>')
def get_variant(cId):
    variant = Variants.query.filter_by(id=cId).first()
    return jsonify(
        {**variant.as_dict(),
         'components': [c.as_dict() for c in variant.variant_components],
         'loss_functions': [lf.as_dict() for lf in variant.variants_loss_functions]})


@api.route('/processes/<int:cId>/info_texts')
def get_info_texts(cId):
    texts = InfoTexts.query.filter_by(type=1).filter_by(processes_id=cId)
    return jsonify({'info_texts': [text.as_dict() for text in texts]})


@api.route('/processes/<int:cId>/selection', methods=['POST'])
def create_selection(cId):
    sel = request.get_json()
    selection = VariantSelection.query.filter_by(processes_id=cId).first()
    if selection is not None:
        selection.selection = json.dumps(sel)
        db.session.commit()
        return Response(sel, 204, mimetype='application/json')
    else:
        s = VariantSelection(processes_id=cId, selection=json.dumps(sel))
        db.session.add(s)
        db.session.commit()
        return Response(sel, 201, mimetype='application/json')


@api.route('/processes/<int:cId>/selection', methods=['GET'])
def get_selection(cId):
    selection = VariantSelection.query.filter_by(processes_id=cId).first()
    # ToDo: error for id not found
    return Response(selection.selection, 200, mimetype='application/json')


@api.route('/processes/used-component-types')
def used_component_types():
    components = VariantComponents.query.all()
    distinct_used_apis = list(set([c.component_api_name for c in components]))
    return jsonify(distinct_used_apis)
