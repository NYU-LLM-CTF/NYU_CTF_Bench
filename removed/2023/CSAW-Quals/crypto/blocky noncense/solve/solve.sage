from hashlib import sha1
from Crypto.Util.number import *
from pwn import *

def hash(msg):
	return bytes_to_long(sha1(msg).digest())

r = process(["sage","chall.sage"])

for i in range(5):
	r.recvuntil(b": ")
	r.sendline(b"1")
	r.recvuntil(b"Enter (hex) string here: ")
	r.sendline(b"0" + str(i).encode())

r.recvuntil(b": ")
r.sendline(b"2")

rs = []
ss = []
hashes = []
for i in range(6):
	r.recvuntil(b"Message ")
	msg_hash = bytes.fromhex(r.recvline().strip().decode())
	r.recvuntil(b"Signature ")
	rs_, ss_ = list(map(int, r.recvline().strip()[1:-1].split(b", ")))
	rs.append(rs_)
	ss.append(ss_)
	hashes.append(msg_hash)

h0 = int(hashes[0].hex(), 16)
h1 = hash(hashes[0] + b"\x00")
h2 = hash(hashes[1] + b"\x01")
h3 = hash(hashes[2] + b"\x02")
h4 = hash(hashes[3] + b"\x03")
h5 = hash(hashes[4] + b"\x04")
hs = [h0,h1,h2,h3,h4,h5]

Field = GF(115792089237316195423570985008687907852837564279074904382605163141518161494337)
R.<d> = PolynomialRing(Field)

N = 6

def kpoly(i, j):
	hi = Field(hs[i])
	hj = Field(hs[j])
	si = Field(ss[i])
	sj = Field(ss[j])
	ri = Field(rs[i])
	rj = Field(rs[j])
	poly = d*(ri*si^-1 - rj*sj^-1) + hi*si^-1 - hj*sj^-1
	return poly

poly = ((kpoly(1,2)^2 - kpoly(2,3)*kpoly(0,1))*kpoly(1,3)*kpoly(2,3) - (kpoly(2,3)^2 - kpoly(3,4)*kpoly(1,2))*kpoly(0,1)*kpoly(0,2))*kpoly(1,4)*kpoly(2,4)*kpoly(3,4) - ((kpoly(2,3)^2 - kpoly(3,4)*kpoly(1,2))*kpoly(2,4)*kpoly(3,4) - (kpoly(3,4)^2 - kpoly(4,5)*kpoly(2,3))*kpoly(1,2)*kpoly(1,3))*kpoly(0,1)*kpoly(0,2)*kpoly(0,3)
roots = poly.roots()

ans = []
for i in roots:
	ans.append(i[0])

r.recvuntil(b": ")
r.sendline(b"4")
r.recvuntil(b"Private Key: ")
r.sendline(str(ans[0]).encode())
print(r.recvline())




