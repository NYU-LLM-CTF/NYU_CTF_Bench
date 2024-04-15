; Disassembly of file: generated.o
; Fri Aug 21 13:36:48 2020
; Mode: 64 bits
; Syntax: YASM/NASM
; Instruction set: 8086, x64
BITS 64


global main


SECTION .text                             ; section number 1, code

main:   ; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        mov     dword [rbp-4H], 201782                  ; 0004 _ C7. 45, FC, 00031436
        cmp     dword [rbp-4H], 16218                   ; 000B _ 81. 7D, FC, 00003F5A
        jnz     ?_001                                   ; 0012 _ 75, 0A
        mov     eax, 1                                  ; 0014 _ B8, 00000001
        jmp     ?_027                                   ; 0019 _ E9, 000002E4

?_001:  mov     byte [rbp-4H], -114                     ; 001E _ C6. 45, FC, 8E
        mov     dword [rbp-4H], 1174643                 ; 0022 _ C7. 45, FC, 0011EC73
        cmp     dword [rbp-4H], 453054                  ; 0029 _ 81. 7D, FC, 0006E9BE
        jnz     ?_002                                   ; 0030 _ 75, 0A
        mov     eax, 1                                  ; 0032 _ B8, 00000001
        jmp     ?_027                                   ; 0037 _ E9, 000002C6

?_002:  mov     byte [rbp-3H], -108                     ; 003C _ C6. 45, FD, 94
        mov     dword [rbp-4H], 995231                  ; 0040 _ C7. 45, FC, 000F2F9F
        cmp     dword [rbp-4H], 2515872                 ; 0047 _ 81. 7D, FC, 002663A0
        jnz     ?_003                                   ; 004E _ 75, 0A
        mov     eax, 1                                  ; 0050 _ B8, 00000001
        jmp     ?_027                                   ; 0055 _ E9, 000002A8

?_003:  mov     byte [rbp-2H], -119                     ; 005A _ C6. 45, FE, 89
        mov     dword [rbp-4H], 4412                    ; 005E _ C7. 45, FC, 0000113C
        cmp     dword [rbp-4H], 1737950                 ; 0065 _ 81. 7D, FC, 001A84DE
        jnz     ?_004                                   ; 006C _ 75, 0A
        mov     eax, 1                                  ; 006E _ B8, 00000001
        jmp     ?_027                                   ; 0073 _ E9, 0000028A

?_004:  mov     byte [rbp-1H], -113                     ; 0078 _ C6. 45, FF, 8F
        mov     dword [rbp-4H], 1578885                 ; 007C _ C7. 45, FC, 00181785
        cmp     dword [rbp-4H], 601428                  ; 0083 _ 81. 7D, FC, 00092D54
        jnz     ?_005                                   ; 008A _ 75, 0A
        mov     eax, 1                                  ; 008C _ B8, 00000001
        jmp     ?_027                                   ; 0091 _ E9, 0000026C

?_005:  mov     byte [rbp], -93                         ; 0096 _ C6. 45, 00, A3
        mov     dword [rbp-4H], 1661542                 ; 009A _ C7. 45, FC, 00195A66
        cmp     dword [rbp-4H], 1520429                 ; 00A1 _ 81. 7D, FC, 0017332D
        jnz     ?_006                                   ; 00A8 _ 75, 0A
        mov     eax, 1                                  ; 00AA _ B8, 00000001
        jmp     ?_027                                   ; 00AF _ E9, 0000024E

?_006:  mov     byte [rbp+1H], -99                      ; 00B4 _ C6. 45, 01, 9D
        mov     dword [rbp-4H], 946498                  ; 00B8 _ C7. 45, FC, 000E7142
        cmp     dword [rbp-4H], 1438878                 ; 00BF _ 81. 7D, FC, 0015F49E
        jnz     ?_007                                   ; 00C6 _ 75, 0A
        mov     eax, 1                                  ; 00C8 _ B8, 00000001
        jmp     ?_027                                   ; 00CD _ E9, 00000230

?_007:  mov     byte [rbp+2H], -121                     ; 00D2 _ C6. 45, 02, 87
        mov     dword [rbp-4H], 760080                  ; 00D6 _ C7. 45, FC, 000B9910
        cmp     dword [rbp-4H], 2363848                 ; 00DD _ 81. 7D, FC, 002411C8
        jnz     ?_008                                   ; 00E4 _ 75, 0A
        mov     eax, 1                                  ; 00E6 _ B8, 00000001
        jmp     ?_027                                   ; 00EB _ E9, 00000212

?_008:  mov     byte [rbp+3H], -112                     ; 00F0 _ C6. 45, 03, 90
        mov     dword [rbp-4H], 457918                  ; 00F4 _ C7. 45, FC, 0006FCBE
        cmp     dword [rbp-4H], 1368772                 ; 00FB _ 81. 7D, FC, 0014E2C4
        jnz     ?_009                                   ; 0102 _ 75, 0A
        mov     eax, 1                                  ; 0104 _ B8, 00000001
        jmp     ?_027                                   ; 0109 _ E9, 000001F4

