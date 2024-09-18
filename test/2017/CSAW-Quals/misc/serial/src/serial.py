#!/usr/bin/env python3
import sys
import random

def send(msg, flip_prb=0.9):
    for c in msg:
        recvd = False
        while not recvd:
            c_bits = [ord(c) >> i & 1 for i in range(7,-1,-1)]
            parity = c_bits.count(1) % 2
            if random.random() < flip_prb:
                c_bits[random.randrange(len(c_bits))] ^= 1
            bits = [0] + c_bits + [parity, 1]
            print(''.join(str(b) for b in bits))
            sys.stdout.flush()
            while True:
                resp = sys.stdin.read(1)
                if resp.isdigit():
                    recvd = int(resp)
                    break

if __name__ == "__main__":
    print("8-1-1 even parity. Respond with '1' if you got the byte, '0' to retransmit.")
    send("flag{@n_int3rface_betw33n_data_term1nal_3quipment_and_d@t@_circuit-term1nating_3quipment}\n")
