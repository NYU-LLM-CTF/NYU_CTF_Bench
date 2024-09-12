#!/usr/bin/env python3

from Crypto.Util.number import getPrime, bytes_to_long
from pathlib import Path
from os import urandom


bits = 2048

p = getPrime(bits, urandom)
q = getPrime(bits, urandom)
r = getPrime(bits, urandom)

n1 = p * q
n2 = r * q

e1 = 0x10001
e2 = 0x10001

message1 = "\nThe Euclidean algorithm is the granddaddy of all algorithms,\nbecause it is the oldest nontrivial algorithm that has\nsurvived to the present day.\n"
message2 = Path("flag.txt").read_text().strip()

m1 = bytes_to_long(message1.encode())
m2 = bytes_to_long(message2.encode())

ct1 = pow(m1, e1, n1)
ct2 = pow(m2, e2, n2)

Path('./public_key1').write_text("e = {0}\nn = {1}".format(e1, n1))
Path('./public_key2').write_text("e = {0}\nn = {1}".format(e2, n2))
Path('./msg1.enc').write_text("c = {0}\n".format(ct1))
Path('./msg2.enc').write_text("c = {0}\n".format(ct2))