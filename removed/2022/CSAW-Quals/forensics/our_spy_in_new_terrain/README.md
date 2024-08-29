# Our Spy In New Terrain (OSINT) 
Premise:
The Good Guys recently learned that The Enemy is planning an attack on a new target! It is up to you, as an agent for the good guys, to determine who The Enemy is going to attack next and what sort of illegal activities they have in mind!

## Authors
Devansh Patel and Eliana Halevi

## Questions & Answers:
1) When joined twitter: 08/2022
2) Github username: spyduhman
3) Name of file storing next clue: log.txt
4) Country of target: canada
5) Swift code of target:TDOMCATTTOR
6) What is a crime: Copyright Infringement


Final Flag: flag{C0N6r475463N7600DW0rKN3X771M3N0PU811C53rV3r}
		          	"congrats_agent_good_work_next_time_no_public_server"
			

## Solution / Notes


### 1. First Tweet
No tricks here. a quick look at Darkroom8109's twitter feed shows the first tweet was published at 3:03 PM 08/04/2022 
<img width="463" alt="Screen Shot 2022-08-24 at 11 57 35 AM" src="https://user-images.githubusercontent.com/90015030/186530961-70bb6116-6b26-46db-98e3-1a8a4458863d.png">

Military time uses the 24 hour clock, so 3:03 PM becomes 15:03 
The final answer is 15:03 08/04/2022

### 2. Github username
Looks like The Enemy agent deleted a tweet! To view this tweet, users can use tools such as Wayback Machine. 

<img width="461" alt="Screen Shot 2022-08-24 at 12 58 24 PM" src="https://user-images.githubusercontent.com/90015030/186538047-fd27716f-b28e-41b4-8d73-7aab6a13d9f4.png">

Using Wayback Machine, a tweet refrencing github can be seen:

<img width="702" alt="Screen Shot 2022-08-24 at 12 54 15 PM" src="https://user-images.githubusercontent.com/90015030/186538205-110b0cb0-2506-40da-8eac-2ea56b6634fd.png">

### 3. Name of File
At a glance, there is nothing noteworthy in spyduhman's git. There is one repository called 'Chat_app'. within Chat_app there are two files: client.py and server.py
If you examine the two files however you can see that logs of the conversation are stored in a file called log.txt. Additionally, if users check the commit history, they will see that spyduhman deleted a log.txt file!
<img width="1176" alt="Screen Shot 2022-08-25 at 6 51 44 PM" src="https://user-images.githubusercontent.com/90015030/186824654-71bbb2b4-57a1-408a-900e-08d22b846d5a.png">
Upon viewing commit details, users can read the entire chat that The Enemy had with its evil agent!

### 4. Country of target
The message in the log contains a url (bit.ly/evilassignment) to a file. The downloaded file is an audio file that appears to use morse code. Unless you are fluent in morse code, the fastest method of decoding this file is by uploading it to a website! 
One website that performs this service somewhat reliably is https://morsecode.world/international/decoder/audio-decoder-adaptive.html
The decoded file says:
     Hello Evil Agent
     Your next target is a bank
     The bank's bin number is 452234
     The targets swift code is your password
     For more instructions visit bit.ly slash osintsec
     Good luck
  
To learn more about which bank is being targeted, enter the given bin number (452234) in a bin number checker (such as the one found at https://www.bincodes.com/bin-checker/ or by googling "bin number 452234").
The results will show that the bank is Toronto-Dominion Bank based in Canada.
  
### 5. Swift code of target
Googling Toronto-Dominion Bank Swift code gives the result 'TDOMCATTTOR'
This information can also be found in swiftcode databases.

### 6.  When next attack will take place
Now the user has a password but no place to use it! The mesage they recieved in morse code _did_ say to visit bit.ly/infosec  for more instructions. The url leads to a password protected PDF called YoureSoClose!
Open the file with 'TDOMCATTTOR'
The image appears to be a body of water.
Looking at basic metadata (in preview via 'inspector' and in Adobe Acrobat via 'properties'), one can see the picture is strangely titled "Remember: Copyright Infringement is Against the Law"
<img width="613" alt="Screen Shot 2022-08-25 at 7 43 14 PM" src="https://user-images.githubusercontent.com/90015030/186830645-2e5ee7cc-158d-42a9-b077-b918276fd815.png">
