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

# xor_key:  [86, 43, 151, 18, 105, 124, 132, 198, 173, 113, 242, 251, 233, 47, 241, 228, 102, 6, 201, 206, 148, 93, 56, 79, 99, 228, 240, 3, 30, 163]
# encoded:  [53, 88, 246, 101, 10, 8, 226, 189, 232, 64, 199, 164, 172, 29, 193, 187, 30, 112, 255, 145, 236, 101, 14, 16, 13, 139, 153, 96, 123, 222]

