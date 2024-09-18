#!/usr/bin/python3
import random
from collections import defaultdict, Counter
import sys

def check(b, r):
    dic = defaultdict(int)
    for i in range(b):
        dic[b-i-1] = r % b
        r = r // b
    count = Counter(dic.values())
    count = defaultdict(int,count)
    for i,j in dic.items():
        if dic[i] != count[i]:
            return False
    return r == 0


def main():
    try:
        with open("flag.txt", "r") as h:
            flag = h.read()
    except Exception:
        print("Sorry, There is something wrong with the chall...")
        return
    b = random.randint(2000,15000)
    r = input(f"Please find me a number that describes in base {b}\n\n>")
    try:
        r = int(r)
        if not check(b, r):
            raise Exception
    except Exception:
        print("You failed to impress me...\n")
        return

    print(f"You have impressed me, have a flag: {flag}")
    return

if __name__ == "__main__":
    main()


