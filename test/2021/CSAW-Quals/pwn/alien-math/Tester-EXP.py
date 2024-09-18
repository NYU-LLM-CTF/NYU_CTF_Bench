# For second question
from z3 import *
def func(a1,a2):
    return (a1*48+11*a2-4)%10
rrr='7759406485255323229225'
flag='7'
for x in range(21):
    n = Int('n')
    s = Solver()
    init=int(rrr[x])
    t=int(rrr[x+1])
    s.add(t==(n+func(init,init+x))%10)
    s.add(n<10)
    s.add(n>=0)
    res=s.check()
    if(str(res)!='sat'):
        exit(1)
    m=s.model()
    res=str(m[m.decls()[0]])
    flag+=res
    print(flag)
assert(flag=="  ")
