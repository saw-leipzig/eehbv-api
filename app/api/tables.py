import json
from flask import jsonify, request, Response, g, url_for, current_app
from sqlalchemy import select
from ..models import ColumnInfo, Components, create_new_component_table
from . import api
from app import db


@api.route('/components', methods=['POST'])
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
            # ToDo: create/reflect component table, update model classes
        db.session.commit()
        create_new_component_table(comp_type["table_name"], comp_type["api_name"], comp_type["columns"])
    except BaseException as e:
        return return_error(e)
    json_comp = json.dumps(comp_type)
    return Response(json_comp, 201, mimetype='application/json')


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


@api.route('/component-infos')
def get_infos():
    infos = ColumnInfo.query.all()
    return jsonify({'infos': [info.as_dict() for info in infos]})
