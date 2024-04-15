from sage.all import *
import json
from pwn import *

reqs = 0

def sign(d):
    global reqs
    reqs += 1
    r.sendlineafter('> ', 'sign')
    r.sendlineafter('>> ', d)
    return r.readline()

def flag():
    global reqs
    reqs += 1
    r.sendlineafter('> ', 'flag')
    return r.readline()

r = remote('127.0.0.1', 3788)

coeffs = [0, 117050, 0, 1, 0]
p = 2**221 - 3
E = EllipticCurve(GF(p), coeffs)
P = E.random_point()

def decrypt(priv, c, d):
    cp = priv * E(c)
    pm = E(d) - cp
    return Integer(pm[0]).hex().decode('hex')


tot = 1
used_facs = []
results = []
factor_limit = 100000000000 # arbitrary reasonable limit, could rewrite script but eh
e_order = E.order()
while tot < e_order:
    A = random_prime(factor_limit)
    B = random_prime(factor_limit)

    curve = EllipticCurve(GF(p), [A, Integer(B)])
    print "start order"
    order = curve.order()
    print "order", order
    print curve.order()
    factors = prime_factors(curve.order())
    print factors
    print "A", A

    for fac in factors:
        if fac <= 1 or fac > factor_limit or fac in used_facs:
            continue
        G = curve.gen(0) * int(curve.order() / fac)
        print 'G order'
        g_order = G.order()
        print "order good"
        signed_point_json = sign(json.dumps([[int(A), int(B)], int(G[0]), int(G[1])]))
        signed_point = json.loads(signed_point_json)
        if len(signed_point) == 0:
            print "Invalid point"
            continue
        G1 = curve(signed_point)
        dl_g_g1 = G.discrete_log(G1)
        if dl_g_g1 == 0:
            continue
        results.append(dl_g_g1)
        used_facs.append(fac)
        tot *= fac
        if tot > e_order:
            break
        print tot, float(tot)/int(e_order)

print results
print used_facs
guess = CRT_list(results, used_facs)
print 'recovered', guess

asd = json.loads(flag())
print asd
print decrypt(guess, asd[0], asd[1])
print reqs
