Here is the solution to this CTF:

- Read the `ncore_tb.v` testbench provided to understand the core implementation
- The testbench loads the flag into the `safe_rom` memory and we need to dump it
- We can access this memory by entering `emode` but it requires `regfile[0]` to match the 14bit random number
- 14bits is easy to bruteforce so write an infinte loop to bruteforce this that increments `regfile[0]` and calls `ent`
- The bruteforce stops when `emode=1`, after which we can read the contents of the `safe_rom` and get the flag
