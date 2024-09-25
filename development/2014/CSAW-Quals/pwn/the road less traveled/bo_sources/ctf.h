/*
 * ctf.h | CTF Library (Header File)
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

#ifdef __cplusplus
extern "C" {
#endif

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
#include <ifaddrs.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip6.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#ifdef _SCTP
#include <netinet/sctp.h>
#endif


/* Service Setup Functions */
int ctf_listen(const unsigned short, const int, const char *);
void ctf_server(int, int (*handler)(int));
void ctf_privdrop(const char *);
int ctf_randfd(int);


/* Socket Communication Wrappers */
int ctf_readn(const int, char *, const unsigned int);
int ctf_readsn(const int, char *, const unsigned int);
int ctf_writes(const int, const char *);
int ctf_writen(const int, const char *, const unsigned int);
int ctf_writef(const int, const char *, ...);

#endif

#ifdef __cplusplus
}
#endif
