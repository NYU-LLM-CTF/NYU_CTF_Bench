/*
 * ctf.h | CTF Library (Header File)
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

#ifndef __CTF_H__
#define __CTF_H__

/* Standard Libraries */
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdarg.h>
#include <string.h>
#include <time.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <pwd.h>
#include <grp.h>
#include <err.h>

#ifdef _DEBUG
#include <assert.h>
#endif


/* Networking Libraries */
#include <sys/socket.h>
#include <netinet/in.h>

#ifdef _IPV6
#include <netinet/ip6.h>
#define CTF_SOCK_DOMAIN AF_INET6
#define sockaddr_t struct sockaddr_in6
#else
#include <netinet/ip.h>
#define CTF_SOCK_DOMAIN AF_INET
#define sockaddr_t struct sockaddr_in
#endif

#ifdef _RAW
#define CTF_SOCK_TYPE SOCK_RAW
#define CTF_SOCK_PROTO IPPROTO_RAW
#elif _SCTP
#include <netinet/sctp.h>
#define CTF_SOCK_TYPE SOCK_SEQPACKET
#define CTF_SOCK_PROTO IPPROTO_SCTP
#elif _UDP
#include <netinet/udp.h>
#define CTF_SOCK_TYPE SOCK_DGRAM
#define CTF_SOCK_PROTO IPPROTO_UDP
#else
#include <netinet/tcp.h>
#define CTF_SOCK_TYPE SOCK_STREAM
#define CTF_SOCK_PROTO IPPROTO_TCP
#endif


/* Service Setup Functions */
int ctf_listen(unsigned short);
void ctf_loop(int, const char *, int (*handler)(int));
void ctf_privdrop(const char *);
int ctf_randfd(int);


/* File and Socket Communication Wrappers */
ssize_t ctf_read(int, char *, size_t);
ssize_t ctf_readuntil(int, char *, size_t, char);
ssize_t ctf_write(int, char *);
ssize_t ctf_writef(int, const char *, ...);
ssize_t ctf_recv(int, char *, size_t);
ssize_t ctf_recvuntil(int, char *, size_t, char);
ssize_t ctf_send(int, char *);
ssize_t ctf_sendf(int, const char *, ...);


#endif
