from base64 import b64decode

CIPHERTEXT_FILE = 'ciphertext.txt'

encrypted = None
with open(CIPHERTEXT_FILE, 'r') as f:
  s = f.read()
  encrypted = b64decode(s)

for i in range(256):
  s = ''.join(chr(ord(c) ^ i) for c in encrypted)
  print s
