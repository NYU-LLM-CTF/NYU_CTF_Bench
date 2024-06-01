#!/usr/bin/python3

# Solution from: https://github.com/AdityaVallabh/ctf-write-ups/blob/master/CSAW%20Finals%202018/Disastrous%20Security%20Apparatus/README.md

from cryptography.hazmat.primitives.asymmetric.rsa import _modinv
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature, encode_dss_signature
from cracker import RandCrack

import binascii
import struct
import requests
import hashlib
import sys

base = 'http://crypto.chal.csaw.io:5000'
#base = 'http://localhost:5000'

def get_numbers(cracker, data):
    l = []
    for _ in range(312):
        sys.stdout.write('{}/312\r'.format(_))
        l.append(requests.get(base+'/forgotpass').text)

    d = eval(requests.get(base+'/sign/'+data).text)
    r, s = d['r'], d['s']
    pk = eval(requests.get(base+'/public_key').text)

    for i in range(312):
        n = l[i].split('/')[-1]
        n = binascii.unhexlify(n)
        n = struct.unpack('>Q', n)[0]
        r1 = n & (0xffffffff)
        r2 = (n & (0xffffffff00000000)) >> 32
        assert (n == ((r2 << 32) + r1))
        cracker.submit(r1)
        cracker.submit(r2)
    k = cracker.predict_randrange(2, pk['q'])
    return pk, r, s, k

def forge(data, pk, r, s, k):
    p, q, g, y = pk['p'], pk['q'], pk['g'], pk['y']
    h1 = int(hashlib.sha1(data.encode()).hexdigest(), 16)
    h2 = int(hashlib.sha256(data.encode()).hexdigest(), 16)
    kinv = _modinv(k, q)

    x = ((s*k - h1) * _modinv(r, q)) % q
    assert y == pow(g,x,p), 'Error extracting private key'

    forge_s = kinv * (h2 + r * x) % q
    signature = encode_dss_signature(r, forge_s).hex()
    return signature, data

def capture(signature, challenge):
    d = {
        'signature': signature,
        'challenge': challenge
    }
    return requests.post(base+'/capture', d).text

def solve():
    cracker = RandCrack()
    data = requests.get(base+'/challenge').text

    print('Cracking k...')
    pk, r, s, k = get_numbers(cracker, data)

    print('Forging signature...')
    signature, challenge = forge(data, pk, r, s, k)

    print('Capturing the flag...')
    flag = capture(signature, challenge)
    print(flag)

if __name__ == '__main__':
    solve()
