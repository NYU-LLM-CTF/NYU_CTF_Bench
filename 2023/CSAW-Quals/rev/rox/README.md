# rox 

This challenge primarily involves significant xoring of some data with the goal of getting a password which can open a file. None of the flags can open the file but the final one needs to be password matched to be continued.

Also this was compiled on GCC in FreeBSD so dynamic analysis would probably need a VM or some compatibility layer. You can open this up statically though.

Author: Aneesh Maganti

# Solution

Look in the food_tests.cpp file to find the password. This originally was supposed to open a 7z file which is why the password doesn't have the normal flag{} formatting. 

# Note

the password is not enclosed in a flag{}, see challenge.json for more information on flag format

# TestPlay Solution

Don't have freebsd so the solution is static analysis

func verify:
1. before the first loop, there is a vector of size 45 with vector arr 

2. First for loop iterates through key and xor by a1

3. second for loop iterates through arr and c = key[i], j = (i * 10 + 12) % size(data), of which data is a giant blob of 4 byte nums at add 0x403680, then assign k = data[j % size(data)]. after which k = k + a1[i % sizeof(a1)] After which k = c ^ data[k % sizeof(data)], then key[i] = k

4. third for loop iterates from 5 to key size, 
5. inner loop, iterate from 0 to 299, k = key[i], l = j * 32 ^ key[i], l = l ^ (key[i-5] == 110), key[i] = l

then the out is compared to "flag{ph3w...u finaLly g0t it! jump into cell}". 

Write exfil.py which exfils the data listed above, the data is 3497 int wide, or 13988 bytes wide

then essentially do the reverse

replcation:

first loop:

```
for (int i = 0; i < a1; i++)
{
    key[i] = a1[i] ^ key[i]
}
```

second loop:

```
for(int i = 0; i < sizeof(key); i++)
{
    int c = key[i];
    int j = (i * 10 + 12) % sizeof(data);
    int k = data[j % sizeof(data)]
    k = k + a1[i % sizeof(a1)]
    k = c ^ data[k % sizeof(data)]
    key[i] = k
}
```

third loop:

```
for(int i = 5; i < sizeof(key); i++)
{
    for(int j = 0; j < 300; j++)
    {
        int k = key[i];
        int l = j * 32 ^ key[i];
        //notice this is optimized out 
        //as xor by same number 300 times result in the same num
        l = l ^ (key[i-5] == 110);
        key[i] = l;
    }
}
```

Note: This challenge would be bruteforceable if not for the third loop

