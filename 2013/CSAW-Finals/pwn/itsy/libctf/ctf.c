/*
 * ctf.c | CTF Library (Source File)
 *
 * Copyright (c) 2011-2013 Alexander Taylor <ajtaylor@fuzyll.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#include "ctf.h"


/*
 * Binds the service to a port and begins listening.
 * Returns the file descriptor of the socket that's been bound.
 * Exits completely on failure.
 */
int ctf_listen(const unsigned short port)
{
    int sd;
    int optval = 1;
    sockaddr_t addr;

    /*
     * Rather than set up the sockaddr struct here, DDTEK does a getifaddrs()
     * on an ifaddrs struct, finds an entry matching a given interface like
     * "eth0" or "em1" and a given protocol version (AF_INET or AF_INET6), and
     * passes that struct to bind instead.
     *
     * I have not done this, which means you cannot bind two services to the
     * same port on different interfaces ("lo" and "eth0", for example). This
     * is interesting for screwing with people's throwing frameworks, but I
     * don't currently have a use for it (it also makes portability more
     * difficult).
     */

    // populate socket structure
#ifdef _IPV6
    addr.sin6_family = CTF_SOCK_DOMAIN;
    addr.sin6_port = htons(port);
    addr.sin6_addr = in6addr_any;
#else
    addr.sin_family = CTF_SOCK_DOMAIN;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
#endif

    // ignore children so they disappear instead of becoming zombies
    if (signal(SIGCHLD, SIG_IGN) == SIG_ERR) {
#ifdef _DEBUG
        errx(-1, "Unable to set SIGCHLD handler");
#else
        exit(-1);
#endif
    }

    // create socket
    sd = socket(CTF_SOCK_DOMAIN, CTF_SOCK_TYPE, CTF_SOCK_PROTO);
    if (sd == -1) {
#ifdef _DEBUG
        errx(-1, "Unable to create socket");
#else
        exit(-1);
#endif
    }

    // set socket reuse option
    if (setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(int)) == -1) {
#ifdef _DEBUG
        errx(-1, "Unable to set socket reuse option");
#else
        exit(-1);
#endif
    }

    // set socket dual stack option
#ifdef _IPV6
#ifdef _DUAL_STACK
    optval = 0;
#endif
    if (setsockopt(sd, IPPROTO_IPV6, IPV6_V6ONLY, &optval, sizeof(int)) == -1){
#ifdef _DEBUG
        errx(-1, "Unable to set socket dual stack option");
#else
        exit(-1);
#endif
    }
#endif

    // bind to socket
    if (bind(sd, (sockaddr_t *)&addr, sizeof(sockaddr_t)) == -1) {
#ifdef _DEBUG
        errx(-1, "Unable to bind socket");
#else
        exit(-1);
#endif
    }

    // listen for new connections
    if (listen(sd, 16) == -1) {
#ifdef _DEBUG
        errx(-1, "Unable to listen on socket");
#else
        exit(-1);
#endif
    }

    return sd;
}


/*
 * Accepts connections and forks off child processes to handle them.
 * Loops indefinitely and should never return.
 */
void ctf_loop(int sd, const char *user, int (*handler)(int))
{
#ifdef _DEBUG
    (void)user;
#endif
    int client;
    int status;
    pid_t pid;

    // start the connection loop
    while (true) {
        // accept a client connection
        client = accept(sd, NULL, NULL);
        if (client == -1) {
            continue;
        }

        // randomize socket descriptor
        /*
         * We randomize the socket descriptor here to make shellcoders
         * unable to hardcode it. This makes for more interesting exploits.
         */
#ifndef _NORAND
        client = ctf_randfd(client);
#endif

        // fork child process off to handle connection
        /*
         * We fork here before dropping privileges to the service's
         * user to prevent people from modifying the parent process in memory.
         */
        pid = fork();
        if (pid == -1) {
            continue;
        }

        // if we got a PID, we're the parent
        if (pid) {
            close(client);
        } else {
            /*
             * We only drop privileges and alarm the child process if we're
             * not compiled for debugging. In practice, these things typically
             * got binary patched out by service developers and testers anyway,
             * so this should save time.
             */
#ifndef _DEBUG
            ctf_privdrop(user);
#endif
            close(sd);
#ifndef _DEBUG
            alarm(16);
#endif
            status = handler(client);
            close(client);
            exit(status);
        }
    }
}


