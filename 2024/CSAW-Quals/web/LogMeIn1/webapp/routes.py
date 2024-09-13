from flask import make_response, session, Blueprint, request, jsonify, render_template, redirect, send_from_directory
from pathlib import Path
from hashlib import sha256
from utils import is_alphanumeric
from models import Account, db
from utils import decode, encode

flag = (Path(__file__).parent / "flag.txt").read_text()

pagebp = Blueprint('pagebp', __name__)

@pagebp.route('/')
def index():
    return send_from_directory("static", 'index.html')

@pagebp.route('/login', methods=["GET", "POST"])
def login():
    if request.method != 'POST':
        return send_from_directory('static', 'login.html')
    username = request.form.get('username')
    password = sha256(request.form.get('password').strip().encode()).hexdigest()
    if not username or not password:
        return "Missing Login Field", 400
    if not is_alphanumeric(username) or len(username) > 50:
        return "Username not Alphanumeric or longer than 50 chars", 403
    # check if the username already exists in the DB
    user = Account.query.filter_by(username=username).first()
    if not user or user.password != password:
        return "Login failed!", 403
    user = {
        'username':user.username,
        'displays':user.displayname,
        'uid':user.uid
    }
    token = encode(dict(user))
    if token == None:
        return "Error while logging in!", 500
    response = make_response(jsonify({'message': 'Login successful'}))
    response.set_cookie('info', token, max_age=3600, httponly=True)
    return response

@pagebp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method != 'POST':
        return send_from_directory('static', 'register.html')
    username = request.form.get('username')
    password = sha256(request.form.get('password').strip().encode()).hexdigest()
    displayname = request.form.get('displayname')
    if not username or not password or not displayname:
        return "Missing Registration Field", 400
    if not is_alphanumeric(username) or len(username) > 50:
        return "Username not Alphanumeric or it is longer than 50 chars", 403
    if not is_alphanumeric(displayname) or len(displayname) > 50:
        return "Displayname not Alphanumeric or it is longer than 50 chars", 403
    # check if the username already exists in the DB
    user = Account.query.filter_by(username=username).first()
    if user:
        return "Username already taken!", 403
    acc = Account(
        username=username, 
        password=password, 
        displayname=displayname,
        uid=1
        )
    try:
        # Add the new account to the session and commit it
        db.session.add(acc)
        db.session.commit()
        return jsonify({'message': 'Account created successfully'}), 201
    except Exception as e:
        db.session.rollback()  # Roll back the session on error
        return jsonify({'error': str(e)}), 500



@pagebp.route('/user')
def user():
    cookie = request.cookies.get('info', None)
    name='hello'
    msg='world'
    if cookie == None:
        return render_template("user.html", display_name='Not Logged in!', special_message='Nah')
    userinfo = decode(cookie)
    if userinfo == None:
        return render_template("user.html", display_name='Error...', special_message='Nah')
    name = userinfo['displays']
    msg = flag if userinfo['uid'] == 0 else "No special message at this time..."
    return render_template("user.html", display_name=name, special_message=msg)

@pagebp.route('/logout')
def logout():
    session.clear()
    response = make_response(redirect('/'))
    response.set_cookie('info', '', expires=0)
    return response

