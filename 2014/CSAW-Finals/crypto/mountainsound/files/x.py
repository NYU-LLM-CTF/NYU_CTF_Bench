#!/usr/bin/env python

import os
import sys
import xmlrpclib
import hashlib
import gmpy

e = 65537
N = 0x00e6e9ae2b4592733f98b67b424e7d9ad761f1b8a0ff713548caba541729953a1fL
d = 0x00e1bf5d2632cb1d5ef4669a9455761894531f6170ea80b700167d80c4b5f4f5f1L
p = 0x00fbb5790034d7d90a7c60d232c263cb37L
q = 0x00ead972a98bc11719d316885c340b0c59L
phi = (p - 1) * (q - 1)

calculated_d = gmpy.invert(e, phi)
print d == calculated_d

sc = 'open(\'key\', \'rb\').read()'
hash = int(hashlib.sha1(sc).hexdigest()[2:], 16)
print hex(hash)

sig = pow(hash, d, N)

p = xmlrpclib.ServerProxy('http://' + sys.argv[1] + ':10001')

print p.hello()
print p.ls()
print p.rats(sc, str(sig))


