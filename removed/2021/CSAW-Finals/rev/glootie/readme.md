## Android + Vulkan Challenge
This is an app which verifies a password (which is the flag) via a compute shader using the Vulkan API. The shader (developed in GLSL, but that is not relevant) is compiled into SPIR-V format which is a multi-platform format, meaning that the same compute shader can be run on _any_ Vulkan supported device (it is widely supported). To solve:
1. Use [jadx](https://github.com/skylot/jadx) / dex2jar etc. to see what's in the apk, you will get the (java) decompiled source code to the _MainActivity_ which is nothing but a very thin shell calling the password checking function from _libnative-lib.so_. So really the main reversing is reversing a .so file which is in x86. (**notice that this means the apk cannot be installed on most mobile devices, this is prefered because we'd rather have contestants run this in Android Emulator which they now can, assuming they have x86 machines or not run this at tall**) 
2. Now reversing the .so file would reveal the shader stuff, some things happen in a _compute shader_ then an output array is expected to be {0,1,..,33} for us to win. So we move to the last stage: what is the shader doing?
3. Finding the shader is effortless, it is conveniently located in the resources/assets/shaders/test.comp.spv (~~there is also a revme.comp.spv which is dummy and never used~~ we removed this dummy file.) to reverse there are tools for SPIR-V disassembly, including in the canon [Vulkan SDK by LunarG](https://www.lunarg.com/vulkan-sdk/) just do:
</a>

```bash
spirv-dis.exe .\test.comp.spv
```
The result can be seen here: https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/rev/glootie/disas.txt
It is (by design) not a complex convoluted format, and the kernel is _very_ simple: it's just XORing user bytes with the keys (which are hard to miss!) and so we get that flag(i) = key(i) ^ i and so: **flag{alW1yz_u3e_d1nGleB0p_4_fl33B}**

```bash
adb shell input text 'password'
```

## For challenge.json
files: only the .apk file </br>
descr: "glootie has made an app which is super-safe! no-one in the J19-Zeta-7 universe can crack the password!" </br>
