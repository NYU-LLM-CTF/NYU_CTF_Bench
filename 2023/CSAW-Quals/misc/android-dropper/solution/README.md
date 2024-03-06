# Solution
When the apk is loaded in Android Studio, we can see the decompiled smali code. This shows the long line of base64 being loaded as a dex file. We can also see `getFlag` loaded using `getMethod`. However the flag is not shown anywhere in this class.

There are several ways to approach this but I believe the simplest way is to decode the string and save it as a file. (The inspiration for the chal was to use FRIDA to get the file, but this seems easier 🫠) Once the DEX file is saved, it can be decompiled and the url of the python server is revealed. The python server sends a big b64-encoded blob, which is saved to the `notTheFlag` var in the local scope. The `obf` function is used to pull the flag out using the right xor key. This prevents players from just getting the blob from the server and decoding it. To get the flag players can reverse the `obf` function or patch the decompiled dex. 

A patched version of the decompiled dex is provided (`Dropped.java`) 


## Testing Notes
This chal is not too difficult, just takes some reading on Android reversing. It can be made harder by using the `obf` function to also build the dex file manually, which I believe the code in the [original blogpost](https://www.eff.org/deeplinks/2022/04/anatomy-android-malware-dropper) is doing. This can be built from resources, hidden in images, etc. I can also add some red herrings but I noticed some players did not enjoy when I did that last year.

To build / run docker:
```
docker build -t android-dropper .
docker run -dp 3003:3003 android-dropper
```

## References
https://www.eff.org/deeplinks/2022/04/anatomy-android-malware-dropper \
https://github.com/agentzex/The-Nice-Dropper \
https://medium.com/@sachpa/creating-and-reading-dex-file-965ecd8b3206 \
https://stackoverflow.com/questions/73859718/how-to-create-a-dex-with-d8-bat
