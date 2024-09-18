#!/usr/bin/env python3

import sys
import base64
import io
import argparse
import random
import time

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

# Mutators for each mode. They return a list of tuples:
#   (mutated_modulus, description)
# description is a string describing the mutation, to be used
# in the output filename.
def bitflip(n, args):
    key_bits = n.bit_length()
    # Do args.k random bitflips
    which_bits = []
    for _ in range(args.k):
        which_bit = random.randint(0, key_bits - 1)
        n = n ^ (1 << which_bit)
    which_bits.sort()
    which_str = ','.join(map(str, which_bits))

    return [ (n, which_str) ]

def bitset(n, args):
    key_bits = n.bit_length()
    if args.k > 24 and not args.random:
        print(f"Cowardly refusing to generate {2**args.k} max k is 24 in this mode", file=sys.stderr)
        sys.exit(1)
    keys = []
    # produce all 2^k variants of n with the k most/least significant bits set
    if not args.random:
        mutations = range(0, 2**args.k)
    else:
        mutations = [random.getrandbits(args.k) for _ in range(args.random)]
    for mut in mutations:
        mut_fmt = f"{{:0{args.k}b}}"
        mod_fmt = f"{{:0{key_bits}b}}"
        mut_bin = mut_fmt.format(mut)
        mod_bin = mod_fmt.format(n)
        lsbstr = 'lsb' if args.lsb else 'msb'
        if args.lsb:
            mut_n = int(mod_bin[:-args.k] + mut_bin, 2)
        else:
            mut_n = int(mut_bin + mod_bin[args.k:], 2)
        keys.append((mut_n, f'{mut_bin}_{lsbstr}'))
    return keys

def byteextend(n, args):
    byte_len = (n.bit_length() + 7) // 8
    n_bytes = int.to_bytes(n, length=byte_len, byteorder='big')
    if args.k > 2 and not args.random:
        print(f"Cowardly refusing to generate {256**args.k} max k is 2 in this mode", file=sys.stderr)
        sys.exit(1)
    keys = []
    # produce all 256^k variants of n extended by k bytes
    if not args.random:
        mutations = range(0, 256**args.k)
    else:
        mutations = [random.getrandbits(args.k*8) for _ in range(args.random)]
    for mut in mutations:
        mut_bytes = int.to_bytes(mut, length=args.k, byteorder='big')
        lsbstr = 'lsb' if args.lsb else 'msb'
        if args.lsb:
            mut_n = int.from_bytes(n_bytes + mut_bytes, byteorder='big')
        else:
            mut_n = int.from_bytes(mut_bytes + n_bytes, byteorder='big')
        keys.append((mut_n, f'{mut_bytes.hex()}_{lsbstr}'))
    return keys

def main():
    parser = argparse.ArgumentParser(description='Parse SSH public key and generate k-bit variants')
    parser.add_argument('ssh_pubkey', help='SSH public key')
    parser.add_argument('--mode', choices=['bitflip', 'bitset', 'byteextend', 'print'], default='bitset', help='Mutate mode')
    parser.add_argument('-k', type=int, default=5, help='Key bits (or bytes) to mutate')
    parser.add_argument('--lsb', action='store_true', help='Apply to the least significant bits (default: mutate MSB)')
    parser.add_argument('-o', '--output_prefix', default='ssh_key_mut', help='Output file prefix')
    parser.add_argument('-r', '--random', type=int, default=None, metavar='R', help='For exaustive mutators, instead sample R mutations')
    args = parser.parse_args()

    _, exponent, modulus = parse_key(open(args.ssh_pubkey).read())
    if args.mode == 'print':
        print(exponent, modulus)
        return

    mutators = {
        'bitflip': bitflip,
        'bitset': bitset,
        'byteextend': byteextend,
    }
    mutator = mutators[args.mode]
    start = time.time()
    mutants = mutator(modulus, args)
    end = time.time()
    for mut, desc in mutants:
        fname = f"{args.output_prefix}_{args.mode}_{desc}.txt"
        with open(fname, 'w') as f:
            print(exponent, mut, file=f)
        print(f"Wrote {fname}")
    print(f"Generated {len(mutants)} {args.mode} mutations for {args.ssh_pubkey} in {end-start:.2f}s")

if __name__ == '__main__':
    main()