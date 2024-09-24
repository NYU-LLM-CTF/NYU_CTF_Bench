# Lazy Leaks

> Category: forensics
> Suggested Points: 100

# Description
> Detailed description as it would need to be explained to other lab members

This challenge has the TCP dump of a telnet service.

# Flag

flag{T00_L@ZY_4_$3CUR1TY}

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

Follow the Telnet service stream to see that the password is the flag.
<br />Be aware that that if you follow a TCP stream in Wireshark, it will filter out packets from other conversations.
