import types
import time
from app import db
from flask import current_app
from sqlalchemy import select, BOOLEAN, INTEGER, FLOAT, VARCHAR, Column, Table
from sqlalchemy.schema import CreateTable
from werkzeug.security import generate_password_hash, check_password_hash
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer

TARGET_FUNC = 'target_func'


class Serializable:
    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class ColumnInfo(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['column_info']


class Components(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['components']


class ProcessParameters(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['process_parameters']


class ProcessSources(db.Model, Serializable):       # this table is only for testing purposes, contains requests to create process type
    __table__ = db.Model.metadata.tables['process_sources']


class Processes(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['processes']
    process_parameters = db.relationship('ProcessParameters', lazy=False, cascade="all, delete-orphan")
    process_solvers = db.relationship('ProblemType', lazy=False, cascade="all, delete-orphan")
    loss_functions = db.relationship('LossFunctions', lazy=False, cascade="all, delete-orphan")
    info_texts = db.relationship('InfoTexts', lazy=False, cascade="all, delete-orphan")
    variant_selection = db.relationship('VariantSelection', lazy=False, cascade="all, delete-orphan")


class ProblemType(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['process_solvers']


class InfoTexts(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['info_texts']


class Variants(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variants']
    variant_components = db.relationship('VariantComponents', lazy=False, cascade="all, delete-orphan")
    variants_loss_functions = db.relationship('VariantsLossFunctions', lazy=False, cascade="all, delete-orphan")
    restrictions = db.relationship('Restrictions', lazy=False, cascade="all, delete-orphan")


class VariantComponents(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variant_components']


class VariantsLossFunctions(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variants_loss_functions']


class LossFunctions(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['loss_functions']


class Restrictions(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['restrictions']


class VariantSelection(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variant_selection']


class MaterialProperties(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['material_properties']


class PropertyValues(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['property_values']


class GlossaryProcesses(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['glossary_processes']


class Glossary(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['glossary']
    glossary_processes = db.relationship('GlossaryProcesses', lazy=False)


class Roles(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['roles']


class Requests(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['requests']


class Users(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['users']

    @property
    def password(self):
        raise AttributeError('Password is not a readable attribute')

    @password.setter
    def password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)

    def generate_auth_token(self, expiration=28800):
        s = Serializer(current_app.config['SECRET_KEY'],
                       expires_in=expiration)
        return s.dumps({'id': self.id, 'role': self.role}).decode('utf-8')

    @staticmethod
    def verify_auth_token(token):
        s = Serializer(current_app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
        except:
            return None
        return Users.query.get(data['id'])

    @staticmethod
    def is_admin(token):
        s = Serializer(current_app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
            return data['role'] == Permission.ADMIN
        except:
            return False

    @staticmethod
    def is_self_or_admin(token, cId):
        s = Serializer(current_app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
            return data['role'] == Permission.ADMIN or data['id'] == cId
        except:
            return False


class Permission:
    DATA = 1
    OPT = 2
    ADMIN = 3


components = {}
tables = {}


def create_models():
    s = select([Components])
    cs = db.engine.execute(s).fetchall()
    for comp in cs:
        tables[comp.api_name] = db.Model.metadata.tables[comp.table_name]
        components[comp.api_name] = type(comp.api_name, (db.Model, Serializable,),
                                         {"__table__": db.Model.metadata.tables[comp.table_name]})


def create_new_component_table(table_name, api_name, columns):
    columns = [Column('id', INTEGER, primary_key=True),
               *[Column(column["column_name"],
                        VARCHAR(40) if column["type"] == 'VARCHAR' else FLOAT if column[
                                                                                     "type"] == 'DOUBLE' else BOOLEAN)
                 for column in columns]]
    table = Table(table_name, db.metadata, *columns)
    table_creation_sql = CreateTable(table)
    print(table_creation_sql)
    db.engine.execute(table_creation_sql)
    print(db.metadata.tables)
    tables[api_name] = db.Model.metadata.tables[table_name]
    components[api_name] = type(api_name, (db.Model, Serializable,),
                                {"__table__": db.Model.metadata.tables[table_name]})
    print(components[api_name])


def import_code(code, name):
    module = types.ModuleType(name)
    exec(code, module.__dict__)
    return module


class ProblemWrapper:
    def __init__(self):
        self.problems = {}

    def call_solver(self, c_id, code, process, lf, model, data):
        if c_id not in self.problems:
            self.problems[c_id] = import_code(code, process)
        # time.sleep(16)  # for testing polling only
        return self.problems[c_id].call_solver(lf, model, data)

    def remove_function(self, c_id):
        self.problems.pop(c_id, None)


class LossFuncWrapper:
    def __init__(self):
        self.loss_functions = {}

    def get_functions(self, process, variant):
        missing_functions = []
        for lf in variant.variants_loss_functions:
            if lf.loss_functions_id not in self.loss_functions:
                missing_functions.append(lf.loss_functions_id)
        if len(missing_functions) > 0:
            lfs = LossFunctions.query. \
                filter(LossFunctions.id.in_(missing_functions)).all()
            for lf in lfs:
                if lf.func is None or TARGET_FUNC not in lf.func:
                    raise Exception('Target function not defined')
                code = lf.func.replace(TARGET_FUNC, TARGET_FUNC + '_' + str(lf.id))
                self.loss_functions[lf.id] = import_code(code, process + '_id_' + str(lf.id))
        return {lf.loss_functions_id: getattr(self.loss_functions[lf.loss_functions_id],
                                              TARGET_FUNC + '_' + str(lf.loss_functions_id))
                for lf in variant.variants_loss_functions}

    def remove_functions(self, c_id):
        lfs = LossFunctions.query.filter_by(processes_id=c_id)
        for lf in lfs:
            self.loss_functions.pop(lf.id, None)

#        return {lf.position: getattr(self.loss_functions[lf.loss_functions_id], TARGET_FUNC + '_' + str(lf.loss_functions_id))
#                for lf in variant.variants_loss_functions}


create_models()
