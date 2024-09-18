#!/usr/bin/env python3
"""
server.py

    Consume the hex answer from the user, and returns the final flag for CTF.
"""

if __name__ == "__main__":
    print("Hello Morpheus. Back from the mission so quickly? I see.")
    answer = input("Well what flags have you discovered? See, if I like what you have, I'll be willing to trade with you...\n\n> ")
    if answer == "4fb81eac0729a" or answer == "4fb81eacud29":
        with open("flag.txt", "r") as fd:
            print("\n" + fd.read())
