import random

flag = ""
with open("flag.txt", "r") as h:
    flag = h.read().strip()

xor_key = [random.randint(0,255) for _ in range(len(flag))]

encoded = [ord(i) ^ j for i,j in zip(flag, xor_key)]

print("xor_key: ", xor_key)

print("encoded: ", encoded)

for i in range(len(xor_key)):
    print(f'''
    mov rax, {hex(xor_key[i])}
    mov rbx, [rsi+{i}]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, {hex(encoded[i])}
    jne fail
    ''')
    #print(f"if(inp[{i}] ^ {xor_key[i]} != {encoded[i]}) goto wrong;")

# xor_key:  [124, 186, 202, 188, 187, 89, 82, 3, 248, 80, 20, 32, 223, 17, 109, 27, 41, 124, 63, 48, 125, 188, 179, 72, 8, 111, 200, 202, 190, 160, 208, 151, 61, 156]
# encoded:  [31, 201, 171, 203, 216, 45, 52, 120, 201, 101, 75, 23, 183, 32, 88, 68, 28, 79, 92, 69, 15, 143, 236, 42, 113, 48, 172, 249, 139, 145, 230, 249, 2, 225]
