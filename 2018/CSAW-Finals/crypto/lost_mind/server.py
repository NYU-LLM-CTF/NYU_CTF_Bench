#!/usr/bin/env python
import SocketServer
from Crypto.Util.number import getRandomInteger, GCD, inverse, getPrime
from Crypto.Util.number import bytes_to_long, long_to_bytes
import signal
import os


class RSA(object):
    def __init__(self):
        pass

    def generate(self, p, q):
        self.p = p
        self.q = q
        self.N = p * q
        phi = (p-1) * (q-1)
        while True:
            e = getRandomInteger(40)
            if GCD(e, phi) == 1:
                self.e = e
                self.d = inverse(e, phi)
                return

    def encrypt(self, p):
        return pow(p, self.e, self.N)

    def decrypt(self, c):
        return pow(c, self.d, self.N)


def get_flag(off, l):
    flag = open('flag', 'r').read().strip()

    init_round = 48
    t_l = 123

    if off + l > len(flag):
        exit(1)
    if off < 0 or l < 1:
        exit(1)

    round = init_round + len(flag) - l
    flag = flag[off:off+l] + os.urandom(t_l - l)

    return flag, round


def go(req):
    r = RSA()
    p = getPrime(512)
    q = getPrime(512)
    r.generate(p, q)

    req.sendall('offset,len:')
    try:
        off, l = map(int, req.recv(10).strip().split(',')[:2])
    except Exception:
        exit(1)

    flag, rounds = get_flag(off, l)

    def enc_flag():
        req.sendall('encrypted flag: %x\n' % r.encrypt(bytes_to_long(flag)))

    def enc_msg():
        req.sendall('input:')
        p = req.recv(4096).strip()
        req.sendall('%x\n' % r.encrypt(bytes_to_long(p)))

    def dec_msg():
        req.sendall('input:')
        c = req.recv(4096).strip()
        try:
            req.sendall('%x\n' % (r.decrypt(bytes_to_long(c))&0xff))
        except Exception:
            exit(1)

    menu = {
        '1': enc_msg,
        '2': dec_msg,
    }

    enc_flag()
    req.sendall('you got %d rounds to go\n' % rounds)
    for _ in xrange(rounds):
        req.sendall((
            '====================================\n'
            '1. encrypt\n'
            '2. decrypt\n'
            '====================================\n'
        ))

        choice = req.recv(2).strip()
        if choice not in menu:
            exit(1)

        menu[choice]()


class incoming(SocketServer.BaseRequestHandler):
    def handle(self):
        signal.alarm(300)
        req = self.request
        go(req)


class ReusableTCPServer(SocketServer.ForkingMixIn, SocketServer.TCPServer):
    pass


SocketServer.TCPServer.allow_reuse_address = True
server = ReusableTCPServer(("0.0.0.0", 32333), incoming)
server.serve_forever()
