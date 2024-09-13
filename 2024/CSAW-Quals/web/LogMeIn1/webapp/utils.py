import re
from Crypto.Util.Padding import pad, unpad
import json
import os


def is_alphanumeric(text):
    pattern = r'^[a-zA-Z0-9]+$'
    if re.match(pattern, text):
        return True
    else:
        return False
    
def LOG(*args, **kwargs):
    print(*args, **kwargs, flush=True)


# Some cryptographic utilities
def encode(status: dict) -> str:
    try:
        plaintext = json.dumps(status).encode()
        out = b''
        for i,j in zip(plaintext, os.environ['ENCRYPT_KEY'].encode()):
            out += bytes([i^j])
        return bytes.hex(out)
    except Exception as s:
        LOG(s)
        return None

def decode(inp: str) -> dict:
    try:
        token = bytes.fromhex(inp)
        out = ''
        for i,j in zip(token, os.environ['ENCRYPT_KEY'].encode()):
            out += chr(i ^ j)
        user = json.loads(out)
        return user
    except Exception as s:
        LOG(s)
        return None
