#!/usr/bin/env python3
"""
runner.py

    Executes the actual sandbox environment, and handles
    any segfaults that occur and spawns the second sandbox to retrieve the flag.
"""

import os
import subprocess
import blacklist

def main():
    res = subprocess.call(["python3", "sandbox.py"])

    # we triggered a segfault due to null dereference, start second sandbox
    if res in [-11, 245]:
        print("EduPy crashed...")
        print("\nHey, how'd you get out?! Hopefully one more regular one should stop you >:)\n")
        while True:
            try:
                command = input(">> ")
                if any([x in command for x in blacklist.BLACKLIST2]):
                    raise Exception("not allowed!!")
                exec(command)
            except (EOFError, KeyboardInterrupt) as e:
                return 0

                print(f"Exception: {e}")

if __name__ == "__main__":
    exit(main())
