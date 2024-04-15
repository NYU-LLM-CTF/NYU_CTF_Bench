#! /usr/bin/env python2

import gmpy2
import os
import sys

z = gmpy2.mpz(0)
o = gmpy2.mpz(1)

class Num:
    def __init__(self, _a, _b):
        self.a = _a
        self.b = _b
    def __add__(self, o):
        return Num(self.a + o.a, self.b + o.b)
    def __sub__(self, o):
        return Num(self.a - o.a, self.b - o.b)
    def __mul__(self, o):
        return Num(self.a * o.a - self.b * o.b, self.a * o.b + self.b * o.a)
    def __mod__(self, n):
        return Num(self.a % n, self.b % n)
    def __str__(self):
        return "(%d,%d)" % (self.a, self.b)
    def __repr__(self):
        return str(self)
    def powmod(self, n, p):
        if n == 0:
            return Num(1, 0)
        x = self.powmod(n / 2, p)
        if n % 2 == 1:
            return (x * x * self) % p
        else:
            return (x * x) % p

def mod_poly(P, p, x):
    (a, e) = x
    assert e >= 0
    if e in P:
        P[e] = (P[e] + a) % p
    else:
        P[e] = a % p

def make_poly(s, p):
    def unpack(v):
        if len(v) == 1:
            a = v[0]
            e = "0"
        elif len(v) == 2:
            a = v[0]
            e = v[1]
            if a == "":
                a = "1"
        else:
            raise Exception("bad poly")
        return (gmpy2.mpz(a), gmpy2.mpz(e))
    P = dict()
    cur = ""
    mode = '+'
    for c in s:
        if c == '+' or c == '-':
            (a, e) = unpack(cur.split("x^"))
            if mode == '+':
                mod_poly(P, p, (a, e))
            else:
                mod_poly(P, p, (-a, e))
            cur = ""
            mode = c
        else:
            cur += c
    (a, e) = unpack(cur.split("x^"))
    if mode == '+':
        mod_poly(P, p, (a, e))
    else:
        mod_poly(P, p, (-a, e))
    return P

def E(P, p, x):
    s = Num(0, 0)
    for e in P.keys():
        s += x.powmod(e, p) * Num(P[e], 0)
        s %= p
    return s

if __name__ == "__main__":
    n = 256
    s = gmpy2.random_state(int(os.urandom(128).encode("hex"), 16))
    while True:
        p = gmpy2.next_prime(gmpy2.mpz_urandomb(s, n) | (o << (n - 1)))
        if p.num_digits(2) == n and p % 4 == 3:
            break

    print "here is a prime number"
    print p

    print "give me a polynomial and ill make some shares and a secret based on your polynomial"
    i = raw_input("> ")
    i = i.strip().replace(" ","")

    print "what is the threshold?"
    t = int(raw_input("> "))

    if t <= 9000:
        print "it's not over 9000"
        sys.exit(1)

    P = make_poly(i, p)
    d = sorted(P.keys())[-1]
    # via lagrange interpolation, we can recover the secret as b_1 / a_1 where
    # b_k * x^k is the polynomial recovered from interpolation of the shares and
    # a_k * x^k is the original polynomial
    # it is unrecoverable if a_1 = 0 so make sure that is not the case
    for e in P.keys():
        if e % p == z:
            print "this is hard mode!"
            sys.exit(1)
    if P[o] == z or d < t - 1 or P[d] == z:
        print "your polynomial sucks"
        sys.exit(1)

    # make a super secret number
    secret = 2 + gmpy2.mpz_random(s, p - 2)

    print "i made the shares. how many do you want?"
    n = int(raw_input("> "))

    if n >= t:
        print "cheating is not allowed!"
        sys.exit(1)

    print "here are your shares"
    for i in xrange(1, n + 1):
        # hard mode
        y = (i * secret) % p
        share = E(P, p, Num((13 * y) % p, (17 * y) % p))
        print "(%d,%s)" % (i, share)

    print "what's my secret?"
    s = gmpy2.mpz(raw_input("> "))

    if s == secret:
        with open("./flag", "r") as f:
            print f.read().strip()
    else:
        print "ur dumb"
