from flask import request

from ..models import ProblemWrapper
from . import api


problems = ProblemWrapper()


@api.route('/problems/<cType>', methods=['POST'])
def solve(cType):
    model = request.get_json()
    problems.call_solver(cType, model)
    return ''
