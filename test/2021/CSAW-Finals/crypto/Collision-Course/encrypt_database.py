import csv
import random
import argparse
import hashlib
import my_aes

parser = argparse.ArgumentParser()
parser.add_argument('--salt', required=True)
parser.add_argument('--passwordfile', required=True)
args = parser.parse_args()

# Check the salt
assert len(args.salt) == 3
for character in args.salt:
    assert character in 'abcdefghijklmnopqrstuvwxyz0123456789'

# Read in database
data = list()
with open('unencrypted_database.csv') as fin:
    dictreader = csv.DictReader(fin)
    for row in dictreader:
        data.append(row)

# Shuffle the data order
random.shuffle(data)

# Key for encrypting the passwords file
encryption_password = ''

ids = list()
# Write out database with hashed IDs
with open('encrypted_database.csv', 'w') as fout:
    fieldnames = data[0].keys()
    writer = csv.DictWriter(fout, fieldnames = fieldnames)
    writer.writeheader()
    
    for row in data:
        assert int(row['id']) > 0 and int(row['id']) <= 500
        # Use the unhashed ID for the key
        encryption_password += row['id']

        # Add the ID to the salt
        salted_id = row['id'] + args.salt
        hashed_id = hashlib.md5(salted_id.encode()).hexdigest()

        # Only take the first four characters of the md5
        hashed_id = hashed_id[:4]
        row['id'] = hashed_id

        # Check if we've duplicated
        assert row['id'] not in ids
        ids.append(row['id'])

        writer.writerow(row)

with open(args.passwordfile) as fin:
    passwords = fin.read()

print(encryption_password)

my_aes.encrypt_to_file(encryption_password, 'password.bin', passwords)
