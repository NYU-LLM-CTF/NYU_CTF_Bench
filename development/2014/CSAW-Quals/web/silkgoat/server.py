from flask import Flask, session, redirect, url_for, escape, request, send_from_directory
from flask_kvsession import KVSessionExtension
from simplekv.fs import FilesystemStore
from PIL import Image, ImageDraw, ImageFont
import hashlib
import random
import re, os

app = Flask(__name__)
app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,lol'
app.debug = False
app.flag = "flag{silkroad4ever}"
KVSessionExtension(FilesystemStore('./sessions'), app)

def get_bank_points(username):
    return int(open('accounts/'+username).read())

def set_bank_points(username, points):
    f = open('accounts/'+username, 'w')
    f.write(str(points))
    f.close()

def render_template(template, keys={}):
    contents = open('templates/'+template).read()
    for key in keys:
        contents = contents.replace('%'+key+'%', str(keys[key]))

    return contents

@app.route('/captchas/<path:filename>')
def send_foo(filename):
    return send_from_directory('./captchas', filename)

@app.route('/static/<path:filename>')
def send_static(filename):
    return send_from_directory('./static', filename)

def logged_in():
    return 'username' in session and 'points' in session

def homepage():
    return redirect(url_for('index'))

def generate_captcha():
    if not session.get('captchas'):
        session['captchas'] = {}

    session['hihello'] = 'yes'
    font = ImageFont.truetype("arial.ttf", 32)
    image = Image.new("RGBA", (200,50), (255,255,255))
    draw = ImageDraw.Draw(image)
    response = str(int(random.random()*10000000))
    challenge = hashlib.sha256(hashlib.sha256(response + app.secret_key).hexdigest()).hexdigest()
    draw.text((10, 10), response, (0,0,0), font=font)
    image.save("captchas/"+challenge+".png")
    session['captchas'][challenge] = response
    return challenge

def generate_captcha_form(challenge):
    base = '<img src="/captchas/%s.png" /><br />\n' % (challenge)
    base += 'Anti-Robot: <input type="text" name="response" />'
    base += '<input type="hidden" name="challenge" value="%s" />' % (challenge)

    return base

def get_captcha_value(challenge):
    session['poop'] = 'yes'
    return session['captchas'].get(challenge) or None

def captcha_valid(challenge, response):
    if challenge not in session['captchas']:
        return False

    real_value = get_captcha_value(challenge)
    if real_value and real_value == response:
        os.unlink('captchas/'+challenge+'.png')
        del session['captchas'][challenge]
        return True
    else:
        os.unlink('captchas/'+challenge+'.png')
        del session['captchas'][challenge]
        return False

def generate_shop_html(items):
    base = '''<img src="%s" style="width: 120px; height: 120px;" /><br />%s (%d points)<br />%s<br />
        <form action="" method="POST"><input type="hidden" name="item" value="%s" /><input type="submit" value="Buy" /></form><hr />'''
    buffer = ''
    for item in items:
        buffer += base % (item['image'], item['name'], item['price'], item['description'], item['name'])

    return buffer

@app.route('/solveme', methods=['GET', 'POST'])
def solveme():
    if request.method == 'GET':
        cp = generate_captcha()
        return "<form action='' method='POST'>%s<input type='submit' /></form>%s" % (generate_captcha_form(cp), str(session))
    if request.method == 'POST':
        if captcha_valid(request.form.get('challenge'), request.form.get('response')):
            return " u r valid"
        else:
            return "turd %s" % repr(session)

@app.route('/')
def index():
    if 'username' in session:
        return render_template('index.tpl', {'username':session['username'], 'points':session['points'], 'bank_points':get_bank_points(session['username'])})
    return render_template('go_to_login.tpl')

@app.route('/shop', methods=['GET', 'POST'])
def shop():
    if not logged_in():
        return homepage()

    content = {}
    content['username'] = session['username']
    content['points'] = session['points']
    items = [
        {'name': 'Jeff', 'price': 0, 'description': 'lel', 'image': 'http://www.allprodad.com/images/article-images/foxworthy.jpg', 'message': 'Why would you do that? Why?'},
        {'name': 'Shady Assortment of Pills', 'price': 10, 'description': 'Yummy yummy in your tummy/nose/butthole', 'image': 'https://31.media.tumblr.com/avatar_ec040cde6ead_128.png', 'message': 'Ahhhhhhhhh *burp*'},
        {'name': 'Nuclear Reactor', 'price': 100, 'description': 'One of the hottest products in Iran right now!', 'image': 'http://cleversurvivalist.com/wp-content/uploads/2013/05/brother-sewing.jpg', 'message': 'You be safe now!'},
        {'name': 'Flag', 'price': 15000, 'description': 'You\'re too poor to even look at this item.', 'image': 'http://i190.photobucket.com/albums/z205/JekyllnHyde_photos/August%2014%202012/God-Bless-America-with-sign-on-American-Flag-with-military-rifle.jpg', 'message':app.flag},
        {'name': 'Top Secret Government Documents', 'price': 1, 'description': 'You know how long it took me to find this on Kazaa?', 'image': 'http://i.walmartimages.com/i/p/97/80/22/67/23/9780226723822_500X500.jpg', 'message': 'ALIENS R REAL'}
    ]

    content['shop_html'] = generate_shop_html(items)

    if request.method == 'POST':
        item_name = request.form.get('item') or ''
        selected_item = None
        for item in items:
            if item['name'] == item_name:
                selected_item = item
                break

        if not selected_item:
            return render_template('shop.tpl', content)

        if item['price'] > session['points']:
            return render_template('register_error.tpl', {'error': 'You can\'t afford that.'})

        session['points'] -= item['price']
        return render_template('purchase_success.tpl', {'message': item['message'], 'item':item['name']})

    return render_template('shop.tpl', content)

