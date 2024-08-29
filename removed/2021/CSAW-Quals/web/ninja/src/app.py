#!/usr/bin/env python2

from flask import Flask
from flask import render_template, render_template_string
from flask import request
import re

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/submit', methods=["GET"])
def submit():
    try:
        template = """ <html>
             <h1> Hello {}   </h1>     
        </html>
        """.format(request.args.get('value'))

    except KeyError:
        return "Error, stop doing sneaky stuff here."

    filter_regex = r"_|config|os|RUNCMD|base|import"


    if re.search(filter_regex, template):
        return "Sorry, the following keywords/characters are not allowed :- _ ,config ,os, RUNCMD, base"


    return render_template_string(template)