from sage.all import *
from pwn import *
import json

## create  the corespending graph created in the challenge.py
coeffs = [0, 117050, 0, 1, 0]
p = 2**221 - 3
curve = EllipticCurve(GF(p), coeffs)

## connect to the remote socket
r = remote("localhost", 12312)

## wait until we got input to select commande
r.recvuntil("> ")
## select the flag commande that will crypt the flag and send the crypt result
r.sendline("flag")
## receive the crypted credentials
ciphers_json  = r.recvline()
## map from json to python array
ciphers = json.loads(ciphers_json)
## get the c point
c = ciphers[0]
## get the flag + pm point
flag_plus_pm = ciphers[1]
## select the sign commande
r.recvuntil("> ")
r.sendline("sign")
## send the coeffs array and the x , y of the c point
r.recvuntil(">> ")
ciphers_to_sign  = c[:-1]
ciphers_to_sign.insert(0 , coeffs)
r.sendline(json.dumps(ciphers_to_sign))


## receive the pm point x, y
pm_x , pm_y , _ = json.loads(r.recvline())
## creat points from the correspending x , y
pm_point = curve((pm_x , pm_y))
flag_plus_pm_point  = curve((flag_plus_pm[0] , flag_plus_pm[1]))
## get the flag point
flag_point  = flag_plus_pm_point - pm_point
## convert to hex and then to ascii
flag = hex(int(flag_point[0]))[2:].decode("hex")
## print it
print("flag{%s}" % flag)