Here is the solution to this CTF:

- Unzip the sourcery.zip to find a .git folder with all the logs and file diffs present
- Analyze the master branch and enhancements branch
- See the commit contents using git show
- Find the commit that deletes secrets cpython compiled file
- Extract the file from the previous commit
- Uncompile it using uncompyle6
- Find the seed array and unscramble it to get a base64 string
- Base64 decode the string to get the flag
