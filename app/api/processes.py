import json
from flask import jsonify, request, Response
from . import api
from ..models import Processes, ProcessParameters, InfoTexts, Variants, VariantSelection, ProblemType, Permission
from app import db
from ..decorators import permission_required


@api.route('/processes')
def get_processes():
    processes = Processes.query.all()
    return jsonify({'processes': [{**process.as_dict(), 'parameters': [p.as_dict() for p in process.process_parameters]} for process in processes]})


@api.route('/processes/<int:cId>')
def get_process(cId):
    process = Processes.query.filter_by(id=cId).first()
    return jsonify({**process.as_dict(), 'parameters': [p.as_dict() for p in process.process_parameters]})


@api.route('/processes', methods=['POST'])
@permission_required(Permission.OPT)
def create_process():
    proc = request.get_json()
    proc_dict = {key: proc[key] for key in ['view_name', 'api_name', 'variant_tree']}
    p = Processes(**proc_dict)
    db.session.add(p)
    db.session.commit()
    for param in proc['process']['process_parameters']:
        param_dict = {**param, 'processes_id': p.id}
        pp = ProcessParameters(**param_dict)
        db.session.add(pp)
    for variant in proc['variants']:
        var_dict = {**variant, 'processes_id': p.id}
        v = Variants(**var_dict)
        db.session.add(v)
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
    return Response(get_process(p.id), 201, mimetype='application/json')


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
