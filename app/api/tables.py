import json
from flask import jsonify, request, g, url_for, current_app
from sqlalchemy import select
from ..models import ColumnInfo, Components
from . import api
from app import db


@api.route('/tables')
def get_tables():
    # s = select([Components])
    # tables = db.engine.execute(s).fetchall()
    s = select([Components, ColumnInfo])
    print(s)
    s = s.select_from(db.metadata.tables['components'].join(ColumnInfo))
    tables = db.engine.execute(s).fetchall()
    print(tables)
    return ''  # jsonify(tables)


@api.route('/infos')
def get_infos():
    # s = select([ColumnInfo, Components])
    # infos = db.engine.execute(s).fetchall()
    infos = ColumnInfo.query.all()
    return jsonify({'infos': [info.as_dict() for info in infos]})
