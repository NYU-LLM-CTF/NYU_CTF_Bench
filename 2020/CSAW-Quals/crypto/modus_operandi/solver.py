from pwn import *

def ECB_or_CBC(ciphertext):
	#Block size = 16
	#ECB generates identical ciphertext blocks for same plaintext blocks
	#Sending 32*A lets us check if we get two identical blocks
	if ciphertext[0:32] == ciphertext[32:64]:
		return "ECB"
	return "CBC"

def main():
	flag = ""
	flag_dict = {"ECB" : "0", "CBC" : "1"}
	p = remote("localhost", "8000")
	print(p.recvline())
	while(True):
		try:
			p.recvline()
			p.sendline("A"*32)
			p.recvuntil(": ")
			ciphertext = p.recvline().strip().decode("utf-8")
			#print(ciphertext)
			p.recvline()
			value = ECB_or_CBC(ciphertext)
			p.sendline(value)
			flag += flag_dict[value]
		except:
			#print(flag)
			# Get flag from binary format
			n = int(flag, 2)
			print(n.to_bytes((n.bit_length() + 7) // 8, 'big').decode())
			exit(0)

	return 0

if __name__ == "__main__":
	exit(main())
