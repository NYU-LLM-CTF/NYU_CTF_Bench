#!/usr/bin/sage
from sage.all import *
import random
import pickle
from secrets import FLAG, REQUIRED

class SS:
    def __init__(self, secret, n, k, prime=((2**127)-1)):
        self.secret = secret
        self.n = n
        self.k = k
        self.p = prime
        self.field = GF(prime)
        self.polynomial = None
        self.ring = self.field['x']
        self.generate_polynomial()
    
    def get_random_coeffs(self):
        return [self.secret] + [random.randint(1,self.secret+20) for i in range(self.k)]            
    
    def generate_polynomial(self):
        coeffs = self.get_random_coeffs()
        self.polynomial = self.ring(coeffs)
        return self.polynomial
    
    def create_shares(self):
        res = []
        for i in range(1, self.n+1):
            res.append((i, self.polynomial(x=i)))
        return res

def rederive(shares, fieldspace):
    field = GF(fieldspace)
    ring = field['x']
    fixed = []
    for x, y in shares:
        x_ = field(x)
        y_ = field(y)
        fixed.append((x_,y_))
    polynomial = ring.lagrange_polynomial(fixed)
    return polynomial


if __name__=="__main__":
    prime = 101109149181191199401409419449461491499601619641661691809811881911
    # flag = "flag{BigPrimes,BigNumbers}"
    flag = FLAG
    secret = Integer(flag.encode('hex'), 16)
    print(secret)
    s = SS(secret, 4000, REQUIRED, prime=prime)
    shares = s.create_shares()
    pickle.dump(shares, open('pshares','wb'))
    random.shuffle(shares)
    captured = rederive(shares[:240],prime) 
    found_secret = captured.list()[0]
    print(found_secret)
