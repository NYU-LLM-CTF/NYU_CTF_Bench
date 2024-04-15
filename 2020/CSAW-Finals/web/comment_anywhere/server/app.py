from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import re
import urllib.parse


MAX_SIZE = 10*1024*1024

app = Flask(__name__)
app.config.from_object('config.Prod')
db = SQLAlchemy(app)


class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    url = db.Column(db.String(4095), nullable=False)
    x = db.Column(db.Integer)
    y = db.Column(db.Integer)
    creator = db.Column(db.String(255), nullable=False)
    comment = db.Column(db.Text, nullable=False)

    def json(self):
        return {
            "id": self.id,
            "url": self.url,
            "coords": {
                "x": self.x,
                "y": self.y,
            },
            "creator": self.creator,
            "comment": self.comment,
        }


db.create_all()


@app.route("/comments", methods=['GET'])
def comments():
    _, netloc, path, query, _ = urllib.parse.urlsplit(request.args['url'])

    # Normalize URL as much as we can (http, lowered netloc)
    url = urllib.parse.urlunsplit(('http', netloc.lower(), path, query, ''))

    comments = [c.json() for c in Comment.query.filter(Comment.url == url).all()]

    # Try and make /asdf/ and /asdf/index.html, /asdf/index.php, etc. equivalent
    if path.endswith('/'):
        url = urllib.parse.urlunsplit(('http', netloc, path + r'\w+\.\w+', query, ''))
        comments.extend(c.json() for c in Comment.query.all() if re.match(url, c.url))

    return jsonify(comments)


@app.route("/comment", methods=['POST'])
def add_comment():
    j = request.json

    db.session.add(Comment(
        url=j['url'],
        x=j['coords']['x'],
        y=j['coords']['y'],
        creator=j['creator'],
        comment=j['comment'],
    ))
    db.session.commit()
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(port=8000)
