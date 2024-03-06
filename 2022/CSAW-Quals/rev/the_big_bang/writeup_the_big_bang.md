

# The Big Bang writeup - Rev category

```json
{
  "name": "The Big Bang",
  "category": "rev",
  "author": "mastertg, amitz800",
  "description": "What do you think about the number 73?",
  "flag": "flag{5h3ld0n_54y5_7h47_7h3_b357_numb3r_1n_7h3_w0rld_15_73,_h3_15_r16h7!!}",
  "type": "dynamic",
  "initial": 500,
  "minimum": 50,
  "decay": 275,
  "box": "domain",
  "internal_port": "port",
  "files": [
    "server.py",
  ]
}
```

In this challenge, we are interacting with a server that gives us some random bits. We are also provided with the source code of the server:

```python
import random
import binascii

MAGIC = 73
K1 = b'\xae@\xb9\x1e\xb5\x98\x97\x81!d\x90\xed\xa9\x0bm~G\x92{y\xcd\x89\x9e\xec2\xb8\x1d\x13OB\x84\xbf\xfaI\xe1o~\x8f\xe40g!%Ri\xda\xd14J\x8aV\xc2x\x1dg\x07K\x1d\xcf\x86{Q\xaa\x00qW\xbb\xe0\xd7\xd8\x9b\x05\x88'
K2 = b"Q\xbfF\xe1Jgh~\xde\x9bo\x12V\xf4\x92\x81\xb8m\x84\x862va\x13\xcdG\xe2\xec\xb0\xbd{@\x05\xb6\x1e\x90\x81p\x1b\xcf\x98\xde\xda\xad\x96%.\xcb\xb5u\xa9=\x87\xe2\x98\xf8\xb4\xe20y\x84\xaeU\xff\x8e\xa8D\x1f('d\xfaw"
K3 = b"\xc6j\x0b_\x8e\xa1\xee7\x9d8M\xf9\xa2=])WI]'x)w\xc1\xc4-\xab\x06\xff\xbd\x1fi\xdb t\xe1\x9d\x14\x15\x8f\xb3\x03l\xe8\ru\xebm!\xc9\xcbX\n\xf8\x98m\x00\x996\x17\x1a\x04j\xb1&~\xa1\x8d.\xaa\xc7\xa6\x82"
K4 = b'9\x95\xf4\xa0q^\x11\xc8b\xc7\xb2\x06]\xc2\xa2\xd6\xa8\xb6\xa2\xd8\x87\xd6\x88>;\xd2T\xf9\x00B\xe0\x96$\xdf\x8b\x1eb\xeb\xeapL\xfc\x93\x17\xf2\x8a\x14\x92\xde64\xa7\xf5\x07g\x92\xfff\xc9\xe8\xe5\xfb\x95N\xd9\x81^r\xd1U8Y}'
K5 = b"9\xf8\xd2\x1a\x8d\xa14\xb9X\xccC\xe8\xf5X\x05l:\x8a\xf7\x00\xc4\xeb\x8f.\xb6\xa2\xfb\x9a\xbc?\x8f\x06\xe1\xdbY\xc2\xb2\xc1\x91p%y\xb7\xae/\xcf\x1e\x99r\xcc&$\xf3\x84\x155\x1fu.\xb3\x89\xdc\xbb\xb8\x1f\xfbN'\xe3\x90P\xf1k"
K6 = b'\xc6\x07-\xe5r^\xcbF\xa73\xbc\x17\n\xa7\xfa\x93\xc5u\x08\xff;\x14p\xd1I]\x04eC\xc0p\xf9\x1e$\xa6=M>n\x8f\xda\x86HQ\xd00\xe1f\x8d3\xd9\xdb\x0c{\xea\xca\xe0\x8a\xd1Lv#DG\xe0\x04\xb1\xd8\x1co\xaf\x0e\x94'

jokes = ["\nSheldon: Why are you crying?\nPenny: Because I'm stupid.\nSheldon: That's no reason to cry. One cries because one is sad. For example, I cry because others are stupid, and that makes me sad.", "Sheldon: Scissors cuts paper, paper covers rock, rock crushes lizard, lizard poisons Spock, Spock smashes scissors, scissors decapitates lizard, lizard eats paper, paper disproves Spock, Spock vaporizes rock, and as it always has, rock crushes scissors.","\nHoward: Sheldon, don't take this the wrong way, but, you're insane.\nLeonard: That may well be, but the fact is it wouldn't kill us to meet some new people.\nSheldon: For the record, it could kill us to meet new people. They could be murderers or the carriers of unusual pathogens. And I'm not insane, my mother had me tested."]

with open("flag.txt",'r') as f:
	flag = f.read().encode()

def foo(x, y, z, w):
	return bytes([(a&b&c&d | a&(b^255)&(c^255)&d | a&(b^255)&c&(d^255) | a&b&(c^255)&(d^255) | (a^255)&b&(c^255)&d | (a^255)&b&c&(d^255)) for a, b, c, d in zip(x, y, z, w)])
   
def gen_iv():
	iv_a = "{0:b}".format(random.getrandbits(MAGIC)).zfill(MAGIC) 
	print(f"Enjoy this random bits : {iv_a}")
	return iv_a, [b"\xff" * MAGIC if iv_a[i]=='1' else b"\x00" * MAGIC for i in range(MAGIC)]

def gen_keys():
	k = b"\x00"*MAGIC
	keys = []
	for i in range(MAGIC-1):
	    key = random.randbytes(MAGIC)
	    keys.append(key)
	    k = xor(k, xor(key,flag))
	keys.append(xor(k,flag))
	return keys
	
def xor(x, y):
    return bytes([a ^ b for a, b in zip(x, y)])
	
def my_input():
	inp = input()
	inp = binascii.unhexlify(inp)
	
	if len(inp) != MAGIC**2:
		print(random.choice(jokes))
		exit(0)
	
	return [inp[MAGIC*i:MAGIC*(i+1)] for i in range(MAGIC)]
	
def guardian(out, i, keys, intersection=b"\x00"*MAGIC):
	for j in range(i+1):
		intersection = xor(intersection, keys[j])
	return intersection == out
	
def main():
	print("Welcome to the Big Bang challenge!")

	iv_a, iv_b = gen_iv()
	keys = gen_keys()
	inp = my_input()
	
	output =  b"\x00"*MAGIC			
	for i in range(MAGIC):
		output = foo(output, foo(keys[i], foo(inp[i], iv_b[i], K5, K6), K3, K4), K1, K2)
		if not guardian(output, i, keys):
			print("Bazinga! You just fell to one of my classic pranks")
			break
	print(f"Congratulations, you are smarter than Sheldon!\nHere is your flag:\n{output}")

if __name__ == "__main__":
	try: 
		main()
	except Exception:
		print(random.choice(jokes))	
```

