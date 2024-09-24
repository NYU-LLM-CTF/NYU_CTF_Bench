fim p0 0b1111_1010
jms AND
hlt: jun hlt ; spin 5ever

; from page 104 of the MCS-4 Assembly Language Programming Manual
; r0 = r0 & r1
AND:
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
xch r1
ral
xch r1
rar
add r2
jun L1
L2:
BBL 0
