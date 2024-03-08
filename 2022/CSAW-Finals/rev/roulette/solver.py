from pwn import *
from math import *
context.log_level='debug'
context.arch='amd64'
#context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
#p=process(['java', "chall"])
p=remote('rev.chal.csaw.io',5020)
ru 		= lambda a: 	p.readuntil(a)
r 		= lambda n:		p.read(n)
sla 	= lambda a,b: 	p.sendlineafter(a,b)
sa 		= lambda a,b: 	p.sendafter(a,b)
sl		= lambda a: 	p.sendline(a)
s 		= lambda a: 	p.send(a)

def num2int(n):
    #if it is positive
    if n <= 0x7FFFFFFF and n >= 0:
        return n
    n &= 0xFFFFFFFF
    return -(0xFFFFFFFF - n + 1) #2's complement


def next(seed1):
    #https://docs.oracle.com/javase/7/docs/api/java/util/Random.html#next(int)
    nextSeed = (seed1 * 0x5DEECE66D + 0xB) & ((1 << 48) - 1)
    clamp = nextSeed >> (48 - 32)
    #print(clamp, num2int(clamp))
    return num2int(clamp), nextSeed

def lod_bits(n1, n2):
    return n1 & 0xFFFF == n2 & 0xFFFF

# def Find_Seed(n1, n2, n3):
#     #guess the lower 16 bits here
#     #second, try numbers i guess
#     liss = []
#     for i in range(2**16):
#         #print(i)
#         attemptSeed = (n1 << 16) + i
#         if lod_bits(next(attemptSeed)[0], n2) and lod_bits(next(next(attemptSeed)[1])[0], n3):#next(attemptSeed)[0] == n2:
#             #return attemptSeed
#             liss.append(attemptSeed)
#     return liss
#     return None

def Find_Seed(n1, n2, n3):
    #guess the lower 16 bits here
    #second, try numbers i guess
    #liss = []
    for i in range(2**16):
        #print(i)
        attemptSeed = (n1 << 16) + i
        if lod_bits(next(attemptSeed)[0], n2) and lod_bits(next(next(attemptSeed)[1])[0], n3):#next(attemptSeed)[0] == n2:
            return attemptSeed
            #liss.append(attemptSeed)
    #return liss
    return None


def encode_seed(num):
    return (num ^ 0x5DEECE66D) & ((1 << 48) - 1)

#first game find seed
ru(">")
sl("1")
sl("red")

ru("Here is how other people did:\n\n")

players=ru(b"dollars!\n\n")
players=players.split(b"dollars!\n\n")[0]
players=players.split(b"\n")

print(b"\n".join(players).decode("raw_unicode_escape"))

seed = 0

for i,j, k in zip(players[-3:], players[-2:], players[-1:]):
    print(i,j, k)
    ipaddr = i.split(b" ")[0]
    print(ipaddr, ipaddr.split(b".")[2].decode("raw_unicode_escape"), int(ipaddr.split(b".")[3].decode("raw_unicode_escape")))
    seed = int(ipaddr.split(b".")[2].decode("raw_unicode_escape")) << 8 | int(ipaddr.split(b".")[3].decode("raw_unicode_escape")) << 0

    ip2 = j.split(b" ")[0]
    target = int(ip2.split(b".")[2].decode("raw_unicode_escape")) << 8 | int(ip2.split(b".")[3].decode("raw_unicode_escape")) << 0

    ip3 = k.split(b" ")[0]
    target2 = int(ip3.split(b".")[2].decode("raw_unicode_escape")) << 8 | int(ip3.split(b".")[3].decode("raw_unicode_escape")) << 0


    print(seed, target, target2)

    seed = Find_Seed(seed, target, target2)

print("Found seed to be:", seed)
num2, seed = next(seed)
num3, seed = next(seed)
print("First num is:", num2)
print("Second num is:", num3)

amt = []
print("player range", len(players))
for i in range(len(players)):
    num, seed = next(seed)
    print(num)
    amt.append(num & 0xff)

lose = []
for i in range(len(players)):
    num, seed = next(seed)
    lose.append(abs(num) & 1 == 0)

print(amt, lose)

#next 20 game full send

#input()

for _ in range(20):

    num, seed = next(seed)
    print(num)
    expenditure = -1
    for i in range(1, 50):
        nextseed = encode_seed((num & 0xffff) + (num3 & 0xffff) + i)
        if next(nextseed)[0] & 15 == 0:
            print(i, (num & 0xffff) + (num3 & 0xffff) + i)
            expenditure = i
    
    seed = encode_seed((num & 0xffff) + (num3 & 0xffff) + expenditure)

    #generate color
    num, seed = next(seed)

    #generate count
    num, seed = next(seed)

    ru(">")
    sl(str(expenditure))
    sl("green")

    ru("Here is how other people did:\n\n")

    players=ru(b"dollars!\n\n")
    players=players.split(b"dollars!\n\n")[0]
    players=players.split(b"\n")

    print(b"\n".join(players).decode("raw_unicode_escape"))

    #generate IP, extract last player's IP
    for i in range(len(players)-1):
        num, seed = next(seed)
        print(num & 0xff00 >> 8, num & 0xff)
    
    num3, seed = next(seed)

    #generate winning and amount
    for i in range(len(players) * 2):
        num, seed = next(seed)

    #input()

    


p.interactive()
