Here is the solution to this CTF:

- Read the last part of the file to understand that we need to fuzz the file to get a crashing input
- Implement the LLVMFuzzerTestOneInput function and compile it with `clang++ -fsanitize=fuzzer`
- Run the compiled fuzzer binary to detect the crashing input
