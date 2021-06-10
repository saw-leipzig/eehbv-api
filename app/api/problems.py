from flask import request

from ..models import ProblemWrapper
from . import api


problems = ProblemWrapper()


@api.route('/problems/<int:cId>', methods=['POST'])
def solve(cId):
    model = request.get_json()
    problems.call_solver(cId, model)
    return ''
