from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Account(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    displayname = db.Column(db.String(80), nullable=False)
    password = db.Column(db.String(80), nullable=False)
    # 0 - admin, 1 - user
    uid = db.Column(db.Integer, nullable=False)
    # Add more fields as needed
    
def init_db(app):
    db.init_app(app)

def clear_db():
    meta = db.metadata
    for table in reversed(meta.sorted_tables):
        db.session.execute(table.delete())
    db.session.commit()

def migrate_db():
    db.create_all()
    
    clear_db()

    db.create_all()

    db.session.commit()

