# Author: nikobelic29
# Playtest solver script

num1 = 0x6E37625970416742
num2 = 0x44777343

def num2chrarr(num) -> str:
    ret = ""
    while num != 0:
        lob = num & 0xff
        ret += chr(lob)
        num >>= 8
    return ret

strr = num2chrarr(num1) + num2chrarr(num2)

print(strr)

work = ""

for i in range(0, len(strr), 2):
    if i == 0:
        continue
    work += strr[i]

print(work)

out = ""

for i in work:
    binn = bin(ord(i))[2:].zfill(8)
    for j, k in zip(binn, binn[4:]):
        if j == k:
            out += "0"
        else:
            out += "1"

print(out)