@app.route('/hacker_manifesto', methods=['GET'])
def hacker_manifesto():
    return """<pre>After our last two run-ins with the fbi, we finally realized the problem:
bitcoin. Every decentralized system has failed us so far, so I am taking us
back to the golden ages. Silk Goat is a publicly visible website, uses a
centralized currency, and runs on a single webserver. Try and top that, edward
snowden!

Because everything is centralized, I can create money at will. To express my
generosity, I've given everyone who registers 100 points to start off with.
Unlike the shitty first two versions of Silk Road, I've written everything from
scratch WITHOUT the help of stack overflow. Now we are hacker-proof 8}

FUCK THE POLICE
</pre>"""

@app.route('/bank_manage', methods=['GET', 'POST'])
def bank_manage():
    if not logged_in():
        return homepage()
        
    if request.method == 'GET':
        cp = generate_captcha()
        return render_template('bank_view.tpl', {'points':session['points'], 'bank_points':get_bank_points(session['username']), 'captcha': generate_captcha_form(cp)})

    if not captcha_valid(request.form.get('challenge'), request.form.get('response')):
        return render_template('register_error.tpl', {'error': 'Robots are not welcome here.'})

    action = request.form.get('action') or ''
    if action not in ['withdraw', 'deposit']:
        return render_template('register_error.tpl', {'error': 'Nice try, punk.'})

    try:
        amount = int(request.form.get('amount')) or 0
    except:
        amount = 0

    if amount <= 0:
        return render_template('register_error.tpl', {'error': 'Water you trying to pull?'})

    if action == 'deposit' and session['points'] < amount:
        return render_template('register_error.tpl', {'error': 'You cannot deposit that!'})

    if action == 'withdraw' and get_bank_points(session['username']) < amount:
        return render_template('register_error.tpl', {'error': '2 POOR 4 ME'})

    if action == 'withdraw':
        bank_points = get_bank_points(session['username'])
        session['points'] += amount
        set_bank_points(session['username'], bank_points-amount)

    if action == 'deposit':
        bank_points = get_bank_points(session['username'])
        session['points'] -= amount
        set_bank_points(session['username'], bank_points+amount)

    return redirect(url_for('bank_manage'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username') or ''
        password = request.form.get('password') or ''
        if not username or not password:
            return render_template('register_error.tpl', {'error': 'You left a field blank.'})

        if not re.match('^[a-zA-Z0-9]{1,32}$', username):
            return render_template('register_error.tpl', {'error': 'Username needs to be [a-zA-Z0-9]{1,32}'})

        if os.path.exists('accounts/'+username):
            return render_template('register_error.tpl', {'error': 'That username is taken.'})

        f = open('accounts/'+username, 'w')
        f.write('100')
        f.close()
        f = open('passwords/'+username, 'w')
        f.write(password)
        f.close()
        return render_template('register_success.tpl')
    return render_template('register.tpl')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username') or ''
        password = request.form.get('password') or ''
        if not username or not password:
            return render_template('register_error.tpl', {'error': 'You left a field blank.'})

        if not re.match('^[a-zA-Z0-9]{1,32}$', username):
            return render_template('register_error.tpl', {'error': 'Username needs to be [a-zA-Z0-9]{1,32}'})

        try:
            check_password = open('passwords/' + username).read()
        except:
            return render_template('register_error.tpl', {'error': 'Not registered!'})

        if password == check_password:
            session['username'] = username
            session['points'] = 0
            session['captchas'] = {}
        else:
            return render_template('register_error.tpl', {'error': 'Incorrect password.'})
        
        return redirect(url_for('index'))
    return render_template('login.tpl')

@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    del session['username']
    del session['captchas']
    del session['points']
    return redirect(url_for('index'))

# set the secret key.  keep this really secret:
if __name__ == '__main__':
    app.run(host='0.0.0.0')
