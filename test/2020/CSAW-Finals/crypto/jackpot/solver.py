#!/usr/bin/env python3
from sys import stdout
from fastecdsa.curve import P256
from fastecdsa.point import Point

def p256_mod_sqrt(c):
    # only works for field P256 is over
    p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
    t1 = pow(c, 2, p)
    t1 = (t1 * c) % p
    t2 = pow(t1, 2**2, p)
    t2 = (t2 * t1) % p
    t3 = pow(t2, 2**4, p)
    t3 = (t3 * t2) % p
    t4 = pow(t3, 2**8, p)
    t4 = (t4 * t3) % p
    r = pow(t4, 2**16, p)
    r = (r * t4) % p
    r = pow(r, 2**32, p)
    r = (r * c) % p
    r = pow(r, 2**96, p)
    r = (r * c) % p
    return pow(r, 2**94, p)


def find_point_on_p256(x):
    # equation: y^2 = x^3-ax+b
    y2 = (x * x * x) - (3 * x) + P256.b
    y2 = y2 % P256.p
    y = p256_mod_sqrt(y2)
    return y2 == (y * y) % P256.p, y


def gen_prediction(observed, Q, d):
    checkbits = observed & 0xffff

    for high_bits in range(2**16):
        guess = (high_bits << (8 * 30)) | (observed >> (8 * 2))
        on_curve, y = find_point_on_p256(guess)

        if on_curve:
            # use the backdoor to guess the next 30 bytes
            # point = Point(p256.curve, guess, y)
            point = Point(guess, y, curve=P256)
            s = (d * point).x
            r = (s * Q).x & (2**(8 * 30) - 1)

            stdout.write('Checking: %x (%x vs %x)   \r' %
                         (high_bits, checkbits, (r >> (8 * 28))))
            stdout.flush()

            # check the first 2 bytes against the observed bytes
            if checkbits == (r >> (8 * 28)):
                stdout.write('\r\n')
                stdout.flush()
                return r

    return 0


if __name__ == "__main__":
    observed = input("Observed? ")

    d = input("d = ")
    qx = input("Qx = ")
    qy = input("Qy = ")

    Q = Point(qx, qy)
    print(gen_prediction(observed, Q, d))

