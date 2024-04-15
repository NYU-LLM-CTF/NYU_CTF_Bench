# Reference solution for "Control" in CSAW CTF Finals 2021
# Author: hgarrereyn

from z3 import *

V = 0
def srand(n):
    global V
    V = n
    
def rand():
    global V
    n = V
    n = ((n * 1103515245) + 12345) & 0x7fffffff
    V = n
    return n

def chunk_to_bits(chunk):
    b = []
    for c in chunk:
        for i in range(8):
            b.append((c >> i) & 1)
    return b

def bits_to_chunk(bits):
    c = []
    for i in range(8):
        v = 0
        for j in range(7,-1,-1):
            v <<= 1
            v += bits[(i*8)+j]
        c.append(v)
    return bytes(c)

def mutate(arr, seed):
    bits = [x for x in arr]
    srand(seed)
    for i in range(0x1337):
        a = rand() & 0x3f
        b = rand() & 0x3f
        bits[a], bits[b] = bits[b], bits[a]
        
    for i in range(0x1337):
        a = rand() & 0x3f
        bits[a] = Not(bits[a])
        
    return bits

def solve_chunk(enc_chunk, seed):
    init = [Bool('b%d' % x) for x in range(64)]
    mut = mutate(init, seed)

    s = Solver()

    bits = chunk_to_bits(enc_chunk)
    for i in range(64):
        s.add(mut[i] == bool(bits[i]))

    s.check()
    m = s.model()
    return bits_to_chunk([int(bool(m[v])) for v in init])

def solve():
    # Extracted from binary.
    enc = b'\x85\xf5\xdd\xa8\x01\xc8\x08\xba\xaa\xf8\xb8\xc1\x95J[\nL\xb1\x88\xc5\xf7\x990\x02\x92\xe8\x93\x9f\xdb\x0cZ\x81\x97\xfc\xf1\xae\xed1\x91\x9a'

    flag = b''
    
    for i in range(5):
        flag += solve_chunk(enc[(i*8):(i*8)+8], i)
    
    return flag

if __name__=='__main__':
    print(b'flag{%s}' % solve())
