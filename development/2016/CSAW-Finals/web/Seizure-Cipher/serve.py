from flask import Flask, render_template, request, redirect, abort
import logging
import os

app = Flask("app", static_folder="static", template_folder="templates")

with app.app_context():
    from app.views import init_views
    init_views(app)

app.run(host="0.0.0.0", port=9000)
