#!/usr/bin/env python3
import flask
from PIL import Image

import os
import tempfile

app = flask.Flask(__name__)
app.config["TEMPLATES_AUTO_RELOAD"] = True
app.secret_key = os.urandom(32)

@app.route("/", methods=["GET", "POST"])
def home():
    if flask.request.method == "POST":
        imgfile = flask.request.files.get("image", None)
        if not imgfile:
            flask.flash("No image found")
            return flask.redirect(flask.request.url)

        filename = imgfile.filename
        ext = os.path.splitext(filename)[1]

        if (ext not in [".jpg", ".png"]):
            flask.flash("Invalid extension")
            return flask.redirect(flask.request.url)

        tmp = tempfile.mktemp("test")
        imgpath = "{}.{}".format(tmp, ext)
        imgfile.save(imgpath)

        img = Image.open(imgpath)
        width, height = img.size
        ratio = 256.0 / max(width, height)

        new_dimensions = (int(width * ratio), int(height * ratio))
        resized = img.resize(new_dimensions)
        resized.save(imgpath)

        resp = flask.make_response()
        with open(imgpath, "rb") as fd:
            resp.data = fd.read()
        resp.headers["Content-Disposition"] = "attachment; filename=new_{}".format(filename)

        os.unlink(imgpath)
        return resp

    return flask.render_template("home.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
