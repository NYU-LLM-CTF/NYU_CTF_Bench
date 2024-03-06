from pwn import *
from collections import defaultdict
from exfil import arr

data = arr

print(len(data))

pkey = [0x3f, 0x42, 0x38, 0x5f, 0x7a, 0x57, 0x71, 0x74, 0x66, 0x44, 0x47, 0x32, 0x3d, 0x16, 0x63, 0x1f, 0x12, 0x1a, 0x12, 0x5c, 0x2a, 0x3, 0x64, 0x1c, 0x15, 0x40, 0x1, 0x3f, 0x4c, 0x2, 0x3a, 0x30, 0x1d, 0x7c, 0x69, 0x4d, 0x19, 0x5f, 0x48, 0x5e, 0x20, 0x3, 0x17, 0x9, 0x52, 0x6b, 0x4c, 0x65, 0x6f, 0x48, 0x6, 0x5b, 0x2b, 0x28, 0x40, 0x2e, 0x4e, 0xb, 0x16, 0x31, 0x30, 0x56, 0x21, 0x6e, 0x2d, 0x30, 0x4b, 0x1c, 0x10, 0x4, 0x3f, 0x18, 0x41, 0x34]

key = [i for i in b"flag{ph3w...u finaLly g0t it! jump into cell wHen U g3t t0 the next cha11}"]

assert(len(key) == len(pkey))

#part 3
for i in range(5, len(key), 1):
    for j in range(300):
        key[i] = j * 32 ^ key[i]

#part 2 and 1 can be bruteforced

def check(i, a1i):
    keyi = a1i ^ pkey[i]
    c = keyi
    j = (i * 10 + 12) % len(data)
    k = data[j % len(data)]
    k = k + a1i
    k = c ^ data[k % len(data)]
    return k == key[i]

def check2(i, a1s):
    for a1i in a1s:
        keyi = pkey[i]
        c = keyi
        j = (i * 10 + 12) % len(data)
        k = data[j % len(data)]
        k = k + a1i
        k = c ^ data[k % len(data)]
        if k == key[i]:
            return a1i
    return None


#97
#p is input len
#j is key len
#5 and 40 is arbitrary, just to find flag length
exfil = dict()
for p in range(5, len(key)):
    flag = False
    dic = defaultdict(lambda:set(range(256)))
    #populate flag
    for j in range(p):
        survey = set()
        for i in range(255):
            if check(j, i):
                survey.add(i)
        #print(survey)
        dic[j] = survey
    #check flag
    flag = False
    for j in range(p, len(key)):
        for i in range(255):
            if (c := check2(j, dic[j % len(dic)])) != None:
                dic[j % len(dic)] = {c}
            else:
                flag = True
    if flag:
        continue
    else:
        print(p, dic)
        exfil = dic
        break

print(exfil)

for i,j in exfil.items():
    try:
        print(chr(list(j)[0]), end="")
    except:
        pass


