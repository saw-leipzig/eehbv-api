import json
from flask import jsonify, request, Response
from ..models import Glossary, GlossaryProcesses, Permission
from . import api
from app import db
from ..decorators import permission_required
from .properties import delete_entry


@api.route('/glossary')
def get_glossary():
    glossary = Glossary.query.all()
    return jsonify(sorted([get_item(item) for item in glossary], key=lambda x: x['term']))


@api.route('/glossary/<int:cId>')
def get_glossary_item(cId):
    entry = Glossary.query.filter_by(id=cId).first()
    return jsonify(get_item(entry))
    # return jsonify({**item.as_dict(), 'processes': [p.as_dict() for p in item.glossary_processes]})


def get_item(entry):
    return {**entry.as_dict(), 'processes': [p.as_dict()[key] for key in ['processes_id'] for p in entry.glossary_processes]}


@api.route('/glossary', methods=['POST'])
@permission_required(Permission.DATA)
def new_glossary():
    gloss = request.get_json()
    gloss_dict = {key: gloss[key] for key in ['term', 'text']}
    g = Glossary(**gloss_dict)
    db.session.add(g)
    db.session.commit()
    for proc in gloss['processes']:
        proc_dict = {'processes_id': proc, 'glossary_id': g.id}
        gp = GlossaryProcesses(**proc_dict)
        db.session.add(gp)
    db.session.commit()
    ng = Glossary.query.filter_by(id=g.id).first()
    json_gloss = json.dumps(get_item(ng))
    return Response(json_gloss, 201, mimetype='application/json')


@api.route('/glossary/<int:cId>', methods=['PUT'])
@permission_required(Permission.DATA)
def edit_glossary(cId):
    gloss = request.get_json()
    gloss_dict = {key: gloss[key] for key in ['term', 'text']}
    Glossary.query.filter_by(id=cId).update({**gloss_dict})
    gp = GlossaryProcesses.query.filter_by(glossary_id=cId)
    for old_gp in gp:
        if old_gp.processes_id not in gloss['processes']:
            db.session.delete(old_gp)
    for new_gp_id in gloss['processes']:
        if new_gp_id != gp.processes_id if isinstance(gp, GlossaryProcesses) else new_gp_id not in map(lambda x: x.processes_id, gp):
            proc_dict = {'processes_id': new_gp_id, 'glossary_id': cId}
            gp = GlossaryProcesses(**proc_dict)
            db.session.add(gp)
    db.session.commit()
    g = Glossary.query.filter_by(id=cId).first()
    json_gloss = json.dumps(get_item(g))
    return Response(json_gloss, mimetype='application/json')


@api.route('/glossary/<int:cId>', methods=['DELETE'])
@permission_required(Permission.DATA)
def del_glossary(cId):
    delete_entry(Glossary, cId)
