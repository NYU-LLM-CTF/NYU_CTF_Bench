


# CSAW - ECC-PopQuiz

![challenge_json](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/challenge_json.JPG)

In this challange we are interacting with a server that generate parameters which used to create an elliptic curve. We are also given `P1, P2` (two points over the curve) such that the following condition is met: `P2 = secret*P1`. Our target is to find secret, and move on to the next case. 
In ECC, the security is based on the fact that it is not feasible to solve the elliptic curve discrete logarithm problem. However, we are given special cases which make some room for known attacks. 

## Case 1 - Smart's Attack

![smart_part](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/smart_part.JPG)

According to the description of the challenge, we know that we are supposed to quized about ECC attacks, which mean that there are high chance that in every case we are given we should find a different attack to use, according to the parameters given. In the first question we are asked `Are you smart enough to crack this?` which hints about "Smart's Attack". If you didn't catch that you could also try every known attack, in case the conditions for the attack to succeed are met. Smart in one of its papers describes a linear time method of computing the ECDLP in curves over a field 𝐹𝑝 such that #𝐸(𝐹𝑝) = 𝑝. 
Lets use `sage` to write a small script that validate it.
```
p = 89839996137262766214523008916288277520454963509062772873376712482635122182481
a = 21782015965216748259055159348930797314268996884578908521123301121799191461186
b = 19060248880287277540197027792912251232060326776480855951005948793571254123638

P1 = (77871255041948278869222860019165014056557906021500637748036164316844729016906, 88460158836727903580348057705510471926588621318627338871441935608854245115961)
P2 = (76478391592010904846143072745503024266206051236336487228382706900655666635083, 87792981823180833491913647476113495881605097331075960015655523774367005101246)

E = EllipticCurve(GF(p), [a, b]) 
print (f"#E(Fp) == p : {E.order() == p}") 

output:
> #E(Fp) == p : True
```
At this point we know that Smart's attack met the conditions for its success, so we can proceed with scripting the attack itself. I found great source here: [Smart's Attack](https://wstein.org/edu/2010/414/projects/novotney.pdf).
We are given example of a case that the attack works, in sage syntax which is perfect!
All we have to do is to generalized the function so it could handle given parameters. We end up with a complete generic code:
```
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
```

Also, another link that might be interesting: [Smart's Attack - Qp Iso to Fp](https://crypto.stackexchange.com/questions/70454/why-smarts-attack-doesnt-work-on-this-ecdlp).
Then all we left to do is run the attack with the given parameters to get the "Success!" and move on to the next part.

![smart_completion](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/smart_completion.JPG)

## Case 2 - MOV Attack


![mov_explain](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/mov_explain.png)

![mov_part](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/mov_part.JPG)

Lets use `sage` to write a script that validate the condition for the attack to succeed.
```
p = 485910523233219594326856978971469021638540203
a = 485910523233219594326856978971469021638540202
b = 0

P1 = (336634239690522474259121862672755101819691722, 415833806364376685511431250812320077392376144)
P2 = (81901185502450824788997188258595097973134661, 94461209519012087694350797011043713258815271)

E = EllipticCurve(GF(p), [a, b]) 
order = E.order()
k = 1
while (p**k - 1) % order:
    k += 1
   
print(f"#E(Fp) | p^k-1 : True for k={k}")

output:
> #E(Fp) | p^k-1 : True for k=2
```
At this point we know that MOV attack met the conditions for its success, so we can proceed with scripting the attack itself. I found a great source here: [MOV Attack](https://gist.github.com/mcieno/f0c6334af28f60d244fa054f5a1c22d2).
We are given example of a case that the attack works, in sage syntax which is again - perfect!
All we have to do is to build a function that handle with given parameters so it could handle our specific case. We end up with a complete generic code:
```
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
```
Then all we left to do is run the attack with the given parameters to get the “Success!” and move on to the next and final part.

![mov_completion](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/mov_completion.JPG)


## Case 3 - Singular Curve

![singular_part](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/singular_part.JPG)

In that part of the challenge, we are given just two points on the curve and the prime number `p`. From the message given `Part 3 --> This singular question remains between you and completion!` , its probably a singular curve, but without a and b which this time are not given, we can't validate the condition. So first of all, lets understand the condition and then calculate `a, b` to be able to validate the condition! A non-singular curve, means that the curve has no cusps or self-intersections. This is equivalent to the condition `4a^3 + 27b^2 != 0`. Hence, singular curve will met the opposite condition. 

Lets use `sage` to write a script that calculate a, b and validate the condition for the attack to succeed.
```
p = 68631194594036195884357677477116918914324171641966039460459583351977765510283
F = GF(p)

x1 = F(62503609971993904857716813507533723645233914937547713111272446894209047740675)
y1 = F(21758564281097739675536204594515787208960284017075651181023596943203397881994)
x2 = F(30412816901436154911886940995254483276555483814092180976367096352962981678989) 
y2 = F(68362473905409614897948973571747380819619874512962206757839815567654666977065)

# How do we calculate a&b? Using the elliptic curve equation of course:    
# (I)  : y1^2 = x1^3 + a*x1 + b	 
# (II) : y2^2 = x2^3 + a*x2 + b
# (I) - (II) : y1^2 - y2^2 = x1^3 - x2^3 + a(x1 - x2) 
# 			   a = (y1^2 - y2^2 - x1^3 + x2^3) / (x1 - x2)
# a-->(I)	   b = y1^2 - x1^3 - a*x1 

a = (y1**2 - y2**2 - x1**3 + x2**3)/(x1 - x2)
b = y1**2 - x1**3 - a*x1

print(f"a = {a} ; b = {b}")
print (f"4*(a^3) + 27*(b^2) == 0 : {4*(a**3) + 27*(b**2) == 0}") 

output:
> a = 68631194594036195884357677477116918914324171641966039460459583351977765510280 ; b = 2
> 4*(a^3) + 27*(b^2) == 0 : True
```
At this point we know that it is a singular curve, so we can proceed with scripting the attack itself. I found a great source here: [calculate dl on singular curve](https://crypto.stackexchange.com/questions/61302/how-to-solve-this-ecdlp). And we got it in sage syntax, we couldn't ask for more, just some tiny fixes and we are ready to go!
```
def SingularCurveAttack(P,Q,p):
	F = GF(p)
	x1, y1 = F(P[0]), F(P[1])
	x2, y2 = F(Q[0]), (Q[1])
	a = ((y1**2 - y2**2)-(x1**3 - x2**3))/(x1 - x2)
	b = y1**2 - (x1**3 + a*x1)
	
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
```
Then all we left to do is run the attack with the given parameters to obtain the flag!

![singular_completion](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/ECC-Pop-Quiz/testing/writeup-files/singular_completion.JPG)

`flag{4Ll_0f_tH353_4tT4cK5_R3lY_0N_51mPl1FY1n9_th3_D15cr3t3_l09_pr08l3m}`

## Notes For Developers

1) Was it fun? 
Yes, definitely. It was great. I had to learn elliptic curves from zero since I'm pretty new to cryptography and I never encountered ECC before this challenge. Learning all the theories (at least the basic theory that I succeeded in understanding in the given time) return me to my freshman year when I studied Abelian groups and all their related material. 

2) Does it teach a useful skill?
At this particular set of challenges, when elliptic curves came into consideration, SageMath is your best friend. First of all, I had to know how to install sage (which took some time), then learn at least the basic commands that helped me generalized solutions I found online. I'm very satisfied that I learned this tool, and on future challenges, I hope I'll get better and understand every single command I put in.

3) Does the difficulty seem to match the author's posited point value?
Sure. I think that 300 points would be fair enough. The first two parts of the challenge can be solved without a REAL initial knowledge in ECC since there are solutions online. However, the participant would waste some time understanding how to write in sage and find the right resources. It took me around 4-6 hours in total to completely write the solution. I put a lot of extra time into understanding basic ECC and the theory behind it. 

4) Is there a clear path to the solution (regardless of difficulty) so that the player doesn't get frustrated by trying to figure out how the challenge author wanted the player to think?
Definitely. The challenge hints about the attack's name that should be used in order to move on to the next part, I liked it.

