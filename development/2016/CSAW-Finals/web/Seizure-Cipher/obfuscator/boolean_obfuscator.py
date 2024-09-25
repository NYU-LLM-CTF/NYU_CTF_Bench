#!/bin/python
import random

class Not(object):
    def __init__(self, b):
        self.b = not b
        assert not self.b == b, "Incorrect not" 
    def __str__(self):
        return "!(%s)" %(str(self.b))
    def make(self, depth):
        self.b = make_expression(self.b, depth - 1)
        return self

class Or(object):
    def __init__(self, b):
        self.l = b
        if b:
            self.r = random.choice([True, False])
        else:
            self.r = False
        assert self.l or self.r == b, "Incorrect or"

    def __str__(self):
        return "(%s || %s)" %(self.l, self.r)
    def make(self, depth):
        self.l = make_expression(self.l, depth - 1)
        self.r = make_expression(self.r, depth - 1)
        return self

class And(object):
    def __init__(self, b):
        self.l = b
        if b:
            self.r = True
        else:
            self.r = random.choice([True, False])

        assert (self.l and self.r) == b, "Incorrect and"
    def __str__(self):
        return "(%s && %s)" %(self.l, self.r)
    def make(self, depth):
        self.l = make_expression(self.l, depth - 1)
        self.r = make_expression(self.r, depth - 1)
        return self

class Xor(object):
    def __init__(self, b):
        self.l = random.choice([True, False])
        if b:
            self.r = not self.l
        else:
            self.r = self.l
        assert bool(self.l ^ self.r) == b, "Incorrect xor"
    def __str__(self):
        return "(%s ^ %s)" %(self.l, self.r)
    def make(self, depth):
        self.l = make_expression(self.l, depth - 1)
        self.r = make_expression(self.r, depth - 1)
        return self

operations = [Not, Xor, Or, And]

def make_expression(n, depth):
    """ Where the magic happens"""
    if depth <= 0:
        return str(n).lower()
    candidates = [operation(n) for operation in operations]
    if len(candidates) <= 0:
        return n

    return random.choice(candidates).make(depth - 1)
