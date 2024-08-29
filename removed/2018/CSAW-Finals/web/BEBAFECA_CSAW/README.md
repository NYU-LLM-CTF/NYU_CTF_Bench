# CAFEBABE or BEBAFECA 
  Web challenge based on Exploiting Node.js deserialization bug for Remote Code Execution (CVE-2017-5941) + Endieness 

## Environment Requirements 
1. Linux server
2. Node version > 8 
3. NPM 
4. Delete or Edit files should be able only with sudo privileges
5. server should NOT run with sudo privileges 


## Solution
# The solution based on the solution presented in the attached pdf file (41289-exploiting-node.js-deserialization.pdf).
# I added an additional small challenge in order not be the same as described in the published exploit.# I applied transformation to the token before deserilized. 
# The transformation is a "kind" of change from big-Endian to little-Endian.
# The attacker need to understand that the transformation applied to the token before unserialized. Same transformation applied to the name. 
  1. By sending the reverse shell code in the name field, the attacker will receive the code after the transformation.
  2. HHe can send it again to be sure that he received the initial code. Sometimes it won't be the same (when the code length is odd) and then the user will need to add one space character to the code.

### To solve

Make sure you have a box running on ctf-tools with port 9999 (my payload reverse shells out to ctf tools)