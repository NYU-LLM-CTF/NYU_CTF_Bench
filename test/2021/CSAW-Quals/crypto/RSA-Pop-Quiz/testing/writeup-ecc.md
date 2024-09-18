



# CSAW - RSA-Pop-Quiz

![challenge_json](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/challenge_json.JPG)

In this challenge, we are interacting with a server that gives us RSA challenges. In the first three parts, we are given the public key `(N, e)` and our ciphertext `c`. Our target is to solve the challenge, which is possible because the special cases been given, to be matched for known attacks' conditions. In the last part, we are also given `d0` which is the half lower part of the private key `d`. In a case of exposure of more than a quarter of the private key bits, it is possible to recover it completely.

### Case 1 - Wiener's Attack / RsaCtfTool

![part_wiener](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/part_wiener.JPG)

In the first part of the challenge, we have been given `N, e, c` and the sentence `This is one of the most common RSA attacks in CTFs!`. Before even go any further, let's see if our RSA tool ["RsaCtfTool"](https://github.com/Ganapati/RsaCtfTool) yields any results. Let's insert any given parameter we have in addition to try to crack this challenge (I added a timeout to save some redundant time wasted on checking wrong attacks, but it will do the work without it):

`python3 RsaCtfTool.py -n <N> -e <e> --uncipher <c> --timeout 2`

![rsactftool_wiener](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/rsactftool_wiener.png)

The tool has been cracked the challenge using Wiener's attack, and provide us with the unciphered text. Convert this HEX value to a string: 
```
command = ["./RsaCtfTool/RsaCtfTool.py", "-n", str(N), "-e", str(e), "--uncipher", str(c), "--timeout", "2"]
ext_hex_pt = os.popen(" ".join(command)).read().split("HEX : ")[1][2:].split("\n")[0].lstrip("0")[:-4]
pt = "".join([chr(int(ext_hex_pt[i:i+2], 16)) for i in range(0, len(ext_hex_pt), 2)])
print(f"plaintext : {pt}")

output:
> plaintext : Wiener wiener chicken dinner
```

### Case 2 - Z3 Theorem Prover / RsaCtfTool

![part_z3](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/part_z3.JPG)

In this part of the challenge, we have been given `N, e, c` and the sentence `Sexy primes were used to make the modulus!`. Before even go any further, let's see if our RSA tool ["RsaCtfTool"](https://github.com/Ganapati/RsaCtfTool) yields any results. Let's insert any given parameter we have in addition to try to crack this challenge (I added a timeout to save some redundant time wasted on checking wrong attacks, but it will do the work without it):

`python3 RsaCtfTool.py -n <N> -e <e> --uncipher <c> --timeout 2`

![rsactftool_z3solver](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/rsactftool_z3solver.png)

The tool has been cracked the challenge using the z3_solver attack which makes use of the z3 theorem prover. It provides us with the unciphered text. Convert this HEX value to a string: 
```
command = ["./RsaCtfTool/RsaCtfTool.py", "-n", str(N), "-e", str(e), "--uncipher", str(c), "--timeout", "2"]
ext_hex_pt = os.popen(" ".join(command)).read().split("HEX : ")[1][2:].split("\n")[0].lstrip("0")[:-4]
pt = "".join([chr(int(ext_hex_pt[i:i+2], 16)) for i in range(0, len(ext_hex_pt), 2)])
print(f"plaintext : {pt}")

output:
> plaintext : Who came up with this math term anyway?
```

### Case 3 - Least Significant Bit Oracle Attack

![part_lsb](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/part_lsb.JPG)

In this part of the challenge, we are given `N, e, c` and the sentence `Looks like there is a oracle which is telling the LSB of the plaintext. That will not help you, right?`
After that, there is a question `What would you like to decrypt? (please respond with an integer)`. It's a "hint" about LSB Oracle Attack! This attacks works due to leaking of the least significant bit by an unpadded RSA encryption/decryption oracle that enables the adversary to decrypt the ciphertext in `Log(n)` (with base 2) requests to the oracle. I found a great source here: [LSB oracle attack docs & implementation](https://github.com/ashutosh1206/Crypton/tree/master/RSA-encryption/Attack-LSBit-Oracle).
After some custom changes, I made it work for generic given parameters. Let's remember that in order to keep using the oracle we should answer with "yes", so when we have done using the oracle, we should answer with "no" to have the option to get asked for the plaintext in order to move on for the next part. I end up with that:
```
upper_limit = N
lower_limit = 0
i = 1

while i <= 1024:
    chosen_ct = c*pow(2**i, e, N) % N
    print(f"lower: {lower_limit}")
    print(f"upper: {upper_limit}")
    conn.send(str(chosen_ct) + "\n")
    data = conn.recvuntil("Would you like to continue? (yes/no)").decode()
    lsb = int(data.split("\r\n")[2][-1])
 
    if lsb == 0:
        upper_limit = (upper_limit + lower_limit)//2
    elif lsb == 1:
        lower_limit = (lower_limit + upper_limit)//2
    else:
    	print ("Unsuccessfull")
    	break
    
    i += 1
    if i == 1024: # Last iteration, could also be written outside
    	conn.send("no" + "\n")
    	break
    	
    conn.send("yes" + "\n")
    conn.recvuntil("What would you like to decrypt? (please respond with an integer)").decode()

pt = long_to_bytes(lower_limit).decode()
pt = pt[:-1] + "e"
print(f"plaintext : {pt}")

output: 
> plaintext : Totally did not mean to put an oracle there
```
The code is pretty much self-explanatory. A few notes that I had to put in:
First of all, about our recovered plaintext. For some reason, I have gotten a mistake on the last byte of the plaintext, that I had to fix manually which was pretty trivial. In case you think It's not trivial, just brute force all the printable options for a byte, which is feasible.
Second, about the long division, take a good look at the operator I have been used - "//" instead of "/", to preserve the long value while dividing long by integer value! Without that, it will cause an estimation of the value since the value will be saved as an integer.


