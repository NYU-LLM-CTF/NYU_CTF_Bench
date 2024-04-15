from flask import Flask, jsonify, abort, request
from redis import Redis

import string
import random


app = Flask(__name__, static_url_path='/static', static_folder='static')
r = Redis()


def get_opts(sid):
    opts = r.hgetall(sid)
    if not opts:
        abort(404)

    opts = {k.decode('utf-8'): v.decode('utf-8') for k, v in opts.items()}
    opts['log'] = int(opts['log'])

    return opts


@app.route('/api/new', methods=['POST'])
def new_room():
    offer = request.get_json()['offer']
    if not offer:
        abort(400)

    sid = ''.join(random.choices(string.ascii_letters + string.digits, k=32))
    r.hset(sid, "offer", offer)
    r.hset(sid, "log", 0)

    return jsonify({"sid": sid})


@app.route('/api/enable_log', methods=['POST'])
def enable_log():
    sid = request.get_json()['sid']
    if not r.exists(sid):
        abort(404)

    r.hset(sid, "log", 1)

    return jsonify({})


@app.route('/api/join', methods=['POST', 'PUT'])
def join():
    sid = request.get_json()['sid']

    opts = get_opts(sid)

    if request.method == "POST":
        msgs = r.lrange(f"{sid}-messages", 0, -1)

        return jsonify({
            **opts,
            "messages": msgs,
        })
    else:
        answer = request.get_json()['answer']
        r.hset(sid, "answer", answer)

        return jsonify({})


@app.route('/api/log_message', methods=['POST'])
def log_msg():
    sid = request.get_json()['sid']
    msg = request.get_json()['msg']

    r.rpush(f"{sid}-messages", msg)
    return jsonify({})


@app.route('/')
def index():
    return app.send_static_file('index.html')


if __name__ == '__main__':
    app.run()
