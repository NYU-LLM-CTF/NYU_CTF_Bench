from pwn import *

def string_to_bytes(string):
    byte_array = []
    i = 0
    while i < len(string):
        if string[i:i+2] == '\\x':
            byte_array.append(bytes.fromhex(string[i+2:i+4]))
            i += 4
        else:
            byte_array.append(string[i].encode('utf-8'))
            i += 1
    return b''.join(byte_array)

with open("list.txt", 'r') as f:
    passwords = f.read().split('\n')[:-1]

with open("/home/ctfplayer/ctf_files/encrypted_passwords.txt", 'rb') as f:
    given_enc_passwords = f.read().split(b'\n')[:-1]

if __name__ == '__main__':
    connection = remote("crypto.chal.csaw.io",5000)
    enc_passwords = {}
    for p in passwords:
        connection.recvuntil(">> ".encode('utf-8'))
        connection.sendline(p.encode('utf-8'))
        output = connection.recvuntil(">> ".encode('utf-8'))
        connection.sendline(b'Y')
        enc_p = string_to_bytes(output.split(b'\'')[1].decode('utf-8'))
        enc_passwords[enc_p] = [p, len(p)]
    for enc_p in given_enc_passwords:
        if enc_p not in enc_passwords:
            for p in enc_passwords.keys():
                if enc_passwords[p][1] >= len(enc_p):
                    key = b''.join((ord(x) ^ y).to_bytes(1,'big') for (x,y) in zip(enc_passwords[p][0],p))
                    admin_pass = b''.join((x ^ y).to_bytes(1,'big') for (x,y) in zip(key,enc_p))
                    flag = admin_pass.decode('utf-8')
                    print(enc_p, '-->', flag)
                    print("flag{" + flag + "}")
                    break
            break
