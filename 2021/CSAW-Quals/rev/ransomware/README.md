## Ransomware Challenge

### `Help, IR team! Our files were encrypted and a super valuable file wasn't backed up! Here is a PCAP of when the attack may have happened, our back-ups, and the encrypted files.`

### Provided Files:
- Malware and encrypted directory.

### Steps to solve:
- Extract the dropper from the PCAP
- Reverse the dropper used to download the Encryptor (Downloaded outside of capture time)
- Reverse the dropper to figure out how to connect and download the encryptor. (Password? System time?)
- Reverse the encryptor to determine that AES in CTR mode was used to download files. 
- The backup and its corresponding encrypted file can be used to determine the key used to encrypt the file. 
- Decrypt the flag file using formula: cipherfile1 XOR cipherfile2 XOR plainfile1 = plainfile2
- PROFIT

### Encryptor:
- Only encrypts PDFs? in "SecretCSAWDocuments" directory.
- Encrypted file names are the hash of the contents of the original file
- AES CTR mode
- Generates its own key and runs it. Players don't have to recover the key but for realism the encryptor sends the key and runs it.
- The ransomware writer's mistake was to reuse the nonce each time a file was encrypted.

### Reference:
- Not part of the challenge. Previous solve from HackTheBox CTF, reference material for writing the encryptor.
- From Rootkits and Bootkits: Reversing Modern Malware and Next Generation Threats, p. 211:
  "TorrentLocker: A Fatal Flaw
   Not all early ransomware was this impenetrable, due to flaws in the implementation of the encryption process. The early versions of Torrentlocker, for instance, used an Advanced Encryption standard (AES) cipher in counter mode to encrypt files. In counter mode, the AES cipher generates a sequence of key characters, which is then XORed with the contents of the file to encrypt it. The weakness of this approach is that it yields the same key sequence for the same key and initialization value, regardless of the contents of the file. To recover the key sequence, a victim can XOR an encrypted file with the corresponding original version and then use this sequence to decrypt other files. After this discovery, TorrentLocker was updated to use the AES cipher in cipher block chaining (CBC) mode, eliminating the weakness. In CBC mode, before being encrypted, a plaintext block is XORed with the ciphertext block from the previous encryption iteration so that even a small difference in input data results in a significant difference in the encrypted result. This renders the data recovery approach against TorrentLocker ineffective."
- Actually it turns out that Torrentlocker had an even sillier flaw and wasn't even implemented with AES. But a lot of blogs at the time got it wrong and advertised that it used AES, and the book writers got the wrong idea and wrote that callout without going to a primary source with their research. Oh well, we still got a challenge out of it.

#### Testing questions:
   1. Do we send the manager's png file showing the date or is that too obvious?
   2. Would participants guess the solution and skip all the reversing? Do we want to put in a fix for that or stay with the realism?

### Credits:
- Inspiration for this came from the Alienware challenge from WPICTF. Same general idea for Windows ransomware, different encryption mechanism for this challenge. Plus we added some realism.  
