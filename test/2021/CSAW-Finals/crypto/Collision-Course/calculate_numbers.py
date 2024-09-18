import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--id', required=True, help="Range of ids to use", type=int)
parser.add_argument('--salt', required=True, help="Total possible salts", type=int)
parser.add_argument('--hash-length', required=True, type=int)
parser.add_argument('--md5-speed', default='500', help="kmd5/s", type=int)

args = parser.parse_args()

total_hash_space = args.id * args.salt

print(f'[*] Total hash space: {total_hash_space:,}')

total_hash_space_cracktime = total_hash_space / (args.md5_speed*1000) / 60

print(f'[*] Estimated single entry hash space crack time: {total_hash_space_cracktime:0.2f} m')

print(f'[*] Estimated all entry hash space crack time: {args.id*total_hash_space_cracktime/60:0.2f} h')

hash_k = 16 ** args.hash_length
print(f'[*] Single-entry collisions: {total_hash_space/hash_k:0.2f}')

id_collision_probability = (args.id/hash_k)
print(f'[*] ID collision possibility (for known salt): {100*id_collision_probability:0.5f} %')

for i in range(1,5):
    print(f'[*] How many salt/id combos match {i} records: {(id_collision_probability**i)*args.salt}')

print(f'[*] Time to crack all IDs with known salt: {args.id**2/(args.md5_speed*1000)/60:0.2f} m')
