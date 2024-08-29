# Reference solution script for "Tur(n)ing Trees" in CSAW 2021 Quals
# by hgarrereyn

from z3 import *


def to3(v):
    r = []
    while v > 0:
        r = [v % 3] + r
        v //= 3
    return r

def from3(v):
    r = 0
    for x in v:
        r *= 3
        r += x
    return r

def to_bv(v):
    a = [BoolVal(False)] * 3
    a[v] = BoolVal(True)
    return a

def from_bv(v):
    for i in range(len(v)):
        if is_true(v[i]):
            return i
        
def to_ascii(v):
    f = ''
    while v > 0:
        f = chr(v & 0x7f) + f
        v >>= 7
    return f

def full_adder(a,b,cin,e):
    """
    a: a input
    b: b input
    cin: carry in
    e: enable
    
    Returns:
    s: sum output
    c: carry output
    b: b output (mirror)
    e: e output (mirror)
    """
    k0 = Or(And(a[0], b[0]), And(a[1], b[2]), And(a[2], b[1]))
    k1 = Or(And(a[0], b[1]), And(a[1], b[0]), And(a[2], b[2]))
    k2 = Or(And(a[0], b[2]), And(a[2], b[0]), And(a[1], b[1]))
    k = [k0,k1,k2]
    
    s0 = Or(And(e[1], Or(And(cin[0], k[0]), And(cin[1], k[2]))), And(e[0], a[0]))
    s1 = Or(And(e[1], Or(And(cin[0], k[1]), And(cin[1], k[0]))), And(e[0], a[1]))
    s2 = Or(And(e[1], Or(And(cin[0], k[2]), And(cin[1], k[1]))), And(e[0], a[2]))
    
    c0 = Or(And(cin[0], Or(a[0], b[0], And(a[1], b[1]))), And(cin[1], Or(And(a[0], b[0]), And(a[0], b[1]), And(a[1], b[0]))))
    c1 = Or(And(cin[0], Or(And(a[1], b[2]), And(a[2], b[1]), And(a[2], b[2]))), And(cin[1], Or(a[2], b[2], And(a[1], b[1]))))
    
    return [s0,s1,s2], [c0,c1], b, e

def double_adder(a,b,cin0,cin1,r):
    """
    a: a input
    b: b input
    cin: carry in
    r: enable switch (size 3)
    
    Returns:
    s2: right sum
    b2: right b (mirror)
    c1: down carry 1
    c2: down carry 2
    """
    ein0 = [r[0], Or(r[1], r[2])]
    ein1 = [Or(r[0], r[1]), r[2]]
    
    s1,c1,b1,e1 = full_adder(a,b,cin0,ein0)
    s2,c2,b2,e2 = full_adder(s1,b1,cin1,ein1)
    
    return s2, b2, c1, c2

def adder_column(a,b,r):
    """
    a: vec of A input
    b: vec of B input
    r: enable switch (size 3)
    """
    cin0 = to_bv(0)
    cin1 = to_bv(0)
    
    s = []
    bout = []
    
    c0 = cin0
    c1 = cin1
    for i in range(len(a)):
        s2,b2,c0,c1 = double_adder(a[i], b[i], c0, c1, r)
        s.append(s2)
        bout.append(b2)
    
    return s, bout

def full_circuit(a,b,r):
    """
    a: vec of A input
    b: vec of B input
    r: vec of enable switch
    """
    fs = []
    
    for i in range(len(r)):
        s,bout = adder_column(a,b,r[i])
        fs.append(s[0])
        a = s[1:]
        b = b[:-1]
        
    fs += a
    return fs

# ----

# k_fixed and t_fixed decoded from the fixed map inputs

# k_fixed: left hand input
k_fixed = [1, 1, 0, 2, 0, 2, 1, 0, 0, 2, 1, 1, 1, 2, 0, 1]

# t_fixed: right hand target output
t_fixed = [2, 1, 0, 0, 2, 2, 0, 2, 2, 1, 2, 1, 2, 0, 1, 0, 
           1, 2, 2, 0, 0, 0, 2, 1, 0, 1, 2, 2, 2, 2, 0, 1, 
           1, 1, 0, 1, 1, 0, 0, 1, 1, 2, 1, 2, 2, 0, 0, 0, 
           0, 2, 1, 0, 2, 2, 0, 0, 1, 2, 2, 1, 0, 2, 0, 1]

# A: all zeros
a_vec = [to_bv(0) for i in range(len(t_fixed))]

# B: fixed value
b_vec = [to_bv(v) for v in k_fixed] + [to_bv(0) for i in range(len(t_fixed) - len(k_fixed))]

# R: user controlled value
vals = [Int('r%d' % x) for x in range(49)]
r_vec = [[x==0, x==1, x==2] for x in vals]

# Symbolically execute the circuit
print('Building circuit...')
fs = full_circuit(a_vec, b_vec, r_vec)

s = Solver()

for i in range(len(t_fixed)):
    s.add(fs[i][t_fixed[i]] == True)

print('Checking for a solution...')
s.check()
m = s.model()

f = [m[v].as_long() for v in vals]
flag = to_ascii(from3(f[::-1]))
print('flag{%s}' % flag)
