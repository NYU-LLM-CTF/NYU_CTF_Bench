# Forensings
> Category: forensics
> Suggested Points: -

# Description
> Detailed description for the participants.

Can you use your best forensics and singing skills to gather the four parts of the flag?

# Deployment
> Any special information about the deployment.

The .zip is the only file needed for deployment. This is an offline challenge.

# Design
> Detailed description for the lab members.

The challenge goal is to mix both forensics tasks with audio steganography. The flag is split into four different parts, where two of them will be gathered using forensics techniques, and the other two using different audio steganography mechanisms.

# Flag

`csawctf{1st_p4rt_4nd_2nd_4re_f0r3nsics_but_3rd_4nd_4th_4r3nt}`

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

One potential solution for the challenge should consist into:
- Unzip the file and get the .raw memdump: `unzip forensings.zip`
- Use the following `volatility` modules with the `.raw` file:
	* `imageinfo` to get the correct profile for the memdump: 	`vol.py -f forensings.raw imageinfo`
	* `clipboard` to get the content of the clipboard when the memdump happened: `vol.py -f forensings.raw --profile=Win7SP1x64 clipboard`
	* `screenshot` to get the Desktop screenshot when the memdump happened: `vol.py -f forensings.raw --profile=Win7SP1x64 screenshot --dump-dir .`
	* `pslist` to get all the running processes when the memdump happened: `vol.py -f forensings.raw --profile=Win7SP1x64 pslist`
	* `memdump` to dump one of all the notepad.exe processes (the only one different from the others): `vol.py -f forensings.raw --profile=Win7SP1x64 memdump -p 1592 -D .`
- After the previous steps, we do the following with each piece of retrieved data to get the parts of the flag:
	1. We decode the b64 in the clipboard and get one part of the flag.
	2. We analyze the Desktop screenshot, and we decode the b64 in the Search bar in one of the opened tabs, getting the second part of the flag.
	3. For the third and fourth part, we should work over the dumped notepad.exe. The key here is to access the content that was written on it, which contains a large b64 with an encoded WAV file. To do this:
		* `strings -e -l 1592.dmp > strings.txt`
		* After checking its content, we see how there is a huge b64 in the middle. To know where it starts and ends, we can note that there are two strings before and after it: `"The song starts after his line"` and `"The flag ended here"`. We can use tools like a text editor or commands like `grep` with keywords like flag or song to figure this out.
		* We use commands to delete everything but the b64 string:
			* `sed -i '1,/The song starts after his line/d' strings.txt`
			* `sed -i '/The flag/,$d' strings.txt`
			* Any other method to get the b64 string only is valid, like manually deleting the rest of the lines from a hex editor, or scripting the task based on a b64 regex.
	4. Now we convert the b64 to a WAV file
	`base64 --decode strings.txt > song.wav`
- With the gathered WAV file, we need to apply steganography:
	1. The file has 6 audio channels. Looking at it closely, there are just 3 unique channels.
	2. For the first one, where the song is, we can realize that in the middle there's a rare sound. Analyzing the spectrogram, we can see a part of the flag written there.
	3. For the other channels, we have to closely analyze the audio. If we elevate the gain (dB) and we hear them, we can see how both of them have a part where the song is cut and some dialing sounds appear.
	4. We take those dialing sounds and export them separately as WAV files.
	5. We add them together and use any DTMF decoder online.
	6. With the numbers retrieved from the last step, we take them and convert them to ASCII, getting the last part of the flag.
- We add all the parts of the flag together, and we have the final solution.
