#!/usr/bin/python
from Crypto.Cipher import DES
import binascii

IV = '13371337'

def padInput(input):
	bS = len(input)/8
	if len(input)%8 != 0:
		return input.ljust((bS+1)*8,"_")	
	return input

def desEncrypt(input,key):
	cipher = DES.new(key, DES.MODE_OFB, IV)
	msg = cipher.encrypt(padInput(input))
	return msg

def getNibbleLength(offset):	
	if str(offset)[0]=="9":
		return len(str(offset))+1
	return len(str(offset))
	
###############################################################
def desDecrypt(input,key):
	cipher = DES.new(key, DES.MODE_OFB, IV)
	msg = cipher.decrypt(input)
	return msg	

def extract(encoded,offset):
	nibbleLen = getNibbleLength(offset)
	firstHalfByte = makeHex((int)(encoded[:nibbleLen])-offset)
	secondHalfByte = makeHex((int)(encoded[nibbleLen:])-offset)
	hexByte = (str(firstHalfByte)+str(secondHalfByte)).decode("hex")
	return hexByte		

def makeHex(dec):
	chr = ['A','B','C','D','E','F']
	if dec>10:
		return chr[dec-11]
	return dec	
	
def decode(contents,offset):
	nibbleLen = getNibbleLength(offset)
	output = ""
	for i in range(0,len(contents),nibbleLen*2):
		try:
			output += extract(contents[i:i+nibbleLen*2],offset)
		except:
			continue
	return output
	
def solver(encrypt,plain):
	# Weakkeys puuled from wiki
	specialKeys = ["FEFEFEFEFEFEFEFE", "FFFFFFFFFFFFFFFF", "1F1F1F1F0E0E0E0E", "E0E0E0E0F1F1F1F1", "E1E1E1E1F0F0F0F0", "0000000000000000", "0101010101010101", "0101010101010101", "FEFEFEFEFEFEFEFE", "1F1F1F1F1F1F1F1F", "E0E0E0E0E0E0E0E0", "01FE01FE01FE01FE", "FE01FE01FE01FE01", "1FE01FE01FE01FE0", "E01FE01FE01FE01F", "01E001E001E001E0", "E001E001E001E001", "1FFE1FFE1FFE1FFE", "FE1FFE1FFE1FFE1F", "011F011F011F011F", "1F011F011F011F01", "E0FEE0FEE0FEE0FE", "FEE0FEE0FEE0FEE0", "1F1F01010E0E0101", "E00101E0F10101F1", "011F1F01010E0E01", "FE1F01E0FE0E01F1", "1F01011F0E01010E", "FE011FE0FE010EF1", "01011F1F01010E0E", "E01F1FE0F10E0EF1", "FE0101FEFE0101FE", "E0E00101F1F10101", "E01F01FEF10E01FE", "FEFE0101FEFE0101", "E0011FFEF1010EFE", "FEE01F01FEF10E01", "FE1F1FFEFE0E0EFE", "E0FE1F01F1FE0E01", "FEE0011FFEF1010E", "1FFE01E00EFE01F1", "E0FE011FF1FE010E", "01FE1FE001FE0EF1", "E0E01F1FF1F10E0E", "1FE001FE0EF101FE", "FEFE1F1FFEFE0E0E", "01E01FFE01F10EFE", "FE1FE001FE0EF101", "0101E0E00101F1F1", "E01FFE01F10EFE01", "1F1FE0E00E0EF1F1", "FE01E01FFE01F10E", "1F01FEE00E0EF1F1", "E001FE1FF101FE0E", "011FFEE0010EFEF1", "1F01E0FE0E01F1FE", "01E0E00101E1E101", "011FE0FE010EF1FE", "1FFEE0010EFEF001", "0101FEFE0101FEFE", "1FFEE0010EF1FE01", "1F1FFEFE0E0EFEFE", "01FEFE0101FEFE01", "1FE0E0F10EF1F10E", "FEFEE0E0FEFEF1F1", "01FEE01F01FEF10E", "E0FEFEE0F1FEFEF1", "01E0FE1F01F1FE0E", "FEE0E0FEFEF1F1FE", "1FFEFE1F0EFEFE0E", "E0E0FEFEF1F1FEFE", "F1F1F1F1E0E0E0E0", "FE1FFE1FFE0EFE0E"]

	cipherText = open(encrypt).read()
	cipherText = decode(cipherText,9133337)
	cipherText = binascii.unhexlify(cipherText)
	decryptMid = []

	for key in specialKeys:
		decryptMid.append(desDecrypt(cipherText,binascii.unhexlify(key)))

	plainText = open(plain).read()
	encryptMid = []

	for key in specialKeys:
		encryptMid.append(desEncrypt(plainText,binascii.unhexlify(key)))
		
	for i in range(len(encryptMid)):
		for j in range(len(decryptMid)):
			if not decryptMid[i]:
				continue
			
			if(encryptMid[i]==decryptMid[j]):
				print "%d %d"%(i,j)
				print "Found Keys : " + specialKeys[i] + "  " + specialKeys[j] 
				# decrypt twice
				#print desDecrypt(desDecrypt(cipherText,binascii.unhexlify(specialKeys[j])),binascii.unhexlify(specialKeys[i]))
				print "Flag Solved"
				cipherTextFlag = open('FLAG.enc').read()
				cipherTextFlag = decode(cipherTextFlag,9133337)
				cipherTextFlag = binascii.unhexlify(cipherTextFlag)
				print desDecrypt(desDecrypt(cipherTextFlag,binascii.unhexlify(specialKeys[j])),binascii.unhexlify(specialKeys[i]))
###############################################################	

print "Given Plaintext and Ciphertext Solver ____________________________________________________________________________________________________________________"
solver('DES2Bytes.enc','DES2Bytes.txt')

