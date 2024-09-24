from cryptography.fernet import Fernet
import base64

key = base64.b64encode(b"xYDFDoqcOACPKeT5gT0wBzAfBSoGieVc")
f = Fernet(key)

file = open("flag.txt","rb")
encrypted = f.encrypt(file.read())
file.close()

with open("encrypted_flag.txt","wb") as encrypted_file:
	encrypted_file.write(encrypted)
