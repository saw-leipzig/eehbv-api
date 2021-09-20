from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import ForeignKeyConstraint
from flask_cors import CORS
from config import config

db = SQLAlchemy()


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    # app.config.from_object(config['default'])
    config[config_name].init_app(app)
    # config['default'].init_app(app)
    CORS(app)

    app.app_context().push()
    db.init_app(app)

    db.reflect(bind='__all__', app=app)
    db.metadata.tables['column_info'].append_constraint(ForeignKeyConstraint(['component_id'], ['components.id']))
    db.metadata.tables['process_parameters'].append_constraint(ForeignKeyConstraint(['processes_id'], ['processes.id']))
    db.metadata.tables['variant_components'].append_constraint(ForeignKeyConstraint(['variants_id'], ['variants.id']))
    # db.metadata.tables['processes'].__table__.columns.pp = db.append_constraint(ForeignKeyConstraint(['processes_id'], ['processes.id']))
    print(db.metadata.tables)

    from .api import api as api_blueprint
    app.register_blueprint(api_blueprint, url_prefix='/api/v1')

    return app
