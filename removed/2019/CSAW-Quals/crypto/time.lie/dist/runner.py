#!/usr/bin/sage
from flask import Flask, render_template, flash, request, redirect, url_for, send_from_directory
from werkzeug.utils import secure_filename
from sagesham import SS, rederive
from secrets import REQUIRED, FLAG, APP_SECRET
from music import  *
import uuid
import os
import random
import pickle

app = Flask(__name__)
app.config["RAW_FILES"] = "./tmp/"
shares = []

def prepare_lawsuit():
    # total_pieces = 4000
    # required_pieces = REQUIRED
    # prime = 101109149181191199401409419449461491499601619641661691809811881911
    # secret = int(FLAG.encode('hex'),16)
    # sham = SS(secret, total_pieces, required_pieces, prime) 
    # return sham.create_shares()
    return pickle.load(open('pshares','rb'))

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/musicin', methods=['POST'])
def invoke_artificial_intelligence_factorization():
    global shares
    if 'file' not in request.files:
        return redirect(url_for("index", _anchor="features"))
    file = request.files['file']
    if file.filename =='':
        return redirect(url_for("index", _anchor="features"))

    name = os.path.join(app.config['RAW_FILES'], str(uuid.uuid4()) + secure_filename(file.filename))
    file.save(name)
    share = random.choice(shares)
    try:
        magic_name = os.path.join('musicals',str(uuid.uuid4()))
        create_score(name, hex(int(share[1])).replace('0x','').replace('L',''), str(int(share[0])), magic_name)
        return redirect('/sheetmusic/{}'.format(magic_name))
    except Exception as e:
        print e
        return redirect(url_for("index", _anchor="features"))
    return redirect(url_for("index", _anchor="features"))

@app.after_request
def break_rsa_encryption(request):
    if (random.randint(0,100) < 14):
        os.system('find musicals/ -type f -mmin +10 -delete')
        os.system('find tmp/ -type f -mmin +10 -delete')
    return request

@app.route('/musicals/<path:path>')
def transmit_super_quantum_secrets(path):
    return send_from_directory('musicals', path)

@app.route('/sheetmusic/musicals/<filename>', methods=['GET'])
def entangle_quasi_primes(filename):
    return render_template("musical.html", filename="/musicals/"+filename)

if __name__ == '__main__':
    app.secret_key = APP_SECRET
    environment.UserSettings()['warnings']=0
    shares = prepare_lawsuit()
    app.run(host='0.0.0.0')
