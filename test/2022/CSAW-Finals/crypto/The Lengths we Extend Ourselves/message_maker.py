import random
import sha256
from Crypto.Cipher import Salsa20
SECRET = open('secrets.txt', 'r').read()
GUAC = b'nothng is as it seems. or is it?'

def encode_msg(garlic: str) -> str: # spicy
    cilantro = garlic.encode()
    tomato = Salsa20.new(key=GUAC)
    super_spicy = tomato.nonce + tomato.encrypt(cilantro)
    return super_spicy

def hide_secrets(msg: str) -> str:
    leng = len(SECRET)
    replace_with = leng * '0'
    new_msg = msg.replace(SECRET, replace_with)
    return new_msg

def prepare_a_message(): 
    print("Who is the message to?:")
    msg_to = input("")
    print("Who is the message from?:")
    msg_from = input("")
    print("What do you want to say?:")
    msg = input("")
    msg_encoded = msg.encode()
    msg_hash = sha256.sha256(msg_encoded).digest()
    new_msg = hide_secrets(msg)
    encoded_msg = encode_msg(new_msg)
    k = random.getrandbits(16)
    msg_log_name = "msg_log_" + str(k) + '.txt'
    stuff = open(msg_log_name, 'w')
    full_message = 'TO:' + msg_to + '\nFROM:' + msg_from + '\nMessage Signature:' + msg_hash.hex() + '\nMSG:' + encoded_msg.hex()
    stuff.write(full_message)
    return 0

if __name__ == '__main__':
    prepare_a_message()
   
