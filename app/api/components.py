from flask import jsonify, request, g, url_for, current_app

from . import api


@api.route('/components/<cType>/')
def get_components(cType):
    return jsonify({
        'comp': cType
    })


@api.route('/components/<cType>/<int:cId>')
def get_component(cType, cId):
    return jsonify({
        'comp': cType,
        'id': cId
    })


@api.route('/components/<cType>', methods=['POST'])
def new_component(cType):
    return jsonify({
        'comp': cType
    })


@api.route('/components/<cType>/<int:cId>', methods=['PUT'])
def edit_component(cType, cId):
    return jsonify({
        'comp': cType
    })


@api.route('/components/<cType>/<int:cId>', methods=['DELETE'])
def del_component(cType, cId):
    return jsonify({
        'comp': cType
    })
