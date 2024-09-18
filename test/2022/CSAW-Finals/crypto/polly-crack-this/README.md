# POLLY-CRACK-THIS

### Please keep flag at 24 chars

The Polly Cracker Groebner-based cryptosystem was first developed in 1994 and has never been seriously adopted off due to mathematical vulnerabilities discovered over the years. It nonetheless gets revisited by cryptographers and academics as it can be designed to be homomorphic and secured with Groebner Basis.

The challenge is designed to test elementary knowledge of abstract algebra concepts as well as the the concept of homomorphism.

#### Here is the challenge design:

1. Let $K$ be a finite field and let $R$ = $K[x_1 ,\ldots , x_n]$ be a polynomial ring over $K$. We use $degree$=2.
2. The secret key is an $Ideal$ of a random $degree-2$ polynomial in $R$
3. The secret key is used to generate the public key; if it is known, we can decrypt anything encrypted by the public key by performing $ciphertext.reduce(secret \textunderscore key)$ in sage
4. In Polly-Cracker we encrypt by:
			$c = m + R.random \textunderscore element() * public \textunderscore key$;    			$c$ is the ciphertext; $m$ is message
5. In this implementation of Polly-Cracker we can decrypt by either:
           $m$ = $c.reduce(secret \textunderscore key)$
           or
           $m$ = $c.reduce(secret \textunderscore key.groebner \textunderscore basis())$

The Groebner-basis ( $G$ )  is an ordered subset of the Polynomial Ring's Ideals ( $I$ ):
	     $G ⊂ I $

6. The secret key is not provided to the contestant, but the Groebner basis of a random Ideal is.
7. The challenge is solved if the player homomorphically decrypts the three provided ciphertexts


#### Here's one way to beat the challenge:

1. Copy the $groebner \textunderscore basis$ and ciphertexts $(c0,c1,c2)$ provided over the wire via nc
2. Perform the following reduction:
        $(((c0 + c1 + c2- 123)/999).reduce(groebner \textunderscore basis)$
3. This results in a very large int that can be converted to hex, then ASCII for a flag
4. The player can also query the server up to 10 times to determine if they've correctly created the admin code, before attempting to decode it further.

#### Authors:
* rollingcoconut

#### References:
* Baumslag, G., Fine, B., Kreuzer, M., &amp; Rosenberger, G. (2016). 13.2 Commutative Gröbner Basis Cryptosystems. In *A course in mathematical cryptography*. essay, De Gruyter 
* https://martinralbrecht.wordpress.com/2010/08/19/somewhat-homomorphic-encryption/
