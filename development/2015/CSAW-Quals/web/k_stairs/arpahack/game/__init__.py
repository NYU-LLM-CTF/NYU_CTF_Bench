from flask import Flask, render_template, g, request, jsonify
from util import *

app = Flask('game')
app.secret_key = '96712673746372683275637813261327687131689426584261927929327925927397494224826758225467546127617'
db = sqlite3.connect('game.db')

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if get_user() is None:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

@app.route('/')
def index():
    return render_template('index.html',
        title='Home', user=get_user()
    )

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST' and login_user(request.form.get('user'), request.form.get('pass')):
        return redirect(url_for('index'))
    return render_template('login.html', user=get_user())

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST' and register_user(request.form.get('user'), request.form.get('pass')):
        return redirect(url_for('index'))
    return render_template('register.html', user=get_user())

@app.route('/play')
@login_required
def game():
    return render_template('play.html',
        title='Play', user=get_user()
    )

def state(st, msg=None):
    # This modifies the state!
    tiles = state_data(st)
    data = {
        'food': st['f']['food'],
        'curr_hp': st['f']['curr_hp'],
        'max_hp': st['f']['max_hp'],
        'level': st['f']['level'],
        'state': encrypt_game(st),
        'tiles': tiles,
        'tokens': session.get('tokens')
    }
    if msg:
        data['message'] = msg
    return jsonify(data)

@app.route('/status', methods=['POST'])
@login_required
def status():
    st = decrypt_game(request.form.get('state'))
    return state(st, '')

@app.route('/action', methods=['POST'])
@login_required
def action():
    mdir = int(request.form.get('move'))
    st = decrypt_game(request.form.get('state'))
    msg = state_action(st, mdir)
    return state(st, msg)

@app.route('/new_game')
@login_required
def new_game():
    st = create_game()
    return state(st)
    session['tokens'] = 20

@app.route('/dlc')
@login_required
def dlc():
    return render_template('dlc.html',
        title='DLC', user=get_user()
    )

@app.route('/buy', methods=['post'])
def buy():
    bid = int(request.form.get('bid'))
    st = decrypt_game(request.form.get('state'))
    msg = buy_item(st, bid)
    return state(st, msg)

@app.route('/tokens')
def tokens():
    data = {
        'tokens': session['tokens']
    }
    return jsonify(data)

@app.route('/faq')
@login_required
def faq():
    return render_template('faq.html',
        title='FAQ', user=get_user()
    )

@app.route('/admin')
@login_required
def admin():
    return render_template('admin.html',
        title='Admin', user=get_user()
    )
