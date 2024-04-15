#!/usr/bin/env python3
import string
import dataclasses
import typing as t

chars = list(" " + string.ascii_lowercase)

@dataclasses.dataclass
class E:
    row: int
    col: int
    val: int


@dataclasses.dataclass
class M:
    rows: int
    cols: int
    m: t.List[E] = dataclasses.field(default_factory = lambda : [])

    def populate(self, arr):
        self.m = [E(i, j, arr[self.cols * i + j])
            for i in range(self.rows) for j in range(self.cols)
            if (self.cols * i + j < len(arr))
        ]

    def mul(self, other):
        if self.cols != other.rows:
            raise Exception()

        row, col = self.rows, other.cols
        new = M(row, col)
        new.m = [
            self.elem_mul(other, i, j)
            for i in range(new.rows) for j in range(new.cols)
        ]
        return new

    def elem_mul(self, other, row, col):
        e = E(row, col, 0)
        s = 0
        for i in range(self.cols):
            s += self.m[self.cols * row + i].val * other.m[other.cols * i + col].val
        e.val = s
        return e


class Enc:
    def __init__(self, enc, m):
        self.enc = enc
        self.s = enc.rows
        self.m = [
            idx
            for c in m for idx in range(len(chars))
            if c == chars[idx]
        ]

    def encrypt(self):
        c = int(len(self.m) / self.s)
        encm = []
        for i in range(c):
            mc = self.m[i * self.s: (i * self.s) + self.s]
            mx = M(3, 1)
            mx.populate(mc)
            enc_mx = self.enc.mul(mx)
            for e in enc_mx.m:
                encm += [e.val]

        if (len(self.m) % 3 > 0):
            mc = self.m[c * self.s: (c * self.s) + self.s]
            for i in range(3 - len(mc)):
                mc.append(-1)
            mx = M(3, 1)
            mx.populate(mc)
            enc_mx = self.enc.mul(mx)
            for e in enc_mx.m:
                encm += [e.val]

        return encm


"""
ecm = M(3, 3)

# i seem to have lost some ...
ecm.populate([3, 6, ?,
              ?, 4, 2,
              1, 5, 7])

e = Enc(ecm, "example text")
print(e.encrypt())
"""
