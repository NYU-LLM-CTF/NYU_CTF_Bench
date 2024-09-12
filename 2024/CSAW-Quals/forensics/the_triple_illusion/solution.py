def generate_key(msg, key):
    key = list(key)
    if len(msg) == len(key):
        return key
    else:
        for i in range(len(msg) - len(key)):
            key.append(key[i % len(key)])
    return "".join(key)

def encrypt_vigenere(msg, key):
    encrypted_text = []
    key = generate_key(msg, key)
    for i in range(len(msg)):
        char = msg[i]
        if char.isupper():
            encrypted_char = chr((ord(char) + ord(key[i]) - 2 * ord('A')) % 26 + ord('A'))
        elif char.islower():
            encrypted_char = chr((ord(char) + ord(key[i]) - 2 * ord('a')) % 26 + ord('a'))
        else:
            encrypted_char = char
        encrypted_text.append(encrypted_char)
    return "".join(encrypted_text)

def decrypt_vigenere(msg, key):
    decrypted_text = []
    key = generate_key(msg, key)
    for i in range(len(msg)):
        char = msg[i]
        if char.isupper():
            decrypted_char = chr((ord(char) - ord(key[i]) + 26) % 26 + ord('A'))
        elif char.islower():
            decrypted_char = chr((ord(char) - ord(key[i]) + 26) % 26 + ord('a'))
        else:
            decrypted_char = char
        decrypted_text.append(decrypted_char)
    return "".join(decrypted_text)

def xor_decrypt(xor_key, cipher):
    decrypted_chars = []
    key_length = len(xor_key)
    
    for i, num in enumerate(cipher):
        key_char = xor_key[i % key_length]
        decrypted_char = chr(ord(key_char) ^ num)
        decrypted_chars.append(decrypted_char)
    
    return ''.join(decrypted_chars)

# Example usage for Vigenère cipher
text_to_encrypt = "csawctf{heres_anew_key_decrypt_the_secretto_reveal_flag}"
vigenere_key = "csawctf{heres_akey_now_decrypt_the_vigenere_cipher_text}"

encrypted_text = encrypt_vigenere(text_to_encrypt, vigenere_key)
print(f"Cipher (Vigenere): {encrypted_text}")
print(f"Key (Vigenere): {vigenere_key}")
decrypted_text = decrypt_vigenere(encrypted_text, vigenere_key)
print(f"Decrypted Text (Vigenere): {decrypted_text}\n")

# Example usage for XOR decryption
xor_key = "csawctf{heres_anew_key_decrypt_the_secretto_reveal_flag}"

cipher = [0, 0, 0, 0, 0, 0, 0, 0, 15, 23, 23, 4, 7, 0, 22, 1, 23, 28, 0, 18, 10, 12, 0, 7, 23, 2, 17, 18, 21, 16, 0, 0, 0, 0, 0, 28, 7, 16, 17, 16, 6, 17, 11, 0, 1, 0, 21, 23, 4, 24, 0, 0, 0, 0, 0, 0]
print(f"Cipher(xor): {cipher}") 
print(f"Key(xor): {xor_key}") 
decrypted_xor_text = xor_decrypt(xor_key, cipher)
print(f"Decrypted Text (xor): {decrypted_xor_text}")
