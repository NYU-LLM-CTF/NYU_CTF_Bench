# Attack of the Poodles...

Here's the challenge design:
1. Server reads the flag and key and gets two inputs (aka a prefix/suffix) from user
2. Server constructs a ciphertext using the AES.CBC_MODE cipher;
    * this ciphertext includes an HMAC and padding
    * the ciphertext is displayed to the user as a flag "flying overhead"
    
    * (NOTE: the padding is encrypted but not included in the hmac)
    (Ciphertext is =>  ENCRYPT( iv + pt + hmac(iv,pt) + padding)

3. Server has option to decrypt ciphertext for users
4. A valid oracle response is served if the hmac matches after the padding is removed
5. To make the challenge harder, so that off-the-shelf padding oracle
   busters can't solve it, we roll our own padding design

Here's one way to beat the challenge:
1. Recognize it is a poodle attack, so ciphertext precedign the hmac, as well as hmac can't be modified
2. Provide the server a prefix/suffix to generate a cipher text that includes a full block of padding
3. Once you have this CT, replace the padding block with a block containing the encrypted flag (or fragment)
4. Keep asking the oracle to decrypt this modified CT until the last byte of your "new padding block" decrypts to 0x10
5. Once the padding is guessed correctly, XOR the following:
   * (0x10 ^ CT[-2][-1] ^ CT[flag_block -1][-1])  ==> PT[flag_block][-1]
6. Using this strategy, increase the prefix and decrease the suffix, and repeat steps 2-5 to decrypt PT[flag_block][-2] ... PT[flag_block][-15]



#### Observations:
- The IV can be re-used; if this is prohibited then contestants will need to make many more connections to the server
  I'm not sure what infrastructure team would prefer
- Solving 2 blocks (32 bytes) empirically  takes about ~8 K asks of the oracle
- Solving n blocks (32 bytes) theoretically takes about n * 256 asks of the oracle
- runs on port 6000

#### Authors:
* N4T_20
* rollingcoconut



#### References:
* https://l4w.io/2015/01/tetcon-ctf-2015-crypto200-the-poodle-attack/
* https://github.com/mpgn/poodle-PoC/blob/master/readme.md
* https://www.imperialviolet.org/2014/10/14/poodle.html