Let's start analyzing the code so we can better understand what's going on here. In the main function we start with generating some vector named `iv` using a call to the function `gen_iv`:

```python
def gen_iv():
	iv_a = "{0:b}".format(random.getrandbits(MAGIC)).zfill(MAGIC) 
	print(f"Enjoy this random bits : {iv_a}")
	return iv_a, [b"\xff" * MAGIC if iv_a[i]=='1' else b"\x00" * MAGIC for i in range(MAGIC)]
```

The function `gen_iv` generates 73 random bits. It also creates another form of the `iv` in which each 1 is replaced with 73 times the byte `\xff` and each 0 is replaced with 73 times the byte `\x00`. Eventually, the length of `iv_b` becomes 73*73. To sum up, this function is expanding the random vector.
The next thing that we want to take a look at is the function `gen_keys`:

```python
def gen_keys():
	k = b"\x00"*MAGIC
	keys = []
	for i in range(MAGIC-1):
	    key = random.randbytes(MAGIC)
	    keys.append(key)
	    k = xor(k, xor(key,flag))
	keys.append(xor(k,flag))
	return keys
``` 

The function `gen_keys` generates 72 random keys and another key which will have to satisfy the condition in which the flag equals xor between all the 73 components. Hence, the last key is calculated by xor between all the 72 components, with the secret flag. To conclude, This function reveals that the flag is the xor between all the 73 keys.
The next function is the `my_input` function which receives input from the user.

```python
def my_input():
	inp = input()
	inp = binascii.unhexlify(inp)
	
	if len(inp) != MAGIC**2:
		print(random.choice(jokes))
		exit(0)
	
	return [inp[MAGIC*i:MAGIC*(i+1)] for i in range(MAGIC)]
``` 

The function receives input from the user and validates that the input length is 73*73 bytes long, otherwise it prints a joke and exits. If the length of the input is valid it breaks the input into 73 blocks of 73 bytes each.
If the user input is valid we are proceeding in the main function to the calculation of the output.

```python
output =  b"\x00"*MAGIC			
	for i in range(MAGIC):
		output = foo(output, foo(keys[i], foo(inp[i], iv_b[i], K5, K6), K3, K4), K1, K2)
		if not guardian(output, i, keys):
			print("Bazinga! You just fell to one of my classic pranks")
			break
	print(f"Congratulations, you are smarter than Sheldon!\nHere is your flag:\n{output}")
```

The output is calculated using the `foo` function. Let's analyze what's exactly that the function does.

```python
def foo(x, y, z, w):
	return bytes([(a&b&c&d | a&(b^255)&(c^255)&d | a&(b^255)&c&(d^255) | a&b&(c^255)&(d^255) | (a^255)&b&(c^255)&d | (a^255)&b&c&(d^255)) for a, b, c, d in zip(x, y, z, w)])
```

The `foo` function receives four parameters and returns some outcome of a boolean algebra expression on those values.
Let's simplify this expression:

 $abcd+ab'c'd+ab'cd'+abc'd'+a'bc'd+a'bcd' = ad(bc+b'c')+ad'(b'c+bc')+a'b(c'd+cd') = ad(b\bigoplus c)'+ad'(b\bigoplus c)+a'b(c\bigoplus d) = a(b\bigoplus c\bigoplus d) + a'b(c\bigoplus d)$
 
