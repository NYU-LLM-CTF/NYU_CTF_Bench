"""
solver.py

    Uses bifid cipher to decrypt ciphertext from given perfect pangrams.
"""

import base64

from secretpy import Bifid
from secretpy import CryptMachine

# bad characters to remove from the key
REMOVE = [" ", ".", ",", "+", "-", ":", "@", "'", "!", "?", "j", "\n"]


def main():

    # parse out each verse
    with open("ramblings", "r") as fd:
        keystrings = fd.readlines()

    # filter and cleanup into a 25-char key
    keys = []
    for key in keystrings:
        key = key.lower()
        for rm in REMOVE:
            key = key.replace(rm, "")

        # helps us catch characters we don't want
        if len(key) != 25:
            continue
        keys += [key]

    # take each cleaned up key and encrypt using Bifid cipher
    key = 5
    cm = CryptMachine(Bifid(), key)

    plaintext = u"just some unnecessary text that holds absolutely no meaning whatsoever and bears no significance to you in any way"
    ciphertext = plaintext

    # encrypt plaintext
    for key in keys:
        alphabet = [u'{}'.format(i) for i in list(key)]
        cm.set_alphabet(alphabet)
        ciphertext = cm.encrypt(ciphertext)

    print("Ciphertext generated: {}".format(ciphertext))

    # decrypt plaintext
    final_plaintext = ciphertext
    for key in reversed(keys):
        alphabet = [u'{}'.format(i) for i in list(key)]
        cm.set_alphabet(alphabet)
        final_plaintext = cm.decrypt(final_plaintext)

    print("Final Plaintext recovered: {}".format(final_plaintext))

if __name__ == "__main__":
    main()
