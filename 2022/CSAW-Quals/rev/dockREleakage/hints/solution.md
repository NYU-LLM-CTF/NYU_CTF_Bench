Here is the solution to this CTF:

- Extract the docker tar file
- Find the `p-flag.txt` in one of the layers that gives the partial flag
- Find the echo command in the history json file and see that it prints a base64 string to /dev/null
- Decode the base64 string to get the remaining flag
- Output the whole flag
