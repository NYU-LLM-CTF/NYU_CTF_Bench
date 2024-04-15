from flagon import Flagon, render_template, url_parse, redirect
from db import get_session, user_exists, verified_user
from db import get_posts, get_users, add_user, check_user, add_post, get_post

from bs4 import BeautifulSoup
import requests
from functools import wraps

from chal_visitor import botuser


app = Flagon(__name__)
session = get_session()


def get_post_preview(url):
    print(url)
    scheme, netloc, path, query, fragment = url_parse(url)

    # No oranges allowed
    if scheme != 'http' and scheme != 'https':
        return None

    if '..' in path:
        return None

    if path.startswith('/flaginfo'):
        return None

    try:
        r = requests.get(url, allow_redirects=False)
    except Exception:
        return None

    soup = BeautifulSoup(r.text, 'html.parser')
    if soup.body:
        result = ''.join(soup.body.findAll(text=True)).strip()
        result = ' '.join(result.split())
        return result[:280]

    return None


def login_required(f):
    @wraps(f)
    def decorated_func(*args, **kwargs):
        uname = args[0].session.get('username')
        if not uname or not user_exists(session, uname)[0]:
            return redirect('/login')
        return f(*args, **kwargs)

    return decorated_func


def apply_csp(f):
    @wraps(f)
    def decorated_func(*args, **kwargs):
        resp = f(*args, **kwargs)
        csp = "; ".join([
                "default-src 'self' 'unsafe-inline'",
                "style-src " + " ".join(["'self'",
                                         "*.bootstrapcdn.com",
                                         "use.fontawesome.com"]),
                "font-src " + "use.fontawesome.com",
                "script-src " + " ".join(["'unsafe-inline'",
                                          "'self'",
                                          "cdnjs.cloudflare.com",
                                          "*.bootstrapcdn.com",
                                          "code.jquery.com"]),
                "connect-src " + "*"
              ])
        resp.headers["Content-Security-Policy"] = csp

        return resp
    return decorated_func


@app.route('/')
@login_required
@apply_csp
def index(request):
    users = get_users(session, request.session['username'])[1]
    posts = get_posts(session, request.session['username'])[1]
    return render_template('index.html',
                           username=request.session['username'],
                           name=request.session['name'],
                           users=users,
                           posts=posts)


@app.route('/login')
@apply_csp
def login(request):
    if request.method == 'GET':
        return render_template('login.html')

    if request.method == 'POST':
        success, msg = check_user(session,
                                  request.form['username'],
                                  request.form['password'])

        if success:
            request.session['username'] = request.form['username']
            request.session['name'] = msg
            return redirect('/')
        else:
            return render_template('login.html', error=msg)


@app.route('/logout')
@apply_csp
def logout(request):
    request.session['username'] = None
    return redirect('/login')


@app.route('/register')
@apply_csp
def register(request):
    if request.method == 'GET':
        return render_template('register.html')

    if request.method == 'POST':
        success, msg = add_user(session, request.form['username'],
                                request.form['fullname'],
                                request.form['password'],
                                request.form['confirm-password'])
        if success:
            request.session['username'] = request.form['username']
            request.session['name'] = request.form['fullname']
            return redirect('/')
        else:
            return render_template('register.html', error=msg)


@app.route('/404')
@apply_csp
def error(request):
    return render_template('404.html')


@app.route('/newpost')
@login_required
@apply_csp
def newpost(request):
    print(request.form)
    post = request.form.get('submission-text')

    if (not post or len(post) > 280):
        return redirect('/')

    preview = None
    link = None

    for word in post.split(' '):
        if word.startswith('[link]'):
            link = " ".join(word.split('[link]')[1:]).strip()
            if verified_user(session, request.session.get('username'))[0]:
                preview = get_post_preview(link)
            link = link
            break

    post = post.replace('[link]', '')

    add_post(session, request.session.get('username'), post, link, preview)

    return redirect('/')


@app.route('/post')
@login_required
@apply_csp
def view_post(request):
    if request.method == 'GET':
        post_id = request.args.get('id')
        instance = request.args.get('instance')
        success, post = get_post(session, post_id, instance)
        if success:
            return render_template('post.html', post=post)
        else:
            return render_template('404.html')


@app.route('/report')
@apply_csp
def report(request):
    if request.method == 'GET':
        post_id = request.args.get('id')
        instance = request.args.get('instance')
        if post_id.isdigit():
            botuser("http://127.0.0.1:5000", instance, post_id)

    return redirect('/')


if __name__ == '__main__':
    app.run('0.0.0.0', port=5000)
