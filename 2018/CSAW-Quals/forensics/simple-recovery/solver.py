#!/usr/bin/env python3

import sys


def decrypt_row(a, b):
    return xor(bytes.fromhex(a), bytes.fromhex(b))


def xor(a, b):
    """XORs two byte arrays of the same length."""
    ia = int.from_bytes(a, sys.byteorder)
    ib = int.from_bytes(b, sys.byteorder)
    xored = ia ^ ib
    return xored.to_bytes(len(a), sys.byteorder)


file_path = 'disk.img'
stripe_size = 256
disk_count = 3

fd = []

if __name__ == "__main__":
    with open('solved-' + file_path, 'wb') as f:
        for i in range(disk_count - 1):
            fd.append(open(file_path + str(i), 'rb'))
            fd[i].read(8)

        total_file_size = int.from_bytes(fd[0].read(8), sys.byteorder)
        fd[1].read(8)

        parity_position = 2
        flip = 0

        for file_size in range(0, total_file_size, stripe_size * 2):
            file_row = [i.read(stripe_size) for i in fd]
            # print('before: ' + repr(file_row))

            if parity_position in range(disk_count - 1):
                # print(repr(xor_row))
                xored = file_row[0]
                for row in file_row[1:]:
                    xored = xor(xored, row)
                # print('xored:' + repr(xored))

                # print('parity: ' + repr(parity_position))
                for i in range(disk_count - 1):
                    if i == parity_position:
                        # print(repr(i) + ' is recovered')
                        file_row[i] = xored

            if flip == 2:
                file_row.insert(0, file_row.pop())
            # print('after:  ' + repr(file_row))
            for stripe in file_row:
                f.write(stripe)

            parity_position = (parity_position - 1) % disk_count
            flip = (flip + 1) % 3
