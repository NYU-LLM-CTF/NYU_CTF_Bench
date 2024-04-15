# Chatterbox

Author: cts (@gf_256)

Challenge description:

```
it's a chat server, go pwn it. enough said

- IP: 18.118.84.13
- Port: 1300 + $TEAM_NUM

Remote:
 - Windows Server 2019 Version 1809 Build 17763.2237
 - Default server configuration
 - kernel32.dll: `9f3ef4ca6ebbb87f8fae8743ef35603c4a5a1423`
 - ws2_32.dll: `9994ea84bda917f1062209feb5cdab97e2a2e55f`
```

# Author's notes

This is a Windows heap pwn challenge. I feel like many CTF players are not exposed to Windows before so this will be an interesting challenge for them.

Attached binaries: contents of `public/` . Remote's `ws2_32.dll` and `kernel32.dll` should be provided too to help the CTF players.
**Ideally,** we would give them the VM image too so they can test locally against the exact same environment as remote.

Difficulty: Hard, about 500 points.

# Deployment notes

The server itself is the pwnable, so each team should have its own instance of the server. Crashing the server is expected so each instance should auto-restart immediately.

**Solving the challenge requires spraying many connections to the daemon. So every team needs to be on its own instance.**

Each team has a server hosted on their own port. We need to assign a port per team.

If you solve the challenge, there is the possibility of doing some shenanigans like shutting down the VM, so we should hope that the solving teams will respect the sportsmanship.

**Flag should be in C:\flag.txt and be world-readable.**

# Vulnerabilities

1. Heap overflow, attacker can write arbitrarily far out of bounds of a chunk of size 1024 bytes

2. The function `recv_packet` lacks adequate error handling which can lead to an incomplete read if the socket is shut down in one direction only, but not closed. This can be paired with the heartbeat functionality to get an out-of-bounds read for a leak.

3. any unintended bugs I may have made by mistake.

# Exploit strategy

The solve.py exploit is a total mess and not portable, but it suffices for a CTF quality exploit.

1. Spray a bunch of ClientSocket objects onto the heap

2. Out-of-bounds read using Bug #2 to leak some vtable pointers from the sprayed ClientSockets. This gives us leak for Server.exe base address

3. Spray ClientSockets again

4. Use Bug #1 to overflow and overwrite some vtable pointers in the sprayed objects. This step is not reliable and it can just crash.

5. We have a single gadget after overwriting vtable pointer, we use this to stack pivot to the heap

6. Then we stack pivot to the .data section in the "channel topic" buffer that is easily controllable, and at a known constant offset from Server.exe

7. Connectback shellcode that sends the flag. We can't spawn a shell since stdin/stdout aren't dup'd to the socket.

# Testing notes
*Note that testing this script requires access to a public IP address that is outside of the VPN (e.g. a DigitalOcean droplet IP or similar).*

The `testing/` directory contains testing scripts useful for querying one or multiple challenge server ports. Use runexploits.py after modifying the `LISTENER_IP` to your external IP address and the `PORTS` to a single or range of ports.  Also confirm that the `SERVER_IP` is valid and set to the `chatterbox.chal.csaw.io` domain IP.  

Next, copy the receiver.py script to your external box.  Modify `NUM_PORTS` and `START_PORT` to match the ports that you are querying with the runexploits.py script (the test should match so that a successful exploit on port 1301 will send the flag to your IP address on port 1301).  Start the receiver.py script first and confirm your box is listening on the intended port(s).  Next, run the run_exploits.py script.  *Note that the run_exploits.py script does not succeed 100% of the time, so if it completes without your box receiving the flag then retry*.  

md5sum hashes for provided files: 
```
❯ md5sum public/MyChatApplication.exe public/MyChatApplication.pdb public/Server.exe public/Server.pdb
348839a508f02025a8c72ea67d4105e7  public/MyChatApplication.exe
e499b8ff00bae77db75bd0d0ee500c07  public/MyChatApplication.pdb
e1bc0f8d678c2d6099dc6729ae5422d4  public/Server.exe
a04aba76d5c2ec093eaf7fa8d59082f3  public/Server.pdb
```