?_009:  mov     byte [rbp+4H], 92                       ; 010E _ C6. 45, 04, 5C
        mov     dword [rbp-4H], 599926                  ; 0112 _ C7. 45, FC, 00092776
        cmp     dword [rbp-4H], 126529                  ; 0119 _ 81. 7D, FC, 0001EE41
        jnz     ?_010                                   ; 0120 _ 75, 0A
        mov     eax, 1                                  ; 0122 _ B8, 00000001
        jmp     ?_027                                   ; 0127 _ E9, 000001D6

?_010:  mov     byte [rbp+5H], -98                      ; 012C _ C6. 45, 05, 9E
        mov     dword [rbp-4H], 1362358                 ; 0130 _ C7. 45, FC, 0014C9B6
        cmp     dword [rbp-4H], 1014138                 ; 0137 _ 81. 7D, FC, 000F797A
        jnz     ?_011                                   ; 013E _ 75, 0A
        mov     eax, 1                                  ; 0140 _ B8, 00000001
        jmp     ?_027                                   ; 0145 _ E9, 000001B8

?_011:  mov     byte [rbp+6H], 91                       ; 014A _ C6. 45, 06, 5B
        mov     dword [rbp-4H], 1828952                 ; 014E _ C7. 45, FC, 001BE858
        cmp     dword [rbp-4H], 2491933                 ; 0155 _ 81. 7D, FC, 0026061D
        jnz     ?_012                                   ; 015C _ 75, 0A
        mov     eax, 1                                  ; 015E _ B8, 00000001
        jmp     ?_027                                   ; 0163 _ E9, 0000019A

?_012:  mov     byte [rbp+7H], -121                     ; 0168 _ C6. 45, 07, 87
        mov     dword [rbp-4H], 409829                  ; 016C _ C7. 45, FC, 000640E5
        cmp     dword [rbp-4H], 956775                  ; 0173 _ 81. 7D, FC, 000E9967
        jnz     ?_013                                   ; 017A _ 75, 0A
        mov     eax, 1                                  ; 017C _ B8, 00000001
        jmp     ?_027                                   ; 0181 _ E9, 0000017C

?_013:  mov     byte [rbp+8H], -102                     ; 0186 _ C6. 45, 08, 9A
        mov     dword [rbp-4H], 367798                  ; 018A _ C7. 45, FC, 00059CB6
        cmp     dword [rbp-4H], 1318701                 ; 0191 _ 81. 7D, FC, 00141F2D
        jnz     ?_014                                   ; 0198 _ 75, 0A
        mov     eax, 1                                  ; 019A _ B8, 00000001
        jmp     ?_027                                   ; 019F _ E9, 0000015E

?_014:  mov     byte [rbp+9H], 91                       ; 01A4 _ C6. 45, 09, 5B
        mov     dword [rbp-4H], 826535                  ; 01A8 _ C7. 45, FC, 000C9CA7
        cmp     dword [rbp-4H], 1104567                 ; 01AF _ 81. 7D, FC, 0010DAB7
        jnz     ?_015                                   ; 01B6 _ 75, 0A
        mov     eax, 1                                  ; 01B8 _ B8, 00000001
        jmp     ?_027                                   ; 01BD _ E9, 00000140

?_015:  mov     byte [rbp+0AH], -117                    ; 01C2 _ C6. 45, 0A, 8B
        mov     dword [rbp-4H], 620386                  ; 01C6 _ C7. 45, FC, 00097762
        cmp     dword [rbp-4H], 795740                  ; 01CD _ 81. 7D, FC, 000C245C
        jnz     ?_016                                   ; 01D4 _ 75, 0A
        mov     eax, 1                                  ; 01D6 _ B8, 00000001
        jmp     ?_027                                   ; 01DB _ E9, 00000122

?_016:  mov     byte [rbp+0BH], 88                      ; 01E0 _ C6. 45, 0B, 58
        mov     dword [rbp-4H], 1589983                 ; 01E4 _ C7. 45, FC, 001842DF
        cmp     dword [rbp-4H], 2155809                 ; 01EB _ 81. 7D, FC, 0020E521
        jnz     ?_017                                   ; 01F2 _ 75, 0A
        mov     eax, 1                                  ; 01F4 _ B8, 00000001
        jmp     ?_027                                   ; 01F9 _ E9, 00000104

?_017:  mov     byte [rbp+0CH], -98                     ; 01FE _ C6. 45, 0C, 9E
        mov     dword [rbp-4H], 428518                  ; 0202 _ C7. 45, FC, 000689E6
        cmp     dword [rbp-4H], 887809                  ; 0209 _ 81. 7D, FC, 000D8C01
        jnz     ?_018                                   ; 0210 _ 75, 0A
        mov     eax, 1                                  ; 0212 _ B8, 00000001
        jmp     ?_027                                   ; 0217 _ E9, 000000E6

