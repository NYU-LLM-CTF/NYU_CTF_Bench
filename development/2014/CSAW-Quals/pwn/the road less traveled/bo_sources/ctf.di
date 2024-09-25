/*
 * ctf.di | CTF Library (Interface File)
 *
 * Copyright (c) 2013-2014 Alexander Taylor <ajtaylor@fuzyll.com>
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

module ctf;

extern (C) {

/* Service Setup Functions */
int ctf_listen(const ushort, const int, const char *);
void ctf_server(int, const char *, int function(int));
void ctf_privdrop(const char *);
int ctf_randfd(int);


/* File and Socket Communication Wrappers */
int ctf_readn(const int, char *, const uint);
int ctf_readsn(const int, char *, const uint);
int ctf_writes(const int, const char *);
int ctf_writen(const int, const char *, const uint);
int ctf_writef(const int, const char *, ...);

}
