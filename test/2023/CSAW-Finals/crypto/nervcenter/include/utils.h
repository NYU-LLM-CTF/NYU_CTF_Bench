#pragma once

#include <stddef.h>

int sendimg(int fd, const char *path, int delay);
int sendvid(int fd, const char *fullpath, float fps);
int read_block(int s, char *buffer, size_t size, int timeout);
unsigned long increase_fd_limit(unsigned long maxfiles);

#define BUFFER_SIZE 1024
