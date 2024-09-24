# Design

This challenge will be composed of two parts, one reversing and one pwning

## CPU Design


the conversion are the following, by default it is a 
reg,reg ops unless otherwise specified

bits    opcode          comments
1       push            2 toggles imm
5       add             2 toggles imm
9       sub             2 toggles imm
13      xor             2 toggles imm
17      mov             2 toggles imm, 4 toggles \[reg+reg\], reg, 8 toggles \[reg+imm\], reg
21      inc             
25      dec             
29      cmp             2 toggles imm
33      jne             
37      ret             
41      call            
45      syscall
49      inverse mov     2 toggles reg, \[reg+imm\]
53      and             2 toggles imm
57      pop             
