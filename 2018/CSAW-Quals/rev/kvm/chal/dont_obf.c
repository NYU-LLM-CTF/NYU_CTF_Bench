#include "dont_obf.h"

char bits[10240];
char *bit_ptr = bits;
int bit_idx;

void bitstream_write(int i) {
  *bit_ptr = *bit_ptr | (i << bit_idx);
  bit_idx += 1;
  if (bit_idx == 8)
    bit_idx = 0;
  if (bit_idx == 0)
    bit_ptr++;
}
