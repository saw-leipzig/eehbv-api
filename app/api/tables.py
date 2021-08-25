import json
from flask import jsonify, request, Response, g, url_for, current_app
from sqlalchemy import select
from ..models import ColumnInfo, Components
from . import api
from app import db


@api.route('/components', methods=['POST'])
def new_component_type():
    comp_type = request.get_json()
    # ToDo: Handle clean transaction! Component will get id only after commit :-(
    c = Components(table_name=comp_type.table_name, view_name=comp_type.view_name, api_name=comp_type.api_name,
                   is_aggregate=comp_type.is_aggregate)
    db.session.add(c)
    db.session.commit()
    for column in comp_type.columns:
        i = ColumnInfo(component_id=c.id, column_name=column.column_name, view_name=column.view_name, type=column.type,
                       position=column.position, unit=column.unit)
        db.session.add(i)
        # ToDo: create component table, update model classes
    db.session.commit()
    json_comp = json.dumps(c.as_dict())
    return Response(json_comp, 201, mimetype='application/json')


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
