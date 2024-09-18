# oracle v2.34

This challenge is an x86-64 ELF binary linked against glibc-2.34. glibc-2.34 implements new security measures such as tcache & fastbins pointer alignment verification, "safe-linking", and elimination of `__free_hook` and `__malloc_hook`.  The docker image is built with Ubuntu latest and supplemented with glibc 2.34, installed in the `/glibc` directory. The binary is patched to use the 2.34 loader using the `patchelf` utility.

See the walkthrough for more details on the vulnerability and solution.  

Files distributed with md5sums:
* MD5(./public/horrorscope)= a451b831caf94120df6e5bd2a97a5c2d
* MD5(./public/libc-2.34.so)= 9bd3fefc86faf941ea561099d7f5ec0a

*note that the libc hash may vary if challengers build their own libc environment. That should not matter, as the accepted solution does not use a specific libc (i.e., no libc ROP gadgets). The libc is provided so that challengers understand the binary runs with libc 2.34, the newest version*


## TODO: This challenge needs vetting of the main menu options. I added functionality on the fly to meet my exploit requirements, so not all of the functions might be perfectly fined tuned. It also needs to be tested to make sure there is not an "easy" solution to it that I missed.
