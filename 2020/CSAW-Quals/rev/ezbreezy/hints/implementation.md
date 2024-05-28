Run the following command to get the flag:

```
r2 -e scr.color=false -q -c 's 0x8001a0; /aa mov byte [rbp' app | python3 -c 'import sys; print("".join([chr(int(line.strip().split(", ")[1],16)-40) for line in sys.stdin]))'
```
