# public
* MD5(./share.zip)= 26103913e0898fae499f071dcb805317

# Note
It's a challenge about VM escaping: a binary runs in the VM and people are supposed to use two vulnerabilities to escape from the VM.
It's easy if you know the solution, that's from an unexcepted solution in 0CTF-finial. If you are testing this challenge, please help me check if the VM is secure and doesn't have other vulnerabilities and people could not use the vulnerability perform some easy solutions, which means finding an easier way is harder than using the official solution.

# Vulnerabilities
* Buffer overflow in VM(./src/main.c) function `readint`
* Buffer overflow in binary, CSAW-Game. function `check`
# Solution

* Use BoF in check to perform ROP to trigger VM vulnerability
* back to binary after freeing `tcahce_perthread_struct`
* Partial write + Use binmap as the head of chunk
* Use tacheche-key to bypass a crash in strtol
* IO Leak + `__free_hook` hijack

# Testing:
The brute force solver (exp.py) is fast when performed locally but very slow when run against the server. There is a threaded testing option available which performs much better, but care must be taken to ensure it is not left running when not in use.  Run `python3 run.py` to generate a 10-threaded execution of `threaded_exp.py`. Some Python errors might be thrown, but wait for the program to print out the retrieved flag via stdout.  

Flag retrieved remotely and locally within the provided Docker container. 

MD5sums for provided files:

```
❯ md5sum CSAW-GAME 
30b1cf5e7d75d9d27de6cf603f538c6e  CSAW-GAME
❯ md5sum pwn 
d677d2623392395c31e257c594961f73  pwn
❯ md5sum libc-2.31.so 
d371da546786965fe0ee40147ffef716  libc-2.31.so
✗ md5sum share.zip
26103913e0898fae499f071dcb805317  share.zip
```

**note - the libc is not explicitly provided but a Dockerfile is which contains this libc**