/*
 * Drops privileges from an administrative user to one specific to the service.
 * Exits completely on failure.
 */
void ctf_privdrop(const char *user)
{
    struct passwd *pwentry;

    // get passwd structure for the user
    pwentry = getpwnam(user);
    if (!pwentry) {
#ifdef _DEBUG
        errx(-1, "Unable to find user");
#else
        exit(-1);
#endif
    }

    /*
     * Here, we make the following checks:
     * 1. Remove ALL extra groups (prevents escalation via group associations)
     * 2. Set real, effective, and saved GID to that of the unprivileged user
     * 3. Set real, effective, and saved UID to that of the unprivileged user
     * 4. Optionally chroot to unprivileged user's home directory
     * 5. Change directory to user's home directory
     *
     * Unless someone mucks with their environment, these should prevent
     * payloads from being able to do nasty stuff to system files, temporary
     * files, and just straight-up escalating privileges.
     */
    if (setgroups(0, NULL) == -1 ||
        setgid(pwentry->pw_gid) == -1 ||
        setuid(pwentry->pw_uid) == -1 ||
#ifdef _CHROOT
        chroot(pwentry->pw_dir) == -1 ||
        chdir("/") == -1
#else
        chdir(pwentry->pw_dir) == -1
#endif
       ) {
#ifdef _DEBUG
        errx(-1, "Unable to drop privileges");
#else
        exit(-1);
#endif
    }
}


/*
 * Randomizes a given file descriptor.
 * Returns the newly randomized file descriptor.
 * Can never fail (falls back to rand() if /dev/urandom is unavailable).
 */
int ctf_randfd(int old)
{
    int max = getdtablesize();  // stay within operating system limits
    int fd = open("/dev/urandom", O_RDONLY);
    int new = 0;

    // randomize new file descriptor
    if (fd < 0) {
        while (new < old) {
            new = rand() % max;  // fall back to rand() if fd was invalid
        }
    } else {
        while (new < old) {
            read(fd, &new, 2);
            new %= max;
        }
        close(fd);
    }

    // duplicate the old file descriptor to the new one
    if (dup2(old, new) == -1) {
        new = old;  // if we failed, fall back to using the un-randomized fd
    } else {
        close(old);  // if we were successful, close the old fd
    }

    return new;
}


/*
 * Reads from a stream until given length is reached.
 * Returns number of bytes read.
 * Warns if it was unable to read entire message.
 */
ssize_t ctf_read(int fd, char *msg, size_t len)
{
    ssize_t bytes_read = 0;
    ssize_t bytes_left = len;

    if (len > 0) {
        // keep reading bytes until we've got the whole message
        while (bytes_left > 0) {
            bytes_read = read(fd, msg, bytes_left);
            if (bytes_read == -1) {
#ifdef _DEBUG
                warnx("Unable to read entire message");
#endif
                break;
            }
            bytes_left -= bytes_read;
        }
    }

    return len - bytes_left;
}


/*
 * Reads data from a stream until sentinel value or maximum length is reached.
 * Returns number of bytes read.
 * Warns if it was unable to read entire message.
 */
ssize_t ctf_readuntil(int fd, char *msg, size_t len, char stop)
{
    ssize_t bytes_read = 0;
    char buf;  // temporary buffer to hold each character read
    size_t i = 0;

    if (len > 0) {
        // read a char at a time until we hit sentinel or max length
        for (i = 0; i < len; i++) {
            // read character
            bytes_read = read(fd, &buf, 1);
            if (bytes_read == -1) {
#ifdef _DEBUG
                warnx("Unable to read entire message");
#endif
                break;
            }

            // add character to our message
            msg[i] = buf;

            // break loop if it was our sentinel
            if (buf == stop) {
                break;
            }
        }
    }

    return i;
}


