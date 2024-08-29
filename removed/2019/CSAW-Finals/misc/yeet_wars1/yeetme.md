# Yeet Wars

This is a heavily modified fork of a [pure python core war implementation](https://github.com/rodrigosetti/corewar) of core wars ([Wikipedia article](http://en.wikipedia.org/wiki/Core_War)).
The key differences are:
* Yeet Wars instructions are assembled into 4 byte fixed width instructions and execute on a virtual memory space
* Yeet Wars is intended to be played in real time
* Yeet Wars is score based
* In Yeet Wars, players are never completely eliminated for the duration of the game

# How To Play
At the start of a yeet wars game, memory is initialized to null bytes and nothing starts out in memory (the 'core'), which is some predefined length (default is 16384 bytes). Players are loaded in but do not have any active threads.
At any point in time, players in the game can "stage" a snippet of assembly limited to a certain amount of lines (default 50). At a regular interval determined by the player's player id, that player's staging payload will be assembled and loaded into a random offset in the core that is divisible by 200, and a new thread will be spawned for that player at the beginning of the payload. If the player already has more than the maximum configured amount of threads (default 10), their oldest thread will be killed to make space.
Staging payloads are loaded in every N 'ticks' (default 30), where one tick is the completion of one execution cycle for every thread that was in the thread pool. To allow for player reactions, each tick takes N seconds to complete (default 20), with each cycle taking an equal fraction of that time to compute.
For every thread that a player owns, they will receive 1 point every time that thread executes a cycle.

# Yeet Assembly
Instructions are generally structured as `<instruction> <left hand argument>, <right hand argument>`
unary instructions are formatted as `<instruction> <argument>`
The instruction type is encoded in the first nibble of the first byte of the instruction
```
YEET      = 1     # move from A to B
YOINK     = 2     # add A to B, store result in B
KNIOY     = 3     # subtract A from B, store result in B
MUL       = 4     # multiply A by B, store result in B
DIV       = 5     # divide B by A, store result in B if A <> 0, else terminate
FITS      = 6     # divide B by A, store remainder in B if A <> 0, else terminate
BOUNCE    = 7     # transfer execution to B (unary instruction)
BOUNCEZ   = 8     # transfer execution to B if A is zero
BOUNCEN   = 9     # transfer execution to B if A is non-zero
BOUNCED   = 10    # decrement A, if A is non-zero, transfer execution to B
ZOOP      = 11    # spawn a new process at B (unary instruction)
YEB       = 12    # exchanges A with B
NOPE      = 14    # No operation (no arguments)
YEETCALL  = 15    # System call (no arguments), arguments are passed to yeetcall via the XD and DX registers. XD identifies the syscall number, while DX is the optional argument
```
Note that for any MOV-like instructions (YEET, YOINK, SUB, etc.) with an immediate as the src is an implicit movb, with the exception of register direct
These values are encoded in the instruction as the a_number or b_number
```
XD_REGISTER = 0
DX_REGISTER = 1
```

The mode being used for the a_number and b_number are encoded in the last nibble of the first byte of the instruction
For immediate and relative instructions, the value is encoded in the 2nd byte of the instruction when used as the a_number (left hand operand), or the 3rd and 4th byte when used as the b_number (right hand operand). This means that an immediate or relative value is limited to a maximum value of 255 in the left hand or 65535 for the right hand
```
IMMEDIATE         = 0   # immediate (Note that if an instruction expecting an address is given an immediate value, the immediate is treated as an absolute address). The symbol for immediate is "$"  
RELATIVE          = 1   # relative. The symbol for relative is "#"  
REGISTER_DIRECT   = 2   # Register direct. The symbol for register direct is "%"  
REGISTER_INDIRECT = 3   # Register indirect (value of the register is treated as a pointer). The symbol fo register indirect is "["
```
Syscall numbers:
```
TRANSFER_OWNERSHIP      = 1 # transfer ownership of the current thread to the player ID specified by DX, up to a maximum of 1.5x the max thread count
LOCATE_NEAREST_THREAD   = 2 # return the location of the nearest thread of a different owner in DX to a maximum distance of 80 bytes
LOCATE_RANDOM_THREAD    = 3 # return the location of a random tactive thread in DX
```
Additionally, the assembler will allow for inline bytes, for example:
```
0x0E000000 // assembled bytes for "NOPE"
YEET #0, #4
```
Finally, any addressing that goes out of the core loops back to the beginning, because all numbers in yeet wars are unsigned. For example, if the core were 100 bytes long and `YEET $255, $150` is executed, then core[50] will be set to 0xFF

FAQ:
**Your code is bad**
* Yes.

**You should feel bad**
* I do


