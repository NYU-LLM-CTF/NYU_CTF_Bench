## PWN Voltex

**Description**: With COVID all the arcades are closed :( Luckily there is a clone
of my favorite rhythm game, Sound Voltex, free and open source online!!

I even charted a new flag song too! Lets play some multiplayer :3

Submitted by itszn from RET2 Systems

**Handout**: handout/pwnvoltex.tar.gz

**Category**: pwn / misc

**Suggested Points**: 200-300

**Author's note**: This challenge involves exploiting an SQL injection in the
game client. The user can pass arbitrary strings to the admin bot via the
song select packet. This can then side channel leak a bit of information based
on if the admin's client reports if the chart was found or not.

I will be hosting my own server for it most likely

**Flag**: `flag{even c++ is not safe from sqli :<<}`
