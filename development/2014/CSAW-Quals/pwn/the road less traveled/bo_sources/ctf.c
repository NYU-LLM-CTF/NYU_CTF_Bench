/*
 * ctf.c | CTF Library (Source File)
 *
 * Copyright (c) 2012-2014 Alexander Taylor <ajtaylor@fuzyll.com>
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
 * Binds a socket to a port and begins listening.
 * Defaults to listening on all interfaces if no interface is specified.
 * Returns the file descriptor of the socket that's been bound.
 * Exits completely on failure.
 */
int ctf_listen(const unsigned short port, const int proto, const char *iface)
{
#ifndef _IPV6
    const int domain = AF_INET;
    struct sockaddr_in addr;
#else
    const int domain = AF_INET6;
    struct sockaddr_in6 addr;
#endif
    struct ifaddrs *ifa;
    int sd = -1;
    int tmp;

    // ignore children so they disappear instead of becoming zombies
    if (signal(SIGCHLD, SIG_IGN) == SIG_ERR) {
        errx(-1, "Unable to set SIGCHLD handler");
    }

    // create socket
    if (proto == IPPROTO_RAW) {
        sd = socket(domain, SOCK_RAW, proto);
    } else if (proto == IPPROTO_SCTP) {
        sd = socket(domain, SOCK_SEQPACKET, proto);
    } else if (proto == IPPROTO_UDP) {
        sd = socket(domain, SOCK_DGRAM, proto);
    } else if (proto == IPPROTO_TCP) {
        sd = socket(domain, SOCK_STREAM, proto);
    }
    if (sd < 0) {
        errx(-1, "Unable to create socket");
    }

    // set socket reuse option
    tmp = 1;  // optval
    if (setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &tmp, sizeof(int)) == -1) {
        errx(-1, "Unable to set socket reuse option");
    }

    // bind to socket
    if (iface == NULL) {
        /*
         * If an interface hasn't been specified, we'll just bind on all
         * available interfaces by default.
         */
#ifndef _IPV6
        addr.sin_family = domain;
        addr.sin_port = htons(port);
        addr.sin_addr.s_addr = htonl(INADDR_ANY);
        if (bind(sd, (const struct sockaddr *)&addr, sizeof(struct sockaddr)) < 0) {
            errx(-1, "Unable to bind socket");
        }
#else
        addr.sin6_family = domain;
        addr.sin6_port = htons(port);
        addr.sin6_addr = in6addr_any;
        if (bind(sd, (const struct sockaddr *)&addr, sizeof(struct sockaddr_in6)) < 0) {
            errx(-1, "Unable to bind socket");
        }
#endif
    } else {
        /*
         * If an interface has been specified, we'll loop through the available
         * interfaces until we find it, and then try to bind on it. The
         * temporary value here will be set to the return value of bind() so
         * we know whether we were successful or not. It's negative by default
         * to catch the edge-case of not finding the specified interface.
         */
        tmp = -1;  // return value of bind()
        if (getifaddrs(&ifa) == 0) {
            for (struct ifaddrs *i = ifa; i; i = i->ifa_next) {
                if ((i->ifa_addr->sa_family == domain) && (strcmp(i->ifa_name, iface) == 0)) {
                    *(unsigned short *)i->ifa_addr->sa_data = htons(port);
#ifndef _IPV6
                    tmp = bind(sd, i->ifa_addr, sizeof(struct sockaddr));
                    break;
#else
                    tmp = bind(sd, i->ifa_addr, sizeof(struct sockaddr_in6));
                    break;
#endif
                }
            }
        }
        freeifaddrs(ifa);
        if (tmp != 0) {
            errx(-1, "Unable to bind socket");
        }
    }

    // listen for new connections
    if (proto != IPPROTO_UDP && proto != IPPROTO_RAW && listen(sd, 16) == -1) {
        errx(-1, "Unable to listen on socket");
    }

    return sd;
}


/*
 * Accepts connections and forks off child processes to handle them.
 * Parent loops indefinitely and should never return.
 * Children exit with the status of the handler function.
 */
void ctf_server(int sd, int (*handler)(int))
{
#ifdef _DEBUG
#endif
    int client;
    int status;
    pid_t pid;

    // seed the random number generator
#ifndef _NORAND
    srand(time(0));
#endif

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
#if !defined(_DEBUG) && !defined(_NORAND)
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
             * got patched out by service developers and testers in a hex editor
             * anyway, so this should save time.
             */
#ifndef _DEBUG
            alarm(16);
#endif
            close(sd);
            status = handler(client);
            close(client);
            exit(status);
        }
   }
}


