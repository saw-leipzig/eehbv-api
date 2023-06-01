import json
from flask import jsonify, request, Response
from . import api
from ..models import Processes, ProcessParameters, LossFunctions, VariantsLossFunctions, InfoTexts, Variants,\
    VariantComponents, VariantsRestrictions, Restrictions, VariantSelection, ProblemType, Permission
from app import db
from ..decorators import permission_required


@api.route('/procceses/<int:cId>', methods=['DELETE'])
@permission_required(Permission.OPT)
def delete_process(cId):
    proc = get_process_raw(cId)
    if proc is None:
        return jsonify({
            'status': 'not found',
            'table': 'processes',
            'id': cId
        }), 204
    db.session.delete(proc)
    db.session.commit()
    return jsonify({
        'status': 'ok',
        'table': 'processes',
        'deleted': cId
    })

@api.route('/processes')
def get_processes():
    processes = Processes.query.all()
    return jsonify({'processes': [{**process.as_dict(), 'parameters': [p.as_dict() for p in process.process_parameters]} for process in processes]})


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
        # param_dict = {**param, 'processes_id': p.id}
        needed_param_entries = {key: param[key] for key in ['name', 'unit', 'variable_name', 'material_properties_id', 'dependent', 'derived_parameter', 'dependency']}
        param_dict = {**needed_param_entries, 'defaults': '', 'general': False, 'processes_id': p.id}
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
            r_dict = {**needed_r_entries, 'processes_id': p.id}
            restr = Restrictions(**r_dict)
            db.session.add(restr)
            db.session.commit()
            vr_dict = {'variants_id': v.id, 'restrictions_id': restr.id}
            vr = VariantsRestrictions(**vr_dict)
            db.session.add(vr)
    var_select_dict = {'processes_id': p.id, 'selection': json.dumps(proc['variant_selection'])}
    vs = VariantSelection(**var_select_dict)
    db.session.add(vs)
    solver_dict = {'processes_id': p.id, 'code': proc['solver']}
    s = ProblemType(**solver_dict)
    db.session.add(s)
    for info_text in proc['infoTexts']:
        info_dict = {**info_text, 'type_id': p.id}
        i = InfoTexts(**info_dict)
        db.session.add(i)
    db.session.commit()
    new_process = get_process_raw(p.id)
    return Response(json.dumps(new_process.as_dict()), mimetype='application/json')


@api.route('/processes/<int:cId>/variants')
def get_variants(cId):
    variants = Variants.query.filter_by(processes_id=cId)
    return jsonify(
        {'variants': [{**variant.as_dict(),
                       'components': [c.as_dict() for c in variant.variant_components],
                       'loss_functions': [lf.as_dict() for lf in variant.variants_loss_functions]}
                      for variant in variants]})


@api.route('/processes/<int:cId>/info_texts')
def get_info_texts(cId):
    texts = InfoTexts.query.filter_by(type=1).filter_by(type_id=cId)
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
