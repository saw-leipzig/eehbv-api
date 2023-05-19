import json
from flask import jsonify, request, Response, g, url_for, current_app
from sqlalchemy import select
from ..models import ColumnInfo, Components, create_new_component_table, Permission
from . import api
from app import db
from ..decorators import permission_required


@api.route('/components', methods=['POST'])
@permission_required(Permission.OPT)
def new_component_type():
    comp_type = request.get_json()
    try:
        # ToDo: Handle clean transaction! Component will get id only after commit :-(
        comp_dict = {key: comp_type[key] for key in ["table_name", "view_name", "api_name", "is_aggregate"]}
        c = Components(**comp_dict)
        db.session.add(c)
        db.session.commit()
        for column in comp_type["columns"]:
            column_dict = {key: column[key] for key in ["column_name", "view_name", "type", "position", "unit"]}
            column_dict["component_id"] = c.id
            i = ColumnInfo(**column_dict)
            db.session.add(i)
        db.session.commit()
        create_new_component_table(comp_type["table_name"], comp_type["api_name"], comp_type["columns"])
    except BaseException as e:
        return return_error(e)
    json_type = get_table_raw(c.id)
    return Response(json.dumps(json_type), 201, mimetype='application/json')


def return_error(ex):
    return Response('{"status": "failed", "message": "' + str(ex) + '"}', 500, mimetype='application/json')


@api.route('/component-types')
def get_tables():
    component_types = Components.query.all()
    infos = ColumnInfo.query.all()
    ctypes = {'componentTypes':
                  [{**component_type.as_dict(),
                    'infos': sorted([info.as_dict() for info in infos if info.component_id == component_type.id],
                                    key=lambda x: x['position'])} for component_type in component_types]}
    return jsonify(ctypes)


@api.route('/component-types/<int:cId>')
def get_table(cId):
    return jsonify(get_table_raw(cId))


def get_table_raw(cId):
    component_type = Components.query.filter_by(id=cId).first()
    return get_component_table(cId, component_type)


@api.route('/component-types/<cType>')
def get_table_type(cType):
    return jsonify(get_table_type_object(cType))


def get_table_type_object(cType):
    component_type = Components.query.filter_by(api_name=cType).first()
    return get_component_table(component_type.id, component_type)


def get_component_table(cId, component_type):
    infos = ColumnInfo.query.filter_by(component_id=cId)
    c_type = {**component_type.as_dict(),
              'infos': sorted([info.as_dict() for info in infos],
                              key=lambda x: x['position'])}
    return c_type


@api.route('/component-infos')
def get_infos():
    infos = ColumnInfo.query.all()
    return jsonify([info.as_dict() for info in infos])


@api.route('/component-infos/<cType>')
def get_info(cType):
    return jsonify(get_info_object(cType))


def get_info_object(cType):
    component_type = Components.query.filter_by(api_name=cType).first()
    c_id = component_type.id
    infos = ColumnInfo.query.filter_by(component_id=c_id)
    return [info.as_dict() for info in infos]