5) Are there ways to "break" the challenge (alternate paths to the solution that are easier than intended?
I'm not sure. However, my solution is failing from time to time and I'm pretty sure it's because there are special cases in each part of the challenge. E.G.: my solution is restarting the connection any time I'm getting an exception. After some amount of time, it will solve the challenge, but it hints about maybe some specific properties that my algorithm fails in, so if the challenge creator generated deliberately some special cases  (for example in Smart's attack, I found some docs about the fact that Qp could be Isomorphic to Fp and it might change the solution a bit - I could just point it out), it might be good to check that the algorithm pass for each and every one of them in order to solve the part for whatever properties you get from the server JSON database of curves.  

6) Is the README.md file comprehensive enough that a moderator can read and understand the solution when fielding questions about the challenge?
Just to make sure, is it suppose to be "y'all about ECC" or "you know all about ECC"? that part was a bit unclear but not affecting the challenge. Besides that, the challenge description is clear and simple to understand. The solution as well.

7) Is it Dockerized and ready to deploy? 
It is. I built the image, ran it in detached mode while exposed port 5000, and then interact with it over localhost:5000. 

8) Does the flag in the challenge match the flag in the `challenge.json` file?
The flag in the `challenge.json` file matches with the flag that the server pulls from the file `flag.txt`.

















