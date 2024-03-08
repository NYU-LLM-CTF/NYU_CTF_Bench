#!/usr/bin/env python3

import asyncio
import random
import string
import resource
import time

NUMBER_OF_CONNECTIONS = 1000
FUZZ_PER_SESSION = 100
CONTROL_PORT = 2000
# NB: don't include 0xdead because that kills the server
control_menu = list(map(str,range(1, 5))) + [str(31337)]
sensor_menu = ['LIST', 'EXAMINE', 'REPORT', 'HELP']
valid_angels = ["Adam","Arael","Armisael","Bardiel","Gaghiel",
                "Ireul","Israfel","Leliel","Lilith","Matarael",
                "Ramiel","Sachiel","Sahaquiel","Sandalphon",
                "Shamshel","Tabris","Zeruel"]
fuzzchars = string.ascii_letters + string.digits + string.punctuation + ' '

def increase_open_files_limit():
    soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
    print(f"Soft limit: {soft}, Hard limit: {hard}")
    resource.setrlimit(resource.RLIMIT_NOFILE, (hard, hard))
    soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
    print(f"Soft limit: {soft}, Hard limit: {hard}")

active_connections = 0
bytes_sent_control = 0
bytes_recv_control = 0
bytes_sent_sensor = 0
bytes_recv_sensor = 0

async def control_client(connection_id):
    global active_connections, bytes_sent_control, bytes_recv_control
    writer = None
    try:
        reader, writer = await asyncio.open_connection(
            '127.0.0.1', CONTROL_PORT)
        active_connections += 1

        for i in range(FUZZ_PER_SESSION):
            # Pick a random menu option, or sometimes generate a random string
            if random.randint(0, 10) > 7:
                choice = random.choice(control_menu)
            else:
                strlen = random.randint(1, 2048)
                choice = ''.join(random.choice(fuzzchars) for _ in range(strlen))
            wdata = choice.encode() + b'\n'
            writer.write(wdata)
            bytes_sent_control += len(wdata)
            await writer.drain()
            data = b''
            try:
                while True:
                    part = await asyncio.wait_for(reader.read(1024), timeout=1)
                    if not part:
                        break
                    data += part
            except asyncio.TimeoutError:
                pass
            bytes_recv_control += len(data)
    except Exception as e:
        print(f'control_client[{connection_id}]:', e)
    finally:
        if writer:
            await writer.wait_closed()
            active_connections -= 1

async def sensor_client(connection_id):
    global active_connections, bytes_sent_sensor, bytes_recv_sensor, bytes_sent_control, bytes_recv_control
    control_writer = None
    try:
        portmsg = b'Session sensor port is:'
        # Need to get the port from the control server
        control_reader, control_writer = await asyncio.open_connection(
            'localhost', CONTROL_PORT)
        active_connections += 1
        while True:
            data = await control_reader.read(100)
            if data and portmsg in data:
                for line in data.decode().split('\n'):
                    if portmsg.decode() in line:
                        sensor_port = int(line.split()[-1])
                        break
                break
        bytes_recv_control += len(data)
    except Exception as e:
        print('sensor_client:', e)
    finally:
        if control_writer:
            await control_writer.wait_closed()
            active_connections -= 1
    writer = None
    try:
        reader, writer = await asyncio.open_connection(
            'localhost', sensor_port)
        active_connections += 1
        for i in range(FUZZ_PER_SESSION):
            # Pick a random menu option, or sometimes generate a random string
            if random.randint(0, 10) < 7:
                choice = random.choice(sensor_menu)
                if choice == 'EXAMINE':
                    if random.randint(0, 9) >= 5:
                        strlen = random.randint(1, 2048)
                        choice += ' ' + ''.join(random.choice(fuzzchars) for _ in range(strlen))
                    else:
                        choice += ' ' + random.choice(valid_angels)
            else:
                strlen = random.randint(1, 2048)
                choice = ''.join(random.choice(fuzzchars) for _ in range(strlen))
            wdata = choice.encode() + b'\n'
            writer.write(wdata)
            bytes_sent_sensor += len(wdata)
            await writer.drain()
            data = b''
            try:
                while True:
                    part = await asyncio.wait_for(reader.read(1024), timeout=1)
                    if not part:
                        break
                    data += part
            except asyncio.TimeoutError:
                pass
            bytes_recv_sensor += len(data)
    except Exception as e:
        print('sensor_client[{connection_id}]:', e)
    finally:
        if writer:
            await writer.wait_closed()
            active_connections -= 1

async def monitor_connections():
    start = time.time()
    while True:
        await asyncio.sleep(5)
        elapsed = time.time() - start
        print(f'After {elapsed:.2f} seconds:')
        print(f'Active connections: {active_connections}')
        print(f'Control bytes sent: {bytes_sent_control} bytes, {bytes_sent_control / elapsed:.2f} bytes/sec')
        print(f'Control bytes recv: {bytes_recv_control} bytes, {bytes_recv_control / elapsed:.2f} bytes/sec')
        print(f' Sensor bytes sent: {bytes_sent_sensor} bytes, {bytes_sent_sensor / elapsed:.2f} bytes/sec')
        print(f' Sensor bytes recv: {bytes_recv_sensor} bytes, {bytes_recv_sensor / elapsed:.2f} bytes/sec')

async def main(number_of_connections):
    for round in range(100):
        print("Fuzz round:", round)
        tasks_1 = [control_client(i) for i in range(number_of_connections)]
        tasks_2 = [sensor_client(i+number_of_connections) for i in range(number_of_connections)]

        await asyncio.gather(*(tasks_1 + tasks_2 + [monitor_connections()]))
    # Shut down the server
    reader, writer = await asyncio.open_connection(
        'localhost', CONTROL_PORT)
    writer.write(str(0xdead).encode() + b'\n')

if __name__ == "__main__":
    server_address = '127.0.0.1'
    number_of_connections = NUMBER_OF_CONNECTIONS
    increase_open_files_limit()
    asyncio.run(main(number_of_connections))
