#pragma once
#define O_RDONLY 0x0000
#define O_WRONLY 0x0001
#define O_RDWR 0x0002
#define O_ACCMODE 0x0003

#define O_BINARY 0x0004    /* must fit in char, reserved by dos */
#define O_TEXT 0x0008      /* must fit in char, reserved by dos */
#define O_NOINHERIT 0x0080 /* DOS-specific */

#define O_CREAT 0x0100 /* second byte, away from DOS bits */
#define O_EXCL 0x0200
#define O_NOCTTY 0x0400
#define O_TRUNC 0x0800
#define O_APPEND 0x1000
#define O_NONBLOCK 0x2000

#define stdin 0
#define stdout 1
#define stderr 2
