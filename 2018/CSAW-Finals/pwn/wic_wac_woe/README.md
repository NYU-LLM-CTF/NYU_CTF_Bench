# Wic Wac Woe

## Part 1

Points: 200-250?

Flag: `flag{Us3_a4ter_l0se_n0w_defeat_CFI!!}`

Description

```
WASM is the future of the web! JS devs will be writting c++, what could go wrong?
```

### Walkthough

This challenge has a pwnable wasm module. Source can be obtained by checking for source map (linked at the end of the wasm binary) and grabbing /test.cpp (something like "check for sourcemapping" can be added as a hint if people don't see it).

There is a UAF with the flag manager if you let the admin win, then make extra moves and win yourself.
Allocate a new string over it with the authorized vtable (also fix the string pointers to point at the flag and api) and then you can send yourself the flag.


## Part 2

Points: 300-350?

Flag: `flag{CFI_byp4ss_mor3_like_d4ta_at7acks_4m_I_write??}`

Description

```
WASM is the future of the web! JS devs will be writting c++, what could go wrong?
```

### Walkthough

For part two you need to get javascript execution to achieve XSS. There is a function that would run javascript but WASM CFI blocks you from using the vtable to call it.

Instead there are data only attacks we can do using other WASM weaknesses. If we cause the UAF again we can control the std::string pointers. If we lose again instead of winning it will cause the destructor to be called again, freeing the std::string. This gives us an arbitrary free. We can use this free to free the username std::string and cause a second UAF. Overwrite it with a malicious std::string pointing to the global string for the eval'ed javascript. Setting the username will overwrite this string (arbitrary write). Because WASM doesn't have memory protections there is no RO memory, so it is writable.

The string is limited to 100 characters, but thats enough to append a new script tag to the head and run xss to fetch(/flags) and exfil them.
