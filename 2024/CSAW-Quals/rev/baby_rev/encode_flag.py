import base64
from pathlib import Path


encoded_flag = base64.b64encode('csawctf{N3v3r_pr073c7_s3ns171v3_1nf0rm4710n_us1ng_jus7_3nc0d1ng!_#3nc0d1ng_1s_n0t_3ncryp710n!}'.encode())

values = [r'\x{:02x}'.format(ord(letter)) for letter in encoded_flag.decode()]

data = []
for i in range(0, len(values), 8):
    data.append('\n{"' + ''.join(val for val in values[i:i+8]) + '"},')

data = '{' + ''.join(line for line in data)[:-1] + '\n};'
Path('./data.h').write_text(data )