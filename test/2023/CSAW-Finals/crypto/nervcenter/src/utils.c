#include <stdio.h>
#include <stdlib.h>
#include <poll.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>

#include "image.h"
#include "utils.h"

int sendimg(int fd, const char *path, int delay) {
    unsigned char *imgbuf;
    size_t imglen;
    if (get_image(path, &imgbuf, &imglen) == -1) {
        printf("[!] Failed to load image: %s\n", path);
        return -1;
    }
    // Read the buffer line by line and send it
    unsigned char *ptr = imgbuf;
    unsigned char *end = ptr + imglen;
    while (ptr < end) {
        size_t len = 0;
        // get the length of the line
        while (ptr+len < end && ptr[len] != '\n') len++;
        if (ptr+len < end) len++; // include the newline
        write(fd, ptr, len);
        // advance the pointer past the line
        ptr += len;
#ifndef CHALDEBUG
        usleep(delay);
#endif
    }
    return 0;
}

int sendvid(int fd, const char *fullpath, float fps) {
    // frames start at 1
    int n_frames = 1;
    // Send clear screen and hide cursor commands
    dprintf(fd, "\033[H\033[2J\033[3J"); // clear screen
    dprintf(fd, "\033[?25l");            // hide cursor
    // Send the frames
    float frametime = 1.0 / fps;
    suseconds_t usec = frametime * 1000000;
    while (1) {
        // Time the call to sendimg to calculate correct delay
        struct timeval start, end;
        gettimeofday(&start, NULL);
        char path[256] = {0};
        snprintf(path, sizeof(path), "%s/frame_%08d.txt", fullpath, n_frames);
        if (sendimg(fd, path, 0) == -1) {
            break;
        }
        gettimeofday(&end, NULL);
        suseconds_t elapsed = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
        if (elapsed < usec) {
            usleep(usec - elapsed);
        }
        n_frames++;
    }
    // Send show cursor command
    dprintf(fd, "\033[?25h");     // show cursor
    // Reset the terminal
    dprintf(fd, "\033c");
    dprintf(fd, "\033[H\033[2J\033[3J");
    return n_frames - 1;
}

int read_block(int s, char *buffer, size_t size, int timeout) {
    // Poll any pending input with a short timeout
    struct pollfd pfd = { .fd = s, .events = POLLIN, };
    poll(&pfd, 1, timeout);
    if (pfd.revents & POLLIN) {
        return read(s, buffer, BUFFER_SIZE);
    }
    else {
        return 0;
    }
}

unsigned long increase_fd_limit(unsigned long maxfiles) {
    // Try to increase open file limit
    // If that fails, raise it as high as we can
    int r;
    struct rlimit rlim;
    r = getrlimit(RLIMIT_NOFILE, &rlim);
    if (r < 0) {
        perror("getrlimit");
        return -1;
    }

    rlim.rlim_cur = maxfiles;
    r = setrlimit(RLIMIT_NOFILE, &rlim);
    if (r < 0) {
        printf("[-] Failed to raise max files to preferred %lu\n", maxfiles);
        rlim.rlim_cur = rlim.rlim_max;
        r = setrlimit(RLIMIT_NOFILE, &rlim);
        if (r < 0) {
            perror("setrlimit");
            return -1;
        }
        else {
            printf("[+] Raised max files to %lu\n", rlim.rlim_cur);
        }
    }
    return rlim.rlim_cur;
}
