from pwn import remote, process

host = "18.218.197.210" #"crypto.chal.csaw.io"
port = 5009 # 5009
server = remote(host, port)
#server = process('python3 ./server.py', shell=True)

def get_pubkey():
	server.recvuntil(b"key:\n\n")
	server.recvuntil(b": ")
	N = int(server.recvuntil(b",")[:-1].decode('utf-8'))
	server.recvuntil(b": ")
	p = int(server.recvuntil(b",")[:-1].decode('utf-8'))
	server.recvuntil(b": ")
	q = int(server.recvuntil(b",")[:-1].decode('utf-8'))
	server.recvuntil(b"[")
	h = [int(e) for e in server.recvuntil(b"]")[:-1].decode('utf-8').replace('\n       ',' ').split(', ')]
	return N,p,q,h

def bitflipper(ct):
	ct_int = int(ct,16)
	num_bits = len(bin(ct_int))
	for i in range(16): #for i in range(num_bits):
		server.recvuntil(b"\n> ")
		new_ct = ct_int ^ (1<<i)
		string_to_send = " ".join(["decrypt", hex(new_ct)[2:]])
		server.sendline(string_to_send.encode('utf-8'))
		server.recvline()
		data = server.recvline()
		if b'...' in data:
			print(str(i).zfill(3)+' --> Error in decrypting!')
		else:
			print(str(i).zfill(3)+' --> '+data.decode('utf-8'))

N,p,q,h = get_pubkey()
#print(N,p,q,h)
server.recvuntil(b"The password ciphertext is ")
pwd_ct = server.recvuntil(b"\n").strip().decode('utf-8')
print(pwd_ct)
bitflipper(pwd_ct)
server.interactive()
