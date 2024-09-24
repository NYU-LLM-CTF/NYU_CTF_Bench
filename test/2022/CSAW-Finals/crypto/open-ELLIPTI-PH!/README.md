# open-ELLIPTI-PH!

NOTES:

* Flag can be dynamic
* Break the curve; get the AES key; decrypt AES-scrambled flag with openssl

#### Here is the challenge design:

1) The flag is encrypted with openssl AES
2) The private ssl/AES key is then encrypted with ECC (Elliptical Curve Cryptography)
3) The parameters of the ECC curve are exposed and are NIST compliant, but they key is terribly short (int(flag) %
   100000)
4) The fact that the key is brute force vulnerable is hidden from the player who has to deduce that due to the other
   curve parameters being cryptographically strong the weakness must be in the hidden private curve key
5) The encryption/decryption ECC scheme was heavily modified from this implementation of _Menezes and Vanstone_ ECC:
    * http://matematicas.uam.es/~fernando.chamizo/asignaturas/cripto1011/ecc.pdf
6) Once the curve DLP is broken, the provided MV-ECC enc/dec functions can be used to retrieve the AES/SSL key by 
performing ECC decryption with the brute-forced curve private key
7) Once the SSL key is retrieved from the ECC decrpytion the player can reverse the SSL commands at the top of the source 
code to decrypt the flag

#### One way to beat the challenge

1. Perform a Pohlig-Hellman attack on the curve to retrive the ```priv_key``` [4].
    1. The public key of the curve is provided and is: ``pub_key = priv_key * G``
    2. ```G``` is an Elliptical Curve point located in the relevant curve file
2. Now with the ```priv_key```  the player can encrypt and decrypt on the curve;
    1. A decryption on the curve using the  ```priv_key``` results in the AES key
       1. The challenge includes a checker the player can use to check their AES key
3. With the AES key in hand, the play then uses openssl to get the flag

#### Authors:

* rollingcoconut

#### References:

* [1] https://math.charlotte.edu/sites/math.charlotte.edu/files/fields/preprint_archive/paper/2013_06.pdf
* [2] https://wstein.org/edu/2010/414/projects/novotney.pdf
* [3] http://matematicas.uam.es/~fernando.chamizo/asignaturas/cripto1011/ecc.pdf
* [4] http://shrek.unideb.hu/~tengely/crypto/section-6.html 

