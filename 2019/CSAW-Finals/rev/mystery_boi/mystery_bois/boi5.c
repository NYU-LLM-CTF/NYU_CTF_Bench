#include "chal.h"
#include "lib/mruntime.h"
#include "lib/mstdlib.h"
#include "lib/mstring.h"

/* Checks length of flag entered */
int loadl(struct reg_t *reg) {
  char *str = (char *)reg->sp;

  if (strlen(str) != FLAG_LEN) {
    reg->r[STATE_REG] = FAIL_RESET;
    RETURN_ENCODED(reg);
  }

  reg->r[STATE_REG] = VERIFY_VALUE;
  RETURN_ENCODED(reg);
}
