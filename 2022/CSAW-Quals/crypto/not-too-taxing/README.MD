# Not Too Taxing

## Overview

We intercepted some email communications between a tax consultant and his client that contained some important tax documents. We were able to successfully extract two of the documents, but we can't figure out the password to the file to get the data. Attached are the two extracted files, Tax_Ret_Form_Blank.pdf and Tax_Ret_Form_Nov_2021.zip, and a transcript of the emails we found, SPBlock_Email.pdf.

Can you figure out the password so we can get this guy's info?


## Summary of Idea

The idea of the challenge is to take an advantage of a known vulnerability in the way windows used to encrypt zip files in the past. The broken algorithm is called ZipCrypto which today, is also known as "legacy windows encryption".The conditions for the attack to succeed is to know at least 12 bytes of plaintext (at least 8 of the bytes should be contiguous, also as long as the known plaintext is, the fastest the attack). The theme of the challenge is that a client insists to send his tax return form encrypted using that algorithm, to the CPA, even tho the CPA tells him that's not a safe algorithm anymore, and it's easily broken. This part of the challenge (break the ZipCrypto algoritm) is done but there will be another "challenge" that covers this one. PCAP file should be provided contains all the email chain between the client to the CPA.

The theme of the challenge involves email communications between a CPA and his client in preparation for a meeting to complete the client's taxes. The client is worried about sending his information in plaintext over email and insists on sending the information encrypted. The CPA is not necessarily tech savvy and won't install unapproved software on his company system because he doesn't want to upset his boss. The client really needs to get his taxes done, so he compromises and encrypts the file in a way that would allow any Windows 10 machine to prompt for a password for decryption without any additional software. This just so happens to be using the backwards compatible, legacy Windows  encryption method "ZipCrypto".

Note: The goal was to capture a PCAP with all the communications traffic to have the challengers extract the information and files themselves. The newer QUIC protocol made this a more difficult than expected, but the idea should be pursued in future rounds once more is known about decrypting the protocol.

## Solution

password for zip : 5up3r_53cr37_p455w0rd_5up3r_53cr37_p455w0rd (not part of the challenge)

https://blog.devolutions.net/2020/08/why-you-should-never-use-zipcrypto

use the command:
7z l -slt Tax_Ret_Form_Nov_2021.zip | grep Method

now we know it used the ZipCrypto algorithm.

solver to obtain the zip keys: 

bkcrack -C Tax_Ret_Form_Nov_2021.zip -c Tax_Ret_Form_Nov_2021.pdf -P Tax_Ret_Form_Blank.zip -p Tax_Ret_Form_Blank.pdf 

use the keys to make a new zip archive with known password "cracked":

bkcrack -C Tax_Ret_Form_Nov_2021.zip -k b2c4a24e f036ff3a 998f6727 -U Tax_Ret_Form_Nov_2021_cracked.zip cracked

then you got the zip archive and you can extract it using the password "cracked" that we set above:

unzip -P cracked Tax_Ret_Form_Nov_2021_cracked.zip

in the decrypted pdf, flag is in phone number field at the second page

flag{1f_y0u_u53_z1pcryp70_4ny0n3_c4n_aud17_y0u}



**MD5 Hash for files**
```
SPBlock_Email.pdf:
4f33d58830fa298738a6078aa5e2f9c2

Tax_Ret_Form_Blank.pdf:
6560694dd9c15a44910d9d7c268bb55a

Tax_Ret_Form_Nov_2021.zip:
b56f8bbe5754827e9f9cbfa83063b6a1
```

**Solve Attempt Write-up:**

My first attempt was to use fcrackzip (https://github.com/hyc/fcrackzip) to bruteforce the zip password, but soon realized that's probably not what the challenge is about. Googling *"windows zip encrypt vulnerability"* led me to the following link (https://blog.devolutions.net/2020/08/why-you-should-never-use-zipcrypto), which is the blog mentioned above in the intended solve. It mentions a way to decrypt the zip file using *"bkcrack"* if given another file zipped using the same compression method. This should provide enough info for players since the challenge provides them with another plaintext file `Tax_Ret_Form_Blank.pdf` which can be used with *"bkcrack"* to decrypt the encrypted file. Following the blog post and using it to get the flag wasn't hard. Though I can see how some players may spend some time finding the right blog post. The SPBlock_Email.pdf provides good information on the direction of the challenge.
