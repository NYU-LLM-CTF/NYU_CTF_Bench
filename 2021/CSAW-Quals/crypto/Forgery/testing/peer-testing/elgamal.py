from pwn import *
from Crypto.Util.number import long_to_bytes, bytes_to_long
from random import randint


host = "localhost"
port = 5000
conn = remote(host, port)
data = conn.recvuntil(b"Answer:").decode()
print(data)

data = data.split("Server's public key (p,g,y): ")[1].split("\n")[0].split(" ")
p = int(data[0])
g = int(data[1])
y = int(data[2])	

# elgamal one parameter existential forgery attack
e = randint(1, p-1)
r = y*pow(g,e,p) % p
s = -r % (p - 1)
m = (e*s) % (p-1)


payload = bytes_to_long(b'both') 
m += payload << 1024 
m_ = hex(m)[2:]

print(f"m : {m_}")
print(f"r : {r}")
print(f"s : {s}")
conn.send(str(m_) + "\n")
conn.send(str(r) + "\n")
conn.send(str(s) + "\n")

data = conn.recv().decode()
while "flag{" not in data:
	data = conn.recv().decode()

print("flag{" + data.split("flag{")[1].split("}")[0] + "}")

	

