import re
import subprocess
import base64
from Crypto.Util.number import getPrime, bytes_to_long, long_to_bytes
import random, codecs
import sys
from pwn import * 

MORSE_CODE_DICT = { 'A':'.-', 'B':'-...',
                    'C':'-.-.', 'D':'-..', 'E':'.',
                    'F':'..-.', 'G':'--.', 'H':'....',
                    'I':'..', 'J':'.---', 'K':'-.-',
                    'L':'.-..', 'M':'--', 'N':'-.',
                    'O':'---', 'P':'.--.', 'Q':'--.-',
                    'R':'.-.', 'S':'...', 'T':'-',
                    'U':'..-', 'V':'...-', 'W':'.--',
                    'X':'-..-', 'Y':'-.--', 'Z':'--..',
                    '1':'.----', '2':'..---', '3':'...--',
                    '4':'....-', '5':'.....', '6':'-....',
                    '7':'--...', '8':'---..', '9':'----.',
                    '0':'-----', ', ':'--..--', '.':'.-.-.-',
                    '?':'..--..', '/':'-..-.', '-':'-....-',
                    '(':'-.--.', ')':'-.--.-'}
def decrypt(message):
    message += ' '
    decipher = ''
    citext = ''
    for letter in message:
        if (letter != ' '):
            i = 0
            citext += letter
        else:
            i += 1
            if i == 2 :
                decipher += ' '
            else:
                decipher += list(MORSE_CODE_DICT.keys())[list(MORSE_CODE_DICT.values()).index(citext)]
                citext = ''
    return decipher

def main(enc):
    asciinum = [decrypt(m.strip()) for m in enc.split("/")]
    b64 = ''.join([chr(int(n)) for n in asciinum])
    rsalist = [n.split("=")[1].strip() for n in base64.b64decode(b64).decode('utf-8').split("\n")]
    n = rsalist[0]
    e = rsalist[1]
    c = rsalist[2]

    decrypted = subprocess.run(['python3', '/home/kali/Desktop/RsaCtfTool/RsaCtfTool.py', '--attack', 'cube_root','-n',n,'-e',e,'--uncipher',c], capture_output=True)
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    result = ansi_escape.sub('', decrypted.stdout.decode('utf-8'))
    rot13 = eval(result.split("\n")[-2].split(" : ")[1]).decode('utf-8') 
    name = codecs.decode(rot13,'rot_13')
    print(name)
    return name

if __name__ == '__main__':
    #connection = remote("crypto.chal.csaw.io",5001)
    connection = remote("localhost",12345)

    for i in range(10):
      try:
          output = connection.recvuntil(">> ".encode('utf-8'))
          enc = output.decode('utf-8').split("\r\n")[3].strip()
          print(output[:100])
          name = main(enc)
          connection.sendline(name.encode('utf-8'))
      except:
          output = connection.recvuntil("\r\n".encode('utf-8'))
          print(output)

    
