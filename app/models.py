import types
import time
from app import db
from sqlalchemy import select


class Serializable:
    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class ColumnInfo(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['column_info']


class Components(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['components']


class ProcessParameters(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['process_parameters']


class Processes(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['processes']
    process_parameters = db.relationship('ProcessParameters', lazy=False)


class ProblemType(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['process_solvers']


class InfoTexts(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['info_texts']


class Variants(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variants']
    variant_components = db.relationship('VariantComponents', lazy=False)


class VariantComponents(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variant_components']


class VariantQuestions(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variant_questions']


class VariantTreeQuestions(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['tree_questions']


class VariantExcludes(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variant_excludes']


class VariantSelection(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['variant_selection']


components = {}
tables = {}


def create_models():
    s = select([Components])
    cs = db.engine.execute(s).fetchall()
    for comp in cs:
        tables[comp.api_name] = db.Model.metadata.tables[comp.table_name]
        components[comp.api_name] = type(comp.api_name, (db.Model, Serializable,), {"__table__": db.Model.metadata.tables[comp.table_name]})


def import_code(code, name):
    module = types.ModuleType(name)
    exec(code, module.__dict__)
    return module


class ProblemWrapper:
    def __init__(self):
        self.problems = {}

    def call_solver(self, cId, process, model):
        if cId not in self.problems:
            p = ProblemType.query.filter_by(id=cId).first()
            if p is None:
                raise Exception('Problem not defined')
            self.problems[cId] = import_code(p.code, process)
        time.sleep(16)  # for testing polling only
        return self.problems[cId].call_solver(model)


create_models()
