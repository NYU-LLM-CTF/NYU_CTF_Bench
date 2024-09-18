from pwn import *
context.log_level='debug'
context.arch='amd64'
#context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
p=process('chall.py')
# p=remote("localhost", 12312)
ru 		= lambda a: 	p.readuntil(a)
r 		= lambda n:		p.read(n)
sla 	= lambda a,b: 	p.sendlineafter(a,b)
sa 		= lambda a,b: 	p.sendafter(a,b)
sl		= lambda a: 	p.sendline(a)
s 		= lambda a: 	p.send(a)

# input()

with open('solve.py', 'rb') as h:
    payload = h.read()

sl(payload)

#res = ru("BONK audit! os.system b'sh'")

#print(b"module '__main__' from '" in res)

#gdb.attach(p)
p.interactive()
