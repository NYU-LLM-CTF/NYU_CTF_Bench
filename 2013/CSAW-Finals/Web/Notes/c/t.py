#!/usr/bin/python

import os
import time
import flask
import sqlite3
import pyvirtualdisplay
import selenium.webdriver

app = flask.Flask(__name__)
key = 'key{73f5b8d14f8261b3c6231264ec924dc9}'

@app.route('/', methods=['GET'])
def index():
	o = """\
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>CSAW CTF 2014 FINALS - INDEX</title>
	</head>
	<body style="text-align:center;">
		<div><img src=\"""" + flask.url_for('static', filename='CSAW.png') + """" alt="CSAW"></div>
		<p>Welcome to CSAW!  <br>A bunch of loser devs wrote this app at some hackathon.  Enter your name below.  (Make it hard to guess, so others cannot find your notes)</p>
		<form method="get" action=\"""" + flask.url_for('go') + """">
			<input type="text" name="id">
			<br>
			<button type="submit">Submit!</button>
		</form>
	</body>
</html>\
"""
	return o

@app.route('/go/', methods=['GET', 'POST'])
def go():
	conn = sqlite3.connect('t.db')
	c = conn.cursor()

	if (flask.request.method == 'POST'):
		id = flask.request.form.get('id')
		text = flask.request.form.get('text')
	elif flask.request.method == 'GET':
		id = flask.request.args.get('id')

	if id == None:
		return flask.redirect(flask.url_for('index'))

	c.execute("""SELECT * FROM 't' WHERE "id" = ?;""", [str(id)])
	row = c.fetchone()

	if (flask.request.method == 'POST'):
		if row == None:
			c.execute("""INSERT INTO 't' ('id', 'text') VALUES (?, ?);""", [str(id), str(text)])
		else:
			c.execute("""UPDATE 't' SET "text" = ? WHERE "id" = ?;""", [str(text), str(id)])
	elif flask.request.method == 'GET':
		if row == None:
			text = ''
		else:
			text = row[1]
	conn.commit()
	conn.close()
	o = """\
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>CSAW CTF 2014 FINALS - GO</title>
	</head>
	<body>
		<h1>Notes for """ + str(id) + """</h1>
		<div>""" + str(text) + """</div>
		<form method="post" action=\"""" + flask.url_for('go', id=id) + """">
			<input type="hidden" name="id" value=\"""" + str(id) + """">
			<textarea name="text">""" + str(text) + """</textarea>
			<br>
			<button type="submit">Submit!</button>
		</form>
		<ul>
			<li><a href=\"""" + flask.url_for('stop', id=id) + """">Delete this note.</a></li>
			<li><a href=\"""" + flask.url_for('launch', id=id) + """">Ask an admin for help.</a></li>
			<li><a id="bdmin" href="#" onclick="document.getElementById('admin').style.visibility='visible';">I'm an admin!</a></li>
		</ul>
		<form id="cdmin" method="get" action=\"""" + flask.url_for('admin') + """">
			<input id="admin" name="password" style="visibility:hidden;" type="textbox">
		</form>
	</body>
</html>\
"""
	return o

@app.route('/stop/', methods=['GET'])
def stop():
	conn = sqlite3.connect('t.db')
	c = conn.cursor()

	id = flask.request.args.get('id')

	c.execute("""DELETE FROM 't' WHERE "id" = ?;""", [str(id)])

	conn.commit()
	conn.close()
	o = """\
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>CSAW CTF 2014 FINALS - STOP</title>
	</head>
	<body>
		<p>You've deleted note id """ + str(id) + """!</p>
	</body>
</html>\
"""
	return o

@app.route('/launch/', methods=['GET'])
def launch():
	id = flask.request.args.get('id')

	if id == None:
		return flask.redirect(flask.url_for('index'))

	display = pyvirtualdisplay.Display(visible=0, size=(800, 600))
	display.start()

	browser = selenium.webdriver.Firefox()

	browser.set_page_load_timeout(15)
	browser.set_script_timeout(15)

	browser.get('http://localhost:2000' + flask.url_for('go', id=id))

	elema = browser.find_element_by_id('admin')
	elemb = browser.find_element_by_id('bdmin')
	elemc = browser.find_element_by_id('cdmin')

	elemb.click()
	elema.send_keys(key)
	elemc.submit()

	time.sleep(1)

	browser.quit()
	display.stop()

	return "You're note is being serviced by an admin.  Thanks for waiting!"

@app.route('/truncatedb/', methods=['GET'])
def truncatedb():
	conn = sqlite3.connect('t.db')
	c = conn.cursor()

	c.execute("""DELETE FROM 't';""")

	conn.commit()
	conn.close()

	return """Table successfully truncated."""

@app.route('/admin/', methods=['GET'])
def admin():
	pw = flask.request.args.get('password')

	if pw == None:
		return flask.redirect(flask.url_for('index'))
	elif pw == key:
		return """Congrats, admin!"""
	else:
		return """You're not an admin!"""

@app.route('/csawsecret/', methods=['GET'])
def secret():
	conn = sqlite3.connect('t.db')
	c = conn.cursor()

	c.execute("""SELECT * FROM 't';""")
	table = c.fetchall()

	conn.commit()
	conn.close()

	o = """\
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>CSAW CTF 2014 FINALS - STOP</title>
	</head>
	<body>
		<pre>""" + str(flask.Markup.escape(str(table))) + """</pre>
	</body>
</html>\
"""
	return o

@app.route('/favicon.ico')
def favicon():
	return flask.send_from_directory(os.path.join(app.root_path, 'static'), 'favicon.ico', mimetype='image/vnd.microsoft.icon')

if __name__ == '__main__':
	app.run(host = '0.0.0.0', port = 2000, debug = False, threaded = True)
