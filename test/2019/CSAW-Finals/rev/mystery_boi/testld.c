#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int __libc_start_main(int *(main)(int, char **, char **), int argc,
                      char **ubp_av, void (*init)(void), void (*fini)(void),
                      void (*rtld_fini)(void), void(*stack_end)) {
  FILE *f = fopen("./mystery_boi", "r");
  char c;
  c = fgetc(f);
  while (c != EOF) {
    printf("%x", c);
    c = fgetc(f);
  }

  fclose(f);
  return 0;
}
