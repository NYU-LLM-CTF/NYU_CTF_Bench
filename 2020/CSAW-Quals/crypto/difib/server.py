#!/usr/bin/env python3
"""
server.py

    Consumes a message that is decrypted from the verses given, and returns the flag once done.
"""

MESSAGE = "just some unnecessary text that holds absolutely no meaning whatsoever and bears no significance to you in any way"

def main():
    message = input("> Alright messenger, what did the boss tell you to tell me? Better be right or you're not getting in!\n")
    if message.strip() == MESSAGE:
        with open("flag.txt", "r") as fd:
            print("\n" + fd.read().strip())
        return 0

    print("Sounds bogus! Scram, you're not getting in!")
    return 1


if __name__ == "__main__":
    exit(main())
