# CSAW 2020 Quals - Krakme
## aren't GPUs cute?
This year's CSAW quals was the first time I authored a challenge, the challenge is called _krakme_ and it was a 200pt rev challenge. You can view the challenge files in the repo [here](https://github.com/osirislab/CSAW-CTF-2020-Quals/tree/master/rev/Krakme). The idea for this challenge was formed after reading this paper [The impact of GPU-assisted malware on memory forensics: A case study](https://www.sciencedirect.com/science/article/pii/S1742287615000559), in fact gpu has been used by malware and [anti-virus software](https://www.tomshardware.com/news/intel-threat-detection-technology-tdt-gpu-offloading,36911.html). For malware, it can be used as a means to hide malicious code, and unpack it via an OpenCL/Cuda kernel, even via shader code, and in defense, it can be used to speed up memory scanning and to avoid slowing down the system by offloading the task to gpu. If you are a gamer, you might want to make sure this is [off](https://getadmx.com/?Category=Windows_10_2016&Policy=Microsoft.Policies.AppHVSI::AppHVSI_AllowVirtualGPU) though. 

I had not seen a ctf challenge involving cuda/OpenCL in any way, and I thought well, this might make for a fresh challenge! Then what I thought was to have a simple crackme where the password checking is done _inside a cuda kernel_. 

## The Kernel
The binary of the challenge was a windows PE binary. The code is fairly simple, the first argument (the _password_) is passed to a cuda kernel. The cuda kernel, will check if the input length is 31, if it is it checks _password[i] ^ i_ against _key[i]_ and keeps a counter of how many bytes did match, if this count is 31 it prints "CORRECT" and "WRONG" otherwise, notice that if the length is off, you won't even get "WRONG" message. (also if you don't pass an argument you would get a hint that you should pass a _password_ to the program)
```c
__global__ void checkKernel(const char* passwd, const int* size, int* result) {
    
    int cnt = 0;
    char key[31] = {0x66,0x6d,0x63,0x64,0x7f,0x68,0x35,0x34,0x7c,0x56,0x67,0x38,0x53,0x64,0x60,0x50,0x72,0x7d,0x7b,0x63,0x67,0x4a,0x78,0x48,0x7b,0x71,0x29,0x7a,0x68,0x67,0x63};
    if (*size != 31) {
        *result = -1;
        return;
    }
    //printf("IN KERN %d\n", cnt);
    for (int i = 0; i < *size; i++) {
        //printf("CHAR IS: %c %x\n", passwd[i],passwd[i]^i);
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
}
```
## The Solve
Why the counter? Why not stop the comparisons if a byte was off? I was just being cautious, timing attack ain't possible. Now you wouldn't have this source, what you could get is, well first just looking at the sections in the PE binary you could see that there are ".nv_fatb" and "nvFatBi" sections, a quick goolging and you realize it is cuda stuff. Next thing is, if you look at the [cuda toolkit](https://developer.nvidia.com/cuda-toolkit), a quick delve into the documentations, and you know what you have to do, in fact if you happen to land on [this page](https://docs.nvidia.com/cuda/cuda-binary-utilities/index.html) of the docs everything would click: in the PE binary, those nv sections hold code in an IL called [PTX](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html), which is this ISA by nvidia which the gpu understands. So the kernel code gets compiled into PTX, and gets tucked into the PE, the task which would be supereasy where it in plain x86 now becomes harder and partly it is just _security by obsecurity_ because unlike x86, PTX docs are really bad, and there isn't much tutorials and info on them. Still the kernel is simple, and given the PTX code and looking through the awful nvidia docs, you would get it. <br>
The ISA has many nuts and bolts that are irrelevant to us as in this challenge no parallelism is used, we only have a single gpu thread running. Another feature of the ISA are the predicate registers: these are 1 bit registers holding predicates and then you can later use them prefixed to an instruction to make that instruction executed or skipped, based on the value of the predicate. For example lets dissect an instruction like:
 ```
 setp.eq.s32	%p1, %r1, %r2;
 ```
 Skimming the parts on the docs, we realize: **setp** is an instruction used to set a value to a predicate register (here **%p1**), the **eq** part means we are doing an equality comparison (so instead of **eq** we can have **lt** for _less than_ comparison, or other things you can see in [Table 19](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#integer-and-bit-size-comparisons__operators-for-signed-integer-unsigned-integer-and-bit-size-types), really run of the mill stuff that you expect: lt, gt, ge and such) and then the **%r1** and **%r2** are the operands of the comparison operator and finally that **s32** part is type, you can see the other types in [Table 8](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#fundamental-types__fundamental-type-specifiers). So this instruction sets **%p1** to true, if **%r1** and **%r2** are equal, how is this **%p1** then used? Something like this:
 ```
  @%p1 bra LABEL;
 ```
 Which means **branch** if **%p1**, usually there is another branch after this without the prefix and there you have it, an _if_ ! The ISA does look weird, but really, do a few instructions and it starts to look less daunting after all.
 
<br>

## Conclusion
Sadly this challenge got only 30 solves and looking into perfectblue [writeup](https://github.com/perfectblue/ctf-writeups/tree/master/2020/csaw-quals-2020/krakme) it seems people might have had trouble with getting the PTX code, maybe trying to 'carve out' the ptx code by hand, while _cuobjdump_ conveniently does it for them. And actually you would not need a nvidia gpu really because you don't even need to run the kernel. Anyway, you XOR the keys with their index and you get this: **flag{m33t_m3_in_blips_n_ch3atz}** <br>
And who know what awaits in [blips and chitz](https://rickandmorty.fandom.com/wiki/Blips_and_Chitz)? 

<p align="center">
    <img
      alt="Node.js"
      src="https://vignette.wikia.nocookie.net/rickandmorty/images/a/a8/Screenshot_69.png/revision/latest?cb=20160919065345"
      width="600"
    />
</p>

## Acknowledgement
Thanks to John, Alan and Swathi for the feedback, erratum and as always encouragement.