### Case 4 - Partial Key Exposure Attack On Low-Exponent RSA

![part_privkey](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/RSA-Pop-Quiz/testing/writeup-files/part_privkey.JPG)

On this next part of the challenge, we are given the parameters `N, e, c` and this time also `d0, d0bits, nBits`, as well as the sentence `Oops, looks like I leaked part of the private key. Hope that doesn't come back to bite me!`. The sentence is "hint" about the fact that we got a part from the private key.  That is, `d0` is the half 512 bits of the private key used to encrypt our desired plaintext! This allows the use of an attack that exploits this exposure of the partial private key, and the value of our exponent which is in this part always equals 17 (small enough to brute force). I found an amazing paper that explains every step of the attack in detail: [Partial Key Exposure Attack On Low-Exponent RSA](http://honors.cs.umd.edu/reports/lowexprsa.pdf) .
I tried to stay in python but at this point, the calculations of equations were too complicated and complex to stick with python. I moved on to work with sage our best friend! After going through the article I end up with this:
```
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
			
			#########################################
			# our goal is to find roots of f(x, y) = (rx + p0)(ry + q0) - N 
			# set p(x) = (rx + p0), q(y) = (ry + q0) --> f(x, y) = p(x)*q(y) - N
			# when p(x) = 0, f(x, y) + N = 0  
			# f(x0, y0) = 0 --> p(x0) = p, q(y0) = y
			# p*q = N --> gcd(p, N) = p, q = N/p
			#######################################
			
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
print(f"plaintext : {pt}")

output: 
> plaintext : I'll be careful next time to not leak the key
```
All we have to do is feed the challenge's server with the last part's plaintext to obtain the flag.

`flag{l00K5_L1K3_y0u_H4v3_p4223D_7h3_D1ff1Cul7_r54_p0p_Kw12_w17H_fLy1N9_C0L0r2}`



## Notes For Developers
1.  Was it fun? In total it was a cool challenge. It could be even better if on the first two parts I would have to learn the intended attacks and implement them manually, in order to solve the challenge. In the end, all I had to do is to use an automated tool. The third part was nice. The fourth part was tricky, in order to solve it completely by myself without any reference, I would probably had to put a lot more time thinking into it. I couldn't solve `ƒ(x,y) = (rx + p0)(ry + q0) – N` without the solution implementation that made me understand what I'm actually had to solve, which is `(rx + p0) = 0`.
    
2.  Does it teach a useful skill? Yes! First of all, this challenge makes me use the RsaCtfTool. On the other side, I'm pretty sure if I was implemented all the attacks manually, I would learn more about two different kinds of attacks which could be cool and teaching as well. More, the LSB oracle attack was fun to learn and implement. The fourth part gave me a bit more experience with sage, which I started to learn that it's a super important and mandatory skill for crypto challenges. 
    
3.  Does the difficulty seem to match the author's posited point value? Yes. The first two parts are piece of cake. The third is to find the right source with a bit of custom manipulation which is still on the easy scale. The fourth part is giving this challenge the points it's worth, I had to read an actual paper about this attack, and couldn't find any implemented solution online. I also had to see a small part of the solution that I mentioned in question 1, but I'm pretty sure that I could get it in the end completely by myself.
    
4.  Is there a clear path to the solution (regardless of difficulty) so that the player doesn't get frustrated by trying to figure out how the challenge author wanted the player to think? Definitely. I'm not sure about the first two clues, because I pretty much skipped them using the automated tool, but reading them at a glance, they are fine and hint at the place the vulnerability is placed. The third and fourth hints are crystal clear, it's more than a hint, it actually tells you what to do, which is fine since the challenge is to implement it. By the way, pretty sure that there are grammar mistakes on the third hint. 
    
5.  Are there ways to "break" the challenge (alternate paths to the solution that are easier than intended? Yes. The first two parts were solved using an automated tool. Can be solved for example by making the user run the challenge on the server-side, which can implement filters so it cant run system commands. Anyway, it's not really an unintended way but it's automated the process. Maybe in the second part, there is an unintended way, it solves the challenge using z3_solver which I'm not sure same as the intended solution.
    
6.  Is the README.md file comprehensive enough that a moderator can read and understand the solution when fielding questions about the challenge? I think the solution should be a bit more detailed. But in general, there is the title of each attack that is being used to solve the different parts.
    
7.  Is it Dockerized and ready to deploy? It is. I built the image, ran it in detached mode while exposed port 5000, and then interact with it over localhost:5000.
    
8.  Does the flag in the challenge match the flag in the  `challenge.json`  file? The flag in the  `challenge.json`  file matches with the flag that the server pulls from the file  `flag.txt`.




