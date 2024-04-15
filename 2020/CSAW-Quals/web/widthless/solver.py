#!/usr/bin/env python3
import base64
import requests
import zwsp_steg
from zwsp_steg.steganography import *

ALLOWED = [
    b"\xe2\x80\x8b",
    b"\xe2\x80\x8c",
    b"\xe2\x80\x8d",
    b"\xe2\x80\x8e",
    b"\xe2\x80\x8f"
]

def unstegify(content):
    final_str = ""
    for i in range(0, len(content), 3):
        target = content[i + 1]
        if target == 139:
            final_str += ZERO_WIDTH_SPACE
        elif target == 140:
            final_str += ZERO_WIDTH_NON_JOINER
        elif target == 141:
            final_str += ZERO_WIDTH_JOINER
        elif target == 142:
            final_str += LEFT_TO_RIGHT_MARK
        elif target == 143:
            final_str += RIGHT_TO_LEFT_MARK
    return final_str


def main():

    # solve for first part
    resp = requests.get("http://127.0.0.1:5000/")
    content = list(resp.content)
    pwd_one = unstegify(content)

    print(zwsp_steg.decode(pwd_one))

    # solve for second part
    resp = requests.get("http://127.0.0.1:5000/ahsdiufghawuflkaekdhjfaldshjfvbalerhjwfvblasdnjfbldf/alm0st_2_3z")
    content = [c for c in resp.content.split() if c in ALLOWED]
    decoded = b"".join(content)
    print(zwsp_steg.decode(str(decoded.decode())))


if __name__ == "__main__":
    exit(main())
