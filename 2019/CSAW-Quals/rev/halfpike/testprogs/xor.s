fim p0 0b1000_1111
jms XOR
hlt: jun hlt


; from page 107 of the MCS-4 Assembly Language Programming Manual
; r0 = r0 ^ r1
XOR:
fim p1 11
L1:
ldm 0
xch r0
ral
xch r0
inc r3
xch r3
jcn a L2
xch r3
rar
xch r2
ldm 0
xch r1
ral
xch r1
rar
add r2
ral 
jun L1
L2:
bbl 0
