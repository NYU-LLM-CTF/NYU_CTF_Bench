from pwn import *

# p = process("./wizkid")
p = remote('rev.chal.csaw.io', 1002)
#p = remote("localhost", 4444)
p.recvuntil("?:")

def next_prime(n):
    return find_prime_in_range(n, 2*n)

def find_prime_in_range(a, b):
    for p in range(a, b):
        for i in range(2, p):
            if p % i == 0:
                break
        else:
            return p
    return None

expression = "(((((((1+1)+1)+1)+1)+1)+1)+0)"
p.sendline(expression)
res = eval(expression)
res2 = next_prime(res+1)
res3 = next_prime(res2+1)

print(res * 2, res2 * 3, res3 * 4)
p.sendline(str(res * 2))
p.recvuntil("number")
p.sendline(str(res2 * 3))
p.recvuntil("??")
p.sendline(str(res3 * 4))

print(p.recvall())
