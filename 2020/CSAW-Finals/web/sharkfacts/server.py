#!/usr/bin/env python3
import os
import urllib.parse
import requests
import gitlab
import subprocess

from flask import app, abort, render_template
from flask import Flask, redirect, url_for, session, jsonify, request
from authlib.integrations.flask_client import OAuth
from loginpass import create_gitlab_backend
from loginpass import create_flask_blueprint
from flask_session import Session

from pow import POW
from gitlab_util import creds, init_project, get_project

OAUTH_APP_NAME = 'gitlab'
GITLAB_HOST = 'gitlab.com'


app = Flask(__name__)

app.secret_key = creds.SECRET_KEY
app.config['GITLAB_CLIENT_ID'] = creds.GITLAB_CLIENT_ID
app.config['GITLAB_CLIENT_SECRET'] = creds.GITLAB_CLIENT_SECRET
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)

pow = POW(app, diff=1, count=4)

# Create an oauth registry
def fetch_token(name):
    token_session_key = '{}-token'.format(name.lower())
    return session.get(token_session_key, {})

def update_token(name, token):
    token_session_key = '{}-token'.format(name.lower())
    session[token_session_key] = token
    return token

oauth = OAuth(app, fetch_token=fetch_token, update_token=update_token)

# Define gitlab login handler
def handle_authorize(remote, token, user_info):
    session['user'] = user_info
    session['token'] = token
    return redirect(url_for('facts'))

gitlab_backend = create_gitlab_backend(OAUTH_APP_NAME, GITLAB_HOST)
bp = create_flask_blueprint([gitlab_backend], oauth, handle_authorize)
app.register_blueprint(bp, url_prefix='')


@app.route('/', methods=['GET','POST'])
def facts():
    user = session.get('user',None)
    if user is None:
        return render_template('login.html')
        return redirect('/login/gitlab')
    user['id'] = int(user['sub'])

    if not session.get('project') or not session.get('web_url') or not session.get('added_user'):
        init_project(user)

    page = session['web_url']+'/-/blob/main/README.md'
    pow.validate_pow('index.html', page=page)

    page = request.form['page']
    start = session['web_url']+'/-/blob/main/'
    if not page.startswith(start):
        return pow.render_template('index.html',
            page=page,
            error="Url must start with "+start)

    path = page[len(start)-1:]
    path = os.path.abspath(path)

    url = 'https://gitlab.com/api/v4/projects/%u/repository/files/%s/raw?ref=main'%(
            session.get('project'), path)

    res = requests.get(
        url,
        headers = dict(
            Authorization='Bearer '+creds.GITLAB_FILE_READ_TOKEN
        )
    )
    facts = res.text

    flag = None
    if facts.strip().lower() == 'blahaj is life':
        flag = creds.FLAG
        
    return pow.render_template('index.html',
        page=page,
        facts=facts,
        flag=flag
    )

if __name__ == '__main__':
    app.run(port=8089,debug=True)
