import json
import os
import threading
from datetime import datetime
from flask import request, current_app, Response

from ..models import ProblemWrapper
from . import api


FINISHED = '/finished'
FAILED = '/failed'

problems = ProblemWrapper()


@api.route('/problems/result/<timestamp>', methods=['GET'])
def get_result(timestamp):
    path = current_app.config['DATA_PATH'] + '/' + timestamp
    if not(os.path.exists(path + FAILED)) and not(os.path.exists(path + FINISHED)):
        return Response("{'status': 'pending'}", 200, mimetype='application/json')
    with open(path + '/result.html', 'r') as f:
        result = f.read()
    return Response(result, 200 if os.path.exists(path + FINISHED) else 500, mimetype='text/plain')


@api.route('/problems/<int:cId>', methods=['POST'])
def handle_problem(cId):
    model = request.get_json()
    print(json.dumps(model))
    date_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    path = current_app.config['DATA_PATH'] + '/' + date_time
    os.mkdir(path)
    with open(path + '/problem.json', 'w') as f:
        json.dump(model, f)
    try:
        solve(cId, model['process']['api_name'], model, path)
    except:
        return Response('Wrong arguments', 400, mimetype='text/plain')
    return Response(date_time, 202, mimetype='text/plain', headers={'Content-Location': '/problems/result/' + date_time})


def solve(cId, process, model, path):
    app = current_app._get_current_object()
    solver_thread = threading.Thread(target=threaded_solve, name='solver-' + path,
                                     args=[app, cId, process, model, path])
    solver_thread.start()


def threaded_solve(cApp, cId, process, model, path):
    result_file = path + '/result.html'
    try:
        with cApp.app_context():
            result = problems.call_solver(cId, process, model)
        res_str = '<div>{res}</div>'.format(res=result if (isinstance(result, str)) else json.dumps(result))
        with open(result_file, 'w') as f:
            f.write(res_str)
        open(path + FINISHED, 'a').close()
    except BaseException as e:
        with open(result_file, 'w') as f:
            f.write(e.args[0] + '\n' + e.args[0])
        open(path + FAILED, 'a').close()
