from pwn import *
import binascii

MAGIC=73
host = "rev.chal.csaw.io"
port = 5000

conn = remote(host, port)

def main():
	
	data = conn.recv().decode()
	iv_a = data.split("\n")[1].split(" : ")[1]
	iv_b = b"".join([b"\xff" * MAGIC if iv_a[i]=='1' else b"\x00" * MAGIC for i in range(MAGIC)])
	conn.send(binascii.hexlify(iv_b) + b"\n")
	data = conn.recv().decode()
	while "flag{" not in data:
		data = data + conn.recv().decode()
	print(data)


main()
