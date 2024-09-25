import random
import string

ALP = list('abcdefghijklmnopqrstuvwxyz')
FEQ = [8, 1, 3, 4, 13, 2, 2, 6, 7, 1, 1, 4, 2, 7, 8, 2, 1, 6, 6, 9, 3, 1, 2, 1, 2, 1]
FLAG = 'flag{h0m0ph0n1c_c1ph3r_15_l0v3}'
FLAG = format(int(FLAG.encode('hex'), 16), 'b').replace('0', 'o').replace('1', 'i')
with open('./plaintext', 'rb') as f:
    MSG = f.read() % FLAG

"""
encryption and decryption implements
"""
def encrypt(msg, key):
    msg = msg.replace('\n', '')
    msg = msg.replace(' ', '')
    enc = ""
    for char in msg:
        if char == ' ':
            enc += ' '
            continue
        else:
            enc_char = str(key[char][(random.randrange(len(key[char])))]) + ','
            enc += enc_char
    return enc[:-1]

def decrypt(enc, key):
    enc = enc.replace('\n', '')
    enc = enc.replace(' ', '')
    enc = enc.split(',')
    msg = ""
    for enc_char in enc:
        for msg_char, arr in key.items():
            if int(enc_char) in arr:
                msg += msg_char
    return msg

def genKey():    # (0~102)
    key = list(x for x in range(0, 103))
    random.shuffle(key)
    idx = 0
    table = dict()
    for cnt in xrange(len(ALP)):
        table[ALP[cnt]] = key[idx:idx+FEQ[cnt]]
        idx += FEQ[cnt]
    with open('key', 'wb') as f:
        f.write(str(table))
    print "[+]Wrote key into file"
    return 0

def genCiphertext():
    # genKey()
    msg = MSG
    with open('key', 'rb') as f:
        key = eval(f.read())

    print "[+]key:", key
    print "[+]Testing Msg:", msg
    enc = encrypt(msg, key)
    print "[+]enc:", enc
    print "================================"
    print decrypt(enc, key)
    assert decrypt(enc, key) == msg.replace('\n', '').replace(' ', '')

def genMsg():
    with open('english_words.txt', 'rb') as f:
        d = f.read()
    d = d.replace('\r', '').split('\n')
    msg = ""
    for x in range(500):
        idx = random.randint(0, len(d))
        msg += d[idx] + ' '
    msg += FLAG
    return msg
    
def solve():
    ciphertext = []
    with open('./ciphertext', 'rb') as f:
        for line in f:
            if line != '\n':
                ciphertext.append(line.split(','))

    # with open('key', 'rb') as f:
    #     key = eval(f.read())
        
    enc1 = ciphertext[0][:-1]
    enc2 = ciphertext[1][:-1]
    key_map = {}
    key = []
    
    for x in xrange(0, 103):
        key_map[str(x)] = list()
        
    for x in xrange(len(enc1)):
        key_map[enc1[x]].append(enc2[x])

    for x in key_map:
        key_map[x] = list(set(key_map[x]))

    key = []
    for x in xrange(0, 103):
        key_item = list()
        for y in key_map:
            if str(x) in key_map[y]:
                key_item += key_map[y]
        key_item = map(int, list(set(key_item)))
        key_item.sort()
        if key_item not in key:
            key.append(key_item)

    return key
def main():
    # genCiphertext() 
    key = solve()
    print "[+]cracked key:", key
    print "l:", len(key)
    with open('./key', 'rb') as f:
        orig_key = f.read()

    orig_key = eval(orig_key)

    for x in orig_key:
        orig_key[x].sort()
        
    print "[+]original key:", orig_key
if __name__ == "__main__":
    main()

