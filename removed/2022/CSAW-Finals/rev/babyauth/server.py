#!/usr/bin/env python3
"""
server.py

    Simple authentication service, with a validation binary used to sanity-check the
    XML document that is submitted
"""
import os
import json
import subprocess
from subprocess import PIPE

import xmltodict
from flask import Flask, render_template, redirect, flash, jsonify, request, url_for
from werkzeug.utils import secure_filename

REDACTED_ARGUMENTS = ["--recover", "--huge", "--xpath", "/test[string-length() < '4']"]

UPLOAD_FOLDER = "uploads/"
ALLOWED_EXTENSIONS = {"xml"}

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["SECRET_KEY"] = "something_along_the_way"


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")


@app.route("/", methods=["POST"])
def validate():
    if "file" not in request.files:
        flash("No file submitted.")
        return redirect(request.url)

    file = request.files["file"]
    if file.filename == "":
        flash("No file submitted.")
        return redirect(request.url)

    if not allowed_file(file.filename):
        flash("File extension is not allowed.")
        return redirect(request.url)

    # prodsec: sanitize path, save to disk for more checks
    filename = secure_filename(file.filename)
    file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))

    # prodsec: run internal validator to prevent errors, or worst, attacks
    proc = subprocess.Popen(
        ["./validator"] + REDACTED_ARGUMENTS + [filename], stdout=PIPE, stderr=PIPE
    )
    try:
        out, errs = proc.communicate(timeout=1)
    except Exception:
        proc.kill()
        flash("Runtime error.")
        return redirect(request.url)

    if errs:
        flash(f"Runtime errors: {errs}")
        return redirect(request.url)

    # now parse the XML!
    with open(filename, "r") as fd:
        contents = fd.read()

    try:
        results = json.dumps(xmltodict.parse(contents))
    except Exception:
        flash("XML parsing error")
        return redirect(request.url)

    username = request.form["username"]
    password = request.form["password"]

    if "username" in results:
        if username != results["username"]:
            flash("XML parsing error")
            return redirect(request.url)
    else:
        flash("XML parsing error")
        return redirect(request.url)

    if "password" in results:
        if password != results["password"]:
            flash("XML parsing error")
            return redirect(request.url)
    else:
        flash("XML parsing error")
        return redirect(request.url)

    flash("Looks good! But I can't sign you in right now...")
    return redirect(request.url)


@app.errorhandler(400)
def bad_request(error):
    return jsonify(success=False, message=error.description), 400


@app.errorhandler(500)
def server_error(error):
    return jsonify(success=False, message=error.description), 500


if __name__ == "__main__":
    if not os.path.exists(app.config["UPLOAD_FOLDER"]):
        os.mkdir(app.config["UPLOAD_FOLDER"])
    app.run(host="0.0.0.0", port=8080, debug=False)
