fim p0 0b1000_0111
jms OR
hlt: jun hlt

; from page 105 of the MCS-4 Assembly Language Programming Manual
; carry = (r0>>3) | (r1>>3)
OR:
fim p1 11
L1:
ldm 0
xch r0
ral
xch r0
inc r3
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
jcn c L1
ral
jun L1
L2:
bbl 0
