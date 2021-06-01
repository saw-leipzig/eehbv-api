import json
from flask import jsonify, request, g, url_for, current_app
from sqlalchemy import select
from ..models import ColumnInfo, Components
from . import api
from app import db


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
