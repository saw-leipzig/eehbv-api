import types
import time
from app import db
from sqlalchemy import select, BOOLEAN, INTEGER, FLOAT, VARCHAR, Column, Table
from sqlalchemy.schema import CreateTable


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


class MaterialProperties(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['material_properties']


class PropertyValues(db.Model, Serializable):
    __table__ = db.Model.metadata.tables['property_values']


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
                        VARCHAR(40) if column["type"] == 'VARCHAR' else FLOAT if column["type"] == 'DOUBLE' else BOOLEAN)
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

    def call_solver(self, cId, process, model):
        if cId not in self.problems:
            p = ProblemType.query.filter_by(id=cId).first()
            if p is None:
                raise Exception('Problem not defined')
            self.problems[cId] = import_code(p.code, process)
        time.sleep(16)  # for testing polling only
        return self.problems[cId].call_solver(model)


create_models()
