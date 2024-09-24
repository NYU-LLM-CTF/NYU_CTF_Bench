# Farmlan~~d~~g 

> Category: misc
> Suggested Points: -

# Description
> Detailed description as it would need to be explained to other lab members

The goal of the challenge is to be able to solve three related problems about three different cybersecurity topics such as: steganography, WiFi Cracking and esoteric languages (programming).

# Deployment
> Any special information about the deployment if there is a server component

The .jpg is the only file needed for deployment. This is an offline challenge.

# Flag
Au+umn2022^

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

The ideal solution for the challenge should be to:
- Analyze the metadata of the image and observe the Title field.
- Decode the base64 Title field.
- Extract with any stego tool the .zip hidden inside the file using the password decoded from the b64 above.
- Decompress the .zip hidden file and get the handshake and animal files.
- Realize that one of the files is not only an animal sound, it is also code written in COW, an esoteric language.
- Copy/paste the code into a COW interpreter and observing that the result is a link to an online dictionary word.
- Decrypt the WiFi handshake file available using the above dictionary and any WiFi cracking tool.
