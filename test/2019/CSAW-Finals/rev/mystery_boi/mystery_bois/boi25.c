
#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"
#include "lib/mstring.h"

int load1(struct reg_t *reg) {
  /*  */
  if (reg->r[CHECKER_REG] == 0) {
    if (reg->r[POP_REG] == '_') {
      reg->r[GROUP_MATCH_REG] = 3;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3532696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 1) {
    if (reg->r[POP_REG] == 'v') {
      reg->r[GROUP_MATCH_REG] = 2;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3532696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 2) {
    if (reg->r[POP_REG] == '6') {
      reg->r[GROUP_MATCH_REG] = 1;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3532696f62);
  }
  /*  */

  reg->r[CHECKER_REG] = 0;
  reg->r[GROUP_REG]++;
  RETURN_ENCODED(reg);
}