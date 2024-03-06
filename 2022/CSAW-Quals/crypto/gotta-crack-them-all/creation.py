import random
from encrypt import *

with open('list.txt') as f:
	passwords = f.read().split('\n')[:-1]

with open('flag.txt') as f:
	admin_password = f.read()[:-1]

while True:
	list_good = False
	password_list = []
	i = 0
	while i < 50:
		password = random.choice(passwords)
		if password not in password_list:
			i += 1
			password_list.append(password)
			if password.count('-') == 2 and len(password) < len(admin_password):
				list_good = True
	if list_good:
		break

password_list.append(admin_password)
random.shuffle(password_list)
enc_list = []
leaked_password = ''
for p in password_list:
	if len(p) < len(admin_password) and leaked_password == '' and p.count('-') == 2:
		leaked_password = p
	enc_list.append(encrypt(p))

with open('leaked_password.txt','w') as f:
	f.write(leaked_password)

with open('encrypted_passwords.txt','wb') as f:
	for enc in enc_list:
		f.write(enc+b'\n')
