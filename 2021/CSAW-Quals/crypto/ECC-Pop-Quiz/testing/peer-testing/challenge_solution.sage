from pwn import *

def HenselLift(P,p,prec):
	E = P.curve()    
	Eq = E.change_ring(QQ)
	Ep = Eq.change_ring(Qp(p,prec))
	x_P,y_P = P.xy()
	x_lift = ZZ(x_P)
	y_lift = ZZ(y_P)
	x, y, a1, a2, a3, a4, a6 = var('x,y,a1,a2,a3,a4,a6')
	f(a1,a2,a3,a4,a6,x,y) = y^2 + a1*x*y + a3*y -x^3 -a2*x^2 -a4*x -a6
	g(y) = f(ZZ(Eq.a1()),ZZ(Eq.a2()),ZZ(Eq.a3()),ZZ(Eq.a4()),ZZ(Eq.a6()),ZZ(x_P),y)
	gDiff = g.diff()
	for i in range(1,prec):
		uInv = ZZ(gDiff(y=y_lift))
		u = uInv.inverse_mod(p^i)      
		y_lift= y_lift -u*g(y_lift)
		y_lift = ZZ(Mod(y_lift,p^(i+1)))
	y_lift = y_lift+O(p^prec)
	return Ep([x_lift,y_lift])

def SmartAttack(P,Q,p,prec):
	E = P.curve()
	Eqq = E.change_ring(QQ)
	Eqp = Eqq.change_ring(Qp(p,prec))
	P_Qp = HenselLift(P,p,prec)     
	Q_Qp = HenselLift(Q,p,prec)     
	p_times_P = p*P_Qp 
	p_times_Q=p*Q_Qp 
	x_P,y_P = p_times_P.xy() 
	x_Q,y_Q = p_times_Q.xy() 
	phi_P = -(x_P/y_P) 
	phi_Q = -(x_Q/y_Q)    
	k = phi_Q/phi_P 
	k = Mod(k,p) 
	return ZZ(k) 

def MovAttack(G,P,p):
	E = P.curve()
	# Find the embedding degree
	# p**k - 1 === 0 (mod order)
	order = E.order()
	k = 1
	while (p**k - 1) % order:
	    k += 1
	K.<a> = GF(p**k)
	EK = E.base_extend(K)
	PK = EK(P)
	GK = EK(G)
	QK = EK.lift_x(a + 2)  # Independent from PK
	AA = PK.tate_pairing(QK, E.order(), k)
	GG = GK.tate_pairing(QK, E.order(), k)
	dlA = AA.log(GG)
	return dlA

def SingularCurveAttack(P,Q,p):

	F = GF(p)
	x1, y1 = F(P[0]), F(P[1])
	x2, y2 = F(Q[0]), (Q[1])
	a = (y1**2 - y2**2-x1**3 + x2**3)/(x1 - x2)
	b = y1**2 - x1**3 - a*x1
	#print(f"calculated a : {a}\ncalculated b : {b}")
	P.<x> = F[]
	f = x^3 + a*x + b
	f_factors = f.factor()
	r = F(f_factors[1][0] - x)
	# change variables to have the singularity at (0, 0)
	f_ = f.subs(x=x - r)
	x1_ = F(x1 + r)
	x2_ = F(x2 + r)
	P_ = (x1_, y1)
	Q_ = (x2_, y2)
	t = GF(p)(f_.factor()[0][0]-x).square_root()
	# map both points to F_p
	u = (P_[1] + t*P_[0])/(P_[1] - t*P_[0]) % p
	v = (Q_[1] + t*Q_[0])/(Q_[1] - t*Q_[0]) % p
	# use Sage to solve the logarithm
	return discrete_log(v, u)


def recv_data():
	return conn.recvuntil(b"What is the value of 'secret'?:")

def extract_params(data, singular=False):
	lines = [line.decode() for line in data.split(b"\r\n") if line != b""]
	#print("***********************************************")
	for line in lines:
		tmp = line[4:]
		if "???" in tmp:
			continue
		elif "p = " in line:
			p = int(tmp)
			continue
		elif "a = " in line:
			a = int(tmp)
			continue
		elif "b = " in line:
			b = int(tmp)
			continue
		if not singular:
			tmp = line[5:-5].split(" : ")
		else:
			a = "???"
			b = "???"
			tmp = line[5:-2].split("L, ")
			
		if "P1: (" in line:
			P1 = (int(tmp[0]), int(tmp[1]))
			x1, y1 = P1[0], P1[1]
			continue
		elif "P2: (" in line:
			P2 = (int(tmp[0]), int(tmp[1]))
			x2, y2 = P2[0], P2[1]
			continue
		else:
			continue
	
	return p, a, b, x1, y1, x2, y2

def print_params(p, a, b, x1, y1, x2, y2):
	print(f"p = {p}")
	print(f"a = {a}")
	print(f"b = {b}\n")
	print(f"P1 = {(x1, y1)}")
	print(f"P2 = {(x2, y2)}")

host = "crypto.chal.csaw.io"
port = 5002
popquiz_level = 1
conn = remote(host, port)

while popquiz_level < 4:
	try: 
		if popquiz_level == 1:
			data = recv_data()
			#print(data.decode())
			p, a, b, x1, y1, x2, y2 = extract_params(data)
			#print_params(p, a, b, x1, y1, x2, y2)
			E = EllipticCurve(GF(p), [a, b]) 
			assert (E.order() == p) 
			P1 = E([x1, y1])
			P2 = E([x2, y2])
			k = SmartAttack(P1, P2, p, 8)
			#assert (k*P1 == P2)
			print(f"secret : {k}")
			conn.send(str(k) + "\n")
			popquiz_level += 1
			print("[+] Smart's attack part completed...")
			
		elif popquiz_level == 2:
			data = recv_data()	
			#print(data.decode())
			p, a, b, x1, y1, x2, y2 = extract_params(data)
			#print_params(p, a, b, x1, y1, x2, y2)
			E = EllipticCurve(GF(p), [a, b])
			P1 = E([x1, y1])
			P2 = E([x2, y2])
			k = MovAttack(P1, P2, p)
			#assert (k*P1 == P2)
			print(f"secret : {k}")
			conn.send(str(k) + "\n")
			popquiz_level += 1
			print("[+] MOV attack part completed...")
			
		elif popquiz_level == 3:
			data = recv_data()
			#print(data.decode())
			p, a, b, x1, y1, x2, y2 = extract_params(data, True)
			#print_params(p, a, b, x1, y1, x2, y2)
			P1 = (x1, y1)
			P2 = (x2, y2)
			k = SingularCurveAttack(P1, P2, p)
			#assert (k*P1 == P2)
			print(f"secret : {k}")			
			conn.send(str(k) + "\n")		
			popquiz_level += 1
			print("[+] Singular Curve attack part completed...")			
			break
	except Exception:
		print("Something went wrong, starting over...")
		conn = remote(host, port)
		popquiz_level = 1
		continue

data = conn.recv().decode()
while "flag{" not in data:
	data = conn.recv().decode()
print(data)



















