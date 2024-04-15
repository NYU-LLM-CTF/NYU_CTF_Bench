from pwn import *
context.log_level='debug'
basis=b""
def get_basis(l):
	global basis
	p.recvline()
	p.sendline(bytes(str(l),encoding='utf8'))
	p.recvline()
	p.sendline(basis+b"+")
	p.readuntil(b"Errors: ")
	tmp=p.read(1)
	if tmp==b"0":
		basis+=b'+'
	else:
		basis+=b'x'
	if l==256 and tmp==b"1":
		p.recvline()
		p.sendline(bytes(str(l),encoding='utf8'))
		p.recvline()
		p.sendline(basis)
		p.recvline()
def get_key():
	global basis
	counter = 0
	res=''
	while counter < 256:
		data=p.readuntil(b"\n")
		y='0'#'1'
		x='1'#'0'
		if(data==b'1.0 + 0.0i\r\n'and basis[counter]==ord('+')):
			res+=y
		elif(data==b'-0.707 + 0.707i\r\n' and basis[counter]==120):
			res+=x
		elif(data==b'0.0 + 1.0i\r\n' and basis[counter]==ord('+')):
			res+=x
		elif(data==b'0.707 + 0.707i\r\n' and basis[counter]==120):
			res+=y
		counter +=1
	print(res)
	return res
#p=remote("127.0.0.1",5000)
p = remote("misc.chal.csaw.io", 5001)
for x in range(1,257):
	get_basis(x)
p.readline()

res=get_key()
key=''
while(res):
	tmp=res[:8]
	num=int(tmp,2)
	key+=chr(num)
	res=res[8:]
context.log_level='debug'
p.recvline()
p.sendline(key)
p.interactive()
