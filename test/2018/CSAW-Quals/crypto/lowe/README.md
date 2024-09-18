# Details
  Participant receives :
 * (e,N): 1536-bit RSA public key; PEM encoded to make it look like "real key"
 * Y\_os: RSA encrypted symmetric key; formatted as big-endian octet string
 * ciphertext C
 The goal is to decrypt ciphertext C without RSA private key.

 To generate a challenge, let's assume secret S which participant wants to "capture"
 is represented as a 64-byte string of bytes. It could be a secret password,
 string "FLAG" repeated 16 times or URL. It must have a length of exactly 64-bytes.

 Following components are generated:
 * RSA/1536 keypair, with public exponent e=3 and modulus N. The key can be
   encoded to PEM format to make challenge look more realistic.
 * Random 512-bit number K from a range `N^(1/3)<K<(2N)^(1/3)`.

 Afterwards we encrypt K with a RSA public key and convert result to big-endian octet string
 (Y=K^e mod N). The string will be 192 bytes long.
 Finally we XOR Y octet string with secret S, C=Y xor S (there may be an information
 in a challenge, which says that XOR was used as symmetric cipher).

 This is easily breakable. The key is to notice that a) there is no padding,
 b) by construction Y+N is a perfect cube, whose root is K (K^3 == Y+N).


By Kris Kwiatkowski, Cloudflare

# Flag
flag{saltstacksaltcomit5dd304276ba5745ec21fc1e6686a0b28da29e6fc}
