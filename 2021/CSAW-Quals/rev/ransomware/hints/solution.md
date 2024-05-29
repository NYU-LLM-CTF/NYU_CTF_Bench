Here is the solution to this CTF:

- Extract the encrypted files from `files.zip`
- Decompile the functions of `ransomwaRE.exe` and see that it is using AES in CTR mode for encryption
- Careful analysis shows that the KEY and IV are reused for every file
- This means that in CTR mode the key-stream is the same for all files
- The key-stream can be recovered from a plaintext-ciphertext pair, which is available as the original and encrypted files
- Use the key-stream to recover encrypted files
- Install `poppler-utils` and use `pdftotext` to extract the flag from the decrypted pdf files
