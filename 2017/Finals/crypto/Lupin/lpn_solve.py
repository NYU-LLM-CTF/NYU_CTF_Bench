from pwn import *
import ast
import numpy as np
import sys

''' BEGIN COPYPASTE FROM HANDOUT '''
product = lambda xs: reduce(lambda a, b: a*b, xs, 1)
unpack = lambda s: list(__import__('itertools').chain(*[[1&(ord(c)>>i) for i in range(8)] for c in s]))
pack = lambda x: (lambda t: ''.join(chr(sum(t[8*i:8*i+8])) for i in range(len(t)/8)))([(b<<(i%8)) for i,b in enumerate(x)])
serialize_mat = lambda X: '%s;%s' % (','.join(str(i) for i in X.shape), pack(X.reshape((product(X.shape),))).encode('base64'))
deserialize_mat = lambda s: (lambda (dims,data): np.array(unpack(data.decode('base64'))).reshape(map(int,dims.split(','))))(s.split(';'))
''' END COPYPASTE FROM HANDOUT '''

def solution():
    flag = None
    i = 0
    while not flag:
        i += 1
        print('Attempt %d' % (i,))
        data = remote('localhost', 8116).recvall()
        A, B, u, c = [deserialize_mat(ast.literal_eval(s.split(': ')[1])) for s in data.split('\n')[:4]]
        tmp = pack(c)
        print('Got %r' % (tmp,))
        if 'flag' in tmp:
            flag = tmp

    print('Flag: %s' % (flag,))

if __name__ == '__main__':
    solution()
