import binascii
from pwn import *

"""  
RUN:   python solver.py 
USAGE: Solve part of the generated ciphertext, where 6,7,8 are blocks to decode: 

    e.x attempt_send("aaaaaa", "bbbbb", [6,7,8])
                         ^         ^
                      input_a    input_b        // input_a and input_b are the prefix and suffix 
                                                // expandable by user to create even blocks                  
"""

AES_BLOCK_SIZE = 16
host = "crypto.chal.csaw.io"
port = 6000         # 6000
server = remote(host, port)
attempt_no = 0

""" Get ciphertext from server """


def get_ct(p, prefix, suffix):
    p.recvuntil(">")
    p.send("1\n")
    p.recvuntil(">")
    p.send(prefix + "\n")
    p.recvuntil(">")
    p.send(suffix + "\n")
    p.recvuntil("A plane flies overhead flying a banner that reads: ")
    ct_bytes = p.recvuntil("'").strip()[:-1]
    ct = ct_bytes.decode()
    return (ct)


""" Check your guess for padding """


def ask_oracle(p, ct):
    global attempt_no
    attempt_no +=1
    if (attempt_no % 100 == 0):
        print("ATTEMPT NU: ", attempt_no)
    p.recvuntil(">")
    p.send("2\n")
    p.recvuntil(">")
    p.send(ct + "\n")
    p.recvline()
    ans = p.recvline()
    if ans.__contains__(b"Valid"):
        return True
    return False


""" Copy blocks from/to"""


def block_copy(msg_raw, b_from, b_to):
    blk_size = AES_BLOCK_SIZE
    msg = bytearray(msg_raw)
    msg[b_to * blk_size: (b_to + 1) * blk_size] = msg[b_from * blk_size: (b_from + 1) * blk_size]
    return bytes(msg)


""" Copy the block of interest to the end of the ciphertext (CT)"""


def block_modify_ct(ct64, b_from, verbose=False):
    d = b64d(ct64)
    if verbose:
        print_chunks(d, "BEFORE CP")
    blocks = get_blocks(d)
    d = block_copy(d, b_from, len(blocks) - 1)
    if verbose:
        print_chunks(d, "AFTER  CP")
    ct = b64e(d)
    if verbose:
        print_chunks(binascii.hexlify(d), "HEX CT   ", 32)
    return ct



""" Automate reqeusts to server to guess padding """


def attempt_send(p, input_a, input_b, blocks_to_decode):
    decoded, decoded_blocks = [], []
    input_b += "b" * len(blocks_to_decode) * AES_BLOCK_SIZE
    last_block_to_dec, decoded = blocks_to_decode[-1], []
    while True:
        ct_offic = get_ct(p, input_a, input_b)
        ct_temp = block_modify_ct(ct_offic, last_block_to_dec)
        resp = ask_oracle(p, ct_temp)
        if resp:
            if hex_decipher_text_c(ct_temp, last_block_to_dec, decoded):
                decoded_blocks.insert(0, "".join(decoded))
                print("DONE ==> : ", "".join(decoded), input_b, input_a)
                return "".join(decoded_blocks)

            input_a += "a"
            input_b = input_b[:-1]



""" Decrypt end of block when padding guessed correctly """


def hex_decipher_text_c(msg, block_num, decoded):
    blocks = split_len(b64d(msg), 16)
    block_n = blocks[-2][-1]
    block_p = blocks[block_num - 1][-1]
    cd = chr(int("10", 16) ^ block_n ^ block_p)
    decoded.insert(0, cd)
    flag_so_far = "".join(decoded)
    if flag_so_far.__contains__("flag{"):
        return True
    print("CHAR DECIPHERED: ", cd, "".join(decoded), " ATTEMPT_NU: ", attempt_no)
    return False


################ HELPER FUNCTIONS ###############
""" print blocks of CT for readability """


def print_chunks(blocks_raw, msg, chunk_size=16):
    blocks = get_blocks(blocks_raw, chunk_size)
    [print("\r[+] ", msg, " Block ", i, block) for i, block in enumerate(blocks)]


def get_blocks(msg, chunk_size=16):
    return split_len(msg, chunk_size)


def split_len(seq, length):
    return [seq[i:i + length] for i in range(0, len(seq), length)]


################ ################## ###############

prefix, suffix = "poodle", "99999"
print(attempt_send(server, prefix, suffix, [7,8]))
server.close()
exit(0)
