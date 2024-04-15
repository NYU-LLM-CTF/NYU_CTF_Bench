with open("flag.txt",'r') as f:
    flag = f.read()

def decode(enc):
    d = 24
    x = enc[::-1]
    x = x[len(x)-d:] + x[0:len(x)-d]
    x = ''.join(['0' if x[i] == '1' else '1' for i in range(len(x))])
    x = x[d:] + x[0:d]
    n = int(len(x)/8)
    plain = ['x']*n
    for i in range(n):
        plain[i] = chr(int(x[(i*8):(i*8+8)],2) >> 1)
    return ''.join(plain)

def main():
    encoded = "1010000011111000101010101000001010100100110110001111111010001000100000101000111011000100101111011001100011011000101011001100100010011001110110001001000010001100101111001110010011001100"
    print(decode(encoded))
    assert flag == decode(encoded)

if __name__ == "__main__":
  main()