# CTF Service Library #

This library is intended to provide a common set of functionality for writing
CTF binaries. This is defined as setting up a simple forking servier listening
on a port that spawns children executing a connection handler with privileges
dropped from root to some service-specific user. The primary goal is to be as
close as possible to Kenshoto, DDTEK, and Legitimate Business Syndicate's
typical implementation from the DEFCON CTF Finals as possible.

Typical usage of this library is to implement all service-specific
functionality in a separate location and link against a custom-compiled
libctf object on a per-service basis. This allows each service to specify
custom options (listening on IPv4 vs. IPv6, for example). As such, no Makefile
is provided.


## API ##

This library provides the following standard functions as its API:

```
int ctf_listen(const unsigned short port)
    Binds the service to a port and begins listening.

void ctf_loop(int fd, const char *user, int (*handler)(int))
    Accepts connections and forks off child processes to handle them.

void ctf_privdrop(const char *user)
    Drops privileges to chosen user.

int ctf_randfd(int fd)
    Randomizes a file descriptor.

ssize_t ctf_read(int fd, char *msg, size_t len)
    Reads message of chosen length and returns number of bytes read.

ssize_t ctf_readuntil(int fd, char *msg, size_t len, char sentinel)
    Reads until chosen length or sentinel and returns number of bytes read.

ssize_t ctf_write(int fd, char *msg)
    Writes a message and returns number of bytes written.

ssize_t ctf_writef(int fd, const char *msg, ...)
    Writes a formatted message and returns number of bytes written.

ssize_t ctf_recv(int sd, char *msg, size_t len)
    Receives message of chosen length and returns number of bytes received.

ssize_t ctf_recvuntil(int sd, char *msg, size_t len, char sentinel)
    Receives until chosen length or sentinel and returns number of bytes received.

ssize_t ctf_send(int sd, char *msg)
    Sends a message and returns number of bytes sent.

ssize_t ctf_sendf(int sd, const char *msg, ...)
    Sends a formatted message and returns number of bytes sent.
```


## Configuration ##

This library supports some compile-time options in the form of DEFINEs.
Supported DEFINES are:

```
-D_DEBUG
    Removes dropping privileges so it may be run as any user.
    Removes alarm so debugging isn't timed.

-D_IPV6
    Switches socket from IPV4 to IPV6.

-D_DUAL_STACK
    Allows service to listen on both IPV4 and IPV6.
    The above IPv6 DEFINE must also be set for dual stack mode to work.

-D_RAW
    Sets up a listening RAW socket (instead of TCP).

-D_SCTP
    Sets up a listening SCTP socket (instead of TCP).

-D_UDP
    Sets up a listening UDP socket (instead of TCP).

-D_CHROOT
    Additionally chroots into the service user's directory after changing to it.

-D_NORAND
    Do not randomize the socket descriptor.
```


## Usage ##

An example service.c implementing a basic CTF service using this library
looks something like the following:

```
#include "ctf.h"

const char *USER = "sample";            // user to drop privileges to
const unsigned short PORT = 65535;      // port to bind and listen on
int child_main(int fd) { return 0; }    // handler for incoming connections
int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    int sd;  // socket descriptor
    sd = ctf_listen(PORT);
    ctf_loop(sd, USER, child_main);
    return 0;
}
```

If you're using xinetd instead of binding and listening on a port yourself,
the example would instead look something like:

```
#include "ctf.h"

int child_main(int fd) { return 0; }    // handler for incoming connections
int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    setvbuf(stdout, NULL, _IONBF, 0);
    child_main(fileno(stdout));
    return 0;
}
```

The only thing you'll really be using this library for is for the read/send
functions.


## Roadmap ##

The following is a list of features that have yet to be added and/or tested:

* Need to test SCTP codepaths.
* Haven't actually compiled on FreeBSD.
* Haven't compiled to anything other than x86/x86-64.
* Need to bind to/re-implement for other languages like C++.
* Need to implement DDTEK's backdoor stuff from DEFCON CTF Finals 19 and 20.
* Should probably support binding on TCP and UDP ports at the same time.
