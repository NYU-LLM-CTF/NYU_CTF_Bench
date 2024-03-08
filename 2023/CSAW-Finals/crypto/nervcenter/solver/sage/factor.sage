import sys
n = int(sys.argv[1])
res = factor(n)
print(" ".join([" ".join([str(p)]*e) for p,e in res]))
