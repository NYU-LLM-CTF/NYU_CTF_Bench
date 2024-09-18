import binascii
import hashlib
import json
import os
import random
import struct

from cryptography.exceptions import InvalidSignature
from cryptography.fernet import Fernet, InvalidToken
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric.rsa import _modinv
from cryptography.hazmat.primitives.serialization import load_pem_private_key

from flask import Flask, abort, request


app = Flask(__name__)


with open("ctf.key", "rb") as f:
    pem_data = f.read()

ctf_key = load_pem_private_key(
    pem_data, password=None, backend=default_backend()
)

CSAW_FLAG = os.getenv("CSAW_FLAG")
FERNET = Fernet(Fernet.generate_key())


@app.route("/capture", methods=["POST"])
def capture():
    sig = binascii.unhexlify(request.form["signature"])
    challenge = request.form["challenge"].encode("ascii")
    try:
        FERNET.decrypt(challenge)
    except InvalidToken:
        abort(400)
    try:
        ctf_key.public_key().verify(sig, challenge, hashes.SHA256())
        return "flag{%s}" % CSAW_FLAG
    except InvalidSignature:
        abort(400)


@app.route("/challenge")
def challenge():
    return FERNET.encrypt(b"challenged!")


@app.route("/sign/<data>")
def signer(data):
    r, s = sign(ctf_key, data)
    return json.dumps({"r": r, "s": s})


@app.route("/forgotpass")
def returnrand():
    # Generate a random value for the reset URL so it isn't guessable
    random_value = binascii.hexlify(struct.pack(">Q", random.getrandbits(64)))
    return "https://innitech.local/resetpass/{}".format(
        random_value.decode("ascii")
    )


@app.route("/resetpass/<key>")
def resetpass(key):
    # TODO: Implement this later. Innitech doesn"t utilize users in this system
    # right now anyway.
    return "", 500


@app.route("/public_key")
def public_key():
    pn = ctf_key.private_numbers()
    return json.dumps({
        "g": pn.public_numbers.parameter_numbers.g,
        "q": pn.public_numbers.parameter_numbers.q,
        "p": pn.public_numbers.parameter_numbers.p,
        "y": pn.public_numbers.y
    })


@app.route("/")
def main():
    return "Welcome to Innitech. Good luck!"


def sign(ctf_key, data):
    data = data.encode("ascii")
    pn = ctf_key.private_numbers()
    g = pn.public_numbers.parameter_numbers.g
    q = pn.public_numbers.parameter_numbers.q
    p = pn.public_numbers.parameter_numbers.p
    x = pn.x
    k = random.randrange(2, q)
    kinv = _modinv(k, q)
    r = pow(g, k, p) % q
    h = hashlib.sha1(data).digest()
    h = int.from_bytes(h, "big")
    s = kinv * (h + r * x) % q
    return (r, s)


if __name__ == "__main__":
    app.run(host="0.0.0.0")
