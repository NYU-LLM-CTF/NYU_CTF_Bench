from Crypto.Util.Padding import pad, unpad
from Crypto.Cipher import AES
import os

def encrypt(txt: str) -> str:
    try:
        padded = pad(txt.encode(), 16)

        c = AES.new(os.environ['AES_KEY'].encode(), AES.MODE_CBC, iv=os.environ['AES_IV'].encode())
        ciphertext = c.encrypt(padded).hex()
        
        return ciphertext
    except Exception as s:
        print(s)

def main() -> None:
    text = input("Please enter the plaintext: ")
    text.strip()
    print(encrypt(text))

if __name__ == "__main__":
    main()

