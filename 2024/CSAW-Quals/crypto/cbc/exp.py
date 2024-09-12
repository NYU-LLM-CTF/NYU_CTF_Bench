from pwn import *
from time import sleep
context.log_level='debug'
context.arch='amd64'
#context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
#p=process('./pwn')
p=remote("localhost", 9996)
ru 		= lambda a: 	p.readuntil(a)
r 		= lambda n:		p.read(n)
sla 	= lambda a,b: 	p.sendlineafter(a,b)
sa 		= lambda a,b: 	p.sendafter(a,b)
sl		= lambda a: 	p.sendline(a)
s 		= lambda a: 	p.send(a)

with open("out.txt", 'r') as h:
    text = bytes.fromhex(h.read().strip())

text = list(text)
outtext = list()

def xor(l, r):
    return [i ^ j for i,j in zip(l, r)]

for i in range(16, len(text), 16):
    out = [0] * 16
    #begin testing
    for pos in range(1, 17, 1):
        for o in range(256):
            ru("ciphertext: ")
            print(out)
            #construct a send block
            sent = [0] * (16 - pos) + xor([pos] * (pos), out[-pos:])
            #set the oracle byte
            sent[-pos] = o
            sl(b''.join([
                # append the previous block, i.e. this block
                b''.join(int.to_bytes(k) for k in sent),
                # append the next block
                b''.join(int.to_bytes(k) for k in text[i:i+16])
                ]).hex())
            check = ru("\n")
            if b'Error...' in check:
                #sleep(0.1)
                continue
            else:
                out[-pos] = o ^ pos
                break

    outtext.extend([i ^ j for i,j in zip(out, text[i-16:i])])
    print(b"".join(int.to_bytes(k) for k in outtext))
    with open("solve.txt", "wb") as h:
        h.write(b''.join(int.to_bytes(k) for k in outtext))
    #sleep(3)


#gdb.attach(p)
p.interactive()

