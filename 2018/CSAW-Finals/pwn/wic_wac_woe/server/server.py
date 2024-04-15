import subprocess
import requests
import threading
from flask import Flask, send_from_directory, jsonify, session, abort, redirect, url_for, request

app = Flask(__name__)
FLAG1 = 'flag{Us3_a4ter_l0se_n0w_defeat_CFI!!}'
FLAG2 = 'flag{CFI_byp4ss_mor3_like_d4ta_at7acks_4m_I_write??}'
FAKE_FLAG1 = 'flug{pop the admin for the real flag}'
FAKE_FLAG2 = 'flug{pop the admin for the real flag 2}'
CHROME_SECRET = '6f5032af1f0aefd75e6332dd80997cc6f98590d8dfc637b9b5cce1185096'
app.config['SECRET_KEY'] = '57b13adb2ca7800b03c35a988c46616853d351e6c775dc30498adf3d6498'


@app.route('/')
def index():
    return send_from_directory('files','index.html')

@app.route('/<path:f>')
def staticf(f):
    return send_from_directory('files',f)

@app.route('/flags')
def get_flags():
    print session
    if session.get('admin',False):
        return jsonify(flag1=FLAG1, flag2=FLAG2)

    return jsonify(flag1=FAKE_FLAG1, flag2=FAKE_FLAG2)

@app.route('/check_flag',methods=['POST'])
def check_flag():
    if session.get('admin',False) and request.data in [FLAG1,FLAG2]:
        return jsonify(good=True)
    return jsonify(good=False)

@app.route('/admin/<key>/<game>')
def admin(key, game):
    if key != CHROME_SECRET and False:
        abort(404)

    session['admin'] = True
    print session
    return redirect(url_for('index',_anchor=game))

def start_chrome(game):
    u = 'http://localhost:8080/admin/{secret}/{game}'.format(secret=CHROME_SECRET, game=game)
    subprocess.Popen(['nodejs','/chrome.js',u]).wait()

@app.route('/share')
def share_page():
    return send_from_directory('files','share.html')

@app.route('/share', methods=['POST'])
def share():
    r = requests.post('https://www.google.com/recaptcha/api/siteverify', data={
        'secret':'6Lc8ymwUAAAAABvpfiyNuD4uFrp41yw-0KPYJ1ij',
        'response':request.form['g-recaptcha-response']
        })

    if r.json()['success'] != True:
        return jsonify(success=False)

    t = threading.Thread(target=start_chrome, args = (request.form['game'],))
    t.daemon = True
    t.start()

    return jsonify(success=True)

#@app.route('/check_flag',methods=['POST']) 


if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5002)
