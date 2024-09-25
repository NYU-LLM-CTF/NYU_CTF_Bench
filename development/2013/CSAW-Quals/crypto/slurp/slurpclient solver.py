#client
from struct import pack
from hashlib import sha512,sha1
from sock import Sock
import os
import hmac
from time import time


def findOrder(gen,prim):
    listy=[]
    iGen=gen
    first=True
    for x in range(0,12000):
        if gen==iGen and not first:

            listy.append(pow(gen,x,prim))
            break
        first=False
        listy.append(gen)
        gen=gen*iGen
        gen=gen%prim
    return len(set(listy)),set(listy)

def findGoodGenerator(n):
	r=(n-1)/9001
	for x in range(4,5000): #if you go past this you're just plain unlucky
		nextAttempt=pow(x,r,n)
		if nextAttempt<n/2:
			return x,nextAttempt



#f = Sock("54.235.155.218", 9999)
def connect():
	f = Sock("localhost", 8000)
	f.read_until("21 bytes, starting with ")
	prefix = f.read_nbytes(16)
	#print prefix
	prefix+="A"
	i=0
	while True:
		ha=sha1()
		ha.update(prefix+pack("I",i))
		if(ha.digest()[-3:] == "\xff\xff\xff"):
			print("CDIGEST %s"%ha.hexdigest())
			break
		if i %1048576==0:
			print(i)
		i+=1
	f.send(prefix+pack("I",i))
	return f

def sendHex(num,f):
	msg=hex(num)[2:]
	if msg[-1]=="L":
		msg=msg[:-1]
	messSize=pack("H", len(msg))
	print(msg)
	f.send(messSize)
	f.send(msg)
def hashToInt(*params):  # a one-way hash function
	sa=sha512()
	for el in params:
		sa.update("%r"%el)
	return int(sa.hexdigest(), 16)
def cryptrand(n=1024):  
	p1=hashToInt(os.urandom(10))<<600
	p1+=hashToInt(os.urandom(10))
	return (p1&((2<<(n+1))-1)) % N

def getServerChal(goodGen,N):
	a = cryptrand()
	clientChal = pow(goodGen, a, N)
	f=connect()

	sendHex(goodGen,f)
	sendHex(clientChal,f)

	print(f.read_until("\n"))
	f.read_until("\n")

	salt = int(f.read_until("\n")[:-1],16)
	serverChal = int(f.read_until("\n")[:-1],16)
	
	f.close()
	return serverChal

def findOrderMatch(gen,prim,solutions):
	knownVals={}
	iGen=gen

	for x in range(0,10000):
		if gen==1:
			break
		gen=gen*iGen
		gen=gen%prim
		for el in solutions:
			p1=(el-gen)%prim
			if p1 in knownVals:
				print("FOUND SOLUTION %s"%p1)
				return p1
			knownVals[p1]=x
		if x%20==0:
			print("Now on iter %d"%x)

def findServerPrivateExplonent(gen,prim,verif,aim):
	knownVals={}
	iGen=gen

	for x in range(0,10000):
		if gen==1:
			break
		gen=gen*iGen
		gen=gen%prim
		if (verif*3+gen)%prim==aim:
			return x+2#0, and ne for true
	assert(0)
N = 59244860562241836037412967740090202129129493209028128777608075105340045576269119581606482976574497977007826166502644772626633024570441729436559376092540137133423133727302575949573761665758712151467911366235364142212961105408972344133228752133405884706571372774484384452551216417305613197930780130560424424943100169162129296770713102943256911159434397670875927197768487154862841806112741324720583453986631649607781487954360670817072076325212351448760497872482740542034951413536329940050886314722210271560696533722492893515961159297492975432439922689444585637489674895803176632819896331235057103813705143408943511591629

def solve():
	'''
N is a schnorr prime for q=9001
'''
	N = 59244860562241836037412967740090202129129493209028128777608075105340045576269119581606482976574497977007826166502644772626633024570441729436559376092540137133423133727302575949573761665758712151467911366235364142212961105408972344133228752133405884706571372774484384452551216417305613197930780130560424424943100169162129296770713102943256911159434397670875927197768487154862841806112741324720583453986631649607781487954360670817072076325212351448760497872482740542034951413536329940050886314722210271560696533722492893515961159297492975432439922689444585637489674895803176632819896331235057103813705143408943511591629
	goodGenBase,goodGen=findGoodGenerator(N)
	print("Good Gen is %d %d"% (goodGenBase,goodGen))
	generator=goodGen

	chals=[]
	for x in range(2):
		chals.append(getServerChal(goodGen,N))

	candidate=findOrderMatch(goodGen,N,chals)
	#two candidates will be returned, one will be if 
	#multiplier slush* verifier number is going to be greater than n, one below, if really unlucky, 
	#you'll have three candidates
	verif=None
	for x in range(3):
		if (candidate+(N*x))%3==0:
			verif=((candidate+(N*x))/3)
	a = cryptrand()
	clientChal = pow(generator, a, N)
	f=connect()
	sendHex(generator,f)
	sendHex(clientChal,f)

	f.read_until("\n")
	f.read_until("\n")

	salt = int(f.read_until("\n")[:-1],16)
	serverChal = int(f.read_until("\n")[:-1],16)
	slush=hashToInt(clientChal, serverChal)
	hopeful= findServerPrivateExplonent(generator,N,verif,serverChal)
	agreedKey = hashToInt(pow(clientChal * pow(verif, slush, N), hopeful, N))
	gennedKey=hashToInt(hashToInt(N) ^ hashToInt(goodGen), hashToInt(goodGen), salt, 
			clientChal, serverChal, agreedKey)

	sendHex(gennedKey,f)
	print(f.read_until("\n"))

solve()
