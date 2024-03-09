"""
r0 : 0x127f8    -> nop
r1 : 0xd0100a10 -> 00 00 00 00 d0 10 0c 70
r2 : 0x1054b0   -> 00 10 54 b4 00 00 00 00
r3 : 0xa
r4 : 0x200006f8 -> ff ff ff ff 00 00 00 00
r5 : 0x2b
r6 : 0xd0100650 -> 00 00 00 2b d0 10 06 d0
r7 : 0x40000030 -> "y regs :) "
r8 : 0x200006f8 -> ff ff ff ff 00 00 00 00
r9 : 0x100000000000000
r10: 0x1
r11: 0x0
r12: 0x340308   -> func(at=0x32512c, toc=0x348ab0)
r13: 0x20007060 -> 00 00 00 00 00 00 00 00
r14: 0xa000ff
r15: 0x400009ec -> 00 00 00 00 00 00 00 00
r16: 0x400009f0 -> 00 00 00 00 00 00 00 00
r17: 0x400009f4 -> 00 00 00 00 00 00 00 00
r18: 0x400009f8 -> 00 00 00 00 00 00 00 00
r19: 0x400009fc -> 00 00 00 00 00 00 00 00
r20: 0x66666667
r21: 0x10047708 -> 00 00 00 18 00 00 00 7c
r22: 0x1000fb48 -> 43 80 00 00 43 62 00 00
r23: 0x1000fb24 -> 41 20 00 00 44 87 00 00
r24: 0x40000a00 -> 00 00 00 00 00 00 00 00
r25: 0x0
r26: 0x0
r27: 0x400
r28: 0x70
r29: 0x10031950 -> 00 00 04 00 00 00 00 01
r30: 0xffffffff
r31: 0x400009e4 -> 00 00 00 00 00 00 00 00
"""

def verify():

    correct = {
        "r1": "00000000d0100a10",
        "r4": "00000000200006f8",
        "r6": "00000000d0100650",
        "r7": "0000000040000030",
        "r8": "00000000200006f8",
        "r12":"0000000000340308",
        
        "r3": "000000000000000a",
        "r5": "000000000000002b",
        "r9": "0100000000000000",
        "r10":"0000000000000001",
        "r27":"0000000000000400",
        "r28":"0000000000000070"
    }

    r3 = input("r3: ")

    if r3 != correct["r3"]:
        print("flag{y0u_4r3_4n_3xp3rt_4t_r3v3rs1ng}")
        return False

    r5 = input("r5: ")
    if r5 != correct["r5"]:
        print("flag{y0u_4r3_4n_3xp3rt_4t_r3v3rs1ng}")
        return False

    r9 = input("r9: ")
    if r9 != correct["r9"]:
        print("flag{y0u_4r3_4n_3xp3rt_4t_r3v3rs1ng}")
        return False

    r10 = input("r10: ")
    if r10 != correct["r10"]:
        print("flag{y0u_4r3_4n_3xp3rt_4t_r3v3rs1ng}")
        return False

    r27 = input("r27: ")
    if r27 != correct["r27"]:
        print("flag{y0u_4r3_4n_3xp3rt_4t_r3v3rs1ng}")
        return False

    r28 = input("r28: ")
    if r28 != correct["r28"]:
        print("flag{y0u_4r3_4n_3xp3rt_4t_r3v3rs1ng}")
        return False
    
    return True

def main():
    print("Let's check if you have a good system: ")
    print("Note: each value is written as a set of 8 bytes; enter your value as a series of 16 hex characters, with 0 padding as necessary. Ex. 0000000000000000")

    valid = verify()
    if not valid:
        return False
    
    print("Good job! You have a good system. Here's your flag: csaw_ctf{when_holes_are_poked_the_beast_closes_his_eyes}")

if __name__ == "__main__":
    main()
