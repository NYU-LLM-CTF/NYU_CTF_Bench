import os
import jwt
import time
import json
import redis
import random
import binascii

import logging
logging.basicConfig(level=logging.INFO)

from uuid import uuid4
from flask import Flask, send_from_directory, jsonify, g, request, abort
from session import SessionProxy, Session

from obswebsocket import obsws, requests

from functools import wraps

app = Flask(__name__)

GUESS_TIME = 35

rclient = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
obsclient = obsws('127.0.0.1',4444)

session = SessionProxy(g, rclient)

@app.before_request
def before_request():
    if 'sid' in request.cookies and 'session' in request.cookies:
        sid = request.cookies['sid']
        g.session = Session(rclient, sid)
        if g.session._new:
            return

        g.session.decode(request.cookies['session'])

@app.after_request
def after_request_func(response):
    if 'session' in g:
        c = g.session.encode()
        response.set_cookie('session', c)
        response.set_cookie('sid', g.session._sid)
    return response

def log(s, mode='INFO'):
    if session.get('uid'):
        s = '[{mode}][{time}][{session.uid}] ' + s
    else:
        s = '[{mode}][{time}] ' + s
    logging.info(s.format(mode=mode, session=session, time=time.ctime()))

@app.route('/race')
def race_page():
    return send_from_directory('.','race.html')

@app.route('/')
def bet_page():
    return send_from_directory('.','bet.html')

def is_over():
    now = int(time.time())
    start = int(rclient.get('start'))

    if start == 0:
        return True

    if now < start + 10:
        return False
    return True

def reset():
    now = int(time.time())
    if not is_over():
        log('Tried to restart at bad time!')
        return

    log('Resetting race')

    snail_a = rclient.get('race.a')
    snail_b = rclient.get('race.b')

    # Reset name if set
    if snail_a:
        rclient.hset('snails.'+snail_a, 'custom', '{}')
    if snail_b:
        rclient.hset('snails.'+snail_b, 'custom', '{}')

    r = rclient.srandmember('snails',2)
    assert(len(r) == 2)

    rclient.set('race.a', r[0])
    rclient.set('race.b', r[1])

    snail_a = rclient.hgetall('snails.'+rclient.get('race.a'))
    snail_b = rclient.hgetall('snails.'+rclient.get('race.b'))

    snail_a['slow'] = int(snail_a['slow'])
    snail_b['slow'] = int(snail_b['slow'])
    total = float(snail_a['slow'] + snail_b['slow'])

    rclient.set('race.a.money', int(random.randrange(10000, 15000)*10*(1-snail_a['slow']/total)))
    rclient.set('race.b.money', int(random.randrange(10000, 15000)*10*(1-snail_b['slow']/total)))

    names = [rclient.lpop('names'),rclient.lpop('names')]
    random.shuffle(names)

    if names[0]:
        rclient.hset('snails.'+snail_a['uid'], 'custom', f'{{name:`{names[0]}`}}')
    if names[1]:
        rclient.hset('snails.'+snail_b['uid'], 'custom', f'{{name:`{names[1]}`}}')

    rclient.set('start', now + GUESS_TIME)

def getRemoteIp():
    trusted_proxies = {'127.0.0.1'}
    route = request.access_route + [request.remote_addr]

    remote_addr = next((addr for addr in reversed(route) 
                    if addr not in trusted_proxies), request.remote_addr)
    return remote_addr

