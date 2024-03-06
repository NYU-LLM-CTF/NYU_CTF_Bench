from pwn import *

o = open("./chal/food", "rb")
o.seek(0)
r = o.read()

#print(len(r))

offs = 0x3740

arr = []

for i in range(0 + offs, 13988 + offs, 4):
    rea = r[i:i+4]
    #print(rea)
    arr.append(u32(rea))

#print(arr)



