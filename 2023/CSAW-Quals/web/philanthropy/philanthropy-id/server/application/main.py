from flask import Flask, current_app, request
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager

app = Flask(__name__)
app.config.from_object('application.config.Config')

db_host = app.config["DB_HOST"]
db_user = app.config["DB_USERNAME"]
db_pass = app.config["DB_PASSWORD"]

db_url = f'postgresql://{db_user}:{db_pass}@{db_host}/philanthropy'

app.config["SQLALCHEMY_DATABASE_URI"] = db_url

db = SQLAlchemy()
db.init_app(app)


jwt = JWTManager(app)

with app.app_context():
    from application.blueprints.routes import identity,response

app.register_blueprint(identity, url_prefix='/identity')

@app.errorhandler(404)
def not_found(error):
    return response('404 Not Found'), 404

@app.errorhandler(403)
def forbidden(error):
    return response('403 Forbidden'), 403

@app.errorhandler(400)
def bad_request(error):
    return response('400 Bad Request'), 400

if __name__ == '__main__':
    app.run()