# Simple library to encrypt data using aes.
# Uses PyCryptodome (python3 -m pip install pycryptodome)
# Can also be called from the command line to decrypt data
# $ python3 my_aes.py -h
# usage: my_aes.py [-h] (--decrypt | --encrypt) --password PASSWORD filename
# 
# positional arguments:
#   filename
# 
# optional arguments:
#   -h, --help           show this help message and exit
#   --decrypt
#   --encrypt
#   --password PASSWORD
try:
    from Crypto.Hash import SHA256
    from Crypto.Protocol.KDF import scrypt
    from Crypto.Cipher import AES
except ImportError:
    raise ImportError("PyCryptodome not installed")
from base64 import b64encode

def main():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--password', required=True)
    parser.add_argument('filename')
    args = parser.parse_args()

    data = decrypt_from_file(args.password, args.filename)
    print(data)

def encrypt_to_file(password, filename, data):
    key = generate_key_from_password(password)
    cipher = AES.new(key, AES.MODE_EAX)
    ciphertext, tag = cipher.encrypt_and_digest(data.encode())

    with open(filename, 'wb') as fout:
        for fitem in (cipher.nonce, tag, ciphertext):
            fout.write(fitem)

def decrypt_from_file(password, filename):
    key = generate_key_from_password(password)

    with open(filename, 'rb') as fin:
        nonce      = fin.read(16)
        tag        = fin.read(16)
        ciphertext = fin.read()

    cipher = AES.new(key, AES.MODE_EAX, nonce)
    data = cipher.decrypt_and_verify(ciphertext, tag)
    return data

def generate_key_from_password(password):
    return scrypt(
        password,
        '', # Salt (empty)
        16, # Key length
        N=2**14,
        r=8,
        p=1
    )

if __name__ == '__main__':
    main()
