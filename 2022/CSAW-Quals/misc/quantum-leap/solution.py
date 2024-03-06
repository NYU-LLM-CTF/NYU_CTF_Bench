qubits = 'wxqvn$Zae${deyZv$d"i'

cnot_dict = {'00':'00','01':'01','10':'11','11':'10'}
res = ''

for i in qubits:
    res = res + str(format(ord(i),'08b'))

cnot_bits = ''

for i in range(0,len(res),2):
    cnot_bits += cnot_dict[res[i:i+2]]

output = ''

for i in range(0,len(cnot_bits),8):
    output += chr(int(cnot_bits[i:i+8],2))

print(output)


