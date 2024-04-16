/*
 * itsy | Binary Planting Service
 *
 * Copyright (c) 2013 Alexander Taylor <ajtaylor@fuzyll.com>
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
#include <sys/stat.h>

#define BUFSIZE 80

const char *USER = "itsy";
const unsigned short PORT = 11586;  // Roud Folk Song Index # of Itsy, Bitsy Spider
const char *MAGIC = "\177ELF";  // ELF magic
static int SOCKET = 0;  // socket descriptor (because you can't pass arguments to a signal handler)


/*
 * Alarm handler.
 */
 void alarm_handler()
 {
    ctf_send(SOCKET, "Down came the rain and washed the spider out\n");
    exit(0);
 }


/*
 * Connection handler.
 */
int child_main(int sd)
{
    char input[BUFSIZE];
    char *filepath = strdup("/tmp/itsy-XXXXXX");
    int tmpfd = 0;

    // set up alarm
#ifndef _DEBUG
    signal(SIGALRM, (sighandler_t)alarm_handler);
#endif

    // get ELF file from the user
    ctf_send(sd, "The itsy, bitsy spider went up the water spout\n");
    ctf_recv(sd, input, BUFSIZE);

    // do some simple validation of the input
    ctf_send(sd, "Down came the rain, and washed the spider out\n");
    if (input[0] != MAGIC[0] && input[1] != MAGIC[1] && input[2] != MAGIC[2] && input[3] != MAGIC[3]) {
        return 0;
    }

    // save it to a temporary file
    ctf_send(sd, "Out came the sun, and dried up all the rain\n");
    tmpfd = mkstemp(filepath);
#ifdef _DEBUG
    warnx("Temporary file %s created", filepath);
#endif
    if (write(tmpfd, input, BUFSIZE) == -1) {
        close(tmpfd);
        return 0;
    }
    close(tmpfd);

    // execute it
	
    ctf_send(sd, "And the itsy, bitsy spider went up the spout again\n");
    chmod(filepath, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP);
	//dup2(sd,1);
	//dup2(sd,0);
    execv(filepath, NULL);
#ifndef _DEBUG
    //unlink(filepath);
#endif

    return 0;
}


/*
 * Main function.
 */
int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;

#ifdef _DEBUG
    warnx("Service was compiled with debug support");
#endif

    // initialize the random number generator
    srand(time(0));

    // listen for new connections and spawn children to handle them
    SOCKET = ctf_listen(PORT);
    ctf_loop(SOCKET, USER, child_main);

    return 0;
}

