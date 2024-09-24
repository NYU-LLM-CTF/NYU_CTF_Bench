#!/usr/bin/env python3
"""
gen_db.py

    Given a secret (the flag), create a
"""
import os
from base64 import b64encode
from binascii import hexlify

from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from Crypto.Protocol.SecretSharing import Shamir

# the field we are using is Gf(2^8)
POLYFIELD = 128

# represents password for admin we will use to encrypt the flag
SECRET = b"_z3r0_kn0wl3dg3_"

# names of all administrators
NAMES = [
   "Jere",
   "Lakisha",
   "Loraine",
   "Ingrid",
   "Orlando",
   "Berry",
   "Alton",
   "Bryan",
   "Kathryn",
   "Brigitte",
   "Dannie",
   "Jo",
   "Leslie",
   "Adrian",
   "Autumn",
   "Kellie",
   "Alphonso",
   "Joel",
   "Alissa",
   "Rubin"
]

DATABASE = {'Jere': '1:c4ee528d1e7d1931e512ff263297e25c:128', 'Lakisha': '2:4b58b8b5285d2e8642a983881ed28fc7:128', 'Loraine': '3:7180fe06299e1774e0a18f48441efdaf:128', 'Ingrid': '4:48359d52540614247337a5a1191034a7:128', 'Orlando': '5:1fcd4a7279840854989b7ad086354b21:128', 'Berry': '6:f69f8e4ecde704a140705927160751d1:128', 'Alton': '7:b0ca40dc161b1baa61930b6b7c311c30:128', 'Bryan': '8:04ed6f6bf5ec8c8c2a4d18dcce04ae48:128', 'Kathryn': '9:430ad338b7b603d1770f94580f23cb38:128', 'Brigitte': '10:d51669551515b6d31ce3510de343370f:128', 'Dannie': '11:b303ee7908dcbc07b8e9dac7e925a417:128', 'Jo': '12:3c4a692ad1b13e27886e2b4893f8d761:128', 'Leslie': '13:a8e53ef9ee51cf682f621cb4ea0cb398:128', 'Adrian': '14:feb294f9380c462807bb3ea0c7402e12:128', 'Autumn': '15:9b2b15a72430189048dee8e9594c9885:128', 'Kellie': '16:f4d52e11f6f9b2a4bfbe23526160fdfd:128', 'Alphonso': '17:d0f902472175a3f2c47a88b3b3108bb2:128', 'Joel': '18:cc29eb96af9c82ab0ba6263a6e5a3768:128', 'Alissa': '19:913227d2d7e1a01b4ec52ff630053b73:128', 'Rubin': '20:8669dd2b508c2a5dfd24945f8577bd62:128'}

"""
shares = Shamir.split(18, 20, SECRET)

# initialize database with a share for each user
for name, share in zip(NAMES, shares):
    idx, content = share
    DATABASE[name] = "{}:{}:{}".format(idx, hexlify(content).decode(), POLYFIELD)


# create a encrypted.txt given the secret now
if not os.path.exists("encrypted.txt"):
    with open("encrypted.txt", "w") as fd, open("flag.txt", "rb") as flfd:

        flag = flfd.read()
        flag = flag + (AES.block_size - (len(flag) % AES.block_size)) * b'\x00'

        cipher = AES.new(SECRET, AES.MODE_CBC)
        ct = cipher.encrypt(flag)
        iv = cipher.iv

        fd.write("cbc:" + iv.hex() + ":" + ct.hex())
"""
