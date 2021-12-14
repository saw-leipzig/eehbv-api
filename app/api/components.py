import json
import os
from flask import jsonify, request, abort, Response, current_app
from werkzeug.utils import secure_filename
import pandas as pd
from ..decimalencoder import DecimalEncoder
from ..models import components, Permission
from . import api
from app import db
from ..decorators import permission_required, abort_failed
from .tables import get_info_object


ALLOWED_EXTENSIONS = {'xlsx', 'csv'}


@api.before_request
def check_path():
    pos = 4
    parts = request.path.split('/')
    if len(parts) > pos and parts[pos - 1] == 'components':
        if not parts[pos] in components:
            abort(404)


@api.route('/components/<cType>')
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


@api.route('/components/<cType>/upload', methods=['POST'])
@permission_required(Permission.DATA)
def upload_components(cType):
    if 'file' not in request.files:
        return abort_failed('No file part submitted', 400)
    file = request.files['file']
    if not file or file.filename == '':
        return abort_failed('No selected file', 400)
    if not allowed_file(file.filename):
        return abort_failed('Only Excel or CSV files allowed for import', 400)
    path = os.path.join(current_app.config['DATA_PATH'], secure_filename(file.filename))
    file.save(path)
    import_result = import_file(cType, path)
    os.remove(path)
    return jsonify({'status': import_result[0], 'msg': import_result[1]}), import_result[2]


def import_file(cType, path):
    table = get_info_object(cType)
    try:
        if path.lower().endswith('.xlsx'):
            data = pd.read_excel(path)
        else:
            data = pd.read_csv(path)
        db_columns = list(map(lambda x: x['column_name'], table))
        file_columns = list(data)
        missing_columns = set(db_columns).difference(file_columns)
        if len(missing_columns) > 0:
            return 'failed', 'Missing columns: ' + str(missing_columns), 400
        d = pd.DataFrame(data, columns=db_columns)
        for entry in d.to_dict(orient='records'):
            c = components[cType](**entry)
            db.session.add(c)
        db.session.commit()
        return 'ok', 'Imported data', 201
    except BaseException as e:
        print(e.args[0])
        return 'failed', e.args[0], 500


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
