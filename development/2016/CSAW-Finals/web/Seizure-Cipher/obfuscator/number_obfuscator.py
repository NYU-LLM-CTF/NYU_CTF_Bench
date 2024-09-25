import random
import math

class Operation(object):
    def __init__(self, n):
        self.n = n

class Division(Operation):
    def canDo(self):
        return self.n > 1
    def make(self, depth):
        self.r = random.randint(0, 300) + 70
        self.l = self.r * self.n
        assert int(self.l / self.r) == self.n, "Incorrect division"

        self.l = make_expression(self.l, depth - 1)
        self.r = make_expression(self.r, depth - 1)
        return self
    def __str__(self):
        return "(%s / %s)" %(self.l, self.r)

class SquareRoot(Operation):
    def canDo(self):
        return self.n < 10000 and self.n > 1
    def make(self, depth):
        self.s = pow(self.n, 2)
        assert int(math.sqrt(self.s)) == self.n, "Incorrect sqrt"

        self.s = make_expression(self.s, depth-1)
        return self
    def __str__(self):
        return "Math.sqrt(%s)" %(self.s)

class Addition(Operation):
    def canDo(self):
        return self.n > 2
    def make(self, depth):
        self.l = random.randint(0, self.n - 1) + 1
        self.r = self.n - self.l
        assert self.l + self.r == self.n, "Incorrect addition"

        self.l = make_expression(self.l, depth - 1)
        self.r = make_expression(self.r, depth - 1)
        return self
    def __str__(self):
        return "(%s + %s)" %(self.l, self.r)

class Subtraction(Operation):
    def canDo(self):
        return self.n > 0
    def make(self, depth):
        self.l = self.n + random.randint(0, 2 * self.n) + 3
        self.r = self.l - self.n
        assert self.l - self.r == self.n, "Incorrect subtraction"

        self.l = make_expression(self.l, depth - 1)
        self.r = make_expression(self.r, depth - 1)
        return self
    def __str__(self):
        return "(%s - %s)" %(self.l, self.r)

# Sorry I'm not feeling the factoring for multiplication
operations = [Division, SquareRoot, Addition, Subtraction]

def make_expression(n, depth):
    """ Where the magic happens"""
    if depth <= 0:
        return n
    candidates = [operation(n) for operation in operations]
    candidates = list(filter(lambda i: i.canDo(), candidates))
    if len(candidates) <= 0:
        return n

    return random.choice(candidates).make(depth - 1)
