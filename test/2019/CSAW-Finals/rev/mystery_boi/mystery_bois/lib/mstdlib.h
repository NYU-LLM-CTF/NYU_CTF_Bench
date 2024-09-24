#ifndef _MSTDLIB
#define _MSTDLIB

#include "mruntime.h"
#include "mstdint.h"
#include "msyscall.h"
#include "open.h"

#define exit()                                                                 \
  ({                                                                           \
    __asm__ __volatile__("xor %%rdi, %%rdi;"                                   \
                         "syscall;" ::"a"(SYS_exit));                          \
  })

#define open(pathname, flags, mode)                                            \
  ({                                                                           \
    int volatile ret;                                                          \
    do {                                                                       \
      __asm__ __volatile__("syscall"                                           \
                           : "=a"(ret)                                         \
                           : "a"(SYS_open), "D"((long)pathname),               \
                             "S"((long)flags), "d"((long)mode)                 \
                           : "rcx");                                           \
    } while (0);                                                               \
    ret;                                                                       \
  })

#define close(fd)                                                              \
  ({                                                                           \
    int volatile ret;                                                          \
    do {                                                                       \
      __asm__ __volatile__("syscall"                                           \
                           : "=a"(ret)                                         \
                           : "a"(SYS_close), "D"((long)fd));                   \
    } while (0);                                                               \
    ret;                                                                       \
  })

#define read(fd, buf, nbytes)                                                  \
  ({                                                                           \
    int volatile ret;                                                          \
    do {                                                                       \
      __asm__ __volatile__("syscall"                                           \
                           : "=a"(ret)                                         \
                           : "a"(SYS_read), "D"((long)fd), "S"((long)buf),     \
                             "d"((long)nbytes)                                 \
                           : "rcx");                                           \
    } while (0);                                                               \
    ret;                                                                       \
  })

#define write(fd, buf, nbytes)                                                 \
  ({                                                                           \
    int volatile ret;                                                          \
    do {                                                                       \
      __asm__ __volatile__("syscall"                                           \
                           : "=a"(ret)                                         \
                           : "a"(SYS_write), "D"((long)fd), "S"((long)buf),    \
                             "d"((long)nbytes)                                 \
                           : "rcx");                                           \
    } while (0);                                                               \
    ret;                                                                       \
  })

#endif
