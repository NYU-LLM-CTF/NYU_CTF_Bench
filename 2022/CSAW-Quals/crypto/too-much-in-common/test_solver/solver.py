from sage.all_cmdline import *
from pwn import *
import sympy as sp

def common_modulus_attack(server):
    server.recvuntil(b"> ")
    server.sendline(b"1")
    server.recvuntil(b"N = ")
    N = server.readline()[:-1]
    # print(N)
    server.recvuntil(b"e = ")
    e1 = server.readline()[:-1]
    # print(e1)
    server.recvuntil(b"c = ")
    c1 = server.readline()[:-1]
    # print(c1)

    N2 = ""
    while N2 != N:
        server.recvuntil(b"> ")
        server.sendline(b"1")
        server.recvuntil(b"N = ")
        N2 = server.readline()[:-1]
        # print(N2)
        server.recvuntil(b"e = ")
        e2 = server.readline()[:-1]
        # print(e2)
        server.recvuntil(b"c = ")
        c2 = server.readline()[:-1]
        # print(c2)

    print("Found matching N")
    N = Integer(int(N))
    e1 = Integer(int(e1))
    c1 = Integer(int(c1))
    e2 = Integer(int(e2))
    c2 = Integer(int(c2))

    g, a, b = xgcd(e1, e2)

    if a < 0:
        temp = pow(c1, -1)
        m1 = power_mod(temp, -a, N)
    else:
        m1 = power_mod(c1, a, N)
    if b < 0:
        temp = pow(c2, -1)
        m2 = power_mod(temp, -b, N)
    else:
        m2 = power_mod(c2, b, N)

    res = mod(m1 * m2, N)
    print("Res", res)
    resstr = int.to_bytes(int(res), byteorder="big", length=32)
    print("Common", resstr)
    server.recvuntil(b"> ")
    server.sendline(b"2 " + resstr)

    phi_attack(server)

def phi_attack(server):
    server.recvuntil(b"N = ")
    N = server.readline()[:-1]
    server.recvuntil(b"e = ")
    e = server.readline()[:-1]
    server.recvuntil(b"d = ")
    d = server.readline()[:-1]

    N = Integer(int(N))
    e = Integer(int(e))
    d = Integer(int(d))

    k = ceil(e*d/N)
    paq = (k*N - e*d +k +1)/k
    pmq = sqrt(pow(paq,2) - 4*N)

    p, q = sp.symbols('p, q')
    eq1 = p + q
    eq2 = p - q
    phi_var = sp.solve([eq1 - paq, eq2 - pmq], (p, q))
    phi = (phi_var[p] -1) * (phi_var[q]-1)
    print("Phi", phi)
    server.recvuntil(b"> ")
    server.sendline(b"2 " + str(phi).encode("utf-8"))
    print(server.recvall().decode("utf-8"))

if __name__ == "__main__":
    server = remote("crypto.chal.csaw.io", 5000)
    common_modulus_attack(server)
