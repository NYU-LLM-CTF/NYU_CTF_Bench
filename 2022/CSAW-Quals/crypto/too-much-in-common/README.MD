# Phi Too Much in Common

Here's the challenge design:
1. It's a two part challenge to test  understanding of RSA exploits when the algorithm is poorly implemented or leaking info
2. In the first challenge the modulus N is reused with 10% probability
4. In the second challenge the user is asked to provide phi when given {e,d,N} 
3. In both challenges <pre> e < sqrt(N) </pr> 
5. The user is **NOT** given the _server.py_ file
6. **Random Generation!** Since the values provided to the user are randomly generated, not each challenge presented may have the mathematical properties required to work backwards 
   1. For this reason the user is allowed to ask the server as many times as she/he wants for a new challenge

Here's one way to beat the challenge:
1. To beat challenge one you need to multiply two ciphertexts that share the same modulus. 
   1. The mathematical basis for this can be found  here: https://infosecwriteups.com/rsa-attacks-common-modulus-7bdb34f331a5
2. To beat challenge two you need to solve for phi:  
   1. If doing manual solve (as in _solver.py_) you will need sympy to solve large linear equations
   2. https://math.stackexchange.com/questions/3082920/how-can-i-break-rsa-if-i-know-the-private-key




#### Authors:
* rollingcoconut



#### References:
* https://math.stackexchange.com/questions/3082920/how-can-i-break-rsa-if-i-know-the-private-key 
* https://infosecwriteups.com/rsa-attacks-common-modulus-7bdb34f331a5 
