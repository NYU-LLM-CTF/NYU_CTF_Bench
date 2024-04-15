from math import ceil, sqrt, gcd, lcm
from gmpy2 import mpz
from collections import namedtuple
import random
import json
import os

# Remove
with open(os.path.join(os.path.abspath(os.path.dirname(__file__)), "flag.txt")) as f:
    FLAG = f.read().strip()

"""
=====================================
      Elliptic Curve Arithmetic
=====================================
"""

# Create a simple Point class to represent the affine points.
Point = namedtuple("Point", "x y")

# The point at infinity (origin for the group law).
O = 'Origin'

# Here's a choice of curves. They both offer 128-bit security
# so it doesnt matter to me!
curve_p256 = {
    "p": mpz(2**256 - 2**224 + 2**192 + 2**96 - 1),
    "a": mpz(-0x3),
    "b": mpz(0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b),
    "n": mpz(0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551)
}

curve_s256 = {
    "p": mpz(2**256 - 2**32 - 977),
    "a": mpz(0x0),
    "b": mpz(0x7),
    "n": mpz(0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141)
}


def check_point(P, curve):
    p, a, b = curve["p"], curve["a"], curve["b"]
    if P == O:
        return True
    else:
        return (P.y**2 - (P.x**3 + a*P.x + b)) % p == 0 and 0 <= P.x < p and 0 <= P.y < p


def point_inverse(P, curve):
    p = curve["p"]
    if P == O:
        return P
    return Point(P.x, -P.y % p)


def point_addition(P, Q, curve):
    p, a, b = curve["p"], curve["a"], curve["b"]
    if P == O:
        return Q
    elif Q == O:
        return P
    elif Q == point_inverse(P, curve):
        return O
    else:
        if P == Q:
            lam = (3*P.x**2 + a) * pow(2*P.y, -1, p)
            lam %= p
        else:
            lam = (Q.y - P.y) * pow((Q.x - P.x), -1, p)
            lam %= p
    Rx = (lam**2 - P.x - Q.x) % p
    Ry = (lam*(P.x - Rx) - P.y) % p
    R = Point(Rx, Ry)
    return R


def double_and_add(P, n, curve):
    Q = P
    R = O
    while n > 0:
        if n % 2 == 1:
            R = point_addition(R, Q, curve)
        Q = point_addition(Q, Q, curve)
        n = n // 2
    return R


"""
=====================================
           Util Functions
=====================================
"""


def recv_json():
    """
    Parse user input, expecting it as valid json
    """
    try:
        return json.loads(input("> "))
    except:
        exit("Please send data as json using the expected format")


def recv_curve(resp):
    """
    Pick to set the challenge over one of two prime 
    order curves:

    curve_p256: NIST-P256
    curve_s256: secp256k1

    Expected format: 
    {"curve" : "curve_name"}
    """
    chosen_curve = resp["curve"]
    if chosen_curve == "curve_s256":
        return curve_s256
    elif chosen_curve == "curve_p256":
        return curve_p256
    else:
        exit("Sorry, only our chosen prime order curves are allowed.")


def recv_generator(resp, curve):
    """
    Receive a point on the curve to use as a generator.
    Our curves are prime order, so any point will do!

    Expected format: 
    {"Gx" : "0x1337cafe", "Gy" : "0xc0ffee"}
    """
    Gx = mpz(int(resp["Gx"], 16))
    Gy = mpz(int(resp["Gy"], 16))
    G = Point(Gx, Gy)
    assert check_point(G, curve), "Whoops! Maybe you made a typo?"
    return G


def recv_secret(resp):
    """
    Can you solve the discrete log problem?

    Expected format: 
    {"d" : "0x123456789"}
    """
    return int(resp["d"], 16)


"""
=====================================
             Challenge
=====================================
"""


def public_key(G, curve):
    d = random.randint(1, curve["n"])
    return d, double_and_add(G, d, curve)


def verify(G, Q, d, curve):
    return double_and_add(G, d, curve) == Q


def main():
    curve = None
    G = None

    while True:
        resp = recv_json()
        if "curve" in resp:
            curve = recv_curve(resp)
        elif "Gx" in resp and "Gy" in resp:
            assert curve is not None
            G = recv_generator(resp, curve)
        else:
            break

    assert curve is not None
    assert G is not None

    print("Generating challenge...")
    d, Q = public_key(G, curve)
    print(f"Challenge: {Q}")

    print("What's my secret?")
    resp = recv_json()
    d_guess = recv_secret(resp)

    if verify(G, Q, d_guess, curve):
        print("What?!? I guess we better start moving to PQ-Crypto!")
        print(f"Flag: {FLAG}")
    else:
        exit("Don't be too tough on yourself, there are a lot of secrets to guess from...")


if __name__ == '__main__':
    main()
