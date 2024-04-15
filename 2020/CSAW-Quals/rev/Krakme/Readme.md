## CUDA Reversing Challenge

Inspired by previous work on GPU-assisted malware such as: https://link.springer.com/article/10.1007/s10207-014-0262-9 why not make a GPU CTF challenge? </br>
I am not sure if it's so easy or so hard, but if this fares well in the Quals, I have some cool ideas to make a sequel to this for the finals. File is a Win64 PE. </br>

### SOLUTION NOTE

I got the 'wrong password' thing: if you put no password at all, you get "[!] usage ./krakme <password>" if you put a _wrong_ password with correct number of characters you get "Wrong Password" and if you put "flag{m33t_m3_in_blips_n_ch3atz}" you get "Correct password":
Also note that in Powershell, you cant do: ./krakme.exe flag{m33t_m3_in_blips_n_ch3atz}
you have to do:  ./krakme.exe "flag{m33t_m3_in_blips_n_ch3atz}" 

### Writeup

This challenge does not require us to run anything as everything needed is self-contained in the binary, also this not require a CUDA-runtime/Nvidia GPU to be solved. The binary is not stripped, looking at the code in Ghidra it would be obvious that cuda is involved and a check is run on the first arg passed to the program, where the check is inside a cuda kernel. </br>

Knowing this, and after some searching it is expected that people eventually land here: https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html which describes how the cuda code is compiled in a fatbinary, inside the binary and then they just disassemble the PTX code [docs](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html) (the assembly code of GPU) revealing the check, which is also not complicated, and then they find out the flag to be "flag{m33t_m3_in_blips_n_ch3atz}", the source of kernel code is:

```c
    int cnt = 0;
    char key[31] = {0x66,0x6d,0x63,0x64,0x7f,0x68,0x35,0x34,0x7c,0x56,0x67,0x38,0x53,0x64,0x60,0x50,0x72,0x7d,0x7b,0x63,0x67,0x4a,0x78,0x48,0x7b,0x71,0x29,0x7a,0x68,0x67,0x63};

    if (*size != 31) {
        *result = -1;
        return;
    }

    for (int i = 0; i < *size; i++) {
        if ((passwd[i] ^ i) == key[i]) {
            cnt++;
        }
    }
    if (cnt == 31) {
        printf("CORRECT PASSWORD!");
    }
    else {
        printf("WRONG PASSWORD, TRY AGAIN!");
    }
    return;
```

What the players would see though would look like the following (which is the generated using CUDA nvdisasm tool): (here it is shortened)

```asm
//--------------------- .text._Z11checkKernelPKcPKiPi --------------------------
	.section	.text._Z11checkKernelPKcPKiPi,"ax",@progbits
	.sectioninfo	@"SHI_REGISTERS=32"
	.align	32
        .global         _Z11checkKernelPKcPKiPi
        .type           _Z11checkKernelPKcPKiPi,@function
        .size           _Z11checkKernelPKcPKiPi,(.L_25 - _Z11checkKernelPKcPKiPi)
        .other          _Z11checkKernelPKcPKiPi,@"STO_CUDA_ENTRY STV_DEFAULT"
_Z11checkKernelPKcPKiPi:
.text._Z11checkKernelPKcPKiPi:
        /*0008*/                   MOV R1, c[0x0][0x20] ;
        /*0010*/                   MOV R6, c[0x0][0x148] ;
        /*0018*/                   MOV R7, c[0x0][0x14c] ;
        /*0028*/         {         IADD32I R1, R1, -0x20 ;
        /*0030*/                   LDG.E R6, [R6]         }
        /*0038*/                   MOV32I R8, 0x7b ;
...
        /*0c10*/                   JCAL `(vprintf) ;
        /*0c18*/                   EXIT ;
.L_3:
        /*0c28*/                   MOV32I R4, 32@lo($str) ;
        /*0c30*/                   MOV32I R5, 32@hi($str) ;
        /*0c38*/                   MOV R6, RZ ;
        /*0c48*/                   MOV R7, RZ ;
        /*0c50*/                   JCAL `(vprintf) ;
        /*0c58*/                   NOP ;
        /*0c68*/                   NOP ;
        /*0c70*/                   NOP ;
        /*0c78*/                   EXIT ;
.L_4:
        /*0c88*/                   BRA `(.L_4) ;
.L_25:


//--------------------- .nv.global.init           --------------------------
	.section	.nv.global.init,"aw",@progbits
	.type		$str,@object
	.size		$str,($str1 - $str)
$str:
.nv.global.init:
        /*0000*/ 	.byte	0x43, 0x4f, 0x52, 0x52, 0x45, 0x43, 0x54, 0x20, 0x50, 0x41, 0x53, 0x53, 0x57, 0x4f, 0x52, 0x44
        /*0010*/ 	.byte	0x21, 0x00
	.type		$str1,@object
	.size		$str1,(.L_2 - $str1)
$str1:
        /*0012*/ 	.byte	0x57, 0x52, 0x4f, 0x4e, 0x47, 0x20, 0x50, 0x41, 0x53, 0x53, 0x57, 0x4f, 0x52, 0x44, 0x2c, 0x20
        /*0022*/ 	.byte	0x54, 0x52, 0x59, 0x20, 0x41, 0x47, 0x41, 0x49, 0x4e, 0x21, 0x00
.L_2:


//--------------------- SYMBOLS --------------------------

	.type		vprintf,@function
```
If it is currently too hard, we can change the decoding part to be merely a bunch of XORs with the key, without the '^ i' part, then in the data section they can see the keys and without knowing anything about the PTX assembly, it can be guessed that it is probably a simple XOR scheme.
