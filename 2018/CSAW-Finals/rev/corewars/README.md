# Corewars

Points: 300

Flag: `flag{_1t_rUn5_4s_r0o7_5nd_c4n_D0_l0ts_Of_s7up1D_Th1Ng5_!}`

Description

```
We must journey deep into the core of the world if we hope to find any meaning here
```

## Files

Give out corewars

## Walkthough

The program is run as root and installs itself as `/proc/sys/kernel/core_pattern` allowing it to
read all core dumps. The program will then use crashes as a way to select op codes in a small vm.

Players can patch the binary to not run as root and manually pipe the core files, giving them the ability
to control when each step of the vm is run. A gdb script can help.

Breaking in all the vm opcodes is probably the quickest way to dynamically see whats going on. Statically
a player can match crashes to opcodes and figure out the code by hand.

The code does a xor over random offsets of the key, 4 bytes at a time. This is xor'ed with the vm PC to
get the real flag byte.

If all is well the real flag (now decrypted) is written to `/tmp/flag`

The key for the current program is
```
sudo ./chal 'key=R"yXkFw8X3jRu=v.L,w}Rn9iL]7Lu#y`XVaX`$rc<ILMq"Ij2X2'
```

