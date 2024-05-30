from pwn import *
from collections import deque

MAGIC_PRIME = 2750
OPTIONS = []
MAGIC_NUMBER = 25132
#p  = process("./main")
p = remote("localhost", 8120)

def get_primes(n):
    numbers = set(range(n, 1, -1))
    primes = [];
    while numbers:
        p = numbers.pop()
        primes.append(p)
        numbers.difference_update(set(range(p*2, n + 1, p)))
    primes.sort()
    primes = deque(primes)
    while primes:
        yield primes.popleft()
        if primes:yield primes.pop()

primes =  list(get_primes(2750))
maperize = lambda x: [x[i:i+10] for i in range(0,len(x),10)]

maps = {
        'U' : maperize(primes[:100]),
        'D' : maperize(primes[100:200]),
        'R' : maperize(primes[200:300]),
        'L' : maperize(primes[300:400])
        }

for i in maps.values(): i[0][0] = 2


def traverse(graph = maps['U'],total = 0,path = "",i=0,j=0):
    if i == 10 or j == 10:
        return 9999999,"BAD",(i,j)
    current = total + graph[i][j]
    if (9,9) == (i,j) and MAGIC_NUMBER == current:
        OPTIONS.append(path)
    if current <= MAGIC_NUMBER:
	r,rsum,rc =  traverse(maps['R'],current,path + 'R',i,j+1)
	u,usum,uc =  traverse(maps['U'],current,path + 'U',i+1,j)
        return (r,rsum,rc) if rsum == MAGIC_NUMBER else (u,usum,uc)
    return path,total,(i,j)

traverse()
p.sendline(OPTIONS[3])

print(p.recvall())
