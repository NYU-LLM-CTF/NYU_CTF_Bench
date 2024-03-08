from pwn import *
def solve(b):
    return (b-4)*b**(b-1)+2*(b**(b-2))+b**(b-3)+b**3

#p = process("chall.py")
p=remote("localhost",21200)

buf = p.recvuntil(">")[:-1].strip()

bae = int(buf.split(b" ")[-1].strip())

print(bae)

p.sendline(str(solve(bae)))

p.interactive()

