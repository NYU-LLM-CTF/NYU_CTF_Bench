# Constela
## Description
The year is 7331, and BadCorp rules the galaxy with it's omnipresent satelites. But recently a resistance movement led by a band of hackers calling themselves the OSIRIS has hacked into BadCorp systems, they have taken over the satelites and it is believed they are trying to send a message across the galaxy... </br>
Can humanity _see_ their message?

## Solution
The data has been exfiltrated using DNS. We extract out all the suspicious looking packets and find that the data is base64 encoded.

Taking the data and joining every pair of suspicious website and decoding it, we get some GPS coordinates.

Plotting the latitude and altitude gives us a QR code when scanned gives us the flag.

The final solver script that does everything is `solve.py`.

# Test notes

1. Challenge was fun and nicely brought together many ttp's that could be used by an attacker in the wild, including exfiltration over alternative protocol (T1048) and data obfuscation (T1001). While prior knowledge of these techniques would make the challenge more accessible, the highly unusual amount of (bad) DNS traffic in the accompanying pcap file combined with the given context clues should be enough indication that this is where attention should be focused. Working through the challenge I had the opportunity to learn some new skills/tools that I've never used before such as tshark, and observe how an attack using exfiltation over an alternative protocol might actually play out. 

2. With a little googling it was possible to find all the tools and information I needed, and I never felt like I was completely lost. Extracting the data from the pcap file took me some time, as first you need to extract and process the individual b64 encoded strings from the DNS queries, which required a little scripting. This took some time but was not overly burdensome. For me, making the connection that the individual gps coordinates were not intended to be used as actual coordinates but to be plotted to derive the QR code that gives you the flag, was not possible. (Very subtle use of "coordinates")  However, I think this idea is very clever, and if I spent more time to think about what to do with all those coordinates maybe I would have solved it. The fact that it's not the latitude and longitude that ultimately gives you the solution but the latitude and the height, which you would only know if you had properly reconstructed the original data, was another nice feature of this CTF. I wonder if it would be possible to gesture towards this a little more without making it too obvious? Overall, I think it is an awesome challenge as is; maybe someone more clever than myself will have better luck x)

3. It was not possible for me to get to the flag without following the natural flow of the challenge. The logical progression of this challenge is another feature I really liked about it. 
