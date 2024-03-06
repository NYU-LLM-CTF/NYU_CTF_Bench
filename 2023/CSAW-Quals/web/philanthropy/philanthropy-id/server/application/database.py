
from application.main import db
from flask import current_app
from flask_login import UserMixin

class Account(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True)
    password = db.Column(db.String(100))
    first_name = db.Column(db.String(100))
    last_name = db.Column(db.String(100))
    member = db.Column(db.Boolean, default=False)

class Image(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(100), unique=True)
    submitter = db.Column(db.String(100))
    credit = db.Column(db.String(100))
    mg_model = db.Column(db.String(100))

def clear_db():
    meta = db.metadata
    for table in reversed(meta.sorted_tables):
        db.session.execute(table.delete())
    db.session.commit()

def migrate_db():

    db.create_all()

    clear_db()

    db.create_all()

    db.session.add(Account(username=current_app.config['ADMIN_USERNAME'],password=current_app.config['ADMIN_PASSWORD']\
                           ,first_name="root",last_name="root", member=True))
    db.session.add(Account(username="solidsnake@protonmail.com",password="2001_$pace_Odyssey", first_name="Iroquois"\
                           ,last_name="Pliskin", member=True))
    
    db.session.add(Image(id=1, filename="b6116d5a-a415-4438-8f43-2b4cb648593e.png", submitter="solidsnake@protonmail.com", credit="N/A", mg_model="NULL"))

    db.session.add(Image(id=2, filename="124d86b2-f579-4aa3-a2b5-012a125aea7d.png", submitter="otacon@protonmail.com", credit="mling@protonmail.com", mg_model="RAY"))
    db.session.add(Image(id=3, filename="1feda4bc-baff-455d-9ef4-7a30c986a668.png", submitter="otacon@protonmail.com", credit="mling@protonmail.com", mg_model="RAY"))
    db.session.add(Image(id=4, filename="ccd1be50-eb5d-4e7c-8c74-b72622738986.png", submitter="otacon@protonmail.com", credit="otacon@protonmail.com", mg_model="RAY"))
    db.session.add(Image(id=5, filename="a267d18b-e1b1-4fc4-9fa9-97df1b55b7c2.png", submitter="otacon@protonmail.com", credit="solidsnake@protonmail.com", mg_model="RAY"))

    db.session.add(Image(id=6, filename="b2f83ebe-e6ab-4af3-9340-71109abd71b5.png", submitter="otacon@protonmail.com", credit="otacon@protonmail.com", mg_model="REX"))
    db.session.add(Image(id=7, filename="18b359f1-4ec2-4712-9e63-27630d374ea2.png", submitter="otacon@protonmail.com", credit="otacon@protonmail.com", mg_model="REX"))
    db.session.add(Image(id=8, filename="9f5ed32b-25e2-43c1-8903-04b5119d689c.png", submitter="otacon@protonmail.com", credit="otacon@protonmail.com", mg_model="REX"))
    db.session.add(Image(id=9, filename="ad56d47f-fd1d-4633-b563-c29ac025a621.png", submitter="otacon@protonmail.com", credit="otacon@protonmail.com", mg_model="REX"))

    db.session.add(Image(id=10, filename="5a25607f-d770-440c-812c-02efc477ca8e.png", submitter="otacon@protonmail.com", credit="nromanenko@protonmail.com", mg_model="NONE"))
    db.session.add(Image(id=11, filename="0c2b4e39-f509-45fb-b7b2-af8230365b22.png", submitter="otacon@protonmail.com", credit="nromanenko@protonmail.com", mg_model="NONE"))
    db.session.add(Image(id=12, filename="509e31ed-b47f-4438-87e3-cbed4fc3d0fa.png", submitter="otacon@protonmail.com", credit="nromanenko@protonmail.com", mg_model="NONE"))
    db.session.add(Image(id=13, filename="b5ce6177-5f45-4a5a-90fb-b847d902782e.png", submitter="otacon@protonmail.com", credit="nromanenko@protonmail.com", mg_model="NONE"))


    db.session.commit()