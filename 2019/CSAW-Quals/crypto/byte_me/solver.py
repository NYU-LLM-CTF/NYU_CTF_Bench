import random
import string
from Crypto.Cipher import AES
from pwn import *

p = remote("localhost", 12312)
p.recvuntil(": ")

results = []
padding = 0
for i in range(0, 17):
	payload = "A"*16 + "A"*i
	p.sendline(payload)
	p.recvuntil("\n")
	result = p.recvuntil("\n")
	results.append({"result":result, "length":i})
	prev = results[len(results)-2]
	if prev["result"][0:64] == result[0:64] and len(results) > 1:
		print("padding length found: " + str(prev["length"]))
		padding = prev["length"]
		break


p.recvuntil(": ")
flag = ""
found = ""
while found != '}':
	if len(flag) < 16:
		sendme = 'B'*padding + 'A'*(15-len(flag))
	else:
		sendme = 'B'*padding + 'A'*(15-(len(flag)%16))
	p.sendline(sendme)
	p.recvuntil("\n")
	if len(flag) < 16:
		matchme = p.recvuntil("\n")[16:48]
	elif len(flag) < 32:
		matchme = p.recvuntil("\n")[48:80]
	else:
		matchme = p.recvuntil("\n")[80:112]

	for i in string.printable:
		prompt = p.recvuntil(": ")
		p.sendline(sendme + flag + i)
		p.recvuntil("\n")
		response = p.recvuntil("\n")
		if len(flag) < 16 and response[16:48] == matchme:
			flag += i
			found = i
			break
		elif len(flag) >= 16 and response[48:80] == matchme:
			flag += i
			found = i
			break
		elif len(flag) >= 32 and response[80:112] == matchme:
			flag += i
			found = i
			break
	print(flag)
