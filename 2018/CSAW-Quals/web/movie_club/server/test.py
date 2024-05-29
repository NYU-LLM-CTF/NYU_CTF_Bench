import os
import re
import time
import hashlib
import urlparse
import threading
import mimetypes
import subprocess

from itsdangerous import URLSafeTimedSerializer

from functools import wraps
import requests

from movies import movies, makeMovie


from flask import (
    Flask, make_response, render_template,
    request, abort, redirect, safe_join,
    render_template_string, send_file,
    jsonify, session, url_for
)

#from flask_cors import CORS
from util import crossdomain

DOMAIN = 'hm.vulnerable.services'



app = Flask(__name__)

app.config['SECRET_KEY'] = 'GOOD_SECRET_1sdsfsdfsf'
SECRET = 'GOOD_SECRET_2aapppeeemm'

admin_signer = URLSafeTimedSerializer(app.config['SECRET_KEY'],'admin')

'''
if not os.path.exists('/tmp/SECRET_KEY'):
    with open('/tmp/SECRET_KEY','w') as f:
        f.write(os.urandom(32))
with open('/tmp/SECRET_KEY','r') as f:
    app.config['SECRET_KEY'] = f.read()

if not os.path.exists('/tmp/ADMIN_SECRET'):
    with open('/tmp/ADMIN_SECRET','w') as f:
        f.write(os.urandom(32).encode('hex'))
with open('/tmp/ADMIN_SECRET','r') as f:
    SECRET = f.read()
'''

#cors = CORS(app, resources={r'/cdn/*': {'origins': '*', 'allow_headers':'*'}})

def is_admin():
    if session.get('admin',False):
        return True
    s = request.headers.get('X-Admin-Secret','')
    if s == '':
        return False
    try:
        return admin_signer.loads(s,max_age=5)
    except:
        return False
    return False

def get_remote_ip():
    trusted_proxies = {'127.0.0.1'}
    route = request.access_route + [request.remote_addr]

    remote_addr = next((addr for addr in reversed(route)
                    if addr not in trusted_proxies), request.remote_addr)
    return remote_addr


def no_cache(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        resp = make_response(f(*args, **kwargs))
        resp.headers['Cache-Control'] = 'no-cache'
        return resp
    return decorated

def validate_host(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        host = request.headers['Host'].split(':')[0]
        ip = get_remote_ip()
        h = hashlib.sha1(ip).hexdigest()
        if host.split('.')[0] != h and not is_admin():
            path = request.url.split('/',3)[3]
            res = make_response(redirect('http://%s.%s/%s'%(h, DOMAIN, path)))
            res.headers['Cache-Control'] = 'no-cache'
            return res
        return f(*args, **kwargs)
    return decorated

def only_app(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        host = request.headers['Host'].split(':')[0]
        ip = get_remote_ip()
        if host != 'app.'+DOMAIN and not is_admin():
            abort(403)
        return f(*args, **kwargs)
    return decorated

@app.route('/', methods=['GET','POST'])
@no_cache
@only_app
def index(domain=None):
    ip = get_remote_ip()
    h = hashlib.sha1(ip).hexdigest()
    return render_template('index.html',cdn=h+'.'+DOMAIN)

def start_chrome(h):
    u = 'http://{sub}.{domain}/admin/{sub}?secret={secret}'.format(sub=h,domain=DOMAIN,secret=SECRET)
    subprocess.Popen(['nodejs','/chrome.js',u]).wait()

@app.route('/api/report', methods=['POST'])
@no_cache
@only_app
def report():
    ip = get_remote_ip()
    h = hashlib.sha1(ip).hexdigest()

    j = request.get_json(force=True)
    if not 'token' in j or not type(j['token']) in [unicode, str]:
        return jsonify(success=False)
    r = requests.post('https://www.google.com/recaptcha/api/siteverify', data={
        'secret':'6Lc8ymwUAAAAABvpfiyNuD4uFrp41yw-0KPYJ1ij',
        'response':j['token']
        })
    if r.json()['success'] != True or r.json()['hostname'] != 'app.'+DOMAIN:
        return jsonify(success=False)

    #subprocess.Popen(['timeout','5','chromium-browser','--headless','--remote-debugging-port=9222','http://127.0.0.1/admin/'+h])
    t = threading.Thread(target=start_chrome, args = (h,))
    t.daemon = True
    t.start()

    return jsonify(success=True)


@app.route('/cdn.js')
def cdn_loader():
    return send_file('./cdn.js')

@app.route('/cdn_admin.js')
def cdn_loader_admin():
    return send_file('./cdn_admin.js')

@app.route('/time')
def test():
    return '%u'%time.time()

@app.route('/api/movies')
@no_cache
@only_app
def get_movies():
    ip = get_remote_ip()
    if not is_admin():
        return jsonify(admin=False, movies=movies)
    return jsonify(admin=True,
            movies=movies[:-1]+[makeMovie(
                'flag{I_h0pe_you_w4tch3d_a11_th3_m0v1es}', 1337, 2018, False)])

@app.route('/admin/view/<string:domain>')
@no_cache
def run_admin(domain):
    if not is_admin():
        abort(403)
    return render_template('index.html',cdn=domain+'.'+DOMAIN,admin=admin_signer.dumps(True))


@app.route('/admin/<string:domain>')
@no_cache
def start_admin(domain):
    if request.args.get('secret','') != SECRET:
        abort(403)
    session['admin'] = True
    return redirect(url_for('run_admin', domain=domain))

@app.route('/cdn/<string:name>',methods=['GET','OPTIONS'])
@crossdomain(origin='*',headers='X-Forwarded-Host')
#@no_cache
@validate_host
def cdn(name):
    fn = safe_join('./cdn',name)
    if not os.path.exists(fn):
        abort(404)

    h = hashlib.sha1(get_remote_ip()).hexdigest()
    host = '%s.%s'%(h,DOMAIN)

    if name != 'app.js':
        return send_file(fn)

    # Only trigger if we are on a "high traffic" path
    if not is_admin() and request.full_path.strip('?') == request.path:
        try:
            # Check the "grace" age of the cache
            r = requests.request('AGE','http://127.0.0.1%s'%(request.path),
                headers={
                    'host': '%s.%s'%(h,DOMAIN),
                    'X-Forwarded-Host': '%s.%s'%(h,DOMAIN)
                }, timeout=.5)

            if 'TTL' in r.headers:
                ttl = float(r.headers['TTL'])
                # If it is quick enough allow their response to cache
                if ttl < 0 and ttl > -1:
                    host = request.headers.get('X-Forwarded-Host','')
        except:
            pass
    else:
        host = request.headers.get('X-Forwarded-Host','')

    if not re.match('^[a-zA-Z0-9-.]+$', host):
        host = ''


    with open(fn, 'r') as f:
        mime = mimetypes.guess_type(fn)[0] or 'application/octet-stream'
        resp = make_response(render_template_string(f.read(), host=host))
        resp.headers['Content-Type'] = mime
        return resp


if __name__ == '__main__':
    app.run(port=8080, debug=True)
