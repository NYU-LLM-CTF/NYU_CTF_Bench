#!/usr/bin/env python

import base64
import io
import signal
import sys
import os
import socket
import subprocess
import resource
import time

# Increase open files limit to 2048
resource.setrlimit(resource.RLIMIT_NOFILE, (2048, 2048))

def parse_key(ssh_pubkey):
    keyline = ssh_pubkey.strip().split()
    keytpe_s, encoded_key, comment = keyline
    # print(f"Key type: {keytpe_s}, comment: {comment} encoded_key len {len(encoded_key)}", file=sys.stderr)
    ssh_pubkey = io.BytesIO(base64.b64decode(encoded_key))

    # key type
    s_len = int.from_bytes(ssh_pubkey.read(4), byteorder='big')
    key_type = ssh_pubkey.read(s_len).decode('utf-8')
    assert key_type == 'ssh-rsa'

    # exponent
    s_len = int.from_bytes(ssh_pubkey.read(4), byteorder='big')
    exponent = int.from_bytes(ssh_pubkey.read(s_len), byteorder='big')

    # modulus
    s_len = int.from_bytes(ssh_pubkey.read(4), byteorder='big')
    modulus = int.from_bytes(ssh_pubkey.read(s_len), byteorder='big')

    return (key_type, exponent, modulus)

class Server:
    def __init__(self, path):
        self.path = path
        self.server_bin = os.path.join(path, 'nervcenter')
        # Set LLVM_PROFILE_FILE to nervecenter.profraw to enable profiling
        self.server = subprocess.Popen(['unbuffer', self.server_bin], text=True, stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT, env={'LLVM_PROFILE_FILE': 'nervecenter.profraw'})
        self.stdout = self.server.stdout
        self.server_output = ''
        self.control = None
        self.sensors = []
        self.wait_for_launch()

    def wait_for_launch(self):
        while True:
            line = self.stdout.readline()
            print(line, end='')
            self.server_output += line
            # [+] Listening on port 2000, fd=3
            if '[+] Listening on port' in line:
                # get the port number
                self.port = int(line.split('port ')[-1].split(',')[0])
                break

    def close(self):
        # read all remaining lines and close the server
        self.server.send_signal(signal.SIGINT)
        self.server_output += self.stdout.read()
        self.server.wait()

    def connect_control(self):
        control_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        control_sock.connect(('localhost', self.port))
        self.control = ControlConnection(control_sock, self)

    def connect_sensors(self, n=1):
        for _ in range(n):
            sensor_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sensor_sock.connect(('localhost', self.control.sensor_port))
            self.sensors.append(SensorConnection(sensor_sock, self))

    def get_private_key(self):
        if self.control is None:
            raise Exception('Must connect control first')
        N, D = None, None
        while True:
            line = self.stdout.readline()
            print(line, end='')
            self.server_output += line
            if line.startswith('N = '):
                N = int(line.split(' = ')[-1])
            elif line.startswith('D = '):
                D = int(line.split(' = ')[-1])
            if N is not None and D is not None:
                break
        return N, D

    def __del__(self):
        self.close()

    def __repr__(self):
        return f'Server(pid={self.server.pid}, control={self.control}, sensors={self.sensors})'

class Connection:
    SERVER = 1
    CLIENT = 2
    def __init__(self, sock, parent):
        self.parent = parent
        self.sock = sock
        self.sock.settimeout(1)
        self.log = []
        self.pending_data = b''

    def recvuntil(self, match, bufsize=1024):
        buf = b''
        while True:
            try:
                if self.pending_data:
                    data = self.pending_data
                    self.pending_data = b''
                else:
                    data = self.sock.recv(bufsize)
                    self.log.append((Connection.SERVER, data))
                # print(data, match, match in data)
                if not data:
                    break
                buf += data
            except socket.timeout:
                pass
            if (idx := buf.find(match)) != -1:
                self.pending_data = buf[idx+len(match):]
                break
        return buf

    def send(self, data):
        self.log.append((Connection.CLIENT, data))
        self.sock.send(data)

    def wait_and_parse(self, match, delim=b'\n'):
        data = self.recvuntil(match)
        return data.split(match)[1].split(delim)[0]

    def close(self):
        self.sock.close()

    def __del__(self):
        self.close()

    def transcript(self, msg=''):
        # show client data in red
        CLIENT_COLOR = '\033[91m'
        RESET = '\033[0m'
        def colorize(direction, data):
            if direction == Connection.SERVER:
                return data
            return CLIENT_COLOR+data+RESET
        print(f'{msg}Transcript between server and {CLIENT_COLOR}client{RESET}:')
        last_direction = None
        buf = b''
        for direction, data in self.log:
            # Need to collect all data from the same direction before printing,
            # or utf8 chars may be split across chunks
            if direction != last_direction:
                if buf:
                    print(colorize(last_direction, buf.decode()), end='')
                buf = b''
            buf += data
            last_direction = direction
        if buf:
            print(colorize(direction, buf.decode()), end='')
        print()