?_018:  mov     byte [rbp+0DH], 91                      ; 021C _ C6. 45, 0D, 5B
        mov     dword [rbp-4H], 69954                   ; 0220 _ C7. 45, FC, 00011142
        cmp     dword [rbp-4H], 1522989                 ; 0227 _ 81. 7D, FC, 00173D2D
        jnz     ?_019                                   ; 022E _ 75, 0A
        mov     eax, 1                                  ; 0230 _ B8, 00000001
        jmp     ?_027                                   ; 0235 _ E9, 000000C8

?_019:  mov     byte [rbp+0EH], -102                    ; 023A _ C6. 45, 0E, 9A
        mov     dword [rbp-4H], 1795081                 ; 023E _ C7. 45, FC, 001B6409
        cmp     dword [rbp-4H], 1478510                 ; 0245 _ 81. 7D, FC, 00168F6E
        jnz     ?_020                                   ; 024C _ 75, 0A
        mov     eax, 1                                  ; 024E _ B8, 00000001
        jmp     ?_027                                   ; 0253 _ E9, 000000AA

?_020:  mov     byte [rbp+0FH], 91                      ; 0258 _ C6. 45, 0F, 5B
        mov     dword [rbp-4H], 652624                  ; 025C _ C7. 45, FC, 0009F550
        cmp     dword [rbp-4H], 1213569                 ; 0263 _ 81. 7D, FC, 00128481
        jnz     ?_021                                   ; 026A _ 75, 0A
        mov     eax, 1                                  ; 026C _ B8, 00000001
        jmp     ?_027                                   ; 0271 _ E9, 0000008C

?_021:  mov     byte [rbp+10H], -116                    ; 0276 _ C6. 45, 10, 8C
        mov     dword [rbp-4H], 702627                  ; 027A _ C7. 45, FC, 000AB8A3
        cmp     dword [rbp-4H], 2341364                 ; 0281 _ 81. 7D, FC, 0023B9F4
        jnz     ?_022                                   ; 0288 _ 75, 07
        mov     eax, 1                                  ; 028A _ B8, 00000001
        jmp     ?_027                                   ; 028F _ EB, 71

?_022:  mov     byte [rbp+11H], -121                    ; 0291 _ C6. 45, 11, 87
        mov     dword [rbp-4H], 1643677                 ; 0295 _ C7. 45, FC, 0019149D
        cmp     dword [rbp-4H], 2012705                 ; 029C _ 81. 7D, FC, 001EB621
        jnz     ?_023                                   ; 02A3 _ 75, 07
        mov     eax, 1                                  ; 02A5 _ B8, 00000001
        jmp     ?_027                                   ; 02AA _ EB, 56

?_023:  mov     byte [rbp+12H], -107                    ; 02AC _ C6. 45, 12, 95
        mov     dword [rbp-4H], 350652                  ; 02B0 _ C7. 45, FC, 000559BC
        cmp     dword [rbp-4H], 1453488                 ; 02B7 _ 81. 7D, FC, 00162DB0
        jnz     ?_024                                   ; 02BE _ 75, 07
        mov     eax, 1                                  ; 02C0 _ B8, 00000001
        jmp     ?_027                                   ; 02C5 _ EB, 3B

?_024:  mov     byte [rbp+13H], 91                      ; 02C7 _ C6. 45, 13, 5B
        mov     dword [rbp-4H], 1629186                 ; 02CB _ C7. 45, FC, 0018DC02
        cmp     dword [rbp-4H], 1784087                 ; 02D2 _ 81. 7D, FC, 001B3917
        jnz     ?_025                                   ; 02D9 _ 75, 07
        mov     eax, 1                                  ; 02DB _ B8, 00000001
        jmp     ?_027                                   ; 02E0 _ EB, 20

?_025:  mov     byte [rbp+14H], -91                     ; 02E2 _ C6. 45, 14, A5
        mov     dword [rbp-4H], 69002                   ; 02E6 _ C7. 45, FC, 00010D8A
        cmp     dword [rbp-4H], 1787269                 ; 02ED _ 81. 7D, FC, 001B4585
        jnz     ?_026                                   ; 02F4 _ 75, 07
        mov     eax, 1                                  ; 02F6 _ B8, 00000001
        jmp     ?_027                                   ; 02FB _ EB, 05

?_026:  mov     eax, 0                                  ; 02FD _ B8, 00000000
?_027:  pop     rbp                                     ; 0302 _ 5D
        ret                                             ; 0303 _ C3
; main End of function


SECTION .data                           ; section number 2, data


SECTION .bss                            ; section number 3, bss


