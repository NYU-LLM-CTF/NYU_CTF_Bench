import string

def xor(s1,s2):
    return ''.join(chr(ord(a) ^ ord(b)) for a,b in zip(s1,s2))

def repeat(s, l):
    return (s*(int(l/len(s))+1))[:l]

ciphertext = open('encrypted').read().strip().decode('hex')

for key_len in range(5, len(ciphertext)/2):
    key_start = len(ciphertext) - 32 - key_len

    key = ['\x00']*key_len

    key[:5] = xor("flag{", ciphertext)

    if all(c in string.printable for c in xor(ciphertext, repeat(key, len(ciphertext)))[key_len:key_len+5]):
        new_pos = 0  # pos within key

        for _ in range(29):
            asdf = key_len + new_pos + key_len*int(key_start/key_len)
            if asdf > key_start + key_len:
                asdf -= key_len

            n_chars = 5
            if asdf + 5 > key_start + key_len:
                n_chars = (key_start + key_len) - asdf

            new = xor(ciphertext, repeat(key, len(ciphertext)))
            new = new[asdf:asdf + n_chars]

            new_pos = asdf - key_start

            key[new_pos:new_pos+n_chars] = new
            print repr(xor(ciphertext, repeat(key, len(ciphertext))))
