import json
from . import api
from werkzeug.exceptions import HTTPException


@api.errorhandler(HTTPException)
def handle_exception(e):
    response = e.get_response()
    response.data = json.dumps({
        "code": e.code,
        "name": e.name,
        "status": "failed",
        "message": e.description,
    })
    response.content_type = "application/json"
    return response
