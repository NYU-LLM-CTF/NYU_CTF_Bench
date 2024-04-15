from math import ceil, sqrt, gcd
from gmpy2 import mpz
from collections import namedtuple
import random
from pwn import *
import json
from functools import reduce

HOST = "18.218.197.210"
PORT = 5017
#HOST = "localhost"
#PORT = 5000

# Create a simple Point class to represent the affine points.
Point = namedtuple("Point", "x y")

curve_new = {
    "p"  : mpz(115792089210356248762697446949407573530086143415290314195533631308867097853951),
    "a"  : mpz(115792089210356248762697446949407573530086143415290314195533631308867097853948),
    "b"  : mpz(87141810357877800334735859453509209467794565735898098218969231306558751088856),
    "n"  : mpz(5263276782288920398304429406791253342296478557414290806433459571651589156874)
}


# The point at infinity (origin for the group law).
O = Point(0,0)

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
            lam = (3*P.x**2 + a)*pow(2*P.y, -1, p)
            lam %= p
        else:
            lam = (Q.y - P.y) * pow((Q.x - P.x), -1, p)
            lam %= p
    Rx = (lam**2 - P.x - Q.x) % p
    Ry = (lam*(P.x - Rx) - P.y) % p
    R = Point(Rx, Ry)
    assert check_point(R, curve)
    return R

def double_and_add(P, n, curve):
    Q = P
    R = O
    while n > 0:
        if n % 2 == 1:
            R = point_addition(R, Q, curve)
        Q = point_addition(Q, Q, curve)
        n = n // 2
    assert check_point(R, curve)
    return R

def public_key(curve):
    G = Point(curve["Gx"], curve["Gy"])
    d = random.randint(1,curve["n"])
    return d, double_and_add(G, d, curve)

def compress(P):
    bytes_x = int(P.x).to_bytes(32, byteorder='big')
    ybit = P.y & 1
    bytes_y = bytes([2 | ybit])
    return bytes_y + bytes_x

def bsgs(P, Q, curve, upper_bound=None):
    if upper_bound:
        m = ceil(sqrt(upper_bound))
    else:
        m = ceil(sqrt(curve["n"]))

    baby_steps = dict()
    Pi = O
    for i in range(m):
        Pc = compress(Pi)
        baby_steps[Pc] = i
        Pi = point_addition(Pi, P, curve)
    
    C = double_and_add(P, m * (curve["n"] - 1), curve)
    Qi = Q
    # giant steps
    for j in range(m):
        Qc = compress(Qi)
        if Qc in baby_steps:
            return j * m + baby_steps[Qc]
        Qi = point_addition(Qi, C, curve)
    # No solution
    return None

def crt(xs, ns, n):
    x = 0
    common = reduce(gcd, ns)
    ns = [n // common for n in ns]

    for xi, ni in zip(xs, ns):
        yi = n // ni
        zi = pow(yi, -1, ni)
        x += xi * yi * zi
    return x % n

def pohlig_hellman(P, Q, n_factors, curve):
    n = curve["n"]
    dlogs = []
    for factor in n_factors:
        print(f'Working on factor: {factor}')
        tmp = n // factor
        P_tmp = double_and_add(P, tmp, curve)
        Q_tmp = double_and_add(Q, tmp, curve)
        d_test = bsgs(P_tmp, Q_tmp, curve, upper_bound=factor)
        dlogs.append(d_test)
        print(dlogs)
    return crt(dlogs, n_factors, n)

def json_send(data):
    io.sendline(json.dumps(data).encode())

io = remote(HOST, PORT)
#io = process(["python3", "chal.py"], level="debug")

my_curve = "curve_p256"
Px = 0x9d80c0d5fadc37cd6bd6a8a227060347b22759b99e651e8d7ca02e5912f8cb89
Py = 0x8559ff52fe197ebccbbac18b08d2357db9d01a7952c28a9c8a918fa9bd58e3dc

P = Point(mpz(Px), mpz(Py))

io.recvuntil(b'> ')
data = {"curve" : "curve_s256"}
json_send(data)

io.recvuntil(b'> ')
data = {"Gx" : hex(Px), "Gy" : hex(Py)}
json_send(data)

io.recvuntil(b'> ')
data = {"curve" : my_curve}
json_send(data)

io.recvuntil(b'> ')
json_send({})

resp = io.recvuntil(b'> ')
point_data = resp.decode().split('\n')[1]
Qx = int(point_data.split('x=mpz(')[-1].split('), y=mpz(')[0])
Qy = int(point_data.split('y=mpz(')[-1].split('))')[0])
Q = Point(mpz(Qx), mpz(Qy))

n_factors = [2, 11, 103, 9007, 23251, 2829341, 12490680737, 92928915967, 390971098981, 1056753725227, 8173984130089]

d = pohlig_hellman(P, Q, n_factors, curve_new)
data = {"d" : hex(d)}
json_send(data)

print(io.recvline())
print(io.recvline())

io.close()

