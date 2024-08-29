---
layout: post
title: Glootie
date: 2021-12-04
author: Iman Hosseini
---

This year I made a challenge for CSAW'21 quals and 2 for the finals. For quals I made _score_ which had _spectral finite core_ as a harder sequel in the finals, and also had _glootie_ in the finals. Let's talk about glootie:

## Glootie
Glootie is an offile reversing challenge, you are given an _apk_ and you have to find the flag. The app has [glootie](https://rickandmorty.fandom.com/wiki/Glootie) asking you to make an app, and there is a "MAKE APP!" button and a text field. Pushing the button gets you a "YOU ARE UNDER ARREST BY THE GALACTIC FEDERATION!" message. Using something like [jadx](https://github.com/skylot/jadx) we can look into what's in the apk. Apk is basically just an archive format, inside of it, we find resources (like the image file of glootie) and source code. Under _Resources/res/drawable/_ we also find _shlami.png_: 
<p align="center">
    <img
      alt="Node.js"
      src="https://raw.githubusercontent.com/osirislab/CSAW-CTF-2021-Finals/main/rev/glootie/shlami.png?token=AC434WJXXMMGARBKHW2PXLDBX65XO"
      width="500"
    />
</p>
Which isn't related to solving the challenge though. What _is_ related is the 'MainActivity' under source code part. We see the decompiled java code whith one function standing out:

```java
    public final void checkpass(View view) {
        Intrinsics.checkNotNullParameter(view, "view");
        View findViewById = findViewById(R.id.textPassword);
        Intrinsics.checkNotNullExpressionValue(findViewById, "findViewById<EditText>(R.id.textPassword)");
        String pass = ((EditText) findViewById).getText().toString();
        AssetManager assets = getAssets();
        Intrinsics.checkNotNullExpressionValue(assets, "this.assets");
        String mism = checkPasswd(pass, assets);
        View findViewById2 = findViewById(R.id.sample_text);
        Intrinsics.checkNotNullExpressionValue(findViewById2, "findViewById<TextView>(R.id.sample_text)");
        ((TextView) findViewById2).setText(mism);
    }

```

It's easy to connect this to what's happening, when we click the only button in the app, the string in textfield is passed to 'checkPasswd' and the result is then shown in the app. But where does 'checkPasswd' come from? There is a hint to what's going on here:

```java
   static {
        System.loadLibrary("native-lib");
    }
}
```

There is some "native-lib" somewhere? Under "Resources/lib/x86" we see _libnative-lib.so_ , so the "checkPasswd" is a JNI call to native code that's inside a ".so" (shared library), drop it in your favorite decompiler and we get (highlighting the important part): 

```C
undefined4
Java_com_example_app0_MainActivity_checkPasswd
          (_JNIEnv *param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
...
  pcVar2 = (char *)FUN_0001fc30(local_23c);
  uVar1 = AAssetManager_fromJava(param_1,param_4);
  uVar1 = AAssetManager_open(uVar1,"shaders/test.comp.spv",3);
  uVar3 = AAsset_getLength(uVar1);
  puVar4 = (uint *)operator.new[](uVar3);
  AAsset_read(uVar1,puVar4,uVar3);
  VulkanDummy(local_22c);
  iVar5 = Run(local_22c,puVar4,uVar3,pcVar2);
  local_280 = 0;
  local_284 = 0;
  while (local_284 < 0x22) {
    to_string((__ndk1 *)local_24c,*(uint *)(iVar5 + local_284 * 4));
    uVar3 = FUN_0001fc30(local_24c);
    __android_log_write(6,&DAT_0004f83f);
    ~basic_string(local_24c);
    if (*(int *)(iVar5 + local_284 * 4) == local_284) {
      local_280 = local_280 + 1;
    }
    local_284 = local_284 + 1;
  }
  basic_string<decltype(nullptr)>(local_25c,"YOU ARE UNDER ARREST BY THE GALACTIC FEDERATION!");
  if (local_280 == 0x22) {
    FUN_0001fdc0(local_25c,"YOU WON! HERE\'S 400 Blemflarcks.",uVar3);
  }
...
}
```

You get the idea... There's some Vulkan launch stuff in "Run" and so we are just passing the stuff from the app, into a Vulkan kernel. Then a check over a buffer's elements to see if stuff at address "iVar5 + local_284\*4" is equal to "local_284" which is incremented. This is a familiar construct, if you want to avoid side-channels over checking a password, instead of returning at first conflicting byte, compare all bytes and verify all bytes were correct. This way, the time to verify the password is not dependent on the input and won't give away any info. And here is the C code for reference:

```c
    int zt = 0;
    for(auto i = 0 ; i<BUFFER_ELEMENTS; i++){
        __android_log_write(ANDROID_LOG_ERROR, "Tag", std::to_string(res[i]).c_str());
        if(res[i] == i){
            zt += 1;
        }
    }
    std::string result = "YOU ARE UNDER ARREST BY THE GALACTIC FEDERATION!";
    if(zt==BUFFER_ELEMENTS){
        result = "YOU WON! HERE'S 400 Blemflarcks.";
    }
```

At this point you might just google a bit about Vulkan, and any Vulkan android blogpost/ example would lead you to "Resources/assets/shaders" where the kernel code resides, and you see a "test.comp.spv" again it's pretty on the nose here that this is a "compute" kernel, and ".spv" is extension for SPIR-V files. Grab your favorite spirv disassembler, mine is [the official LunarG](https://www.lunarg.com/vulkan-sdk/) SDK, and run "spirv-dis" on the file to get the dissasembly. The full output is [here](https://github.com/osirislab/CSAW-CTF-2021-Finals/blob/main/rev/glootie/disas.txt). SPIR-V is not meant to obfuscate really, and this is also very similar to a challenge I made [before](https://blog.osiris.cyber.nyu.edu/2020/12/01/cuda-reversing/), it's actually nice to see the similarity of PTX ISA with SPIR-V which is not really a coincidence. It's a short code, with a simple pattern, it's XOR cipher, and the keys are right there together: <br>

```
   %uint_102 = OpConstant %uint 102
   %uint_109 = OpConstant %uint 109
    %uint_99 = OpConstant %uint 99
   %uint_100 = OpConstant %uint 100
   %uint_127 = OpConstant %uint 127
   %uint_106 = OpConstant %uint 106
    %uint_80 = OpConstant %uint 80
    %uint_57 = OpConstant %uint 57
   %uint_112 = OpConstant %uint 112
    %uint_84 = OpConstant %uint 84
   %uint_121 = OpConstant %uint 121
    %uint_62 = OpConstant %uint 62
   %uint_107 = OpConstant %uint 107
   %uint_116 = OpConstant %uint 116
    %uint_32 = OpConstant %uint 32
   %uint_124 = OpConstant %uint 124
   %uint_120 = OpConstant %uint 120
    %uint_39 = OpConstant %uint 39
   %uint_104 = OpConstant %uint 104
    %uint_70 = OpConstant %uint 70
    %uint_46 = OpConstant %uint 46
    %uint_68 = OpConstant %uint 68
   %uint_122 = OpConstant %uint 122
   %uint_113 = OpConstant %uint 113
    %uint_45 = OpConstant %uint 45
    %uint_44 = OpConstant %uint 44
    %uint_98 = OpConstant %uint 98
    %uint_92 = OpConstant %uint 92
```

The difference here, is that unlike in the CUDA challenge, here we actually run our kernel over multiple threads, one for each byte of the buffer. So there is no branching instructions in the disassembled code. Looking into some docs, we see that "%47 = OpAccessChain %\_ptr_Input_uint %gl_GlobalInvocationID %uint_0" line is accessing the thread idx, OpenGL folks would probably recognize the terminology. This value is later loaded into "%i" and then into "%47" and finally we see k being accessed and XORed at i:

```
         %58 = OpAccessChain %_ptr_Private_uint %k %56
         %59 = OpLoad %uint %58
         %60 = OpLoad %uint %i
         %62 = OpAccessChain %_ptr_Uniform_uint %myBuffer %int_0 %60
         %63 = OpLoad %uint %62
         %64 = OpBitwiseXor %uint %59 %63
```

Here is the source code of the shader: <br>

```
#version 450 core

layout (local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout (set = 0, binding = 0, std430) buffer MyBuffer
{
    uint array[];
} myBuffer;

layout (push_constant) uniform Scalar
{
    uint x;
} scalar;

uint k[34] = uint[](102,109,99,100,127,100,106,80,57,112,112,84,121,62,107,80,116,32,124,84,120,112,84,39,104,70,46,68,122,113,45,44,98,92);

void main()
{
    uint i = gl_GlobalInvocationID.x;
     myBuffer.array[i] = k[i]^myBuffer.array[i];
}
```

What input would make us pass this check function? Let's call it flag: So "k\[i]^flag\[i] = i" -> "flag\[i] = i ^ k\[i]" XOR your way to the flag: "flag{alW1yz_u3e_d1nGleB0p_4_fl33B}".
