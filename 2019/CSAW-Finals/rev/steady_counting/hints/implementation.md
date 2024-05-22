Run the following radare2 command to print the ascii value of the flag characters, then convert them to get the flag

```
r2 -e scr.color=false -q -c 'aaa; s 0x60f0e0; (m; pi 10 @ `axtq`; s +1); 30.(m);' counting  | sed -n '/sub cl/s/sub cl, //p'
```
