import json
from . import api
from flask import jsonify, request, Response
from app import db
from ..models import PropertyValues, MaterialProperties
from ..decimalencoder import DecimalEncoder


@api.route('/properties')
def get_properties():
    props = MaterialProperties.query.all()
    return jsonify({'properties': [prop.as_dict() for prop in props]})


@api.route('/properties', methods=['POST'])
def new_property():
    prop = request.get_json()
    p = MaterialProperties(**prop)
    db.session.add(p)
    db.session.commit()
    json_prop = json.dumps(p.as_dict())
    return Response(json_prop, 201, mimetype='application/json')


@api.route('/properties/<int:cId>', methods=['PUT'])
def edit_property(cId):
    prop = request.get_json()
    return edit_entry(MaterialProperties, prop, cId)


@api.route('/properties/<int:cId>', methods=['DELETE'])
def del_property(cId):
    prop = MaterialProperties.query.filter_by(id=cId).first()
    db.session.delete(prop)
    db.session.commit()
    return jsonify({
        'status': 'ok',
        'deleted': cId
    })


@api.route('/properties/values')
def get_prop_values():
    values = PropertyValues.query.all()
    json_values = json.dumps({'values': [value.as_dict() for value in values]}, cls=DecimalEncoder)
    return Response(json_values, mimetype='application/json')


@api.route('/properties/values', methods=['POST'])
def new_prop_value():
    value = request.get_json()
    v = PropertyValues(**value)
    db.session.add(v)
    db.session.commit()
    json_prop = json.dumps(v.as_dict(), cls=DecimalEncoder)
    return Response(json_prop, 201, mimetype='application/json')


@api.route('/properties/values/<int:cId>', methods=['PUT'])
def edit_prop_value(cId):
    value = request.get_json()
    return edit_entry(PropertyValues, value, cId)


@api.route('/properties/values/<int:cId>', methods=['DELETE'])
def del_prop_value(cId):
    return delete_entry(PropertyValues, cId)


def edit_entry(clazz, value, cId):
    clazz.query.filter_by(id=cId).update(value)
    db.session.commit()
    v = clazz.query.filter_by(id=cId).first()
    json_comp = json.dumps(v.as_dict(), cls=DecimalEncoder)
    return Response(json_comp, mimetype='application/json')


def delete_entry(clazz, cId):
    value = clazz.query.filter_by(id=cId).first()
    db.session.delete(value)
    db.session.commit()
    return jsonify({
        'status': 'ok',
        'deleted': cId
    })
