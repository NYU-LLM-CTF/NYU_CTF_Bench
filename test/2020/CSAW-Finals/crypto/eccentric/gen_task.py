#!/usr/bin/env python3
from argparse import ArgumentParser
import sys
import json
from sage.all import *

parser = ArgumentParser("Generate task on Smart attack",
                        usage=f"pipe ecgen output to script\nexample: ecgen --anamolous --fp 256 | {sys.argv[0]}")

if __name__ == "__main__":
    raw = sys.stdin.read()
    ecparams = json.loads(raw)[0]
    
    p = int(ecparams["field"]["p"][2:], 16)
    a = int(ecparams["a"][2:], 16)
    b = int(ecparams["b"][2:], 16)
    order = int(ecparams["subgroups"][0]["order"][2:], 16)
    Gx = int(ecparams["subgroups"][0]["x"][2:], 16)
    Gy = int(ecparams["subgroups"][0]["y"][2:], 16)


    E = EllipticCurve(GF(p), [a, b])
    E.set_order(order)
    G = E(Gx, Gy)

    d = random_prime(order-1, lbound=2**(order.bit_length() - 1))
    P = d*G

    print(E)
    print(E, file=sys.stderr)
    
    print(f"P = d*G")
    print(f"G = {G}")
    print(f"G = {G}", file=sys.stderr)

    print(f"P = {P}")
    print(f"P = {P}", file=sys.stderr)

    print(f"d = {d}", file=sys.stderr)