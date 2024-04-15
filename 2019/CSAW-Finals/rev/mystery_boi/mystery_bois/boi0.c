#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"

int load1(struct reg_t *reg) {
  long long volatile failstr = 0x000a6c696166; // fail\n
  write(stdout, &failstr, 5);

  for (size_t i = 0; i < NUM_GPRS; i++) {
    reg->r[STATE_REG] = READ_INPUT;
  }

  for (size_t i = 0; i < READ_LEN; i++) {
    ((char *)reg->sp)[i] = 0;
  }

  RETURN_ENCODED(reg);
}
