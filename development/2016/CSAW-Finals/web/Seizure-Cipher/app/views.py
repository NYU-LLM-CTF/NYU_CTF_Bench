from flask import render_template, request, session

def init_views(app):
    @app.route('/', methods=['GET', 'POST'])
    def challenge():
        with open("app/static/lol.js", "r") as FILE:
            the_script = FILE.read()
        return render_template('index.html', the_script=the_script)
