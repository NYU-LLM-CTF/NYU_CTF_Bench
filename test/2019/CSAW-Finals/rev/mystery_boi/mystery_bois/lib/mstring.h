#pragma once
#include "mstdlib.h"

#define strlen(buf)                                                            \
  ({                                                                           \
    size_t len = 0;                                                            \
    do {                                                                       \
      while (buf[len] != 0)                                                    \
        len++;                                                                 \
    } while (0);                                                               \
    len;                                                                       \
  })

#define print(buf, len)                                                        \
  for (size_t i = 0; i < len; i++) {                                           \
    write(stdout, *(buf++), 1);                                                \
  }

#define fgets(str, num, stream)                                                \
  ({                                                                           \
    int len = read(stdin, str, num);                                           \
    str[len + 1] = '\0';                                                       \
    len;                                                                       \
  })
