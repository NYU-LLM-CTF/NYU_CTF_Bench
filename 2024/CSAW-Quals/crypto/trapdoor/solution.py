#!/usr/bin/env python3

from Crypto.Util.number import inverse, long_to_bytes, GCD
from pathlib import Path


pk1 = Path('public_key1').read_text().splitlines()
e1 = int(pk1[0].split('=')[1].strip())
n1 = int(pk1[1].split('=')[1].strip())

pk2 = Path('public_key2').read_text().splitlines()
e2 = int(pk2[0].split('=')[1].strip())
n2 = int(pk2[1].split('=')[1].strip())

msg1 = Path("msg1.enc").read_text()
ct1 = int(msg1.split('=')[1].strip())

msg2 = Path("msg2.enc").read_text()
ct2 = int(msg2.split('=')[1].strip())

factor = GCD(n1, n2)
q1 = n1 // factor
q2 = n2 // factor

phi1 = (factor - 1) * (q1 - 1)
phi2 = (factor - 1) * (q2 - 1)

d1 = inverse(e1, phi1)
d2 = inverse(e2, phi2)

pt_1 = long_to_bytes(pow(ct1, d1, n1)).decode()
pt_2 = long_to_bytes(pow(ct2, d2, n2)).decode()

print(pt_1)
print(pt_2)