class ControlConnection(Connection):
    def __init__(self, sock, parent):
        super().__init__(sock, parent)
        self.authenticated = False
        self.wait_for_sensor_port()
        self.wait_for_prompt()

    def wait_for_sensor_port(self):
        self.sensor_port = int(self.wait_and_parse(b'Session sensor port is: '))

    def wait_for_prompt(self):
        return self.recvuntil(b'Enter your choice: ')

    def send_and_wait(self, data):
        self.send(data)
        return self.wait_for_prompt()

    def __repr__(self):
        return f'ControlConnection(sensor_port={self.sensor_port})'

    def sign(self, n, e, d, m):
        print(f"Signing message: {m}")
        print(f"n = {n}")
        print(f"e = {e}")
        print(f"d = {d}")
        signing_bin = os.path.join(self.parent.path, 'solver', 'signmessage')
        cmd = [signing_bin, str(n), str(e), str(d), str(m)]
        try:
            sig = subprocess.check_output(cmd, text=True)
        except subprocess.CalledProcessError as e:
            print(f"Error signing message: {e}")
            return None
        return sig.strip()

    def authenticate_real(self):
        E = 65537
        N, D = self.parent.get_private_key()
        self.send(b'1\n')
        chal = self.recvuntil(b'Response: ')
        for line in chal.split(b'\n'):
            if line.startswith(b'Challenge: '):
                chal = line.split(b'Challenge: ')[-1].decode()
                break
        sig = self.sign(N, E, D, chal)
        if sig is None:
            return False
        self.send_and_wait(sig.encode() + b'\n')
        self.authenticated = True

    # ============= Unauthenticated Menu =============
    # 1. Exercise the authentication code. Won't succeed and that's fine.
    def authenticate_fail(self):
        self.send(b'1\n')
        self.recvuntil(b'Response: ')
        self.send_and_wait(b'blah\n')

    # 2. Get the server's public key.
    def get_key(self):
        data = self.send_and_wait(b'2\n')
        for line in data.split(b'\n'):
            if line.startswith(b'ssh-rsa'):
                return line.strip().decode()

    # 3. Sensor system halt
    def sensor_halt(self):
        self.send_and_wait(b'3\n')

    # 4. Sensor system resume
    def sensor_resume(self):
        self.send_and_wait(b'4\n')

    # 5. MAGI status
    def magi_status(self):
        self.send(b'5\n')
        self.send_and_wait(b'\n')

    # 6. Help
    def help(self):
        self.send_and_wait(b'6\n')

    # 7. Exit
    def exit(self):
        self.send(b'7\n')
        self.recvuntil(b'Goodbye!')

    # 1234 (secret) -- dump fd_bits
    def dump_fd_bits(self):
        data = self.send_and_wait(b'1234\n')
        for line in data.split(b'\n'):
            if line.startswith(b'fd_bits = '):
                return line.decode().split(' = ')[-1]

    # ============= Authenticated Menu =============
    # 1. Send flag
    def send_flag(self):
        assert self.authenticated
        self.send_and_wait(b'1\n')

    # 2. Show credits
    def show_credits(self):
        assert self.authenticated
        self.send_and_wait(b'2\n')

    # 3. Exit
    def exit_auth(self):
        assert self.authenticated
        self.send_and_wait(b'3\n')
        self.recvuntil(b'Goodbye!')

    def self_test(self):
        self.authenticate_fail()
        self.get_key()
        self.sensor_halt()
        self.sensor_resume()
        self.magi_status()
        self.help()
        # Send an invalid command
        self.send_and_wait(b'blah\n')
        self.authenticate_real()
        self.send_flag()
        # self.show_credits()
        self.exit_auth()

class SensorConnection(Connection):
    def __init__(self, sock, parent):
        super().__init__(sock, parent)
        self.wait_for_sensor_id()
        self.wait_for_prompt()

    def wait_for_sensor_id(self):
        # This is sensor ID 7.
        self.sensor_id = int(self.wait_and_parse(b'This is sensor ID ', delim=b'.'))

    def wait_for_prompt(self):
        return self.recvuntil(b'> ')

    def send_and_wait(self, data):
        self.send(data)
        return self.wait_for_prompt()

    def __repr__(self):
        return f'SensorConnection(sensor_id={self.sensor_id})'

    # LIST command
    def list(self):
        self.send_and_wait(b'LIST\n')

    # EXAMINE <arg> command
    def examine(self, arg):
        self.send_and_wait(b'EXAMINE ' + arg.encode() + b'\n')

    def report(self):
        self.send_and_wait(b'REPORT\n')

    def help(self):
        self.send_and_wait(b'HELP\n')

    def exit(self):
        self.send_and_wait(b'QUIT\n')

    def self_test(self):
        self.list()
        self.examine('Ramiel')
        self.examine('blah')
        self.report()
        self.help()
        # Send an invalid command
        self.send_and_wait(b'blah\n')
        self.exit()

    def send_oob(self, data):
        self.sock.send(data, socket.MSG_OOB)

def main(argv):
    s = Server(argv[1])
    s.connect_control()
    s.connect_sensors(5)
    for sensor,byte in zip(s.sensors[1:],b'test'):
        sensor.send_oob(bytes([byte]))
    s.sensors[0].self_test()
    s.control.self_test()
    s.close()
    # Print transcripts
    s.control.transcript('[CONTROL] ')
    print()
    for sensor in s.sensors:
        sensor.transcript(f'[SENSOR {sensor.sensor_id}] ')
        print()
    print(f'[SERVER OUTPUT]')
    print(s.server_output)

if __name__ == '__main__':
    main(sys.argv)
