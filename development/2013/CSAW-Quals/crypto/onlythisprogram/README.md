# onlythisprogram
## Author

## Points
300
## Category
Crypto
## Description
I tested out my new encryption tool on some files from the internet and it seems like it worked pretty good. What do you think?
## Flag
`BuildYourOwnCryptoSoOthersHaveJobSecurity`
## Solution
`solve.py`
## Setup
Distribute `onlythisprogram.tgz`
## Notes
Hint:
You don't have to figure out the whole key to solve the challenge. Some file formats make better oracles than others.
`echo "For some reason psifertex really likes figlets. In this case it's necessary because the file size should not be a huge giveaway. Though I suppose images would have worked too. Anyway, the key is: BuildYourOwnCryptoSoOthersHaveJobSecurity"|sed 's/ /   /g'|figlet -w 3000|gzip > key`
