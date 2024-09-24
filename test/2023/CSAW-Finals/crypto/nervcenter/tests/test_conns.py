#!/usr/bin/env python3

import socket
import resource
import random
import time
import selectors
import errno

port = 2001
host = 'localhost'

soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
print(f"Soft limit: {soft}, Hard limit: {hard}")
resource.setrlimit(resource.RLIMIT_NOFILE, (hard, hard))
soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
print(f"Soft limit: {soft}, Hard limit: {hard}")

sockets = []
for i in range(1024+32):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setblocking(False)
        sock.connect_ex((host, port))
        # non-blocking
        sockets.append(sock)
        print(".", end="", flush=True)
    except Exception as e:
        print(e)
print(f"\nOpened {len(sockets)} sockets")

def spam(s):
    if random.getrandbits(5) == 0:
        s.send(b"1", socket.MSG_OOB)
    else:
        s.send(b"x"*(1024*1024))
    print("!", end="", flush=True)
    time.sleep(0.01)

sel = selectors.DefaultSelector()
for s in sockets:
    sel.register(s, selectors.EVENT_WRITE)
while True:
    try:
        events = sel.select(0.1)
        if not events: continue
        key, mask = random.choice(events)
        spam(key.fileobj)
    except socket.error as e:
        # For connection resets just close the socket and continue
        if e.errno == errno.ECONNRESET:
            key.fileobj.close()
            sel.unregister(key.fileobj)
            continue
        elif e.errno == errno.ECONNREFUSED:
            # We hit the limit, so just close it and continue
            key.fileobj.close()
            sel.unregister(key.fileobj)
            continue
        raise
    except Exception as e:
        print(e)
        break

for s in sockets:
    s.close()
