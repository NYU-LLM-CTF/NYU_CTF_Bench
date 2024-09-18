# Collision course

A database administrator wrote a script to create unique IDs from the original numeric IDs contained within a database. While doing so, they decided to use the original IDs to encrypt his password, since they were sure the original IDs couldn't be recovered. Prove them wrong and recover their password.

Tip - my_aes.py is a library they used for encrypting and decrypting password.bin. It can be used as a standalone script to decrypt the .bin file if the password is obtained

## Author
Kroll (Sean Straw)

### Files provided:
encrypt_database.py

encrypted_database.csv

my_aes.py

password.bin

## Testing speed of standard laptop
```
lime:csaw_crypto sean$ python3 test_md5_speed.py
[*] Running hash test of 1,000,000 iterations
[*] Runtime of 1.56850807 seconds
[*] Estimated speed of 637 Kmd5/s
```
## Calculating numbers with current configuration
```
lime:csaw_crypto sean$ python3 calculate_numbers.py --id 500 --salt $((36**3)) --hash-length 4 --md5-speed 500
[*] Total hash space: 23,328,000
[*] Estimated single entry hash space crack time: 0.78 m
[*] Estimated all entry hash space crack time: 6.48 h
[*] Single-entry collisions: 355.96
[*] ID collision possibility (for known salt): 0.76294 %
[*] How many salt/id combos match 1 records: 355.95703125
[*] How many salt/id combos match 2 records: 2.7157366275787354
[*] How many salt/id combos match 3 records: 0.02071942617476452
[*] How many salt/id combos match 4 records: 0.00015807667674838655
[*] Time to crack all IDs with known salt: 0.01 m
```

## Running actual hash collision

```
lime:csaw_crypto sean$ python3 test_md5_collisions.py
[*] Testing collisions of valid combos for aaaa
    -Salt set: abcdefghijklmnopqrstuvwxyz1234567890
    -Salt len: 3
    -Hash len: 4
    -Num ids: 500
[*] Got 349 instances for aaaa
[*] Took 47.622256983 seconds
```


## Testing Result: Crypto - Collision course
No major issue found from the test. Only conflict is with the PyCryptodome library version needed in the my_aes.py file. 
My box has an existing pycryptodome==3.9.7 version and running the script with this version will result in a Argument TypeError in running line 53: data = cipher.decrypt_and_verify(ciphertext, tag) of the script. However if someone is to install it new which is pycryptodome==3.11.0, the script will run fine without error. Maybe on the comment on the top of my_aes.py file, make a note of that or specify the version of the PyCryptodome to install. 
Line 2: # Uses PyCryptodome (python3 -m pip install pycryptodome)  => # Uses PyCryptodome (python3 -m pip install pycryptodome==3.11.0)

└─$ python3 solution.py --database encrypted_database.csv --passwordfile password.bin
Found valid salt: v0o
encryption_password : 512462742884204432941601161143043489298424544333464172653303796548426331723733920657104455378371151272254410144640611046937732439614031614925834898335397460231239404400322255303157458268462313743071213499539327538447047346714645743126813785486222623061873102574242504514521517043843929343239949836388300358323426914116431510921224210011945333134419021834050908016635248242829118108290499408251130528039236625628335016278642131613093814901681392954115249415219771869354184463314336269357297552309931818035552481591433124326611335621438327047822715317375811773378641246537333432418510224412348038236033252493229101703283864473242091304614191781038236112171195370364741202733851581321933011284099671271472179311347159423442286922262242342962021861921311622103532087678500333429232284274463903874049714221140339519837547182114483489105189115267978241826181207287466212282044713422431361563761224491937212912728535112485482891883326468291444405495329104073986340216736383240279259303653383133694523614794754915425323155245223367734013682008812444142761494217941972013193594376644849622122029960261282602812471444871503849234450233238302235199111425422225380138292435320351833454744143262164515619139582772483081171946736239110672205175176133476169282304911471753327125440464135445152107264321459325779541484214361964884132022491372622034562584163174389134411658724147734339415416341441393276126172
b'flag{d0nt_g3t_2_s4lty}\n'

Q: How hard was the challenge to solve for you? As in how many people do you think will get it?
probably medium. given that the aes decryption function is provided in the my_aes file, the only part that needs to be figure out is the salt and the encrypted password. My guess is maybe 50% of the people will get it.  

Q: Could you think of other paths to the flag other than the intended one?
Na, not to my knowledge




## Hashes for the given files

```
c88f332c324721063f1b89c8af2b4146  encrypt_database.py
23d362f77ebb20f9946a745cf17c79f1  encrypted_database.csv
7f237da98894af2e29849949beb88004  handout.zip
e10ae1c9bbcfdbb1d277b765b4c548b5  my_aes.py
9cca7a72135564400d782f0f11d2755a  password.bin
```

