import argparse
import my_aes
import csv
import itertools
import hashlib

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--database', required=True)
    parser.add_argument('--passwordfile', required=True)
    args = parser.parse_args()

    database = []
    with open(args.database) as fin:
        dictreader = csv.DictReader(fin)
        for row in dictreader:
            database.append(row)

    charset = 'abcdefghijklmnopqrstuvwxyz0123456789'
    encryption_password = ''
    for salt in itertools.product(charset, repeat=3):
        salt = ''.join(salt)
        found_salt = True 
        encryption_password = ''
        for row in database:
            try:
                i = crack_id(row['id'], salt)
                encryption_password += str(i)
            except ValueError:
                found_salt = False
                break
        if found_salt:
            print(f"Found valid salt: {salt}")
            data = my_aes.decrypt_from_file(encryption_password, args.passwordfile)
            print(data)


def crack_id(idhash, salt):
    for i in range(501):
        idhash_guess = str(i) + salt
        idhash_guess = hashlib.md5(idhash_guess.encode()).hexdigest()[:4]
        if idhash_guess == idhash:
            return i

    raise ValueError("No valid ID found")

if __name__ == '__main__':
    main()
