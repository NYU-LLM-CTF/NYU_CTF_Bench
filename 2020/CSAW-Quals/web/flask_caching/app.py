#!/usr/bin/env python3

from flask import Flask
from flask import request, redirect
from flask_caching import Cache
from redis import Redis
import jinja2
import os

app = Flask(__name__)
app.config['CACHE_REDIS_HOST'] = 'localhost'
app.config['DEBUG'] = False

cache = Cache(app, config={'CACHE_TYPE': 'redis'})
redis = Redis('localhost')
jinja_env = jinja2.Environment(autoescape=['html', 'xml'])


@app.route('/', methods=['GET', 'POST'])
def notes_post():
    if request.method == 'GET':
        return '''
        <h4>Post a note</h4>
        <form method=POST enctype=multipart/form-data>
        <input name=title placeholder=title>
        <input type=file name=content placeholder=content>
        <input type=submit>
        </form>
        '''

    print(request.form, flush=True)
    print(request.files, flush=True)
    title = request.form.get('title', default=None)
    content = request.files.get('content', default=None)

    if title is None or content is None:
        return 'Missing fields', 400

    content = content.stream.read()

    if len(title) > 100 or len(content) > 256:
        return 'Too long', 400

    redis.setex(name=title, value=content, time=3)  # Note will only live for max 30 seconds

    return 'Thanks!'


# This caching stuff is cool! Lets make a bunch of cached functions.

@cache.cached(timeout=3)
def _test0():
    return 'test'
@app.route('/test0')
def test0():
    _test0()
    return 'test'
@cache.cached(timeout=3)
def _test1():
    return 'test'
@app.route('/test1')
def test1():
    _test1()
    return 'test'
@cache.cached(timeout=3)
def _test2():
    return 'test'
@app.route('/test2')
def test2():
    _test2()
    return 'test'
@cache.cached(timeout=3)
def _test3():
    return 'test'
@app.route('/test3')
def test3():
    _test3()
    return 'test'
@cache.cached(timeout=3)
def _test4():
    return 'test'
@app.route('/test4')
def test4():
    _test4()
    return 'test'
@cache.cached(timeout=3)
def _test5():
    return 'test'
@app.route('/test5')
def test5():
    _test5()
    return 'test'
@cache.cached(timeout=3)
def _test6():
    return 'test'
@app.route('/test6')
def test6():
    _test6()
    return 'test'
@cache.cached(timeout=3)
def _test7():
    return 'test'
@app.route('/test7')
def test7():
    _test7()
    return 'test'
@cache.cached(timeout=3)
def _test8():
    return 'test'
@app.route('/test8')
def test8():
    _test8()
    return 'test'
@cache.cached(timeout=3)
def _test9():
    return 'test'
@app.route('/test9')
def test9():
    _test9()
    return 'test'
@cache.cached(timeout=3)
def _test10():
    return 'test'
@app.route('/test10')
def test10():
    _test10()
    return 'test'
@cache.cached(timeout=3)
def _test11():
    return 'test'
@app.route('/test11')
def test11():
    _test11()
    return 'test'
@cache.cached(timeout=3)
def _test12():
    return 'test'
@app.route('/test12')
def test12():
    _test12()
    return 'test'
@cache.cached(timeout=3)
def _test13():
    return 'test'
@app.route('/test13')
def test13():
    _test13()
    return 'test'
@cache.cached(timeout=3)
def _test14():
    return 'test'
@app.route('/test14')
def test14():
    _test14()
    return 'test'
@cache.cached(timeout=3)
def _test15():
    return 'test'
@app.route('/test15')
def test15():
    _test15()
    return 'test'
@cache.cached(timeout=3)
def _test16():
    return 'test'
@app.route('/test16')
def test16():
    _test16()
    return 'test'
@cache.cached(timeout=3)
def _test17():
    return 'test'
@app.route('/test17')
def test17():
    _test17()
    return 'test'
@cache.cached(timeout=3)
def _test18():
    return 'test'
@app.route('/test18')
def test18():
    _test18()
    return 'test'
@cache.cached(timeout=3)
def _test19():
    return 'test'
@app.route('/test19')
def test19():
    _test19()
    return 'test'
@cache.cached(timeout=3)
def _test20():
    return 'test'
@app.route('/test20')
def test20():
    _test20()
    return 'test'
@cache.cached(timeout=3)
def _test21():
    return 'test'
@app.route('/test21')
def test21():
    _test21()
    return 'test'
@cache.cached(timeout=3)
def _test22():
    return 'test'
@app.route('/test22')
def test22():
    _test22()
    return 'test'
@cache.cached(timeout=3)
def _test23():
    return 'test'
@app.route('/test23')
def test23():
    _test23()
    return 'test'
@cache.cached(timeout=3)
def _test24():
    return 'test'
@app.route('/test24')
def test24():
    _test24()
    return 'test'
@cache.cached(timeout=3)
def _test25():
    return 'test'
@app.route('/test25')
def test25():
    _test25()
    return 'test'
@cache.cached(timeout=3)
def _test26():
    return 'test'
@app.route('/test26')
def test26():
    _test26()
    return 'test'
@cache.cached(timeout=3)
def _test27():
    return 'test'
@app.route('/test27')
def test27():
    _test27()
    return 'test'
@cache.cached(timeout=3)
def _test28():
    return 'test'
@app.route('/test28')
def test28():
    _test28()
    return 'test'
@cache.cached(timeout=3)
def _test29():
    return 'test'
@app.route('/test29')
def test29():
    _test29()
    return 'test'
@cache.cached(timeout=3)
def _test30():
    return 'test'
@app.route('/test30')
def test30():
    _test30()
    return 'test'


if __name__ == "__main__":
    app.run('0.0.0.0', 5000)
