from sage.all import *
import json

from secret import flag

class Magic:
    def __init__(self):
        self.coeffs = [0, 117050, 0, 1, 0]
        self.p = 2**221 - 3

        self.E = EllipticCurve(GF(self.p), self.coeffs)
        self.P = self.E.random_point()
        self.priv = random_prime(self.p)
        self.pub = self.P * self.priv
        
    def sign(self, d):
        try:
            coeffs, x, y = json.loads(d)
            curve = EllipticCurve(GF(self.p), coeffs)
            point = self.priv * curve((x,y))
            return json.dumps([int(i) for i in point])
        except:
            return "[]"

    def flag(self):
        return self.encrypt(flag)

    def encrypt(self, msg):
        try:
            msg = Integer(msg.encode('hex'), 16)
            k = random_prime(self.p)
            c = self.P * k
            cp = self.pub * k
            pm = self.E.lift_x(msg)
            return json.dumps([[int(i) for i in c], [int(i) for i in (cp + pm)]])
        except:
            return "[]"



if __name__ == "__main__":
    idk = Magic()
    for _ in xrange(25):
        choice = raw_input('> ').strip()
        if choice == 'sign':
            data = raw_input('>> ').strip()
            print idk.sign(data)
        elif choice == 'encrypt':
            data = raw_input('>> ').strip()
            if 3 <= len(data) <= 16:
                print idk.encrypt(data)
        elif choice == 'flag':
            print idk.flag()
        else:
            break

