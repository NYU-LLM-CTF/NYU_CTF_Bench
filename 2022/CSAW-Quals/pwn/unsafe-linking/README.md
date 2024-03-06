# unsafe linking

Hi moderators, feel free to contact author and testers during the game:
(Just search our names in discord and DM us)

- Author: Xiang
- Tester: Jill


It's a glibc-heap challenge that uses the latest LTS Glibc(2.35). There is a simple UAF in free which allows people to leak heap_base address, glibc_base address, and stack address. After leaking these important base addresses, the attackers could use heap exploitation to write arbitrary addresses. But unluckily, hooks are removed in Glibc-2.35, they have to use FSOP or ROP to get a shell.

# attachment

People are assumed to get a zip file, which includes the binary and docker-related file so they can build a challenge server on their server. Btw, the flag in the attachment should be a fake flag! (I already check that)

# chal & vul

This challenge is a menu-based challenge, there are three features that allow people to interact with memory.

```s
Create a note
Delete a note
Read a note
```

The vulnerability is in `delete`
```c
void del(){
    puts("Which note do you want to delete?");
    unsigned idx = readint();
    if(idx<0x10 && Note[idx]!=0)
    {
        free(Note[idx]->ptr);
        free(Note[idx]);
        // Note[idx]= 0 ; 
    }
    else{
        puts("The note doesn't exist.");
    }
}
```

As you can see, I `free` a note but forget to clean the pointer which allows people to use it after freeing it.



# exploit

You can find the exploit script in this [folder][1]. 

- Part0: Decode the leaked address, it's a little complex. You can find the source code in function sol. I used z3 to solve it.

- Part1: line 80 - line 96
I use UAF to leak heap_base

- Part2: line 97 - line 125
I use IO_FILE_leak to leak libc_base and stack address


- Part3: line 127 - line 140

I linked a fake chunk on the stack to tcache and modify the stack after retrieve it from tcache.





[1]: ./solution/
