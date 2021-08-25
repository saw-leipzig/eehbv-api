from flask import jsonify
from . import api
from ..models import Processes, ProcessParameters, InfoTexts, Variants, VariantExcludes, VariantQuestions, VariantTreeQuestions


@api.route('/processes')
def get_processes():
    processes = Processes.query.all()
    # return jsonify({'processes': [process.as_dict() for process in processes]})
    return jsonify({'processes': [{**process.as_dict(), 'parameters': [p.as_dict() for p in process.process_parameters]} for process in processes]})


@api.route('/processes/<int:cId>/variants')
def get_variants(cId):
    variants = Variants.query.filter_by(processes_id=cId)
    return jsonify({'variants': [variant.as_dict() for variant in variants]})


@api.route('/processes/<int:cId>/info_texts')
def get_info_texts(cId):
    texts = InfoTexts.query.filter_by(type=1).filter_by(type_id=cId)
    return jsonify({'info_texts': [text.as_dict() for text in texts]})


@api.route('/processes/<int:cId>/questions')
def get_variant_questions(cId):
    process = Processes.query.filter_by(id=cId).first()
    questions = VariantQuestions.query.filter_by(processes_id=cId)
    excludes = VariantExcludes.query.filter_by(processes_id=cId)
    resp = tree_questions(questions, excludes) if process.variant_tree else tree_questions(questions, excludes)
    return jsonify(resp)


def list_questions(questions, excludes):
    return {'list': None}


def tree_questions(questions, excludes):
    tree_q = VariantTreeQuestions.query.filter(VariantTreeQuestions.variant_questions_id.in_((q.id for q in questions)))
    root = next(q for q in tree_q if q.parent_id is None)
    resp = {'question': next(q.question for q in questions if q.id is root.variant_questions_id),
            'yes': tree_recursion(root.id, 1, questions, excludes, tree_q),
            'no': tree_recursion(root.id, 0, questions, excludes, tree_q)}
    return resp


def tree_recursion(parent_id, resp, questions, excludes, tree_q):
    node = next((q for q in tree_q if q.parent_id == parent_id and q.parent_response == resp), None)
    val = {'question': None if node is None else next(q.question for q in questions if q.id is node.variant_questions_id),
           'excludes': [e.variants_id for e in excludes if e.response == resp and e.tree_questions_id == parent_id],
           'yes': None if node is None else tree_recursion(node.id, 1, questions, excludes, tree_q),
           'no': None if node is None else tree_recursion(node.id, 0, questions, excludes, tree_q)}
    return val