/*
 * Writes a given message to a given stream.
 * Returns number of bytes written (-1 for failure).
 */
ssize_t ctf_write(int fd, char *msg)
{
    size_t len = strlen(msg);
    size_t i = 0;  // counter for total bytes written
    ssize_t wrote = 0;

    // write entire message (in chunks if we have to)
    while (i < len) {
        wrote = write(fd, msg + i, len - i);
        if (wrote < 1) {
#ifdef _DEBUG
            warnx("Unable to write entire message");
#endif
            return -1;
        }
        i += wrote;
    }

    return (ssize_t)i;
}


/*
 * Wrapper for ctf_write() to allow for formatted messages.
 */
ssize_t ctf_writef(int fd, const char *format, ...)
{
    va_list list;
    char *buf = NULL;  // temporary buffer to hold formatted string
    ssize_t status = 0;

    // format message and place it in our buffer
    va_start(list, format);
    status = vasprintf(&buf, format, list);
    va_end(list);
    if (status == -1) {
        goto end;
    }

    // write our message
    status = ctf_write(fd, buf);

end:
    free(buf);
    return status;
}


/*
 * Receives from a socket until given length is reached.
 * Returns number of bytes received.
 * Warns if it was unable to receive entire message.
 */
ssize_t ctf_recv(int sd, char *msg, size_t len)
{
    ssize_t bytes_recvd = 0;
    ssize_t bytes_left = len;

    if (len > 0) {
        // keep reading bytes until we've got the whole message
        while (bytes_left > 0) {
            bytes_recvd = recv(sd, msg, bytes_left, 0);
            if (bytes_recvd == -1) {
#ifdef _DEBUG
                warnx("Unable to receive entire message");
#endif
                break;
            }
            bytes_left -= bytes_recvd;
        }
    }

    return len - bytes_left;
}


/*
 * Receives data from a socket until sentinel value or maximum length is reached.
 * Returns number of bytes received.
 * Warns if it was unable to receive entire message.
 */
ssize_t ctf_recvuntil(int sd, char *msg, size_t len, char stop)
{
    ssize_t bytes_recvd = 0;
    char buf;  // temporary buffer to hold each received character
    size_t i = 0;

    if (len > 0) {
        // receive a char at a time until we hit sentinel or max length
        for (i = 0; i < len; i++) {
            // receive character
            bytes_recvd = recv(sd, &buf, 1, 0);
            if (bytes_recvd == -1) {
#ifdef _DEBUG
                warnx("Unable to receive entire message");
#endif
                break;
            }

            // add character to our received message
            msg[i] = buf;

            // break loop if it was our sentinel
            if (buf == stop) {
                break;
            }
        }
    }

    return i;
}


/*
 * Sends a given message through a given socket.
 * Returns number of bytes sent (-1 for failure).
 */
ssize_t ctf_send(int sd, char *msg)
{
    size_t len = strlen(msg);
    size_t i = 0;  // counter for total bytes sent
    ssize_t sent = 0;

    // send entire message (in chunks if we have to)
    while (i < len) {
        sent = send(sd, msg + i, len - i, 0);
        if (sent < 1) {
#ifdef _DEBUG
            warnx("Unable to send entire message");
#endif
            return -1;
        }
        i += sent;
    }

    return (ssize_t)i;
}


/*
 * Wrapper for ctf_send() to allow for formatted messages.
 */
ssize_t ctf_sendf(int sd, const char *format, ...)
{
    va_list list;
    char *buf = NULL;  // temporary buffer to hold formatted string
    ssize_t status = 0;

    // format message and place it in our buffer
    va_start(list, format);
    status = vasprintf(&buf, format, list);
    va_end(list);
    if (status == -1) {
        goto end;
    }

    // send our message
    status = ctf_send(sd, buf);

end:
    free(buf);
    return status;
}
