#!/usr/bin/env python3
import subprocess
import socket
import binascii
import random
import tempfile
import os
import random

dump = input("Pls give datas like \"90909090\" for four nops:\n")

if len(dump) >= 1000:
    print("Too long!!", flush=True)
    exit()

dumpList = [dump[i:i+2] for i in range(0, len(dump), 2)]

hexList = []

for b in dumpList:
    try:
        hexList += binascii.unhexlify(b)
    except:
        print("Even-Byte Hex only!!", flush=True)
        exit()

def port_open(port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex(('localhost', port))
    if result == 0:
        return False
    else:
        return True

flag = open("flag.txt", 'r').readline().strip().encode('charmap')
null = open("/dev/null", 'w')

with tempfile.TemporaryDirectory() as workdir:
    for fn in ["Makefile", "tacOS-base.bin"]:
        os.symlink(os.path.join(os.path.dirname(os.path.realpath(__file__)), fn), os.path.join(workdir, fn))

    with open(os.path.join(workdir, "untrusted-code.bin"), 'wb') as f:
        f.write(bytearray(hexList) + flag + b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00')

    subprocess.run(["make"], cwd=workdir, stdout=null, stderr=null)

    displays = list(range(200))
    random.shuffle(displays)
    for p in displays:
        if port_open(p + 5900):
            print("Connect with VNC to port", p + 5900, flush=True)
            subprocess.run([
                "timeout",
                "-s", "KILL",
                "15",
                "qemu-system-x86_64",
                "-m", "16",
                "-drive", "format=raw,file=" + os.path.join(workdir, "tacOS.bin"),
                "-vnc", ":" + str(p)
            ], stdout=null, stderr=null)
            break
    else:
        print("Servers busy, try again later", flush=True)

    # workdir is auto cleaned by leaving ctxt
