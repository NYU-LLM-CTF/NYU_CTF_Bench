import binascii
from pwn import *

# [STATIC FIELD AND POLYNOMIAL RING FROM CHALLENGE FILE]
p_ = 83297968285319659068199479277537600821638173621636418555341
K = GF(p_)
R = PolynomialRing(K,2,'x',order='degrevlex')
R.inject_variables()

# [CONNECT TO SERVER]
host = "crypto.chal.csaw.io"
port = 5002         # 6000
server = remote(host, port)

# [GET GROEBNER BASIS]
server.recvuntil("> ")
gb_ = server.recvline()[:-1]
gb = sage_eval(gb_.decode('utf-8'), locals=globals())

# [GET CIPERTEXTS]
server.recvuntil("> ")
c0_ = server.recvline()[:-1]
c0 = sage_eval(c0_.decode('utf-8'), locals=globals())

server.recvuntil("> ")
c1_ = server.recvline()[:-1]
c1 = sage_eval(c1_.decode('utf-8'), locals=globals())

server.recvuntil("> ")
c2_ = server.recvline()[:-1]
c2 = sage_eval(c2_.decode('utf-8'), locals=globals())

# [DECRYPT USING HOMOMORPHIC PROPERTIES]
int_dec = ((c0 + c1 + c2 - 123)/999).reduce(gb)
print(int_dec)
print(binascii.unhexlify(hex(int(int_dec))[2:]))


server.close()