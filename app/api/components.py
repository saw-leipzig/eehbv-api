import json
from flask import jsonify, request, abort, Response
from ..decimalencoder import DecimalEncoder
from ..models import components, Permission
from . import api
from app import db
from ..decorators import permission_required


@api.before_request
def check_path():
    pos = 4
    parts = request.path.split('/')
    if len(parts) > pos and parts[pos - 1] == 'components':
        if not parts[pos] in components:
            abort(404)


@api.route('/components/<cType>/')
def get_components(cType):
    comps = components[cType].query.all()
    print([c.as_dict() for c in comps])
    json_comp = json.dumps({'components': [c.as_dict() for c in comps]}, cls=DecimalEncoder)
    print(json_comp)
    return Response(json_comp, mimetype='application/json')


@api.route('/components/<cType>/<int:cId>')
def get_component(cType, cId):
    c = components[cType].query.filter_by(id=cId).first()
    json_comp = json.dumps(c.as_dict(), cls=DecimalEncoder)
    return Response(json_comp, mimetype='application/json')


@api.route('/components/<cType>', methods=['POST'])
@permission_required(Permission.DATA)
def new_component(cType):
    comp = request.get_json()
    c = components[cType](**comp)
    db.session.add(c)
    db.session.commit()
    json_comp = json.dumps(c.as_dict(), cls=DecimalEncoder)
    return Response(json_comp, 201, mimetype='application/json')


@api.route('/components/<cType>/<int:cId>', methods=['PUT'])
@permission_required(Permission.DATA)
def edit_component(cType, cId):
    comp = request.get_json()
    components[cType].query.filter_by(id=cId).update(comp)
    db.session.commit()
    c = components[cType].query.filter_by(id=cId).first()
    json_comp = json.dumps(c.as_dict(), cls=DecimalEncoder)
    return Response(json_comp, mimetype='application/json')


@api.route('/components/<cType>/<int:cId>', methods=['DELETE'])
@permission_required(Permission.DATA)
def del_component(cType, cId):
    c = components[cType].query.filter_by(id=cId).first()
    db.session.delete(c)
    db.session.commit()
    return jsonify({
        'status': 'ok',
        'table': cType,
        'deleted': cId
    })
