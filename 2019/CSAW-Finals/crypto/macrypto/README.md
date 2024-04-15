# macrypto

> Suggested Category: crypto

> Description: wrote this cipher for a vendor, who demanded

__macrypto__ (macro + crypto smashed together) is a crypto challenge that involves figuring out a flag plaintext from a broken RC4 stream cipher written in Rust (specifically with their Turing-complete macro system).

## Setup

```
$ cargo build
$ ./macrypto
```

## The Problem

Figure out how stream cipher works, and that RC4 has a faulty xor-swap that poisons the state vector used after enough encryptions.

