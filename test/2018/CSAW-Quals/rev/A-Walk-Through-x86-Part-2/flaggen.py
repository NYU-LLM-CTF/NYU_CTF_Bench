#!/usr/bin/env python2

xor_key = (ord('E') | ord('l')) & (ord('y') | ord('k'))

flag = "flag{0ne_sm411_JMP_for_x86_on3_m4ss1ve_1eap_4_Y0U}"

encrypted = ""
for c in flag:
    encrypted += chr((ord(c) << 1) ^ xor_key)
print(repr(encrypted))

decrypted = ""
for c in encrypted:
    decrypted += chr((ord(c) ^ xor_key) >> 1)
print(decrypted)

nasmString = ''
for c in encrypted:
    nasmString += hex(ord(c)) + ', 0x1f, '

print(nasmString[:-2])
