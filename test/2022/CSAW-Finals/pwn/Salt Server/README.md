# Readme
### Challenge Description
I took twit nacl, changed a bunch of the constants, added a few changes, and then created a small protocol based on it.  The way I'd solve it is using GDB and having that do the encryption for me otherwise, it's going to just be a lot of annoying reverse engineering.  I'd estimate at 10-12 hours most likely for a skilled reverse engineer, however, if people understand exactly what this is it could take as short as 3-4. 

Once you can communicate you are given three extremely strong primitives, arbitrary relative read, arbitrary relative write and the ability to load files into memory. The trick is load the file into memory and then read the relative offset to get the flag.

### TLDR
Salt client is the exploit solver.
DO NOT DISTRIBUTE SALT CLIENT.
I would rate this as HARD.

Please ensure that the name of this challenge is salt_server, saltServer, or saltserver.  This is the largest hint of the challenge and makes it better.
Ensure that flag.txt is the flag location and communicate that to teams.



# Flavor text
This is for the salt of all the tears.  Flag is located at flag.txt.
