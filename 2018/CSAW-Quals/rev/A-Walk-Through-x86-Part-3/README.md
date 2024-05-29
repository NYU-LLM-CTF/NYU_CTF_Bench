Give them: "part-3-server.py", "Makefile", "tacOS.bin"

Flag is in 'flag.txt'

Description:

The final boss!

Time to pull together your knowledge of Bash, Python, and stupidly-low-level assembly!!

This time you have to write some assembly that we're going to run..  You'll see the output of your code through VNC for 60 seconds.

Objective: Print the flag.

What to know:

Strings need to be alternating between the character you want to print and '0x1f'.

To print a string you need to write those alternating bytes to the frame buffer (starting at 0x00b8000...just do it).  Increment your pointer to move through this buffer.

If you're having difficulty figuring out where the flag is stored in memory, this code snippet might help you out:

```
get_ip:
  call next_line
  next_line:
  pop rax
ret
```

That'll put the address of `pop rax` into rax.

Call serves as an alias for `push rip` (the instruction pointer - where we are in code) followed by `jmp _____` where whatever is next to the call fills in the blank.

And in case this comes up, you shouldn't need to know where you are loaded in memory if you use that above snippet...

Happy Reversing!!

 - Elyk
 
