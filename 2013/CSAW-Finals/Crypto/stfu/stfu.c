/*
 * stfu.c | Secure Text File Unit
 *          A CSAW 2013 Final Round Reverse Engineering Challenge
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

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <err.h>
#include "lfsr.h"

#define SWAP(x) (((x) >> 24) | (((x) & 0x00FF0000) >> 8) | (((x) & 0x0000FF00) << 8) | ((x) << 24))

bool encode(FILE *ifd, FILE *ofd)
{
    char buf[4];	        // input buffer
    unsigned int num;		// current random number

    // write file magic
    if (!fwrite("STFU", 4, 1, ofd)) {
    	return false;
    }

    // initialize linear feedback shift register
    num = SWAP(rand());
    if (!fwrite(&num, 4, 1, ofd) || !fwrite("\x20\x1F\x1E\x0A", 4, 1, ofd)) {
    	return false;
    }
    lfsr.init(SWAP(num), 32, 31, 30, 10);  // x^32 + x^31 + x^30 + x^10 + 1 is maximal-length

    // skip a random number of places into the sequence
    num = SWAP(rand() & 0xFFFF);
    if (!fwrite(&num, 4, 1, ofd)) {
    	return false;
    }
    for(num = SWAP(num); num > 0; num--) {
    	lfsr.next();
    }

    // encode the file
    while ((buf[0] = fgetc(ifd)) != EOF) {
    	// advance the linear feedback shift register state
    	num = lfsr.next();

    	// catch all the edge cases where we don't have 4 entire bytes left in the input file
    	if ((buf[1] = fgetc(ifd)) == EOF) {
    		num = num ^ *(int *)buf;
    		if (!fwrite(&num, 1, 1, ofd)) {
    			return false;
    		}
    		return true;
    	} else if ((buf[2] = fgetc(ifd)) == EOF) {
    		num = num ^ *(int *)buf;
    		if (!fwrite(&num, 2, 1, ofd)) {
    			return false;
    		}
    		return true;
    	} else if ((buf[3] = fgetc(ifd)) == EOF) {
    		num = num ^ *(int *)buf;
    		if (!fwrite(&num, 3, 1, ofd)) {
    			return false;
    		}
    		return true;
    	}

    	// if we have 4 entire bytes, encode them normally
    	num = num ^ *(int *)buf;
    	if (!fwrite(&num, 4, 1, ofd)) {
    		return false;
    	}
    }

    return true;
}


int main(int argc, char **argv)
{
    FILE *ifd = NULL;       // input file descriptor
    FILE *ofd = NULL;		// output file descriptor
    char *ifname = NULL;    // input filename
    char *ofname = NULL;    // output filename

    // display usage
    if (argc <= 1) {
        printf("Usage: %s <FILE>\n", argv[0]);
        exit(EXIT_SUCCESS);
    }

    // initialize random number generator
    srand(time(0));

    // open input file
    ifname = argv[1];
    ifd = fopen(ifname, "rb");
    if (!ifd) {
        errx(EXIT_FAILURE, "Could not open input file for reading");
    }

    // open output file
    ofname = (char *)calloc(strlen(ifname) + 5, sizeof(char));
    if (strstr(ifname, ".") == NULL) {
    	strncpy(ofname, ifname, strlen(ifname));
    } else {
    	strncpy(ofname, ifname, strstr(ifname, ".") - ifname);
    }
    strcat(ofname, ".stfu");
    ofd = fopen(ofname, "wb");
    if (!ofd) {
    	errx(EXIT_FAILURE, "Could not open output file for writing");
    }

    // encode the file, then clean up
    if (!encode(ifd, ofd)) {
    	// delete the output file
    	free(ofname);
    	fclose(ifd);
    	fclose(ofd);
    	errx(EXIT_FAILURE, "Could not encode entire file");
    }
    free(ofname);
    fclose(ifd);
    fclose(ofd);

    return EXIT_SUCCESS;
}
