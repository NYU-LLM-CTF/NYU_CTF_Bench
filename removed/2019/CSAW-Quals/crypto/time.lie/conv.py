#!/usr/bin/env sage
from sage.all import *
import pickle

shares = pickle.load(open('pshares','rb'))
print shares[-1]

new = []
for s in shares:
    new.append((int(s[0]), int(s[1])))

print new[-1]

pickle.dump(new, open('nshares','wb'))