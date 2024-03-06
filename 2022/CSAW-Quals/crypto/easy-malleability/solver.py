#from gmpy2 import divm, mpz, mul, powmod
from pwn import remote, process
import sys
import time
import binascii

host = "localhost" #"crypto.chal.csaw.io"
port = 5000 # 5009

server = remote(host, port)
#server.interactive()
#server = process('python3 ./server.py', shell=True)

#def byte_to_int(str):
#	return int(str.hex(), 16)

#def hex_to_byte(hex):
#	return bytes.fromhex(("0" if len(hex) % 2 else "") + hex)



def encrypt_message(msg):
	server.send(" ".join(["encrypt", msg.hex()]) + "\n")
	server.recvline()
	ct = server.recvuntil(b"\n").strip()
	#print("encrypt_message: ct = " + str(ct))
	server.recvuntil(b"\n> ")
	return ct

def decrypt(ct):
	server.send(b" ".join([b"decrypt", ct])+b"\n")
	server.recvline()
	pt = server.recvuntil(b"\n").decode()
	#print("plaintext = " + str(pt))
	server.recvuntil(b"\n> ")
	return(pt)

# Adds exactly one to what presumably is a low-order byte of some ciphertext (i.e. in the padding somewhere)
def increment_ct_byte(ct, offset_from_end):
	#print("ct = " + str(ct))
	ct_bytes = binascii.unhexlify(ct)
	ct_bytes_list = list(ct_bytes)
	#print("ct_bytes_list = " + str(ct_bytes_list))
	ct_bytes_list[len(ct_bytes_list)-offset_from_end]=ct_bytes_list[len(ct_bytes_list)-offset_from_end]+1 #1
	new_ct = binascii.hexlify(bytes(ct_bytes_list))
	return new_ct

def main():
	server.recvuntil(b"The password ciphertext is ")
	pwd_ct = server.recvuntil(b"\n").strip()
	print("pwd_ct = " + str(pwd_ct))
	server.recvuntil(b"\n> ")

	new_ct = increment_ct_byte(ct=pwd_ct, offset_from_end=2)
	print("Old ct = " + str(pwd_ct))
	print("New ct = " + str(new_ct))
	#msg = b"This is a test"
	#ct = encrypt_message(msg)
	#print("ct = " + str(ct))
	password = decrypt(new_ct).strip()[:12]
	print("The password is " + str(password))

	server.send(" ".join(["solve_challenge", password])+"\n")
	server.interactive()

	'''Junk from testing
	#msg = b"This is a test"
	#server.send(" ".join(["encrypt", msg.hex()]) + "\n")
	#server.interactive()
	#ct = server.recvuntil("\n").strip()
	#server.send(b" ".join([b"execute", ct, binascii.hexlify(msg)])+b"\n")
	#execute(ct, msg)
	#server.recvuntil("exit\n")

	#execute(ct, msg)
	#server.recvuntil("exit\n")

	#execute(ct, msg)
	#server.recvuntil("exit\n")

	new_ct = increment_ct_byte(ct=ct, offset_from_end=2)
	print("Old ct = " + str(ct))
	print("New ct = " + str(new_ct))
	execute(new_ct, msg)
	server.interactive()

	msg = b"This is a test"
	server.send(" ".join(["encrypt", msg.hex()]) + "\n")
	#server.interactive()
	ct = server.recvuntil("\n").strip()
	server.send(b" ".join([b"execute", ct, binascii.hexlify(msg)])+b"\n")
	server.recvuntil("exit\n")
	server.interactive()
	#server.recvuntil("execute <ciphertext> <command>\n")
	server.recvuntil("exit\n")
	#server.send("encrypt 61616161")
	#msg = b"test message"
	msg = b"cat flag.txt"
	server.send(" ".join(["encrypt", msg.hex()]) + "\n")
	#server.interactive()
	flag_ct = server.recvuntil("\n").strip()
	#server.interactive()
	#print("flag_ct = " + str(flag_ct))
	flag_ct_bytes = binascii.unhexlify(flag_ct)
	flag_ct_bytes_list = list(flag_ct_bytes)
	#print("flag_ct_bytes_list = " + str(flag_ct_bytes_list))

	server.recvuntil("exit\n")
	msg2 = b"cat flag.txta"
	server.send(" ".join(["encrypt", msg2.hex()]) + "\n")
	#server.interactive()
	wrong_ct = server.recvuntil("\n").strip()
	#server.interactive()
	#print("wrong ciphertext = " + str(wrong_ct))
	wrong_ct_bytes = binascii.unhexlify(wrong_ct)
	wrong_ct_bytes_list = list(wrong_ct_bytes)
	#print("wrong_ct_bytes_list = " + str(wrong_ct_bytes_list))

	# Test solution
	#flag_ct_bytes_list[len(flag_ct_bytes_list)-2]=flag_ct_bytes_list[len(flag_ct_bytes_list)-2]+1 #1

	#new_ct = binascii.hexlify(bytes(flag_ct_bytes_list))
	#print(b"new_ct = " + new_ct)
	#print(str(new_ct.__class__))
	#server.send(b" ".join([b"execute", new_ct, binascii.hexlify(msg)])+b"\n")


	# Test attempt to cheese the flag
	server.send(b" ".join([b"execute", wrong_ct, binascii.hexlify(msg)])+b"\n")
	server.interactive()
	'''

if __name__ == "__main__":
	main()
