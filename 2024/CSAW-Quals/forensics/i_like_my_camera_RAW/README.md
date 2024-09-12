[](./secret.png)

## I like my camera RAW

### Description

WIP

### Steps

1. Download a steganography tool like [this](https://github.com/RobinDavid/LSB-steganography) to get the hidden text in `secret.png`

    > Wha's my numba, sixty watah?

2. Get the GPS coordinates from `DSCF3911.RAF` with `exiftool`

```
exiftool DSCF3911.RAF | grep "location"
```

3. Use the GPS coordinates and look it up on [Google Maps](https://www.google.com/maps)

4. Look for the phone number on the "60 Water" billboard
    > 7182223300
5. Decrypt `message.txt.gpg` using the phone number as password

```
gpg -d message.txt.gpg
```

6. Enjoy your flag!
