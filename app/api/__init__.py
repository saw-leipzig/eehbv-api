from flask import Blueprint

api = Blueprint('api', __name__)

from . import components, tables, problems, processes, properties
