# https://www.rogdham.net/2018/09/17/csaw-ctf-2018-write-ups.en


from pwn import *
from functools import partial
import string

#context.log_level = "DEBUG"

def get_len(r, data):
    r.recvuntil('\n')
    r.sendline(data)
    line = r.recvuntil('\n')[2:-3].decode('unicode-escape')
    return len(line)


def solve(oracle, suffix, charset):
    out = []
    for c in charset:
        data = c + suffix
        data *= 5
        while len(data) < 20:
            data += '<'  # pad
        out.append((c, oracle(data)))
    max_value = max(out, key=lambda o: o[1])[1]
    return [o[0] for o in out if o[1] != max_value]


def solve_all(oracle):
    suffixes = ['']
    charset = string.ascii_lowercase + '_' + '{' + '}'
    while suffixes:
        new_suffixes = []
        for suffix in suffixes:
            if suffix:
                # skip loops at the right of suffix
                if suffix.endswith(suffix[-1:] * 3):
                    continue
                if suffix.endswith(suffix[-2:] * 3):
                    continue
            chars = solve(oracle, suffix, charset)
            if not(chars):
                yield suffix
                continue
            for char in chars:
                new_suffixes.append(char + suffix)
        log.info(suffixes)
        suffixes = new_suffixes

#with remote('localhost', 8040) as r:                   # <-- when local testing
with remote('crypto.chal.csaw.io', 8040) as r:          # <-- when testing with chal.test
    for solved in solve_all(partial(get_len, r)):
        log.success(solved)
    print('f' + solved)
