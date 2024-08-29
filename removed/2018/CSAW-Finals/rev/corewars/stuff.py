from pwn import *
import random
import string
import os

def xor(a,k):
    o = ''
    for i,c in enumerate(a):
        o += chr(ord(c)^ord(k[i%len(k)]))
    return o

#f = xor("echo '|%s' > /proc/sys/kernel/core_pattern\0",'flag{')
#print map(ord,f)

#f = xor('/proc/self/exe\0','flag{')
#print map(ord,f)

flag='key=_1t_rUn5_4s_r0o7_5nd_c4n_D0_l0ts_Of_s7up1D_Th1Ng5_!\0'

'''
void* frame = (void*)regs->rbp;
    7     uint64_t last_call = read64(frame+8);
    6     fprintf(f, "last_call is %p\n",last_call);
    5     last_call = (uint64_t)addr_of((void*)last_call);
    4     fprintf(f, "last_call is %p\n",last_call);
    3     fflush(f);
    2     if (last_call == 0xffffffffffffffff) {
    1         return 0;
  225     }
'''

def run():
    print '--'
    flag_chars = list(enumerate(flag))[4:]
    random.shuffle(flag_chars)
    flag_parts = [flag_chars[i:i+4] for i in range(0,len(flag_chars),4)]
    #print flag_parts

    MOV_R0 = 1
    XOR = 2 # r0 = r0 ^ r1
    MOV_R1 = 3
    LSHIFT = 5 # r0 = r0 << imm
    GET_FLAG = 4 # r1 = flag[r1]
    CHECK = 6 

    asm = []

    out_flag = list(flag)


    for part in flag_parts:
        if random.randint(0,0) == 0:
            # Simple lshift
            asm += [MOV_R0, 0]
            v = 0
            for i,c in part:
                ip = (len(asm)+5)&(0x1f)
                if c == '\0':
                    new_c = c
                else:
                    new_c = chr(ord(c)^ip)
                    print ip
                    if not new_c in string.printable.strip():
                        print bin(ord(c)),bin(ip)
                        return False

                out_flag[i] = new_c

                asm += [LSHIFT, 8, MOV_R1, i, GET_FLAG, XOR]
                v <<= 8
                v += ord(new_c)


            print hex(v)
            k = u64(os.urandom(8))
            k_ = k^v
            asm += [MOV_R1, k, XOR, MOV_R1, k_, CHECK]
    asm += [7]

    print '{'+','.join('0x%x'%x for x in asm) + '}'
    print repr(''.join(out_flag))
    return True

while not run():
    pass

