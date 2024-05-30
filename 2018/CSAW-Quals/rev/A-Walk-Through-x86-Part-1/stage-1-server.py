#!/usr/bin/env python3
from time import sleep


def input_answer(prompt, answer):
    user_input = input(prompt)
    if user_input == answer:
        return 1
    else:
        return 0


def main():
    if not input_answer("What is the value of dh after line 129 executes? (Answer with a one-byte hex value, prefixed with '0x')\n", "0x00"):
        return 0

    if not input_answer("\nWhat is the value of gs after line 145 executes? (Answer with a one-byte hex value, prefixed with '0x')\n", "0x00"):
        return 0

    if not input_answer("\nWhat is the value of si after line 151 executes? (Answer with a two-byte hex value, prefixed with '0x')\n", "0x0000"):
        return 0

    if not input_answer("\nWhat is the value of ax after line 169 executes? (Answer with a two-byte hex value, prefixed with '0x')\n", "0x0e74"):
        return 0

    if not input_answer("\nWhat is the value of ax after line 199 executes for the first time? (Answer with a two-byte hex value, prefixed with '0x')\n", "0x0e61"):
        return 0

    return 1


if __name__ == "__main__":
    for i in range(40):
        print('.', end='', flush=True)
        sleep(0.25)
    print("\nWelcome!\n")

    if(main()):
        print("flag{rev_up_y0ur_3ng1nes_reeeeeeeeeeeeecruit5!}")
    else:
        print("Sorry, try again!")
