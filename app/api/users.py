import json
from flask import jsonify, request, Response
from . import api
from ..models import Users, Permission, Roles
from app import db
from werkzeug.security import generate_password_hash
from .properties import delete_entry
from ..decorators import permission_required, abort_auth, abort_failed


@api.route('/auth/login', methods=['POST'])
def login():
    credentials = request.get_json()
    user = Users.query.filter_by(username=credentials['username']).first()
    if user is not None:
        if user.verify_password(credentials['password']):
            resp_user = get_user(user)
            resp_user['token'] = user.generate_auth_token()
            return jsonify({'status': 'ok', 'user': resp_user})
        else:
            return abort_failed('Wrong password', 200)
    else:
        return abort_failed('No such user', 200)


def get_user(user):
    return {key: user.as_dict()[key] for key in ["id", "username", "role"]}


@api.route('/auth/hash', methods=['POST'])
def hash_password():
    cred = request.get_json()
    pwd_hash = generate_password_hash(cred['password'])
    return jsonify({'hash': pwd_hash})


@api.route('/users')
@permission_required(Permission.ADMIN)
def get_users():
    users = Users.query.all()
    return jsonify([get_user(user) for user in users])


@api.route('/roles')
@permission_required(Permission.ADMIN)
def get_roles():
    roles = Roles.query.all()
    return jsonify([role.as_dict() for role in roles])


@api.route('/users', methods=['POST'])
@permission_required(Permission.ADMIN)
def new_user():
    user = request.get_json()
    if Users.query.filter_by(username=user['username']).first() is not None:
        return abort_failed('User already exists', 422)
    u = Users(**user)
    db.session.add(u)
    return commit_and_return_user(u, 201)


@api.route('/users/<int:cId>/password', methods=['PUT'])
def edit_user(cId):
    user = request.get_json()
    auth = request.headers.get('Authorization')
    if auth is None or not (auth.startswith('Bearer ')):
        return abort_auth('Missing authentication')
    token = auth[7:]
    if not Users.is_self_or_admin(token, user['id']):
        return abort_auth('Missing authorization')
    if user['password'] is None:
        return abort_failed('Missing parameter password', 422)
    d_user = Users.query.filter_by(id=cId)
    if d_user.first() is None:
        return abort_failed('User not found', 404)
    d_user.update({'password_hash': generate_password_hash(user['password'])})
    return commit_and_return_user(d_user.first())


@api.route('/users/<int:cId>/role', methods=['PUT'])
@permission_required(Permission.ADMIN)
def change_user_role(cId):
    user = request.get_json()
    if user['role'] is None:
        return abort_failed('Missing parameter role', 422)
    d_user = Users.query.filter_by(id=cId)
    if d_user.first() is None:
        return abort_failed('User not found', 404)
    d_user.update({'role': user['role']})
    return commit_and_return_user(d_user.first())


def commit_and_return_user(d_user, code=200):
    db.session.commit()
    json_comp = json.dumps(get_user(d_user))
    return Response(json_comp, code, mimetype='application/json')


@api.route('/users/<int:cId>', methods=['DELETE'])
@permission_required(Permission.ADMIN)
def del_user(cId):
    return delete_entry(Users, cId)
