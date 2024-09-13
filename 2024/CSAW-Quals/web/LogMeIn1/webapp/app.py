from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os
from models import init_db
from routes import pagebp


app = Flask(__name__,static_folder=".")

#init db

db_host = os.environ['DB_HOST']
db_username = os.environ['DB_USERNAME']
db_pass = os.environ['DB_PASSWORD']
db_port = os.environ['DB_PORT']
db_name = os.environ['DB_NAME']

db_url = f'postgresql://{db_username}:{db_pass}@{db_host}:{db_port}/{db_name}'

app.config["SQLALCHEMY_DATABASE_URI"] = db_url
app.secret_key = os.environ['FLASK_SECRET']

db = SQLAlchemy()
init_db(app)


app.register_blueprint(pagebp)


if __name__ == '__main__':
    app.run(host="0.0.0.0", threaded=True, port=1111)




