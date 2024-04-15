#!/usr/bin/env python
with open("flag.txt", "r") as flag:
    flag = flag.read().strip()

# I want them to patch in calls to a function I provide in llvm
# this function aids in decryption

#get program counter var and buf to some state and then u patch in call to some function
#this function can't be statically reversable (Impossible but make it hard with jumps)
#the jumps will emulate the algorithm of decryption 

#global vars have to be in a certain state for decryption process

#decryption process can be based off an un memoized fibbonacci

#how to make decryption process llvmable? without patches and debug tricks

# can place function that I don't use
# modify global vars
# primeth fibonnacci?

def is_prime(n):
  if n == 2 or n == 3: return True
  if n < 2 or n%2 == 0: return False
  if n < 9: return True
  if n%3 == 0: return False
  r = int(n**0.5)
  f = 5
  while f <= r:
    if n%f == 0: return False
    if n%(f+2) == 0: return False
    f +=6
  return True  


def fibb_gen():
    keys = []
    i = 2
    a = 0
    b = 1
    while len(keys) != len(flag):
        c = a + b
        if is_prime(i):
            keys.append(c % 10**19)
        a = b
        b = c

        i += 1

    return keys


def encrypt(b):
    if type(b) == str:
        b = list(b)
    keys = fibb_gen()
    for i,v in enumerate(keys):
        if type(b[i]) == str:
            b[i] = ord(b[i])
        r = b[i] ^ v
        keys[i] = (b[i] ^ v) 
    return keys


d = encrypt(encrypt(flag))

print("*"*19)
print("*"*19)
for i in d:
    print(i)
print("*"*19)
print("*"*19)
print(len(flag))
#d = encrypt(d)
c = "".join(map(chr,d))
print(c)
#print hex(c).strip("0xL").decode("hex")
