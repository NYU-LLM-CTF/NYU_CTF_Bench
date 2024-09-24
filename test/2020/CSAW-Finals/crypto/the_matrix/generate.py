#!/usr/bin/env python3
"""
generate.py

    Run this to generate a `messages.txt` to handout to players
"""
from encoder import Enc, M

if __name__ == "__main__":
    ecm = M(3, 3)
    ecm.populate([
        3, 6, 1,
        9, 4, 2,
        1, 5, 7
    ])

    plaintexts = []
    with open("answers.txt", "r") as fd:
        plaintexts = fd.readlines()

    out = open("messages.txt", "w")
    for pt in plaintexts:
        e = Enc(ecm, pt)
        out.write(str(e.encrypt()) + "\n")

    out.close()
