#!/usr/bin/env python2
"""
solve.py

    Bruteforces weak curve by solving for discrete log
"""

import sys
import random

from supercurve import curve

def log(curve, p, q):
    assert curve.is_on_curve(p)
    assert curve.is_on_curve(q)

    start = random.randrange(curve.order)
    r = curve.mult(start, p)

    for x in range(curve.order):
        if q == r:
            logarithm = (start + x) % curve.order
            steps = x + 1
            return logarithm, steps
        r = curve.add(r, p)

    raise AssertionError('logarithm not found')


def main():
    if len(sys.argv) != 3:
        print("Usage: ./solve.py <pub_x> <pub_y>")
        return 1

    pub = (long(sys.argv[1]), long(sys.argv[2]))
    y, steps = log(curve, curve.g, pub)

    print("Steps: {}".format(steps))
    print("Scalar: {}".format(y))
    return 0

if __name__ == '__main__':
    exit(main())
