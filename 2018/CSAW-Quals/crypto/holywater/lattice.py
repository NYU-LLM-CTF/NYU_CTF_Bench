from cryptography.fernet import Fernet
import random

rr = random.SystemRandom().randrange

class Lattice:
  def __init__(self,i0,i1,i2,i3,i4,i5,i6,i7):
    self.v0 = i0
    self.v1 = i1
    self.v2 = i2
    self.v3 = i3
    self.v4 = i4
    self.v5 = i5
    self.v6 = i6
    self.v7 = i7
    self.exp = 4294967279

  def __str__(self):
     return ("{:08x}".format(self.v0) +
             "{:08x}".format(self.v1) +
             "{:08x}".format(self.v2) +
             "{:08x}".format(self.v3) +
             "{:08x}".format(self.v4) +
             "{:08x}".format(self.v5) +
             "{:08x}".format(self.v6) +
             "{:08x}".format(self.v7))

  @classmethod
  def origin(cls):
    return cls(0,0,0,0,0,0,0,0)

  @classmethod
  def absolute(cls):
    return cls(1,0,0,0,0,0,0,0)

  @classmethod
  def random(cls):
    e = cls.origin().exp
    return cls(rr(e), rr(e), rr(e), rr(e), rr(e), rr(e), rr(e), rr(e))

  def wobble(self):
    isogeny = []
    for i in range(63, -1, -1):
      isogeny.append((rr(1, self.exp), i))
    return self.mix(isogeny)

  @classmethod
  def stochastic(cls):
    return cls.random().wobble()

  def __mod__(self, n):
    return Lattice(self.v0 % n, self.v1 % n, self.v2 % n, self.v3 % n,
                   self.v4 % n, self.v5 % n, self.v6 % n, self.v7 % n)

  def __add__(self, otro):
    return Lattice(self.v0 + otro.v0,
                   self.v1 + otro.v1,
                   self.v2 + otro.v2,
                   self.v3 + otro.v3,
                   self.v4 + otro.v4,
                   self.v5 + otro.v5,
                   self.v6 + otro.v6,
                   self.v7 + otro.v7) % self.exp

  def dilate(self, fact):
    return Lattice(self.v0 * fact,
                   self.v1 * fact,
                   self.v2 * fact,
                   self.v3 * fact,
                   self.v4 * fact,
                   self.v5 * fact,
                   self.v6 * fact,
                   self.v7 * fact) % self.exp

  def __mul__(self, otro):
    x = [self.v0, self.v1, self.v2, self.v3, self.v4, self.v5, self.v6, self.v7]
    y = [otro.v0, otro.v1, otro.v2, otro.v3, otro.v4, otro.v5, otro.v6, otro.v7]
    return Lattice (x[0] * y[0] - x[1] * y[1] - x[2] * y[2] - x[3] * y[3]
                  - x[4] * y[4] - x[5] * y[5] - x[6] * y[6] - x[7] * y[7],
                    x[0] * y[1] + x[1] * y[0] + x[2] * y[4] + x[3] * y[7]
                  - x[4] * y[2] + x[5] * y[6] - x[6] * y[5] - x[7] * y[3],
                    x[0] * y[2] - x[1] * y[4] + x[2] * y[0] + x[3] * y[5]
                  + x[4] * y[1] - x[5] * y[3] + x[6] * y[7] - x[7] * y[6],
                    x[0] * y[3] - x[1] * y[7] - x[2] * y[5] + x[3] * y[0]
                  + x[4] * y[6] + x[5] * y[2] - x[6] * y[4] + x[7] * y[1],
                    x[0] * y[4] + x[1] * y[2] - x[2] * y[1] - x[3] * y[6]
                  + x[4] * y[0] + x[5] * y[7] + x[6] * y[3] - x[7] * y[5],
                    x[0] * y[5] - x[1] * y[6] + x[2] * y[3] - x[3] * y[2]
                  - x[4] * y[7] + x[5] * y[0] + x[6] * y[1] + x[7] * y[4],
                    x[0] * y[6] + x[1] * y[5] - x[2] * y[7] + x[3] * y[4]
                  - x[4] * y[3] - x[5] * y[1] + x[6] * y[0] + x[7] * y[2],
                    x[0] * y[7] + x[1] * y[3] + x[2] * y[6] - x[3] * y[1]
                  + x[4] * y[5] - x[5] * y[4] - x[6] * y[2] + x[7] * y[0]) % self.exp

  def __pow__(self, expo):
    acc = Lattice.absolute()
    for i in range(0, expo):
      acc = acc * self
    return acc

  def __eq__(self, otro):
    return ([self.v0, self.v1, self.v2, self.v3, self.v4, self.v5, self.v6, self.v7]
         == [otro.v0, otro.v1, otro.v2, otro.v3, otro.v4, otro.v5, otro.v6, otro.v7])

  def mix(self, isogeny):
    acc = Lattice.origin()
    for i in range(0, len(isogeny) - 1):
      acc = acc + (self ** isogeny[i][1]).dilate(isogeny[i][0])
    return acc + Lattice.absolute().dilate(isogeny[-1][0])

class Whomst:
  def __init__(self, gaussian):
    self.group_order = 257
    noise = gaussian.wobble()
    self.alpha = noise ** rr(2, self.group_order)
    self.gamma = noise ** rr(2, self.group_order)

  def left(self, clown):
    return (self.alpha * clown) * self.gamma

  def right(self, joker):
    return self.alpha * (joker * self.gamma)

if __name__ == "__main__":
  gaussian = Lattice.random()
  poisson  = Lattice.random()

  alice = Whomst(gaussian)
  bob   = Whomst(gaussian)

  clown = alice.left(poisson)
  joker = bob.left(poisson)

  assert(alice.left(joker) == bob.right(clown))
  print gaussian, poisson, clown, joker

  f = Fernet(str(alice.left(joker)).decode('hex').encode('base64'))
  msg = f.encrypt(open('flag.txt').read())
  print msg
