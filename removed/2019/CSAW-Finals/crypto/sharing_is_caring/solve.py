
#!/usr/bin/python2
import re
import random
import subprocess as sp
from pwn import *

DEBUG = False

POL = '5x^1 + 87x^9000'
THRESHOLD = '9001'
NUM_SHARE = '9000'


def debug(msg):
    if DEBUG:
        print("[DEBUG] Got from server: '%s'" % msg)


def connect():
    return remote("localhost", 12312)
    

def recv_shares(r):
    shares = []
    for i in range(int(NUM_SHARE)):
        line = r.recvline().decode().strip()
        debug(line)
        x, y_a, y_b = re.findall(r'\d+', line)
        shares.append((x, y_a, y_b))
    write_shares(shares)
    return shares


def write_shares(shares):
    reals_file = open("reals", "w")
    imags_file = open("imags", "w")
    for i, real, imag in shares:
        reals_file.write("{} {}\n".format(i, real))
        imags_file.write("{} {}\n".format(i, imag))
    reals_file.close()
    imags_file.close()


def get_secret(shares, p):
    print(p)
    p = sp.Popen(['sage', 'lag.sage', str(p)], stdout=sp.PIPE)
    print("[*] Cracking secret...")
    status = p.wait()
    print("[+] Finished cracking with status %s" % status)
    secret = int(p.stdout.read().strip())
    print("[+] Got secret %s" % secret)
    return secret


if __name__ == '__main__':
    r = connect()
    # prime header
    debug(r.recvline())
    # get prime
    raw_p = r.recvline().strip()
    debug(raw_p)
    p = int(raw_p)
    print("[+] Got prime %d" % p)
    # header polynomial
    debug(r.recvline())
    # send ploynom
    r.sendline(POL)
    print("[+] Setting polynom to: %s" % POL)
    # header threshold
    debug(r.recvline())
    debug(r.recvline())
    # send threshold
    r.sendline(THRESHOLD)
    print("[+] Setting threshold to: %s" % THRESHOLD)
    # header num shares
    debug(r.recvline())
    # send num shares
    r.sendline(NUM_SHARE)
    print("[+] Setting the number of shares to: %s" % NUM_SHARE)
    # header shares
    debug(r.recvline())
    debug(r.recvline())
    debug(r.recvline())
    # recv shares
    shares = recv_shares(r)
    print("[+] Got the shares")
    # header secret
    debug(r.recvline())
    # send secret
    secret = get_secret(shares, p)
    r.sendline(str(secret))
    # get flag
    while True:
        try:
            print("[+] Got from server: '%s'" % r.recvline())
        except:
            print("[+] Closed")
            break
    
