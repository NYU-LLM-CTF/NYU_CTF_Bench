import random
import socket
import struct

CUTOFF_INCREMENT = 0.10
DIRTY_BITS_INCREMENT = 0x50


class Runner(object):
    def __init__(self):
        self.weights = [
            (self.add_random_byte, 40),
            (self.delete_set_byte, 35),
            (self.random_dirty_bits, 14),
            (self.xor_random_byte, 10),
            (self.wipe, 1)
        ]
        self.punishments = []
        for func, weight in self.weights:
            self.punishments += [func for _ in range(weight)]
        self.reset()

    def reset(self):
        self.page = [0 for _ in range(0x1000)]
        self.dirty_bits = [0 for _ in range(0x1000)]
        self.num_dirty_bits = 0x80
        self.random_dirty_bits()

    def random_dirty_bits(self):
        self.dirty_bits = [0 for _ in range(0x1000)]
        for _ in range(self.num_dirty_bits):
            random_byte = 2**random.randint(0, 7)
            self.dirty_bits[random.randint(0, 0xfff)] |= random_byte

    def apply_dirty_bits(self):
        page_copy = list(self.page)
        for i, dirty_byte in enumerate(self.dirty_bits):
            page_copy[i] |= dirty_byte

        return page_copy

    def add_byte(self, index, byte):
        self.page[index] = byte
        dirty = self.apply_dirty_bits()
        return 'MODIFIED ' + hex(index) + 'TO BE: ' + hex(dirty[index])

    def execute(self):
        dirty_page = self.apply_dirty_bits()
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(("pwn.chal.csaw.io", 1006))
        sock.settimeout(5.0)
        payload = b''
        for byte in dirty_page:
            payload += struct.pack('<B', byte)
        sock.sendall(payload)
        print("OUTPUT:")
        print(sock.recv(1024))
        sock.close()

    def add_random_byte(self):
        self.page[random.randint(0, 0xfff)] = random.randint(0, 0xff)

    def delete_set_byte(self):
        set_bytes = []
        for i, byte in enumerate(self.page):
            if byte:
                set_bytes.append(i)
        if set_bytes:
            self.page[random.choice(set_bytes)] = 0

    def xor_random_byte(self):
        random_byte = random.randint(0, 0xff)
        for i in range(len(self.page)):
            self.page[i] ^= random_byte

    def wipe(self):
        self.page = [0 for _ in range(0x1000)]

    def punish(self):
        func = random.choice(self.punishments)
        func()
        return func.__name__

    def print_page(self):
        dirty_page = self.apply_dirty_bits()
        board = '-' * (33 * 3 + 5) + '\n'
        board += '|' + ' ' * 4 + '| '
        board += '\u001b[36;1m\u001b[1m'
        board += ' '.join(['%02X' % x for x in range(32)]) + ' |\n'
        board += '\u001b[0m'
        board += '-' * (33 * 3 + 5) + '\n'
        for i in range(32):
            board += '| ' + '\u001b[36;1m\u001b[1m%02X\u001b[0m' % i + ' | '
            for j in range(32):
                if dirty_page[i * 32 + j]:
                    board += '\u001b[31;1m\u001b[1m'
                else:
                    board += '\u001b[32m'
                board += '%02X' % (dirty_page[i * 32 + j]) + ' '
                board += '\u001b[0m'

            board += '|\n'
        board += '-' * (33 * 3 + 5)
        return board


if __name__ == '__main__':
    r = Runner()
    print(r.print_page())
