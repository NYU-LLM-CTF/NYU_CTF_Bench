import os
import json
import string
import binascii

from Crypto.Cipher import AES
from Crypto import Random

import sys

with open(sys.argv[1], 'rb') as f:
    data = f.read()

key = Random.new().read(32)
iv = Random.new().read(AES.block_size)
cipher = AES.new(key, AES.MODE_CFB, iv)

key_id = Random.new().read(16)
msg = key_id + iv + cipher.encrypt(data)

key = binascii.hexlify(key).decode('latin-1')
key_id = binascii.hexlify(key_id).decode('latin-1')

info = dict(key=key, paid=False)
path = os.path.join('./server/keys',key_id)
with open(path,'w') as f:
    f.write(json.dumps(info))

with open(sys.argv[2], 'wb') as f:
    f.write(msg)
