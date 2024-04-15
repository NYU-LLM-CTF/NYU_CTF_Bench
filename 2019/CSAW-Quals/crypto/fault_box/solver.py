from pwn import *
from libnum import *
import gmpy2
import re

"""
1) use fault enryption to factor N
2) calc the generated random number for p and q
3) predict the nth pair of (p, q), and decrypt the flag
"""

# r = remote('localhost', 1234)
r = remote("crypto.chal.csaw.io", 1001)

def gen_prime(base):
    off = 0
    while True:
        if gmpy2.is_prime(base+off):
            break
        off += 1
    p = base + off
    return p

def recv_menu():
    r.recvuntil('4. encrypt\n====================================\n')


def recv_flag_c():
    recv_menu()
    r.sendline('1')
    flag_c = r.recvline().strip()
    return flag_c


def send_enc(data):
    recv_menu()
    r.sendline('4')
    r.recvuntil('input the data:')
    r.sendline(data)

    return int(r.recvline().strip(), 16)


class RSA(object):
    def __init__(self):
        pass

    def generate(self, p, q, e=0x10001):
        self.p = p
        self.q = q
        self.N = p * q
        self.e = e
        phi = (p-1) * (q-1)
        self.d = invmod(e, phi)

    def encrypt(self, p):
        return pow(p, self.e, self.N)

    def decrypt(self, c):
        return pow(c, self.d, self.N)

    def TEST_CRT_encrypt(self, p, fault=0):
        ep = invmod(self.d, self.p-1)
        eq = invmod(self.d, self.q-1)
        qinv = invmod(self.q, self.p)
        c1 = pow(p, ep, self.p)
        c2 = pow(p, eq, self.q) ^ fault
        h = (qinv * (c1 - c2)) % self.p
        c = c2 + h*self.q
        return c

    def TEST_CRT_decrypt(self, c, fault=0):
        dp = invmod(self.e, self.p-1)
        dq = invmod(self.e, self.q-1)
        qinv = invmod(self.q, self.p)
        m1 = pow(c, dp, self.p)
        m2 = pow(c, dq, self.q) ^ fault
        h = (qinv * (m1 - m2)) % self.p
        m = m2 + h*self.q
        return m


def calc_N():
    """
    get N's value

    r1 = m1 ^ e mod N
    r2 = m2 ^ e mod N

    m1^e - r1 = k1*N
    m2^e - r2 = k2*N
    """
    e = 0x10001
    m1 = 0x2
    m2 = 0x3

    r1 = send_enc(n2s(m1))
    r2 = send_enc(n2s(m2))

    N = gcd(m1**e - r1, m2**e - r2)
    while N % 2 == 0:
        N = N // 2
    while N % 3 == 0:
        N = N // 3
    while N % 5 == 0:
        N = N // 5
    while N % 7 == 0:
        N = N // 7

    return N


def crack_pq():
    """
    returns the orignal bits
    """
    N = calc_N()

    recv_menu()
    r.sendline('2')
    fake_flag = int(r.recvline().strip(), 16)

    recv_menu()
    r.sendline('3')
    fake_flag_ = int(r.recvline().strip(), 16)

    p = gcd(abs(fake_flag - fake_flag_), N)
    q = N // p

    rr = RSA()
    rr.generate(p, q)
    fake_flag_p = rr.decrypt(fake_flag)

    print('decrypted fake flag:', n2s(fake_flag_p))
    q_off = re.search(r'fake_flag\{(.*?)\}', n2s(fake_flag_p)).group(1)
    q_off = int(q_off, 16)

    for i in range(0x1000):
        fault_c = rr.TEST_CRT_encrypt(fake_flag_p, i)
        if fault_c == fake_flag_:
            p_off = i
            break

    p_rand = p - p_off
    q_rand = q - q_off

    return p_rand, q_rand

def crack_rand(rand_num, cracker, bits=1024):
    """
    rand_num 1024 bits
    """
    for i in xrange(bits//(8*4)):
        cracker.submit((rand_num >> 32*i) & 0xFFFFFFFF)


def crack():
    # gather 624 * 32 bits
    from randcrack import RandCrack
    rc = RandCrack()

    # 19.5 * 1024 == 624 * 32
    # means 10 rounds is enough to predict
    for i in xrange(10):
        p_rand, q_rand = crack_pq()
        if i == 9:
            # enough bits
            crack_rand(p_rand, rc)
            crack_rand(q_rand, rc, 512)

            print('predicted high bits of q:\n %X' % (rc.predict_getrandbits(512)))
            print('received q:\n %X' % (q_rand))
            break

        crack_rand(p_rand, rc)
        crack_rand(q_rand, rc)

    p_base = rc.predict_getrandbits(1024)
    q_base = rc.predict_getrandbits(1024)

    p = gen_prime(p_base)
    q = gen_prime(q_base)

    return p, q


def solve():
    p, q = crack()
    k = RSA()
    k.generate(p, q)
    flag_c = int(recv_flag_c(), 16)
    flag = n2s(k.decrypt(flag_c))
    print( 'got the flag: ', flag)

# go
solve()
