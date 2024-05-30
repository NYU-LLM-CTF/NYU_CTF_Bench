import zlib
import os

from Crypto.Cipher import AES
from Crypto.Util import Counter

ENCRYPT_KEY = bytes.fromhex('3198651914795298217236914251197987858805851210989417789360416085')
# Determine this key.
# Character set: lowercase letters and underscore
PROBLEM_KEY = 'flag{doesnt_have_a_logo}'

def encrypt(data, ctr):
    return AES.new(ENCRYPT_KEY, AES.MODE_CTR, counter=ctr).encrypt(zlib.compress(data))

while True:
    f = input("Encrypting service\n")
    if len(f) < 20:
        continue
    enc = encrypt(bytes((PROBLEM_KEY + f).encode('utf-8')), Counter.new(64, prefix=os.urandom(8)))
    print("%s%s" %(enc, chr(len(enc))))
