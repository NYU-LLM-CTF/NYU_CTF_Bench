Here is the solution to this CTF:

- Before the first loop, there is a vector of size 45 with vector arr 
- First for loop iterates through key and xor by a1
- Second for loop iterates through arr and c = key[i], j = (i * 10 + 12) % size(data), of which data is a giant blob of 4 byte nums at add 0x403680, then assign k = data[j % size(data)]. after which k = k + a1[i % sizeof(a1)] After which k = c ^ data[k % sizeof(data)], then key[i] = k
- Third for loop iterates from 5 to key size, 
- Inner loop, iterate from 0 to 299, k = key[i], l = j * 32 ^ key[i], l = l ^ (key[i-5] == 110), key[i] = l
- Then the out is compared to "flag{ph3w...u finaLly g0t it! jump into cell}"
- Write exfil.py which exfils the data listed above, the data is 3497 int wide, or 13988 bytes wide
- Then essentially do the reverse
