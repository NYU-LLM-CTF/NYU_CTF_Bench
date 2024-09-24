from pwn import *
import os
import string
from Crypto.Util.number import long_to_bytes


host = "localhost"
port = 5000

conn = remote(host, port)

data = conn.recvuntil(b"What is the plaintext?").decode() 
print(data)


N = int(data.split("\r\n")[2].split("N = ")[1])
e = int(data.split("\r\n")[3].split("e = ")[1])
c = int(data.split("\r\n")[4].split("c = ")[1])

print(f"N : {N}")
print(f"e : {e}")
print(f"c : {c}")


command = ["./RsaCtfTool/RsaCtfTool.py", "-n", str(N), "-e", str(e), "--uncipher", str(c), "--timeout", "2"]

ext_hex_pt = os.popen(" ".join(command)).read().split("HEX : ")[1][2:].split("\n")[0].lstrip("0")[:-4]

pt = "".join([chr(int(ext_hex_pt[i:i+2], 16)) for i in range(0, len(ext_hex_pt), 2)])

print(f"pt : {pt}")
#pt = "Wiener wiener chicken dinner"

conn.send(pt + "\n")
data = conn.recvuntil(b"What is the plaintext?").decode()
print(data)


N = int(data.split("\r\n")[4].split("N = ")[1])
e = int(data.split("\r\n")[5].split("e = ")[1])
c = int(data.split("\r\n")[6].split("c = ")[1])

print(f"N : {N}")
print(f"e : {e}")
print(f"c : {c}")


command = ["./RsaCtfTool/RsaCtfTool.py", "-n", str(N), "-e", str(e), "--uncipher", str(c), "--timeout", "2"]
ext_hex_pt = os.popen(" ".join(command)).read().split("HEX : ")[1][2:].split("\n")[0].lstrip("0")[:-4]

pt = "".join([chr(int(ext_hex_pt[i:i+2], 16)) for i in range(0, len(ext_hex_pt), 2)])

print(f"pt : {pt}")

pt = "Who came up with this math term anyway?"

conn.send(pt + "\n")
data = conn.recvuntil("What would you like to decrypt? (please respond with an integer)").decode()
print(data)

N = int(data.split("\r\n")[4].split("N = ")[1])
e = int(data.split("\r\n")[5].split("e = ")[1])
c = int(data.split("\r\n")[6].split("c = ")[1])

print(f"N : {N}")
print(f"e : {e}")
print(f"c : {c}")
print(N.bit_length())

upper_limit = N
lower_limit = 0
i = 1


while i <= 1024:
    chosen_ct = c*pow(2**i, e, N) % N
    print(f"lower: {lower_limit}")
    print(f"upper: {upper_limit}")
    
    conn.send(str(chosen_ct) + "\n")
    data = conn.recvuntil("Would you like to continue? (yes/no)").decode()
    #print(data.split("\r\n"))
    lsb = int(data.split("\r\n")[2][-1])
   
    if lsb == 0:
        upper_limit = (upper_limit + lower_limit)//2
    elif lsb == 1:
        lower_limit = (lower_limit + upper_limit)//2
    else:
    	print ("Unsuccessfull")
    	break
    
    i += 1
    
    if i == 1024:
    	conn.send("no" + "\n")
    	break
    conn.send("yes" + "\n")
    conn.recvuntil("What would you like to decrypt? (please respond with an integer)").decode()

pt = long_to_bytes(lower_limit).decode()
#print(pt)
pt = pt[:-1] + "e"
print(pt)


"""
###to delete##
conn.send("0000" + "\n")
conn.recvuntil("Would you like to continue? (yes/no)").decode()
conn.send("no" + "\n")
#####
"""

conn.recvuntil(b"What is the plaintext?").decode()

#pt = "Totally did not mean to put an oracle there"

conn.send(pt + "\n")
data = conn.recvuntil(b"What is the plaintext?").decode()
print(data)

N = int(data.split("\r\n")[4].split("N = ")[1])
e = int(data.split("\r\n")[5].split("e = ")[1])
d0 = int(data.split("\r\n")[6].split("d0 = ")[1])
c = int(data.split("\r\n")[7].split("c = ")[1])

print(f"N : {N}")
print(f"e : {e}")
print(f"d0 : {d0}")
print(f"c : {c}")

d0bits = 512
nBits = 1024
r = 2^(d0bits)
x = var('x')
stop = False
for k in range(1,e+1):
	if stop:
		break
	print(f"k : {k}")
	s_candidates = solve_mod([e*d0 - k*(N-x+1) == 1], 2^d0bits)
	for cand_s in s_candidates:
		s = ZZ(cand_s[0])
		p = var('p')
		p0_candidates = solve_mod([p^2 - s*p + N == 0], 2^d0bits)
		for cand_p0 in p0_candidates:
			p0 = ZZ(cand_p0[0])
			print(f"p0 : {p0}")
			
			"""
			q = var('q')
			q0_candidates = solve_mod([p0*q == N], 2^d0bits)
			q0 = ZZ(q0_candidates[0][0])
			print(f"q0 : {q0}")
			"""
			

			PR.<z> = PolynomialRing(Zmod(N))
			f = r*z + p0
			f = f.monic()
			roots = f.small_roots(beta=0.50)
			print(f"roots : {roots}")
			
			if roots:
				x0 = roots[0]
				p = gcd(r*x0 + p0, N)
				q = N//ZZ(p)
				d = int(pow(e,-1,(p-1)*(q-1)))
				m = long_to_bytes(pow(c,d,N))
				print(m.decode())
				stop = True
pt = m.decode()		
conn.send(pt + "\n")

data = conn.recv().decode()
while "flag{" not in data:
	data = conn.recv().decode()	
flag = "flag{" + data.split("flag{")[1].split("}")[0] + "}"
print(f"flag : {flag}")	
			


