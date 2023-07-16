import json
import threading
from datetime import datetime
from flask import request, current_app, Response, jsonify

from ..decimalencoder import DecimalEncoder
from app import db, solver
from ..decorators import permission_required
from ..models import ProblemWrapper, LossFuncWrapper, Processes, Variants, components, \
    Requests, Restrictions, TARGET_FUNC, Permission, ProblemType
from .problems import load_restrictions, wrap_function_parameters, build_loss_function_model
from . import api
from ..solver import passed_parameters

problem_dict = ProblemWrapper()
loss_function_dict = LossFuncWrapper()


@api.route('/machines/<int:c_id>/explore', methods=['POST'])
def explore_machine(c_id):
    model = request.get_json()
    variant = Variants.query.filter_by(id=c_id).first()
    process = Processes.query.filter_by(id=variant.processes_id).first()
    component_keys = ['component_api_name', 'variable_name', 'description']
    machine = load_data(variant, model['machine'])
    loss_functions = loss_function_dict.get_functions(process.api_name, variant)
    restrictions = load_restrictions(variant.restrictions)
    lf_model = build_loss_function_model(variant)
    variant_model = {'parameters': model['parameters'],
                     'restrictions': restrictions,
                     'components': [{key: c.as_dict()[key] for key in component_keys} for c in
                                    sorted(variant.variant_components, key=lambda cc: cc.position)],
                     'loss_functions': lf_model
                     }
    res = compute_power(loss_functions, variant_model, model['parameters'], machine)
    return jsonify(res)


def load_data(variant, machine):
    data = {}
    for comp in machine.keys():
        for c in variant.variant_components:
            if c.description == comp:
                comp_name = c.component_api_name
                # cd = {}
                cd = components[comp_name].query.filter_by(id=machine[comp]['id']).first()
                # cd = components[comp_name].query.filter(components[comp_name].id == machine[comp]['id']).first()
                # exec('cd = components[comp_name].query.filter_by(component_' + comp_name + '_id == machine[comp]['id']).first()')
                if cd is None:
                    raise ValueError('Component data not found')
                data[c.variable_name] = {**cd.as_dict()}
    return data


def compute_power(loss_func, variant_model, parameters, machine):
    mpc = MachinePowerComputation(loss_func, variant_model, parameters, machine)
    return mpc.compute()


class MachinePowerComputation:

    def __init__(self, loss_func, model, parameters, machine):
        self.loss_func = loss_func
        self.model = model
        self.cl = {}
        self.losses = {}
        self.total = 0
        self.parameters = parameters
        self.machine = machine

    def compute(self):
        for depth in range(len(self.model['components'])):
            cd, msg = self.conditions_satisfied(self.machine, depth)
            if cd:
                ul, msg = self.update_losses(self.machine, depth)
                if not ul:
                    return {'success': False, 'msg': msg}
            else:
                return {'success': False, 'msg': msg}
        self.sum_losses()
        return {'success': True, 'total': self.total, 'losses': self.losses}

    def update_losses(self, combinations, depth):
        lfs = self.loss_func
        p = self.parameters
        l = self.cl
        for lf in self.model['loss_functions']:
            if lf['eval_after_position'] == depth:
                try:
                    exec(lf['variable_name'] + ' = ' + lf['function_call'])
                except Exception as ex:
                    passed_vars = passed_parameters(lf['function_call'], False, p, l, combinations)
                    msg = 'Error in evaluating function {fd} - "{fc}"; passed parameters: {pp}; error: {err}'. \
                        format(fd=lf['description'], fc=lf['function_call'], pp=passed_vars, err=str(ex))
                    return False, msg
                # pack current loss for deeper levels
                exec('self.cl["' + lf['variable_name'] + '"] = ' + lf['variable_name'])
        return True, ''

    def conditions_satisfied(self, combinations, depth):
        # noinspection DuplicatedCode
        p = self.parameters
        l = self.cl
        # check implicit conditions
        for restr in self.model['restrictions']:
            if depth == restr['eval_after_position']:
                try:
                    result = eval(restr['restriction'])
                    if not result:
                        return False, 'Restriction failed: ' + restr['restriction']
                except NameError:
                    pass
                except Exception as ex:
                    passed_vars = passed_parameters(restr['restriction'], True, p, l, combinations)
                    msg = 'Error in evaluating restriction {fd} - "{fc}"; parameters: {pp}; error: {err}'. \
                        format(fd=restr['description'], fc=restr['restriction'], pp=passed_vars, err=str(ex))
                    return False, msg
        return True, ''

    def sum_losses(self):
        for current_losses_key in self.cl.keys():
            if self.function_is_loss(current_losses_key):
                self.losses[current_losses_key] = self.cl[current_losses_key]
                self.total += self.losses[current_losses_key]

    def function_is_loss(self, var):
        return all(lf['is_loss'] for lf in self.model['loss_functions'] if lf['variable_name'] == var)
