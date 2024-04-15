# United

## Overview
Multi-step challenge requiring user to:
1) Use SQLi Union attack to leak the leak info on the 2 admins
2) Crack the SHA-1 leaked password for the common password used by 1 of the 2 admins
3) Find the unlinked admin login page and log in to find the flag

## Particulars

#### Built using:
- Node
- Express
- Passport
- sqlite3
- Docker

#### To Run Locally:
- Build docker image: docker build -t United .
- Run: docker run -p 3000:3000 United

#### Solution:

##### To get the admin information
The player number in the detail view of the roster tab is vulnerable to SQLi. Using a UNION attack you can leak the info from the admin table. Players will need to leak the columns or find the /admins/all endpoint

Sample path to exploit: "http://localhost:3000/players/2-P' UNION SELECT NULL, username, password, name from admins--"

The existence of an admins table is hinted by the /admins/ route. This can be found in the in the following places:
- robots.txt disallow entries
- In the "contact the admins" link target on the About page
- Redirection from the /administration link when unauthenticated
- The /admins/all endpoint if they find via a tool like gobuster

##### To crack the admin password
Admin user iripp's leaked SHA-1 password can be cracked with John the Ripper and the RockYou wordlist

Username: iripp
Password: doughnut

The other admin user, yrock has a much more secure password not in the wordlist (note: this is an assumption).

The admin usernames provide hints to use John the Ripper and the RockYou Wordlist:
- Ionakana Ripp: Ionakana is the Hawaiian version of "Jonnathan" -> Jonnathan Ripp -> John the Ripper
- Yue Rock -> You Rock -> RockYou

##### To find the admin login
The users can finding the /administration link in either the robots.txt file or via a tool like gobuster. Visiting the URL when not authenticated will redirect to the admin login @ /admins/login.

Once they login as iripp they will see the flag.

#### Flag:
- flag{United_w3_leek_the_d4tabas3}

## Note
Feel free to update any styling or copy in the challenge. It's a bit...barebones.
