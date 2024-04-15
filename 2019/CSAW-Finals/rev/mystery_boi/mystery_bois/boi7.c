#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"

// Dispatches to verification functions per-character
int loadl(struct reg_t *reg) {
  switch (reg->r[STATE_REG]) {
  case VERIFY_CHAR:
    CALL_ENCODED(reg, BOI8_BIN);
    break;
  case VERIFY_FOUND_KEY:
    CALL_ENCODED(reg, BOI9_BIN);
    break;
  case CORRECT_CHECKER:
    reg->r[STATE_REG] = VERIFY_POP_CHAR;
    RETURN_ENCODED(reg);
    break;
  }

  RETURN_ENCODED(reg);
}
