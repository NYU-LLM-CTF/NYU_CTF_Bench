import hashlib
import time
import itertools

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--hash', default='aaa')
parser.add_argument('--saltset', default='abcdefghijklmnopqrstuvwxyz')
parser.add_argument('--salt-len', default=4, type=int)
parser.add_argument('--hash-len', default=3, type=int)
parser.add_argument('--num-ids', default=1000, type=int)

args = parser.parse_args()

hash_test = args.hash

print(f'[*] Testing collisions of valid combos for {hash_test}')

start_time = time.perf_counter()

instances = 0

for i in range(args.num_ids):
    for s in itertools.product(args.saltset, repeat=args.salt_len):
        t = (str(i) + ''.join(s)).encode()
        h = hashlib.md5(t).hexdigest()[:args.hash_len]
        if h == hash_test:
            instances += 1

end_time = time.perf_counter()
print(f'[*] Got {instances} instances for {hash_test}') 
print(f'[*] Took {end_time-start_time} seconds')
