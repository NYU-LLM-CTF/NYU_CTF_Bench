#!/usr/bin/env python3

from Crypto.Cipher import AES
import Crypto.Random

#flag = "flag{ECB_re@lly_sUck$}"
flag_binary = "01100110011011000110000101100111011110110100010101000011010000100101111101110010011001010100000001101100011011000111100101011111011100110101010101100011011010110010010001111101"
flag_dict = {"0" : "ECB", "1" : "CBC"}
print("Hello! For each plaintext you enter, find out if the block cipher used is ECB or CBC. Enter \"ECB\" or \"CBC\" to get the flag!")

def AESEncrypt(plaintext, i):
	# Padding
	length = 16 - (len(plaintext) % 16)
	plaintext += bytes([length])*length
	# Key
	key = Crypto.Random.get_random_bytes(AES.block_size)
	# ECB mode for 0, CBC for 1
	if i == "0":
		cipher = AES.new(key, AES.MODE_ECB)
	else:
		iv = Crypto.Random.get_random_bytes(AES.block_size)
		cipher = AES.new(key, AES.MODE_CBC, iv)

	return cipher.encrypt(plaintext).hex()

def main():
    for i in flag_binary:
        print("Enter plaintext: ")
        plaintext = input()
        ciphertext = AESEncrypt(plaintext.strip().encode('utf-8'),i)
        print("Ciphertext is: ", ciphertext)
        print("ECB or CBC? ")
        ECB_or_CBC = input()
        if(ECB_or_CBC != flag_dict[i]):
            return 1
    return

if __name__ == "__main__":
        main()
