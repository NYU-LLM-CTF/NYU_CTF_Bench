import struct
import socket
import pbkdf2
import hashlib
from Cryptodome.Cipher import AES
import base64
import requests
import math


password = "1691176061"
url = "http://localhost:3333/cmd"

def pack_arg(arg):
    pack_str = ">c" + str(len(arg)) + "s"
    res = struct.pack(pack_str, len(arg).to_bytes(1, 'big'), bytes(arg, 'utf-8'))
    return res
def pad(text, block_size):
    """
    Performs padding on the given plaintext to ensure that it is a multiple
    of the given block_size value in the parameter. Uses the PKCS7 standard
    for performing padding.
    """
    no_of_blocks = math.ceil(len(text)/float(block_size))
    pad_value = int(no_of_blocks * block_size - len(text))

    if pad_value == 0:
        return text + block_size.to_bytes(1, 'big') * block_size
    else:
        return text + pad_value.to_bytes(1, "big") * pad_value

def sign(data):
    key = hashlib.pbkdf2_hmac("sha256", password.encode("utf-8"),bytes("\x00\x00\x00\x00", 'utf-8'), 100,32)
    iv=bytes("\x00"*16, "utf-8")
    aes = AES.new(key, AES.MODE_CFB, iv=iv, segment_size=128)
    aes.iv = iv
    pad_text = pad(data, 16)
    ciphertext = aes.encrypt(pad_text)
    return data + hashlib.md5(ciphertext).digest()





res = struct.pack(">i", 0x01)
res += 0xfe.to_bytes(1, 'big')
res += 0x01.to_bytes(1, 'big')
res += pack_arg("ls")
res = sign(res)

data = base64.b64encode(res).decode('utf-8')
post_data = {'data': str(data)}
x = requests.post(url, json=post_data)
decoded = base64.b64decode(x.text)
print(str(decoded[2:]))


res = struct.pack(">i", 0x01)
res += 0xfe.to_bytes(1, 'big')
res += 0x02.to_bytes(1, 'big')
res += pack_arg("cat")
res += pack_arg("flag.txt.gpg")
res = sign(res)

data = base64.b64encode(res).decode('utf-8')
post_data = {'data': str(data)}
x = requests.post(url, json=post_data)
decoded = base64.b64decode(x.text)
f = open("encytped.gpg", "wb")
f.write(decoded[2:])

