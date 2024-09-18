#pragma once
#include "lib/mruntime.h"
#include "lib/mstdlib.h"

#define BOIC_BIN 0x0063696f62
#define BOI9_BIN 0x0039696f62
#define BOI8_BIN 0x0038696f62
#define BOI7_BIN 0x0037696f62
#define BOI6_BIN 0x0036696f62
#define BOI5_BIN 0x0035696f62
#define BOI4_BIN 0x0034696f62
#define BOI3_BIN 0x0033696f62
#define BOI2_BIN 0x0032696f62
#define BOI1_BIN 0x0031696f62
#define BOI0_BIN 0x0030696f62

enum state {
  READ_INPUT,
  VERIFY_LENGTH,
  VERIFY_VALUE,
  FAIL_RESET,
  VERIFY_POP_CHAR,
  VERIFY_CHAR,
  PARSE_FINISH,
  FAIL_VERIFY,
  GO_HOME,
  VERIFY_FOUND_KEY,
  CORRECT_CHECKER
};

enum assigned_regs {
  A1_REG,
  CHECKER_REG,
  FAIL_REG,
  LEN_REG,
  POP_REG,
  STATE_REG,
  GROUP_REG,
  GROUP_MATCH_REG,
  CHECKER_FOUND_REG

};

// flag{jk_there_was_no_mystery}
#define FLAG_LEN 30
#define READ_LEN 32

#define FAIL(reg)                                                              \
  { CALL_ENCODED(reg, BOI0_BIN) }

#define YOU_WIN(reg)                                                           \
  { CALL_ENCODED(reg, BOI1_BIN) }
