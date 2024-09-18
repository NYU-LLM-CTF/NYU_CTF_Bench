
#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"
#include "lib/mstring.h"

int load1(struct reg_t *reg) {
  /*  */
  if (reg->r[CHECKER_REG] == 0) {
    if (reg->r[POP_REG] == '}') {
      reg->r[GROUP_MATCH_REG] = 19;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3631696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 1) {
    if (reg->r[POP_REG] == 'y') {
      reg->r[GROUP_MATCH_REG] = 18;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3631696f62);
  }
  /*  */

  reg->r[CHECKER_REG] = 0;
  reg->r[GROUP_REG]++;
  RETURN_ENCODED(reg);
}