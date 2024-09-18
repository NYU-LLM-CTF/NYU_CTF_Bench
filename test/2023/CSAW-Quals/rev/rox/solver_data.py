from pwn import *

from exfil import arr

data = arr

pkey = [0x3f, 0x42, 0x38, 0x5f, 0x7a, 0x57, 0x71, 0x74, 0x66, 0x44, 0x47, 0x32, 0x3d, 0x16, 0x63, 0x1f, 0x12, 0x1a, 0x12, 0x5c, 0x2a, 0x3, 0x64, 0x1c, 0x15, 0x40, 0x1, 0x3f, 0x4c, 0x2, 0x3a, 0x30, 0x1d, 0x7c, 0x69, 0x4d, 0x19, 0x5f, 0x48, 0x5e, 0x20, 0x3, 0x17, 0x9, 0xf]


key = [i for i in b"flag{ph3w...u finaLly g0t it! jump into cell}"]

# xor 110 is optimized out

#part 3
for i in range(5, len(key), 1):
    for j in range(300):
        key[i] = j * 32 ^ key[i]

# part 2 and part 1 might have to be bruteforced

def find_preimage(kval, pkval, pos, data):
    ans = []
    for a1i in range(255):
        #part 2
        c = a1i ^ pkval
        j = (pos * 10 + 12) % len(data)
        k = j + data[j % len(data)]
        k = k + a1i
        k = c ^ data[k % len(data)]
        if kval == k:
            ans.append(a1i)
    return ans

print(find_preimage(key[0], pkey[0], 0, data))




