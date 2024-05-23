import re
import sys

def load_from_file(f):
    res = []
    lines = open(f).readlines()
    for line in lines:
        i, val = re.findall(r'\d+', line)
        res.append((i, val))
    return res


reals = load_from_file('reals')
reals.append((0,0))
#imags = load_from_file('imags')
#imags.append((0,0))

p = sys.argv[1]
F = GF(p)
R = F['r']
rf = R.lagrange_polynomial(reals)

b1r = rf[1]
secret = (b1r * inverse_mod(5 * 13, p)) % p
print(secret)