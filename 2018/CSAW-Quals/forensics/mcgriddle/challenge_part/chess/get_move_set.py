from pwn import *

p = remote('ctf-tools.osiris.cyber.nyu.edu', 9998)


content = p.recvuntil(') :')
with open('moves', 'a') as output:
    while True:
        p.sendline("go")
        content = p.recvuntil(') :')
        l = content.split('\n')
        for i in l:
            if "My move is :" in i:
                output.write(i)
                print i
