# The Lengths We Extend Ourselves
Premise:
You’re out for revenge against your work-nemesis, Alice! It’s not ethical nor is it legal but you’ve intercepted a message from Alice to the Boss. You want to append ' P.S. I QUIT!' to her message but to do that you need the right hash signature! What signature do you need for this attack to work?

## Author
Eliana Halevi

## Questions & Answers:
What is the hash signature of the message appended with ' P.S. I QUIT!'?: a65cf5860ff5a095bbb0ad2c64c08f9adabdff77f4e5ef17d96433f9ddd9ff5

Final Flag: flag{100ks_1ik3_4Lic3_i5_0ut_0f_@_j08_s0_c0n92475_i_Gu355?}
		          	"looks_like_alice_is_out_of_a_job_so_congrats_i_guess?"
			

## Solution / Notes

### 1. Hash Signature
This is a Length Extention Attack! To perform a length extention attack we need 3 things: the original message's hash, the length of the previous message, and the data you'd like to append to the original data. 
In the intercepted message, the hash is stated at the top:

TO:Boss
FROM:Alice
Message Signature: 08e7934a4493dd806028a9cfe3b6980375209c58b9895d7ed5b05fd61c02a3f1

At a glance it seems like you can just get the length of the encoded message with len:
ex.

print(len(f637d069f1f65f2a6b03d1168a49d6d1ff4e9c82182102ad8f7a8de15c8213227a5b5c1dad9b6d6ed58fde9ddae24d51ca5cd2a50cf8ce2562f0a317a2e6c927491fb4dece5b35439b5163514c171ffe110c341fef0e9eb52de772c1ac300e15559069b134082fea11c949443d41c9988fafdf2acae8e8d55cb20ee8a0521ed2daa7254dbc4c38a4d3c15f19c461cbe573a484781a0419528b850dc77e022f476926719ea6c625c5d57b0ac4fedeedd8be8e5dd4b0d5f5cc4d73ecd4c11b28399d7606d54e97df688ed8683f145d6c7443bac5bd84c7090cb7baaaff8324dfdf6af7363a1451ac22f0a131e36ef3a3d0b3230f1445b1b66ad6ea6ca5182f942984579765de51acf8e9064c3a7faad8eefd4cfb9c202dc2880431ba2c0fe94798e954165675c6d1556cca13ed4d97a329b11479af960d96fe3749a5123e05fd62685f9d798347146228cc14ad0b6d738b6a0d865f06241e6b6018124f9e672efe3b0c59815c0c7d23758feb448c12d36291f861edfba2d558d6d4f33ade2b3e61f107d79e63d1f8227f4dfacf67897c1f5842652e863236f0e28406))

But because the message is encrypted with Salsa20, the length of the ciphertext is not equal to the length of the plain text. 
def encode_msg(garlic: str) -> str: # spicy
    cilantro = garlic.encode()
    tomato = Salsa20.new(key=GUAC)
    super_spicy = tomato.nonce + tomato.encrypt(cilantro)
    return super_spicy

The key, GUAC, is hardcoded at the top of the python file:

GUAC = b'nothng is as it seems. or is it?'

So the easiest way to decrypt Alice's message is with the following:
def decode(message: bytes) -> str: 
    msg_nonce = message[:8]
    ciphertext = message[8:]
    cipher = Salsa20.new(key=GUAC, nonce=msg_nonce)
    plaintext = cipher.decrypt(ciphertext)
    return plaintext
    
The decrypted message says:
Done! As long as you include your secret key somewhere in the message our messages can't be tampered with! Cool right? Plus even if you include the key it will just look like zeros. Ex. My key is: 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000. Anyway, catch ya later. -A

NOTE: 
You don't have access to Alice's secret key (SECRET = open('secrets.txt', 'r').read()) because you don't have her secrets.txt file. The message was hashed before the secret key was obfuscated. It is not possible to recover the secret key. Therefore, you cannot simply append ' I QUIT!' to the original fully decrypted message because you don't have the key

The length of the original message is 403.

When a message is hashed with sha256, no matter what size it is, it is padded with b'\x80' followed by a number of b'\x00's and the length processed msg * 8
    buffbytes = 64 - 1 - (length + 8) % 64
    zeros = b'\x00' * buffbytes 
    processed = (length * 8).to_bytes(8, "big")
    return b'\x80' + zeros + processed
    
To add more data to the original message, we need to calculate the original amount of padding and add that to the original message length, create a new hash object, and set it's previous state as the original hash and the new size. This indicates that the original message and that padding have already been processed. Update this instantiated hash object with the evil message. To access the new hash value, digest the object and call .hex()


def attack(length: int, hashval: bytes, suffix: bytes) -> bytes:
    orig_padding = len(sha256_padding(length))  # old padding size
    new_size = orig_padding + length            # new padding size
    new_hash = sha256.sha256()                  # new hash object
    new_hash.state = (hashval, new_size)        # state of object is equal to last state + padding before hashed w
    new_hash.update(suffix)                     # add suffix
    return new_hash.digest()


NOTE: DIGEST IS UNSTABLE AND WILL SCRAMBLE IF CALLED MULTIPLE TIMES