/*
 * Drops privileges to one specific to the service.
 * Exits completely on failure.
 */
void ctf_privdrop(const char *user)
{
    struct passwd *pwentry;

    // get passwd structure for the user
    pwentry = getpwnam(user);
    if (!pwentry) {
        errx(-1, "Unable to find user");
    }

    /*
     * Unless someone mucks with their environment, these checks should prevent
     * payloads from being able to do nasty stuff to system files and temporary
     * files (or just straight-up escalating privileges).
     */

    // remove all extra groups (prevents escalation via group associations)
    if (setgroups(0, NULL) < 0) {
        errx(-1, "Unable to remove extra groups");
    }

    // set real, effective, and saved GID to that of the unprivileged user
    if (setgid(pwentry->pw_gid) < 0) {
        errx(-1, "Unable to change GID");
    }

    // set real, effective, and saved UID to that of the unprivileged user
    if (setuid(pwentry->pw_uid) < 0) {
        errx(-1, "Unable to change UID");
    }

    // change directory (optionally chroot into the unprivileged user's home directory)
#ifdef _CHROOT
    if (chroot(pwentry->pw_dir) < 0 || chdir("/") < 0) {
#else
    if (chdir(pwentry->pw_dir) < 0) {
#endif
        errx(-1, "Unable to change current directory");
    }
}


/*
 * Randomizes a given file descriptor.
 * Returns the newly randomized file descriptor.
 * Can never fail (falls back to rand() or the original file descriptor).
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
 * Reads from a file descriptor until given length is reached.
 * Returns number of bytes received.
 */
int ctf_readn(const int fd, char *msg, const unsigned int len)
{
    int prev = 0;  // previous amount of bytes we read
    unsigned int count = 0;

    if ((fd >= 0) && msg && len) {
        // keep reading bytes until we've got the whole message
        for (count = 0; count < len; count += prev) {
            prev = read(fd, msg + count, len - count);
            if (prev <= 0) {
#ifdef _DEBUG
                warnx("Unable to read entire message");
#endif
                break;
            }
        }
    }

    return count;
}


/*
 * Reads from a file descriptor until a newline or maximum length is reached.
 * Returns number of bytes read, including the newline (which is now NULL).
 */
int ctf_readsn(const int fd, char *msg, const unsigned int len)
{
    unsigned int count = 0;
    char tmp;  // temporary storage for each character read

    if ((fd >= 0) && msg && len) {
        for (count = 0; count < len; count++) {
            // read character
            if (read(fd, &tmp, 1) <= 0) {
#ifdef _DEBUG
                warnx("Unable to read entire message");
#endif
                break;
            }

            // break loop if we received a newline
            if (tmp == '\n') {
                msg[count] = '\0';
                break;
            }

            // add character to our message
            msg[count] = tmp;
        }
    }

    return count;
}


/*
 * Wrapper for ctf_writen() that does strlen() for you.
 * Returns number of bytes written (or <= 0 for failure).
 */
int ctf_writes(const int fd, const char *msg)
{
    return ctf_writen(fd, msg, strlen(msg));
}


/*
 * Writes a given message of a given length to a given file descriptor.
 * Returns number of bytes written (or <= 0 for failure).
 */
int ctf_writen(const int fd, const char *msg, const unsigned int len)
{
    int prev = 0;  // previous amount of bytes we wrote
    unsigned int count = 0;

    // write entire message (in chunks if we have to)
    if ((fd >= 0) && msg && len) {
        for (count = 0; count < len; count += prev) {
            prev = write(fd, msg + count, len - count);
            if (prev <= 0) {
#ifdef _DEBUG
                warnx("Unable to write entire message");
#endif
                return prev;
            }
        }
    }

    return count;
}


/*
 * Wrapper for ctf_writen() to allow for formatted messages.
 */
int ctf_writef(const int fd, const char *format, ...)
{
    va_list list;
    char *buf = NULL;  // temporary buffer to hold formatted string
    int status = 0;

    // format message and place it in our buffer
    va_start(list, format);
    status = vasprintf(&buf, format, list);
    va_end(list);
    if (status < 0) {
        goto end;
    }

    // write our message
    status = ctf_writen(fd, buf, strlen(buf));

end:
    free(buf);
    return status;
}
