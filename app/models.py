from app import db
from sqlalchemy import select


class ColumnInfo(db.Model):
    __table__ = db.Model.metadata.tables['column_info']


class Components(db.Model):
    __table__ = db.Model.metadata.tables['components']


components = {}
tables = {}


def create_models():
    s = select([Components])
    cs = db.engine.execute(s).fetchall()
    for comp in cs:
        tables[comp.api_name] = db.Model.metadata.tables[comp.table_name]
        components[comp.api_name] = type(comp.api_name, (db.Model,), {"__table__": db.Model.metadata.tables[comp.table_name]})


create_models()
