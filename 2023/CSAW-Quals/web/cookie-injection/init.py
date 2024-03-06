from flask import Flask, render_template, request, session, url_for, redirect, make_response
import pymysql.cursors
from app import app, get_conn
import string, random
import login


def generate_cookie(length = 20):
    characters = string.ascii_letters + string.digits
    random_string = ''.join(random.choice(characters) for _ in range(length))
    return random_string


# Index page
@app.route('/')
def index(welcome = '', message='View Details', flag = True):
    res = make_response(render_template('userHome.html', welcome = welcome, flag = flag, message=message))
    
    cursor = get_conn().cursor()
    trackingID = generate_cookie()
    res.set_cookie("trackingID", trackingID)
    session['trackingID'] = trackingID
    session['email'] = ''
    query = "INSERT INTO trackingid (cookie, email) VALUES (%s, %s)"
    cursor.execute(query, (trackingID, 'guest'))
    get_conn().commit()


    login.injectableFunction()
    return res


app.secret_key = 'Q3I3Pm1lc3NpQ3I3Pm1lc3NpQ3I3Pm1lc3Np'

if __name__ == "__main__":
    app.run('0.0.0.0', 5800, debug=True)


