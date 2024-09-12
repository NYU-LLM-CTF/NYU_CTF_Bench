# magic tricks

> Category rev
> Easy/Medium

# Description

A classic crackme with a twist of golang reversing. Use the program and the output file to reconstruct the flag file. Requires understanding of basic crypto operations such as XOR and rotational shifts, and the ability to understand golang code under a disassembly program such as Ghidra, IDA, or Binary Ninja. Needs basic knowledge of symbolic execution tools such as Z3.

# Flag

csawctf{tHE_runE5_ArE_7H3_k3y_7O_th3_G0ph3r5_mA91C}

# Deployment

None needed

# Solution

Requires some knowledge of golang reversing.

Load up ghidra and analyze. The binary is stripped, but eventually a function will be found and you can go to it. (You can also try to find it through the strings)

Upon analyzing further, the input we put in is put into `rune` which basically is `ord` for golang. Then, identify the algorithm used.


```
  local_140 = runtime.stringtoslicerune();
  for (lVar4 = 0; lVar4 < lVar2; lVar4 = lVar4 + 1) {
    iVar1 = *(int *)(local_140 + lVar4 * 4);
    *(int *)(local_140 + lVar4 * 4) =
         (int)((long)((long)iVar1 + 23U ^ (long)(iVar1 + -1)) % 4) + iVar1 * 2 + -0x20;
  }
  local_138 = runtime.slicerunetostring(uVar3);
```

The input is added by 23, XOR'd by the previous element, then modulo'd 4. Then add the result with the element * 2 and finally subtract by 32.

Solution is in Z3 solve script.
