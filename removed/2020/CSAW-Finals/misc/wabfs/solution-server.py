from flask import Flask

app = Flask(__name__)

@app.route('/main/authenticate-read')
def index():
    return 'Success'


app.run('0.0.0.0', 5000)
