import types
from app import db
from sqlalchemy import select


class Serializable:
    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class ColumnInfo(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['column_info']


class Components(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['components']


class ProblemType(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['problem_type']


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

    def call_solver(self, name, model):
        if name not in self.problems:
            p = ProblemType.query.filter_by(api_name=name).first()
            if p is None:
                raise Exception('Problem not defined')
            self.problems[name] = import_code(p.code, name)
        self.problems[name].call_solver(model)


create_models()
