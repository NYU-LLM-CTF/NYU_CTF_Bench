#!/usr/bin/env python3
import base64
import binascii
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
    flag = 'flag{placeholder}english padding to make the the the the the statistics easier'
    key = __import__('os').urandom(KEYLEN)
    ctxt = encrypt(key, flag)
    print('ctxt: %r' % (ctxt,))
    ptxt = decrypt(key, ctxt)
    print('ptxt: %r' % (ptxt,))
    assert ptxt == flag
    return ptxt, ctxt

def longestcontiguousascii(s, f=lambda x:x):
    '''
    >>> longestcontiguousascii("AA\0a")
    2
    >>> longestcontiguousascii("AA\0aaa")
    3
    >>> longestcontiguousascii("A"*5)
    5
    >>> longestcontiguousascii([None, 'a', 'b', None, 'c'])
    2
    '''
    streak = 0
    tmp = 0
    while len(s) > 0:
        if s[0] and f(' ') <= s[0] <= f('~'):
            tmp += 1
            streak = max(streak, tmp)
        else:
            tmp = 0
        s = s[1:]
    return streak

def solve(ctxt, ngrams):
    #score = longestcontiguousascii
    # TODO: better heuristics than longestcontiguousascii (e.g. ngrams)
    score = lambda s: sum(ngrams[1].get(''.join(a).encode('utf8'), 0) for a in zip(s,s[1:]) if a[0] and a[1])
    minus = lambda a, b: [point_add(x, negate(y)) for (x,y) in zip(a,b)]
    points = [point_decompress(base64.b64decode(p)) for p in ctxt.split(b';')]
    guessptxt = 'flag{'+'\0'*(KEYLEN-5)
    best = 0, None
    for i in range(5, KEYLEN):
        print('i: %r' % (i,))
        for j in range(ord(' '), ord('~')):
            print('\tj: %r' % (j,))
            tmp = list(guessptxt)
            tmp[i] = chr(j)
            tmp = [topoint(ord(c)) for c in tmp]
            keyguess = minus(points, tmp)
            testresult = [frompoint(x) for x in minus(points, cycle(keyguess))]
            testresult = [chr(x) if x else None for x in testresult]
            value = score(testresult)
            #testresult = minus(points, keyguess)
            #value = longestcontiguousascii(testresult, f=lambda x: topoint(ord(x)))
            if value > best[0]:
                print('NEW BEST: %r' % ((value, testresult),))
                best = value, (keyguess, testresult)
            else:
                print(value, testresult)
        guessptxt = ''.join([c if c else '\0' for c in best[1][1][:KEYLEN]])
        print('BEST AFTER ITERATION %d: %r' % (i, (guessptxt, best[1][1]),))
        
    return best[1]

if __name__ == '__main__':
    ptxt, ctxt = main()
    with open('sherlock.ngrams', 'r') as f:
        ngrams = __import__('ast').literal_eval(f.read())
        ngrams = [{binascii.unhexlify(k): v for (k,v) in d.items()} for d in ngrams]
    #print('%r' % (ngrams,))
    result = solve(ctxt, ngrams)
    print(result)
