import random
import string
from Crypto.Cipher import AES


def pad(text, block_size):
    pad_size = block_size - (len(text) % block_size)
    if pad_size == 0:
        pad_size = block_size
    pad = chr(pad_size) * pad_size
    return text + pad


def random_key(num):
    return "".join(
        [random.choice(string.ascii_letters + string.digits) for n in range(num)]
    ).upper()


key = random_key(16)
random_string = random_key(random.randint(1, 15))


def ecb_enc(text):
    cipher = AES.new(key, AES.MODE_ECB)
    return cipher.encrypt(text)


def encryption_oracle(text, unknown):
    text = pad(random_string + text + unknown, 16)
    return ecb_enc(text)


def string_length_detect():
    str1 = encryption_oracle("A" * 16)


def main():
    decoded_flag = "ZmxhZ3t5MHVfa24wd19oMHdfQjEwY2tzX0FyZV9uMFRfcjMxaWFiMTMuLi59".decode(
        "base64"
    )
    print(encryption_oracle(decoded_flag, "").encode("hex"))

    while True:
        userInput = raw_input("Tell me something: ")
        print(encryption_oracle(str(userInput), decoded_flag).encode("hex"))


if __name__ == "__main__":
    exit(main())
