#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"
#include "lib/mstring.h"

int loadl(struct reg_t *reg) {
  switch (reg->r[STATE_REG]) {
  case VERIFY_POP_CHAR:
    CALL_ENCODED(reg, BOI6_BIN);
    break;
  case VERIFY_CHAR:
    CALL_ENCODED(reg, BOI7_BIN);
    break;
  case PARSE_FINISH:
    JUMP_ENCODED(BOI1_BIN);
    break;
  case FAIL_VERIFY:
    JUMP_ENCODED(BOI0_BIN);
    break;
  }
  RETURN_ENCODED(reg);
}
