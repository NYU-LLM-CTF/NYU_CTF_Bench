import random
from Crypto.PublicKey.RSA import *
from base64 import b64encode

with open("flag.txt", "r") as FILE:
    flag = FILE.read().strip()
    
assert len(flag) == 64

secret = [ord(i) for i in flag]
rsaobj = generate(1536, e=3)

def find_invpow(x,n):
    high = 1
    while high ** n <= x:
        high *= 2
    low = high//2
    while low < high:
        mid = (low + high) // 2
        if low < mid and mid**n < x:
            low = mid
        elif high > mid and mid**n > x:
            high = mid
        else:
            return mid
    return mid + 1


key = 0
while len(hex(key)) != 130:
    lb = find_invpow(rsaobj.n, 3)
    ub = find_invpow(rsaobj.n * 2, 3)

    key = random.randint(lb, ub)
    encrypted_key = pow(key, 3, rsaobj.n)

    result = []

key = [int(x) for x in bytearray.fromhex(hex(key)[2:])]
C = bytes([c ^ k for c, k in zip(secret, key)])

with open("file.enc", "wb") as FILE:
    FILE.write(b64encode(C))

with open("key.enc", "w") as FILE:
    FILE.write(str(encrypted_key))

pubkey = rsaobj.publickey().exportKey('PEM')

with open('pubkey.pem', 'wb') as f:
  f.write(pubkey)
