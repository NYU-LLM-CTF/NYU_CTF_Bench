```
./build-client.sh
docker-compose build
docker-compose up
python solution.py
gpg -d encrpyed.gpg: Password: X.Ai.A12.Archangel
```

Protocol Example 

```
get user:     00 00 00 06 01 01 06 6b 61 62 6c 61 61 78 d5 68 cf f2 e3 4f 51 ab 2d 4e e9 ea 50 26 0b
buy nft:      00 00 00 06 02 01 04 00 00 00 01 94 4b 50 df 71 d8 1f aa 3d 10 01 d6 78 2d 2d 71
get location: 00 00 00 06 03 01 04 00 00 00 02 3a 68 48 17 4b f9 76 24 51 da 7e 1e 17 28 d3 d4
rename:       00 00 00 06 04 02 04 00 00 00 02 07 6e 65 77 6e 61 6d 65 5a a4 d8 67 f2 f8 ce 9d 32 a3 e4 13 d1 fb 33 06
```
