from pwn import *

#r = process('bomblab')
r = remote('localhost', 4848)
#r = process('yeetlab_release')

print r.recvuntil("'yote'\n")
r.sendline("'omae wa mou shixxxxiedn'NANI!?'")
print r.recvuntil("number: \n")
r.sendline("3385539096549136")
r.recvuntil("rsi\n")
resp = r.recvuntil("passphrase: \n")
print resp[:23]
r.sendline(resp[:23])
print r.recvuntil("}")
