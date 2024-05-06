import random
import math
import requests

remote_oracle_url = "http://crypto.csaw.io/rsa/decrypt"

#Public modulus (n)
n=26906177157603510224370406783094305504077340947906531817399239399530789870302131621172646916728678717424254816529956157726347481373963707471097162085403107842347543608268147188585927775766400738777523900665532392003061694758047363105808213014221422713214739752760138627476076929661188588519076579856528258600985735717379123089511697140363359256964131640146169610915257233210627099137318258247494083238359995575932066133817359288340229806143302236195738006063109108936419879896891348020806474841117234127110428177450850870307344120447174083974955979677030276104709257126160022711565028171938574382093701232149121512363

# Public exponent (e)
e = 65537

#Encrypted flag
c = b'\x0e\xb9\x0e\xf5\x80\\\xe9\x94\xee\xa8\x7f\x0c\xc3H\r\xc1\xbb/\x03\x16\x9c\xb1(\x17\xa1+\x1e\xd7#\xa2\x0f\x19%\xc1B8Yw\x7f\xe5\xc0\x11\xca?\xa3TW|\tN\xf4X\x80\x8c\xb1Z6x\x98\xbd\xee\x04r\x16\x02\xc0\xc1\xc6\\\x14_/nW2*\xff\xbd\x8e\x98>DZ$\xe3\xf9\xfa\xca\xeb@\x95b\xcc\xed)R\x9c\x14\n\\9\xa1\xcc\n\x15#p\xe9\x80\xf0RL\xb7\x829\x1b\xbb\xca\xdf"E\x0c)b\xea\xb9\xba\xba\x92\x05\xc0C\x05{\x19\xacq\xbd\xba\\\x0b\x0e\xd5\xe6~\xf2\x14E\x16L[\x15\x9aP\xbd\xe4*\xa3 \x143\xa60\x1f\xd0oh\xe2\xea\x01\xeb\x9c8\xebq\xb4y\xd3\x986|W\x01\x82\x1c\xce\x9f\x08\xa6\xa6\x17\xba(\xc7\x9e\x01\x96\xff\xd4!\x8e\xb9s\xe9Kj\nWS\xe7\x1a\x0c\xb7_0X\xe3\x90\xbc\xab\x9d\xea\x02\xd5\xdaxj\xafq\xfe\x8f\xcb\xaa\xeb\x11\xdbb\x1c\xd1\xc7\xfa\xb6\x87\xd4!QA\x88\xfb\x9f\xe8u6|;R'


#Creation of the mask used for padding
def create_mask(word: str):
    mask=''
    while (int.from_bytes(mask.encode('utf-8'), byteorder='big')<n-len(word)):
        mask+= word
    return mask.encode('utf-8')


#function to xor two byte arrays
def xor(x: bytes, y: bytes) -> bytes:
    '''XOR bytearrays x and y up to length of x'''
    m=y
    for i in range(len(y),len(x)):
        m+=b'\0'
    return bytes([a^b for a,b in zip(x,m)])

#Textbook RSA encryption with no padding
def encrypt_no_padding(m,e):
    int_result = int.from_bytes(m, byteorder='big')
    int_ciphertext = pow((int_result),e, n)
    return int_ciphertext.to_bytes(((int_ciphertext.bit_length()+7)//8),byteorder='big')


#--------------------------------------------------------------------------------------------------------------------
#First step: Identify the padding
#Encrypt a message m of your choice using textbook RSA encryption. Output: c (byte array)
#Ask the decryption oracle to decrypt it for you. Output: m' (byte array)
# m and m' are not equal. XOR'ing both byte arrays gives you the mask: The padding consists in xor'ing the plaintext with this mask < n.
test = b'test this message xxxxxxxxxxxxxxxxxy'
cipher_test = encrypt_no_padding(test,e)
#test_decrypt = decrypt_oracle(cipher_test,d)
test_decrypt = requests.post(url=remote_oracle_url, data=cipher_test).content
print("decrypted by oracle:", test_decrypt)
mask = xor(test,test_decrypt)
print("padding used:", (mask).decode('utf-8'))

#--------------------------------------------------------------------------------------------------------------------
#Use the pattern you recognize to create your mask
mask = create_mask('///punks.lively.laptop')
print("*****************************************************************")

#--------------------------------------------------------------------------------------------------------------------
#Modification of the encryption function including the padding
#Add a xoring between plaintext and recovered mask
def encrypt(m,e):
    result = xor(m,mask)
    return encrypt_no_padding(result,e)

#--------------------------------------------------------------------------------------------------------------------
#Attack the algorithm by using the malleability of textbook RSA
#Create a modified version of the inital ciphertext, (c'), by making predictable changes to the given ciphertext (c)
#c' = "(2**e)*c"
#The output of the decryption oracle after decrypting (c') will help find the inital plaintext.
# Output: ((2*(m xor mask))xor mask)
#--------------------------------------------------------------------------------------------------------------------
cipher_bis = (pow(2,e,n) * int.from_bytes(c, byteorder='big')) % n
cipher_bis_bytes= cipher_bis.to_bytes(((cipher_bis.bit_length()+7)//8),byteorder='big')
m_bis = requests.post(url=remote_oracle_url, data=cipher_bis_bytes).content

#--------------------------------------------------------------------------------------------------------------------
#Retrieve m by cancelling following operations: xor mask, multiply by 2, xor mask
result = xor(m_bis,mask) #cancel first xor
result_int = int.from_bytes(result, byteorder='big')
result_int = result_int >> 1 #cancel multiply by 2 by shifting to the right
result_bytes = result_int.to_bytes(((result_int.bit_length()+7)//8),byteorder='big')
result = xor(result_bytes,mask) #cancel last xor
#--------------------------------------------------------------------------------------------------------------------

print("Recovered flag by challenger using malleability, xoring and shifting:", result.decode())
