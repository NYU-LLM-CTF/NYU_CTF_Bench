#include "flag-compress.h"
#include "huffman.h"
#include "dont_obf.h"
#include "obf.h"

static inline void outb(uint16_t port, uint8_t value)
    __attribute__((always_inline));
static inline char inb(uint16_t port) __attribute__((always_inline));

void print(char *str) {
  const char *p;
  for (p = str; *p; ++p)
    outb(0xE9, *p);
}

void recv(char *str, int len) {
  for (int i = 0; i < len; ++i)
    str[i] = inb(0xe9);
}

int memcmp(char *a, char *b, size_t len) {
  for (int i = 0; i < len; ++i)
    if (a[i] != b[i])
      return 1;
  return 0;
}

static inline void outb(uint16_t port, uint8_t value) {
  asm volatile("outb %0,%1"
               :
               /* empty */
               : "a"(value), "Nd"(port));
}

static inline char inb(uint16_t port) {
  char value;
  asm volatile("inb %1,%0" : "=a"(value) : "Nd"(port));
  return value;
}
void __attribute__((noreturn)) __attribute__((section(".start"))) _start(void) {
  char buff[10240];
  recv(buff, sizeof(buff));
  for (int i = 0; i < sizeof(buff); ++i) {
    if (!compress(buff[i], &HEAD_NODE)) {
      print("Wrong!\n");
      goto exit;
    }
  }
  if (memcmp(bits, (char *)flag_compress, flag_compress_len) == 0)
    print("Correct!\n");

exit:
  for (;;)
    asm("hlt" : /* empty */ : "a"(0) : "memory");
}
