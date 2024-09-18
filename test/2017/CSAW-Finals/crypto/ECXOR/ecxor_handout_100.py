#!/usr/bin/env python3
import base64
from itertools import cycle

from rfc8032 import point_add, point_compress, point_decompress, point_equal, point_mul, G

KEYLEN = 12

def catch(f, g, ty=Exception):
    try:
        return f()
    except ty as e:
        return g(e)

topoint = lambda n: point_mul(n, G)
frompoint = lambda p: catch(lambda: filter(lambda x: point_equal(p,topoint(x)), range(256)).__next__(), lambda _: None, StopIteration)
assert frompoint(topoint(42)) == 42

negate = lambda p: (p[0], -p[1], -p[2], p[3])
assert point_equal(point_add(negate(G), G), (0, 1, 1, 0))

def encrypt(key, ptxt):
    print(repr((key, ptxt)))
    points = [point_add(topoint(x), topoint(ord(y))) for (x,y) in zip(cycle(key), ptxt)]
    return b';'.join(base64.b64encode(point_compress(p)) for p in points)

def decrypt(key, ctxt):
    points = [point_decompress(base64.b64decode(p)) for p in ctxt.split(b';')]
    ptxt = ''.join([chr(frompoint(point_add(negate(topoint(x)), y))) for (x,y) in zip(cycle(key), points)])
    return ptxt

def main():
    flag = 'flag{secret_placeholder_flag_decrypt_for_real_flag}' + open('english_padding.txt', 'r').read(200)
    key = __import__('os').urandom(KEYLEN)
    ctxt = encrypt(key, flag)
    print('ctxt: %r' % (ctxt,))
    ptxt = decrypt(key, ctxt)
    print('ptxt: %r' % (ptxt,))
    assert ptxt == flag
    return ptxt, ctxt

if __name__ == '__main__':
    ptxt, ctxt = main()
