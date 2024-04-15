#!/usr/bin/env python2
from pwn import *
from string import ascii_lowercase

def execute_command(payload):
    command = ["/../../../../pin", "-t", "inscount0.so", "--", "/home/sai/github/1nsanity/counting"]
    p = process(command)
    p.sendline(payload)
    print p.recvall()

def ins_count():
    with open("inscount.out","r") as count:
        c = int(count.read().strip().split(" ")[1])
    return c

flag_len = 31
flag = "flag{"

options = ascii_lowercase + "{}_"
def solve():
    global flag
    max_ins = 0
    max_o = ""
    for _ in range(31 - len(flag) - 1):
        for o in options:
            cur_len = flag_len - len(flag) - 2
            execute_command(flag + o+("a"*cur_len) + '}')
            count = ins_count()
            if max_ins < ins_count():
                max_ins = count
                max_o = o
            print("finished: {}".format(o))
        flag += max_o
        print(flag)
        pause()

solve()
print(flag + "}")
