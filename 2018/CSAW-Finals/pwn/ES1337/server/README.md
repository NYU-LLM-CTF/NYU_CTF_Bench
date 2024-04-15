# V8 server

This server listens on port 1337, players connect, solve a POW, and provide a URL.
The server will then spin up a docker image and run the modified chrome on the given URL.

# Setup

Copy this directory to target server, run setup.sh. It will install docker and set up the systmd service, then reboot.

Port 1337 should be exposed to non NA teams.
