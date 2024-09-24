Here is the solution to this CTF:

- Read the `ncore_tb.v` test bench to understand the capabilities of the core
- The core has branch prediction and a cache, and allows timing the instructions
- This combination points to the Spectre attack
- Implement a Spectre attack on this core to load the `safe_rom` values into the cache speculatively
- Read different addresses of the cache to see which one takes shorter time to load which indicates that was loaded speculatively
- Leak the bytes of the flag one by one and obtain the flag