def stream(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if getRemoteIp() not in ['199.48.170.61']:
            abort(403)

        return f(*args, **kwargs)
    return wrapper

def user(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if session.get('uid') is None:
            uid = str(uuid4())
            session.uid = uid
            session.money = 100

        return f(*args, **kwargs)
    return wrapper

#@app.route('/switch/debug')
#@stream
#def switch_setup():
#    change_scene('Scene1')
#    return ''

@app.route('/switch/setup')
@stream
def switch_setup():
    change_scene('Scene3')
    return ''

@app.route('/switch/race')
@stream
def switch_race():
    change_scene('Scene2')
    return ''

@app.route('/bet/<int:winner>',methods=['PATCH'])
@user
def send_bet(winner):
    uid = session.uid

    now = int(time.time())
    start = int(rclient.get('start'))

    if now >= start:
        return jsonify(success=False, error='Betting is closed')

    if not winner in [0,1]:
        return jsonify(success=False, error='Invalid choice')

    winner = ['a','b'][winner]

    if rclient.hexists('race.a.bets', uid) or rclient.hexists('race.b.bets', uid):
        return jsonify(success=False, error='Already Bet')

    bet = request.form.get('bet')
    try:
        bet = int(bet)
    except:
        log(f'Bad bet {bet}')
        return jsonify(success=False, error='Invalid Bet Amount')

    money = session.money

    if bet <= 0:
        return jsonify(success=False, error='Invalid Bet Amount')

    if bet > money:
        bet = money
    if bet > 1000000:
        bet = min(bet,1000000)

    log(f'Bet {bet}')

    rclient.hset(f'race.{winner}.bets', uid, bet)
    rclient.incrby(f'race.{winner}.money', bet)
    return jsonify(success=True)

@app.route('/flag1')
@user
def buy_flag2():
    if session.money < 250000:
        return jsonify(success=False, error='Not enough money')
    session.money -= 250000
    return jsonify(success=True, flag='flag1 will be here')
        
@app.route('/flag2')
@user
def buy_flag():
    if session.money < 1000000000000000000:
        return jsonify(success=False, error='Not enough money')
    session.money -= 1000000000000000000
    return jsonify(success=True, flag='flag2 will be here')

@app.route('/name', methods=['PATCH'])
@user
def buy_name():
    uid = session.uid

    name = request.form['name']
    now = int(time.time())

    lastname = rclient.get('user.'+uid+'.nameset')
    if lastname and now < int(lastname) + 60*2:
        return jsonify(success=False, error='Can only set name every 2 min')

    if session.money < 250000:
        return jsonify(success=False, error='Not enough money')

    if '"' in name or "'" in name or '`' in name:
        return jsonify(success=False, error='Invalid name')

    session.money -= 250000

    rclient.set('user.'+uid+'.nameset', now)

    rclient.rpush('names',name)
    return jsonify(success=True)

def calc_odds():
    a_sum = int(rclient.get('race.a.money'))
    b_sum = int(rclient.get('race.b.money'))
    if a_sum == 0:
        a_sum = 1
    if b_sum == 0:
        b_sum = 1

    a_odds = a_sum / float(b_sum)
    b_odds = b_sum / float(a_sum)

    return a_odds, b_odds, a_sum, b_sum

def change_scene(name):
    obsclient.connect()
    obsclient.call(requests.SetCurrentScene(name))
    obsclient.disconnect()

@app.route('/check')
@user
def get_money():
    now = int(time.time())
    start = int(rclient.get('start'))
    if start == 0:
        reset()

    if now > start:
        a_odds, b_odds, a_sum, b_sum = calc_odds()
    else:
        a_odds, b_odds, a_sum, b_sum = 0,0,0,0

    uid = session.uid

    payouts = rclient.lrange('payouts.'+uid, 0, -1)
    if payouts:
        for p in payouts:
            session.money += int(float(p))
        rclient.delete('payouts.'+uid)
    if session.money < 100:
        session.money = 100

    side = None
    bet = rclient.hget('race.a.bets', uid)
    if bet:
        side = 0
    else:
        bet = rclient.hget('race.b.bets', uid)
        if bet:
            side = 1

    return jsonify(
        a=a_odds, b=b_odds,
        a_sum=a_sum, b_sum=b_sum,
        bet=bet,
        side=side,
        money=session.money,
        start=start
    )

@app.route('/snails')
@stream
def get_snails():
    if is_over():
        reset()

    snail_a = rclient.hgetall('snails.'+rclient.get('race.a'))
    snail_b = rclient.hgetall('snails.'+rclient.get('race.b'))

    return jsonify(snails=[snail_a,snail_b], start=rclient.get('start'))

@app.route('/win/<int:winner>')
@stream
def mark_win(winner):
    assert(winner in [0,1])

    winner = ['a','b'][winner]

    now = int(time.time())

    if now < int(rclient.get('start')) + 10:
        log('Winner declared too soon...')
        return jsonify(result=False)

    log(f'Snail {winner} wins!')
    a_odds, b_odds, _,_ = calc_odds()

    a_bets = rclient.hgetall('race.a.bets')
    for uid,v in a_bets.items():
        v = int(float(v))
        if winner == 'a':
            v = b_odds * v
        else:
            v = -v
        rclient.lpush('payouts.'+uid, v)

    b_bets = rclient.hgetall('race.b.bets')
    for uid,v in b_bets.items():
        v = int(float(v))
        if winner == 'b':
            v = a_odds * v
        else:
            v = -v
        rclient.lpush('payouts.'+uid, v)

    rclient.delete('race.a.bets')
    rclient.delete('race.b.bets')

    return jsonify(result=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=49383, debug=True)

