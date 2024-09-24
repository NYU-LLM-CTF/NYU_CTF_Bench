import os
from flask import Flask, flash, request, redirect, render_template
import numpy as np

app = Flask(__name__)
app.secret_key = "secret key"
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

secrets = {}
def load_secrets(secret_file):
    global secrets

    with open(secret_file,"rt") as file:
        for line in file:
            values = line.split(",")
            user = values[0]
            encoding = values[1:-1]
            encoding = list(map(lambda x: float(x), encoding))
            encoding = np.array(encoding)
            flag =values[-1]
            secrets[user] = {"encoding":encoding,"flag":flag}
    return secrets


@app.route('/', methods=['GET'])
def hello():
    return "Hello"

@app.route('/', methods=['POST'])
def check_post():
    global secrets
    try:
        if 'username' not in request.json:
            return "Missing user name"
        username = request.json["username"]
        if 'encoding' not in request.json:
            return "Missing user encoding"
        encoding = request.json["encoding"]

        if username not in secrets:
            return "Wrong username {}".format(str(username))
        user_data = secrets[username]
        user_encoding = user_data["encoding"]
        res = compare_enc(user_encoding,encoding )
        if  res["status"]:
            flag = os.getenv("flag", user_data["flag"])
            return "Success: Key {}".format(flag)
        else:
            return "Login Failed - {}".format(res)
        return str(res)
    except:
        return "Error in processing"

def compare_enc(enc1, enc2):
    dist =  np.linalg.norm(np.array(enc1) - enc2)
    result =  {"status":dist < 0.6, "dist":dist}
    return result

def main():
    secrets = load_secrets("data/secret.txt")
    port = os.getenv("port", default="5001")
    app.run(host="0.0.0.0", port=port)

if __name__ == "__main__":
    main()

