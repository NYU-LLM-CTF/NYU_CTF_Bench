#!/usr/bin/python2.7
# -*- coding: utf-8 -*-
from collections import Counter
from pwn import *
from libnum import *
import re
import time


context.log_level = 'error'
base_c = 0


def encrypt(num):
    recv_menu()
    r.sendline('1')
    r.recvuntil('input:')
    r.sendline(n2s(num))
    return int(r.recvline(), 16)


def decrypt(num):
    recv_menu()
    r.sendline('2')
    r.recvuntil('input:')
    r.sendline(n2s(num))
    return int(r.recvline(), 16)


def recv_menu():
    r.recvuntil('2. decrypt\n====================================\n')


def get_flagc(off, l):
    r.recvuntil('offset,len:')
    r.sendline('%d,%d' % (off, l))
    flag_c = int(r.recvline().split(':')[1].strip(), 16)
    return flag_c


def get_N():
    """
    --------
    4 rounds
    --------
    r1 = 2^e % N
    r2 = 3^e % N
    r3 = (2*2)^e % N
    r4 = (2*3)^e % N

    r1*r1 %N = r3
    r1*r2 %N = r4

    r1*r1 = r3 + k1*N
    r1*r2 = r4 + k2*N

    N = gcd(r1*r1-r3, r1*r2-r4)
    """
    global base_c
    r1 = encrypt(2)
    base_c = r1
    r2 = encrypt(3)
    r3 = encrypt(2*2)
    r4 = encrypt(2*3)

    N = gcd(r1*r1-r3, r1*r2-r4)
    while N % 2 == 0:
        N = N // 2
    while N % 3 == 0:
        N = N // 3
    while N % 5 == 0:
        N = N // 5
    while N % 7 == 0:
        N = N // 7

    return N

def crack(N, flag_c, MSB=1):
    global base_c

    flag_LSB = decrypt(flag_c)  # 1 round
    N_bits = len(bin(N)) - 2
    flag_bits = len(bin(s2n('flag{'.rjust(123, 'A'))))  # fake flag
    rnd = N_bits - flag_bits

    off_c = pow(base_c, rnd, N)
    res = decrypt(off_c * flag_c % N)  # 1 round

    for i in xrange(rnd, rnd + 10):
        off_c_nxt = pow(base_c, i+1, N)
        res_nxt = decrypt(off_c_nxt * flag_c % N)  # 1 ~ 2 rounds

        if res == 0 and res_nxt != 0:
            UB = 2**(i+1)
            LB = 2**i


            while abs(UB - LB) > 1:  # (39 ~ 40) * 2 rounds
                off = (UB + LB) / 2
                off_c = encrypt(off)
                res = decrypt(off_c * flag_c % N)
                if res == (flag_LSB * off) % N % 0x100:
                    LB = off
                else:
                    UB = off

            return n2s(N / LB)[:MSB]

        res = res_nxt


# get the len of the flag
def flag_len():
    r.close()
    for l in xrange(123, 1, -1):
        s = remote('lost_mind', 32333)
        s.recvuntil('offset,len')
        off = 0
        s.sendline('%d,%d' % (off, l))
        try:
            print s.recvline(timeout=2)
        except Exception:
            continue
        finally:
            s.close()

        return l+1


# flag is 43 bytes long
# print flag_len()
print '[+]the flag is %d bytes long' % 43
flag = ''
for i in xrange(0, 43):
    start_time = time.time()
    cracked_chars = []
    while True:
        r = remote('lost_mind', 32333)
        flag_c = get_flagc(i, 1)
        pattern = r'you got (\d*?) rounds to go'
        rounds = int(re.search(pattern, r.recvline()).group(1))
        # print '[!]we have %d rounds to win!' % rounds
        N = get_N()
        # print '[+]got N:', N
        try:
            char = crack(N, flag_c)
            if char is not None:
                cracked_chars.append(char)
        except Exception:
            continue
        finally:
            r.close()
        # more chars cracked_chars contains, higher chance to get the correct char
        # 10 is enough at some point
        if len(cracked_chars) == 10:
            print cracked_chars
            break

    counter = Counter(cracked_chars)
    flag += str(counter.most_common(1)[0][0])
    print 'cracked flag:', flag
    end_time = time.time()
    print 'round time:', end_time - start_time
