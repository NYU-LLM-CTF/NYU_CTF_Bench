# Beyond Quantum

This challenge demonstrates the malleability of the NTRU algorithm. I've used an implementation by Jedrzej Krause (https://github.com/jkrauze/ntru) with his permission. We give him credit in the flag.

Here's how it works:

The player interacts with a server and gets the `server.py` file. They also get the contents of the `cipher` folder, which is Krause's implementation of the NTRU algorithm. I've gotten rid of the logging that he provides, as well as the part that pads the ciphertext. Basically the challenge is a take on the traditional signature forgery challenge -- except here you're doing a chosen ciphertext attack. The idea is you take the ciphertext and slightly modify it, and that produces a change in the plaintext that can be in the padding area. It's pretty easy and intended just to demo the malleability of NTRU -- so more instructive than challenging. I'd say most people will solve this challenge in a couple of minutes if they just try editing the ciphertext. Some people will research NTRU and take longer.

With the ZipCrypto first part this would have been a 200-point quals challenge I'd say, so a 100-point challenge for finals, sure. As it stands it's a 100-point Quals challenge. Depending on the number of challenges we have ready for release, we could consider holding this one for next year.

A way to make this harder is to use the chosen plaintext attack cited ![here](https://crypto.stackexchange.com/questions/33769/which-attacks-are-possible-against-raw-textbook-ntru-encryption). I went for the CCA attack.

Giving them the public key isn't strictly necessary, but since this is an asymmetric cryptosystem I decided to do that. Otherwise the path to the solution is even more obvious.