We can see that `z` and `w` are always constants which means the same for `c` and `d` relatively:
 
 ```python
 K1 = b'\xae@\xb9\x1e\xb5\x98\x97\x81!d\x90\xed\xa9\x0bm~G\x92{y\xcd\x89\x9e\xec2\xb8\x1d\x13OB\x84\xbf\xfaI\xe1o~\x8f\xe40g!%Ri\xda\xd14J\x8aV\xc2x\x1dg\x07K\x1d\xcf\x86{Q\xaa\x00qW\xbb\xe0\xd7\xd8\x9b\x05\x88'
K2 = b"Q\xbfF\xe1Jgh~\xde\x9bo\x12V\xf4\x92\x81\xb8m\x84\x862va\x13\xcdG\xe2\xec\xb0\xbd{@\x05\xb6\x1e\x90\x81p\x1b\xcf\x98\xde\xda\xad\x96%.\xcb\xb5u\xa9=\x87\xe2\x98\xf8\xb4\xe20y\x84\xaeU\xff\x8e\xa8D\x1f('d\xfaw"
K3 = b"\xc6j\x0b_\x8e\xa1\xee7\x9d8M\xf9\xa2=])WI]'x)w\xc1\xc4-\xab\x06\xff\xbd\x1fi\xdb t\xe1\x9d\x14\x15\x8f\xb3\x03l\xe8\ru\xebm!\xc9\xcbX\n\xf8\x98m\x00\x996\x17\x1a\x04j\xb1&~\xa1\x8d.\xaa\xc7\xa6\x82"
K4 = b'9\x95\xf4\xa0q^\x11\xc8b\xc7\xb2\x06]\xc2\xa2\xd6\xa8\xb6\xa2\xd8\x87\xd6\x88>;\xd2T\xf9\x00B\xe0\x96$\xdf\x8b\x1eb\xeb\xeapL\xfc\x93\x17\xf2\x8a\x14\x92\xde64\xa7\xf5\x07g\x92\xfff\xc9\xe8\xe5\xfb\x95N\xd9\x81^r\xd1U8Y}'
K5 = b"9\xf8\xd2\x1a\x8d\xa14\xb9X\xccC\xe8\xf5X\x05l:\x8a\xf7\x00\xc4\xeb\x8f.\xb6\xa2\xfb\x9a\xbc?\x8f\x06\xe1\xdbY\xc2\xb2\xc1\x91p%y\xb7\xae/\xcf\x1e\x99r\xcc&$\xf3\x84\x155\x1fu.\xb3\x89\xdc\xbb\xb8\x1f\xfbN'\xe3\x90P\xf1k"
K6 = b'\xc6\x07-\xe5r^\xcbF\xa73\xbc\x17\n\xa7\xfa\x93\xc5u\x08\xff;\x14p\xd1I]\x04eC\xc0p\xf9\x1e$\xa6=M>n\x8f\xda\x86HQ\xd00\xe1f\x8d3\xd9\xdb\x0c{\xea\xca\xe0\x8a\xd1Lv#DG\xe0\x04\xb1\xd8\x1co\xaf\x0e\x94'
 ```
 
In the simplified expression, we can see that `c` and `d` are always come together in the form of $c\bigoplus d$. If we check the values of $K1\bigoplus K2$, $K3\bigoplus K4$, and $K5\bigoplus K6$ we will see that:
 
$K1\bigoplus K2 = K3\bigoplus K4 = K5\bigoplus K6$ = `73*b"\xff"`  which is a vector of 1s.
 
 For those specific values of $c$ and $d$ :
 $a(b\bigoplus c\bigoplus d) + a'b(c\bigoplus d) = ab'+a'b = a\bigoplus b$
 
Hence, the function foo is just a xor of the first two parameters!  In that case, we can rewrite the line:
 
 ```python
 output = foo(output, foo(keys[i], foo(inp[i], iv_b[i], K5, K6), K3, K4), K1, K2)
 ```
 
 As:
 
 ```python
 output = xor(output, xor(keys[i], xor(inp[i], iv_b[i])))
 ```
 
We know that the flag we are looking for is xor between all the keys, so to obtain it, we should just "cancel" `iv_b`. So we want our input to be equals to `iv_b`, because of xor's commutative characteristic. After each iteration, the code validates using the `gurdian` function, that the current calculation is xor between all the keys until the current point.

 ```python
 def guardian(out, i, keys, intersection=b"\x00"*MAGIC):
	for j in range(i+1):
		intersection = xor(intersection, keys[j])
	return intersection == out 
 ```
 
This prevents the user to change the order of `iv_b` while inserting an input. Just adding another fun layer to the challenge.  
 
To conclude, here is the solver code:
 
```python
from pwn import *
import binascii

MAGIC=73
host = "localhost"
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
```
 
The obtained flag is: `flag{5h3ld0n_54y5_7h47_7h3_b357_numb3r_1n_7h3_w0rld_15_73,_h3_15_r16h7!!}`
 