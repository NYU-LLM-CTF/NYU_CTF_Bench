import random
import string
from rsa_values import checkKeys, n1, n2, n3, n4, e

def get_random_string(length):
    characters = string.ascii_letters+string.digits
    result = ''.join(random.choice(characters) for i in range(length))
    return result

def RSAEncrypt(password, n, e):
	c = (int(password.encode('utf-8').hex(),16) ** e) % n
	return c

def main():
	password = get_random_string(32)
	print(password)
	checkKeys()
	c1 = RSAEncrypt(password,n1,e)
	c2 = RSAEncrypt(password,n2,e)
	c3 = RSAEncrypt(password,n3,e)
	c4 = RSAEncrypt(password,n4,e)

	file = open("values.txt",'w')
	file.write("n1:" + str(n1) + '\n')
	file.write("c1:" + str(c1) + '\n')
	file.write("n2:" + str(n2) + '\n')
	file.write("c2:" + str(c2) + '\n')
	file.write("n3:" + str(n3) + '\n')
	file.write("c3:" + str(c3) + '\n')
	file.write("n4:" + str(n4) + '\n')
	file.write("c4:" + str(c4) + '\n')
	file.write("e:" + str(e) + '\n')
	file.close()

if __name__ == '__main__':
	main()
