#include "lib/mstdlib.h"

int load1(struct reg_t *reg) {
  long long volatile winstr = 0x000a6e6977756f79; // youwin\n
  write(stdout, &winstr, 7);
  close(reg->rf);
  return -1;
}
