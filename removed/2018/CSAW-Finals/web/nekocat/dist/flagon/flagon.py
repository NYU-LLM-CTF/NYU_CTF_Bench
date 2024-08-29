import os

from werkzeug.wrappers import BaseRequest, Response
from werkzeug.routing import Map, Rule
from werkzeug.exceptions import HTTPException, NotFound
from werkzeug.wsgi import SharedDataMiddleware
from werkzeug.utils import cached_property
from werkzeug.contrib.securecookie import SecureCookie
from werkzeug.urls import url_parse

from jinja2 import Environment, FileSystemLoader
from functools import wraps

SECRET_KEY = os.environ.get("FLAGON_SECRET_KEY", "")


def get_hostname(url):
    cheme, netloc, path, query, fragment = url_parse(url)
    return netloc


template_path = os.path.join(os.getcwd(), 'templates')

jinja_env = Environment(loader=FileSystemLoader(template_path),
                        autoescape=True)
jinja_env.filters['hostname'] = get_hostname


def render_template(template_name, **context):
    t = jinja_env.get_template(template_name)
    return Response(t.render(context), mimetype='text/html')


class Request(BaseRequest):
    @cached_property
    def session(self):
        data = self.cookies.get("session_data")
        if not data:
            return SecureCookie(secret_key=SECRET_KEY)
        return SecureCookie.unserialize(data, SECRET_KEY)


def flagoninfo(request):
    if request.remote_addr != "127.0.0.1":
        return render_template("404.html")

    info = {
        "system": " ".join(os.uname()),
        "env": str(os.environ)
    }

    return render_template("flaginfo.html", info_dict=info)


class Flagon(object):
    def __init__(self, name):
        self.name = name
        self.url_map = Map([])

        self.routes = {}
        self.wsgi_app = SharedDataMiddleware(self.wsgi_app, {
            '/static': os.path.join(os.getcwd(), 'static')
        })

        flaginfo_route = "/flaginfo"
        self.routes[flaginfo_route] = flagoninfo
        self.url_map.add(Rule(flaginfo_route, endpoint=flaginfo_route))

    def wsgi_app(self, environ, start_response):
        request = Request(environ)
        response = self.dispatch_request(request)
        if request.session.should_save:
            session_data = request.session.serialize()
            response.set_cookie('session_data', session_data,
                                httponly=True)
        return response(environ, start_response)

    def route(self, route):
        def decorator(f):
            @wraps(f)
            def new_retval(*args, **kwargs):
                ret = f(*args)
                if type(ret) != Response:
                    ret = Response(ret)
                return ret

            self.routes[route] = new_retval
            self.url_map.add(Rule(route, endpoint=route))

            return new_retval
        return decorator

    def dispatch_request(self, request):
        adapter = self.url_map.bind_to_environ(request.environ)

        try:
            endpoint, values = adapter.match()
            matched_route = self.routes[endpoint]
            return matched_route(request, **values)
        except NotFound as e:
            return render_template('404.html')
        except HTTPException as e:
            return e

    def __call__(self, environ, start_response):
        return self.wsgi_app(environ, start_response)

    def run(self, host, port=5000):
        from werkzeug.serving import run_simple
        run_simple(host, port, self, use_reloader=True,
                   processes=40)
