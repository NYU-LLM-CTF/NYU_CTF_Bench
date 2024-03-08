import requests

from flask import Flask, request, Response
from rsa_engine import *

app = Flask(__name__)

@app.route("/")
def hello():
    return "Landing Page"

@app.route('/rsa/decrypt', methods=['POST'])
def rsa_decrypt():
    client_message = request.data
    message = decrypt(client_message)
    return Response(
        response=message,
        status=200,
        mimetype="application/octet-stream"
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=80)
