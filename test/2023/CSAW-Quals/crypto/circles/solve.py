from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
from secret import special_function

with open('flag.enc','rb') as f:
	enc = f.read()

key = special_function(0xcafed3adb3ef1e37).to_bytes(32,"big")
iv = b"r4nd0m_1v_ch053n"
cipher = AES.new(key, AES.MODE_CBC, iv)
flag = unpad(cipher.decrypt(enc),AES.block_size)

with open('flag_solved.png', 'wb') as f:
	f.write(flag)