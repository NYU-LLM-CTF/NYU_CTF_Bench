from base64 import b64decode
from Crypto.PublicKey.RSA import *

def find_invpow(x,n):
    """Finds the integer component of the n'th root of x,
    an integer such that y ** n <= x < (y + 1) ** n.
    """
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

ciphertext = 'm3q5z7SK3JarnzF06ZR4vRUIIWEOghmd/e8lDTP+u5EDm2WTCgmNjkYU8bNXAzMQCaIAhyZgaUa4vf+igGqSLg=='
with open("file.enc", "r") as FILE:
    ciphertext = b64decode(FILE.read())

print(ciphertext)

with open("key.enc", "r") as FILE:
    key = int(FILE.read())


rsaobj = None
with open('pubkey.pem', 'rb') as f:
  rsaobj = importKey(f.read())

N = rsaobj.n 
s = find_invpow(key + N, 3) 
ctext = list(map(ord, ciphertext)) 
key = [int(x) for x in bytearray.fromhex(hex(s)[2:130])] 
C = [c ^ k for c, k in zip(ctext, key)]

print("".join(chr(i) for i in C))

