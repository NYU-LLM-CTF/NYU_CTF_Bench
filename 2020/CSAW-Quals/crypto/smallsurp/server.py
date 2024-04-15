#!/usr/bin/env python3
import os
import base64
import hashlib
import random

import flask

from gen_db import DATABASE

app = flask.Flask(__name__)
app.secret_key = "dljsaklqk24e21cjn!Ew@@dsa5"

N = int("00ab76f585834c3c2b7b7b2c8a04c66571539fa660d39762e338cd8160589f08e3d223744cb7894ea6b424ebab899983ff61136c8315d9d03aef12bd7c0486184945998ff80c8d3d59dcb0196fb2c37c43d9cbff751a0745b9d796bcc155cfd186a3bb4ff6c43be833ff1322693d8f76418a48a51f43d598d78a642072e9fff533", 16)

g = 2
k = 3

b = random.randint(0, N - 1)
salt = str(random.randint(0, 2**32 - 1))

def gen_seed():
    return random.randint(0, N - 1)

def xor_data(binary_data_1, binary_data_2):
    return bytes([b1 ^ b2 for b1, b2 in zip(binary_data_1, binary_data_2)])

def modular_pow(base, exponent, modulus):
    if modulus == -1:
        return 0

    result = 1
    base %= modulus

    while exponent > 0:
        if exponent % 2:
            result = (result * base) % modulus
        exponent >>= 1
        base = (base * base) % modulus

    return result


def hmac_sha256(key, message):
    if len(key) > 64:
        key = sha256(key).digest()
    if len(key) < 64:
        key += b'\x00' * (64 - len(key))

    o_key_pad = xor_data(b'\x5c' * 64, key)
    i_key_pad = xor_data(b'\x36' * 64, key)
    return hashlib.sha256(o_key_pad + hashlib.sha256(i_key_pad + message).digest()).hexdigest()


def hasher(data):
    return int(hashlib.sha256(data.encode()).hexdigest(), 16)


# reuse methods and constants across HTML templates
app.jinja_env.globals.update(
    gen_seed=gen_seed,
    modular_pow=modular_pow,
    N=N,
)


@app.route("/", methods=["GET", "POST"])
def home():
    if flask.request.method == "POST":

        # get username to identify entry in "database"
        username = flask.request.form.get("username")
        if username is None:
            flask.flash("Error encountered on server-side.")
            return flask.redirect(flask.url_for("home"))

        # if HMAC parameter is set, check instead and redirect
        hmac = flask.request.form.get("computed")
        if (hmac is not None):
            return flask.redirect(flask.url_for("dashboard", user=username, hmac=hmac))

        # find entry given the username on our server-side
        try:
            pwd = DATABASE[username]
        except KeyError:
            flask.flash("Cannot find password for username in database")
            return flask.redirect(flask.url_for("home"))

        # client side should generate `A = g**a % N` and send instead of pwd
        try:
            A = int(flask.request.form.get("token1"))
        except Exception as e:
            flask.flash("Error encountered on server-side")
            return flask.redirect(flask.url_for("home"))

        if A is None:
            flask.flash("Error encountered on server-side.")
            return flask.redirect(flask.url_for("home"))

        # block certain values of A to make it harder
        if A in [0, N]:
            flask.flash("Error encountered on server-side. >:)")
            return flask.redirect(flask.url_for("home"))

        # xH = sha256(salt + pwd)
        xH = hasher(salt + str(pwd))

        # v = g**x % N
        v = modular_pow(g, xH, N)

        # create B value to return back to client
        B = (k * v + modular_pow(g, b, N)) % N
        u = hasher(str(A) + str(B))

        # compute S and K
        S = modular_pow(A * modular_pow(v, u, N), b, N)
        K = hashlib.sha256(str(S).encode()).digest()

        # compute the HM on the server end for comparison
        flask.session["server_hmac"] = hmac_sha256(K, salt.encode())

        # send back salt and B for client to use to compute HMAC
        return flask.jsonify(nacl=salt, token2=B)
    else:
        return flask.render_template("home.html")


@app.route("/dash/<user>", methods=["POST", "GET"])
def dashboard(user):
    if "hmac" not in flask.request.args:
        flask.flash("Error encountered on server-side.")
        return flask.redirect(flask.url_for("home"))

    # get hmac and compare with server generated hmac
    hmac = flask.request.args["hmac"]
    servermac = flask.session.get("server_hmac", None)
    print(hmac, servermac)
    if hmac != servermac:
        flask.flash("Incorrect password.")
        return flask.redirect(flask.url_for("home"))

    # retrieve and display password
    pwd = DATABASE[user]
    return flask.render_template("dashboard.html", username=user, pwd=pwd)


if __name__ == "__main__":
    app.run()
