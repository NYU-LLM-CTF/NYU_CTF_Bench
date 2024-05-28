import struct

# PYTHON2
#hash = open('hash.txt').read()
#hash = map(lambda x: struct.unpack("B", x)[0], hash)

# PYTHON3
hash = open('hash.txt', 'rb').read().decode('latin-1')
hash = [ord(x) for x in hash]
flag = [ 0 ] * 48

flag[0]  = hash[235]
flag[1]  = hash[178]
flag[2]  = hash[217]
flag[3]  = hash[226]
flag[4]  = hash[250]
flag[5]  = hash[91] - 7
flag[6]  = hash[169] + 1
flag[7]  = hash[245] - 9
flag[8]  = hash[0] + 3
flag[9]  = hash[219] - 5
flag[10] = hash[14] + 4
flag[11] = hash[16]
flag[12] = hash[80]
flag[13] = hash[138]
flag[14] = hash[139]
flag[15] = hash[227] - 8
flag[16] = hash[148]
flag[17] = hash[146]
flag[17] = hash[146]
flag[18] = hash[29]
flag[19] = hash[171] + 8
flag[20] = hash[128]
flag[21] = hash[131]
flag[22] = hash[184] + 9
flag[23] = hash[6] - 9
flag[24] = hash[165] - 4
flag[25] = hash[49] - 5
flag[26] = hash[12]
flag[27] = hash[116]
flag[28] = hash[222] + 7
flag[29] = hash[254] + 3
flag[30] = hash[75]
flag[31] = hash[17]
flag[32] = hash[60]
flag[33] = hash[94]
flag[34] = hash[194]
flag[35] = hash[149]
flag[36] = hash[187] - 1
flag[37] = hash[43]
flag[37] = hash[43]
flag[38] = hash[65]
flag[39] = hash[73]
flag[40] = hash[33] + 5
flag[41] = hash[68]
flag[42] = hash[37] - 8
flag[43] = hash[41] - 5
flag[44] = hash[13]
flag[45] = hash[209]
flag[46] = hash[195] + 7
flag[47] = hash[50] - 2

# PYTHON3
print("".join([chr(x) for x in flag]))

# PYTHON2
#print ("".join(map(lambda x: struct.pack("B", x), flag)))
# flag{h0p3_y0u_3nj0yed_4_FREE_5cr1pting_l4nguag3}
