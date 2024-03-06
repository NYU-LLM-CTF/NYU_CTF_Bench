# Corporate NTK Problems
Premise:
Defense contractor Big Corp has a possible security issue where classified information may have been leaked. The Governement is asking for your help to identify the possibility of the leak and if true, what has been compromised.

## Author
Andrew Prajogi

## Flag
flag{NCIS G1bb$' rU13 #4}

## Required Files (Download Link)
https://drive.google.com/file/d/1XVYMWnhgN9ykc2ikPbxMKrMuaYNxbGTk/view?usp=share_link

## Questions & Answers:
1. What is the hostname of this system?
	BIGCORPLT978
		Check registry: HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/ComputerName/ComputerName/ComputerName

2. Who is the user of this system?
	John Smith
		Check registry: HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows NT/CurrentVersion/ProfileList
		Some can also just the emails to see the names being passed back and forth along with the email itself

3. What timezone is this system set to? Answer in full name format (e.g. Universal Time Coordinated
	Pacific Standard Time
		Check registry: HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/TimeZoneInformation/TimeZoneKeyName

4. When was this OS installed? Format YYYY-MM-DD HH:MM:SS and Time in local Timezone
	Install Time: 8:36AM PST 10/01/2022
	2022-10-01 08:36:47 -07:00 | 1664638607
		Check registry: HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows NT/CurrentVersion

5. Did you find evidence of mishandled classified documents?
	Yes
		Obviously, or what was the point of the box lol?

6-8. What are evidence of mishandled data? Pleae enter the SHA-256 Hash for the evidence.
	1. Future Nuclear Power Plans.pdf
	b383b191dd43beb620cd1e8adf8e6f8032842f9f935c492e45cd5f2f9934bba1":
    
	2. ML092650379.pdf
	6b32444e3ec51e9ddb6e25695a006e4b51253967e7f124414ed0c7e1f86fa9b2":

	Location: Users/John Smith/AppData/Roaming/Thunderbird/Profiles/lwju899e.default-release
	Within John's email, there are two sent messages to Bob that hold these two listed files. Upon inspection of the pdf files, you should see that they contained appended data.
	1. Was a combination of two classified files and added fluff
	2. Was a classified file appended to a lesser classified file
	There were no more than 2

9-11. What are the leaked documens in "Future Nuclear Power Plans.pdf"?
	1. Nuclear Reactor Design Notes.pdf
	aa773fbd9bb1ce1b9aabc98e6a6f7f7391999fdfdf422b9ee583da7de46b38a7
	
	2. Nuclear Power Plant Generation.pdf
	2c5d0c6611016b35e85ee0944f21198b3e3f616da077faf3849d673eefbb6938
	
	Location: Users/John Smith/AppData/Roaming/Thunderbird/Profiles/lwju899e.default-release
	Within John's email, John and his coworker Charlie exchanged higher classified files that were then passed onto Bob.
	If you were able to parse the appended files, you can compare the data and find these two pdfs hidden within.
	There were no more than 2
	
12-13. What are the leaked documents in "ML092650379.pdf"?
	1. Design Control Document in PDF.pdf
	0ae25651d1a1ecb5facd059a81c764b051e7280cacc02ad62075957b1aaad997

	Location: Users/John Smith/AppData/Roaming/Thunderbird/Profiles/lwju899e.default-release
	Within John's email, John and his coworker Charlie exchanged higher classified files that were then passed onto Bob.
	If you were able to parse the appended file, you can compare the data and find these this pdfs hidden within.
	There were no more than 1