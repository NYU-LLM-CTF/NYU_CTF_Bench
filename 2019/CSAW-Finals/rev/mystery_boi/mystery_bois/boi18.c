
#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"
#include "lib/mstring.h"

int load1(struct reg_t *reg) {
  /*  */
  if (reg->r[CHECKER_REG] == 0) {
    if (reg->r[POP_REG] == 'n') {
      reg->r[GROUP_MATCH_REG] = 33;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3831696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 1) {
    if (reg->r[POP_REG] == 'c') {
      reg->r[GROUP_MATCH_REG] = 34;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3831696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 2) {
    if (reg->r[POP_REG] == 'f') {
      reg->r[GROUP_MATCH_REG] = 35;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3831696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 3) {
    if (reg->r[POP_REG] == 'o') {
      reg->r[GROUP_MATCH_REG] = 36;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3831696f62);
  }
  /*  */
  if (reg->r[CHECKER_REG] == 4) {
    if (reg->r[POP_REG] == 'd') {
      reg->r[GROUP_MATCH_REG] = 37;
      reg->r[STATE_REG] = VERIFY_FOUND_KEY;
      RETURN_ENCODED(reg);
    }
    reg->r[CHECKER_REG]++;
    JUMP_ENCODED(0x3831696f62);
  }
  /*  */

  reg->r[CHECKER_REG] = 0;
  reg->r[GROUP_REG]++;
  RETURN_ENCODED(reg);
}