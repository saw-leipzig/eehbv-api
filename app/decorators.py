from functools import wraps
import json
from flask import abort, current_app, request, Response
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer


def permission_required(permission):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            auth = request.headers.get('Authorization')
            if auth is None or not(auth.startswith('Bearer ')):
                return abort_auth('Missing authentication')
            token = auth[7:]
            s = Serializer(current_app.config['SECRET_KEY'])
            try:
                data = s.loads(token)
                if data['role'] < permission:
                    return abort_auth('Not sufficient rights')
            except:
                return abort_auth('Invalid token')
            return f(*args, **kwargs)
        return decorated_function
    return decorator


def abort_auth(reason):
    return abort_failed(reason, 403)


def abort_failed(reason, code):
    return Response(json.dumps({'status': 'failed', 'message': reason}), code, mimetype='application/json')
