#!/usr/bin/env sage
# vim: ft=python

# Copied out of our lib
def fix_pwn():
    """ Fix importing pwntools in a sage script, because ncurses

    Usage:
        fix_pwn()
        from pwn import *

    Alternatively, you can make a regular *.py script and run it with
    sage-python <name>.py
    """
    import os
    os.putenv('TERM', 'linux')
    os.putenv('TERMINFO', '/etc/terminfo')
fix_pwn()

from pwn import *
import subprocess as sp
import re
import os
from sage.all import *
from Crypto.Util.number import long_to_bytes

# sp.check_call('make')
s = remote('localhost', 12312)

KAX = '\x0A'
KBX = '\x0B'
KCX = '\x0C'
KDX = '\x0D'
KPC = '\x0E'
KRX = '\x0F'
KSP = '\x10'
DST = '\xDD'
HLT = '\xFE'
MOV = '\x88'
MOVI = '\x89'
MOVK = '\x91'
RDK = '\x92'
PUSH = '\xED'
POP = '\xB1'
ADD = '\xD3'
ADDI = '\xC6'
SUB = '\xD8'
SUBI = '\xEF'
MUL = '\x34'
DIV = '\xB9'
XOR = '\xB7'
CMP = '\xCC'
JMP = '\x96'
JE = '\x81'
JNE = '\x9E'
JG = '\x2F'
JGE = '\xF4'
JL = '\x69'
JLE = '\x5F'
# LDF = '\xD9'
ACB = '\xC4'
ACR = '\xC5'

AGE = '\x9B'
AGD = '\x7F'
# RSC = '\x42\x3f'  # Undocumented instruction you find from RE'ing

iv = os.urandom(12)
print(iv.encode('hex'))
# print long_to_bytes(iv).encode('hex')


payload = ''.join([
    ACB,
    # DST,

    PUSH, KCX,
    PUSH, KAX,
    PUSH, KAX,
    PUSH, KAX,
    MOVI, KAX, p64(0x8),
    AGE, KAX,
    DST,
    # Get encrypted challenge (first 8 bytes of KRX)
    # also all of KRX as C1

    POP, KRX,
    DST,
    # Get T1

    # Clear KRX
    PUSH, KBX,
    POP, KRX,

    # Load a second msg to get a tag for
    MOVI, KAX, p64(0x10),
    MOVI, KBX, p64(0x4141414141414141),
    PUSH, KBX,
    PUSH, KBX,
    PUSH, KBX,
    PUSH, KBX,
    AGE, KAX,
    DST,

    # Get second tag T2
    POP, KRX,
    DST,

    RDK, chr(32),
    ACR,

    # Assuming we authenticated successfully
    # Use a read primitive to pull data from the trust zone
    MOVI, KAX, p64(0x4000),
    AGE, KAX,
    AGD,
    DST,
])

s.send(payload)


def get_krx():
    data = s.readuntil('TVM RUNNING')
    # print data
    krx = re.search(r'KRX: \[([^\]]+)\]', data).group(int(1))
    return krx.replace(' ', '').decode('hex')

c1 = get_krx()
t1 = get_krx()[16:]
c2 = get_krx()
t2 = get_krx()[16:]

# We used the blank KRX to begin with, so the IV is zero'd
iv = '\0' * 12
ctxt = c1[:8]

print(c1.encode('hex'))
print(t1.encode('hex'))
print(c2.encode('hex'))
print(t2.encode('hex'))

# Some functions copied/modified from https://gist.github.com/rugo/c158f595653a469c6461e26a60b787bb
def split_blocks(b_str, bsize=16):
    b_str += "\x00" * (len(b_str) % bsize)
    return [bytearray(b_str[k:k+bsize]) for k in range(0, len(b_str), bsize)]

def xor(a, b):
    assert(len(a) == len(b))
    return bytearray([a[i] ^^ b[i] for i in range((len(a)))])

def byte_to_bin(byte):
    b = bin(byte)[2:]
    return "0" * (8 - len(b)) + b

def block_to_bin(block):
    assert(len(block) == 16)
    b = ""
    for byte in block:
        b += byte_to_bin(byte)
    return b

def bytes_to_poly(block, a):
    f = 0
    for e, bit in enumerate(block_to_bin(block)):
        f += int(bit) * a**e
    return f

def poly_to_int(poly):
    a = 0
    for i, bit in enumerate(poly._vector_()):
        a |= int(bit) << (127 - i)
    return a

# Ciphertexts are 2 blocks, tags are 1 block
c1 = split_blocks(c1)
t1 = split_blocks(t1)[0]
c2 = split_blocks(c2)
t2 = split_blocks(t2)[0]

# No AAD, so just pad to 128 bits
c_len = 32 * 8
L = bytearray(long_to_bytes(c_len).rjust(16, '\0'))

T = xor(t1, t2)
C = [xor(a,b) for a,b in zip(c1,c2)]

F, a = GF(2**128, name="a").objgen()
R, X = PolynomialRing(F, name="X").objgen()

C_p = [bytes_to_poly(blk, a) for blk in C]
T_p = bytes_to_poly(T, a)

L_p = bytes_to_poly(L, a)
C1_p = [bytes_to_poly(blk, a) for blk in c1]
T1_p = bytes_to_poly(t1, a)
C2_p = [bytes_to_poly(blk, a) for blk in c2]
T2_p = bytes_to_poly(t2, a)

# f1 = C1_p[0] * X**3 + C1_p[1] * X**2 + L_p * X + T1_p
f1 = C1_p[0] * X**3 + C1_p[1] * X**2 + L_p * X
f2 = C2_p[0] * X**3 + C2_p[1] * X**2 + L_p * X
p = C_p[0] * X**3 + C_p[1] * X**2 + T_p

EJs = []
for root, _ in p.roots():
    # Compute EJ using C1
    EJ = f1(root) + T1_p

    # Try to compute a tag for C2 as a test
    guess_T2 = f2(root) + EJ
    if guess_T2 == T2_p:
        H = root
        break

# Set up the poly for computing the challenge tag
c_len = 8 * 8
L = bytearray(long_to_bytes(c_len).rjust(16, '\0'))
L_p = bytes_to_poly(L, a)

ctxt_p = bytes_to_poly(split_blocks(ctxt)[0], a)
f_ctxt = ctxt_p * X**2 + L_p * X + EJ

tag_p = f_ctxt(H)
tag = long_to_bytes(poly_to_int(tag_p))
print tag.encode('hex')
resp = iv + ctxt + tag[:12]
s.send(resp)

# Get the flag
print get_krx()
