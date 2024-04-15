from pwn import *

seed1 = (72454, 35, 0, 16)
seed2 = (783047, 91, 1, 50)


def xor(x, y):
    return "".join([chr(ord(x[idx]) ^ ord(y[idx])) for idx in range(len(x))])


def crack(seed):
    p = remote("pwn.chal.csaw.io", 1002)
    p.sendafter("seed\n", "%16d" % (seed[0]))
    p.recvuntil(":\n")

    results = []
    for _ in range(100):
        results.append(p.recv(48))
        p.recvline()

    known = results[seed[3]][:16]
    known_text = "Encrypted Flag: "
    crack = results[seed[1]][seed[2] * 16 + 16 : seed[2] * 16 + 32]

    ciphered = xor(known, known_text)
    return xor(ciphered, crack)


flag = crack(seed1) + crack(seed2)
print(flag)
