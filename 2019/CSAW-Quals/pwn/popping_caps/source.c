#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

typedef unsigned long long uint64_t;

long read_num() {
  char buf[0x20];
  fgets(buf, 0x20, stdin);


  return atol(buf);
}

void bye() {
  fprintf(stdout, "Bye!");
  malloc(0x38);
  exit(0);
}

int main() {
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin, NULL, _IONBF, 0);
  setvbuf(stderr, NULL, _IONBF, 0);

  printf("Here is system %p\n", &system);

  uint64_t num_coins = 7;

  char* free_reference = 0;
  char* read_reference = 0;

  while (num_coins) {
    printf("You have %llu caps!\n", num_coins--);

    puts("[1] Malloc");
    puts("[2] Free");
    puts("[3] Write");
    puts("[4] Bye");

    puts("Your choice: ");
    uint64_t choice = read_num();

    switch(choice) {
    case 1:
      puts("How many: ");
      read_reference = free_reference = malloc(read_num());
      break;
    case 2:
      puts("Whats in a free: ");
      void* ptr = &free_reference[read_num()];
      free(ptr);
      if (free_reference == read_reference) {
        read_reference = NULL;
      }
      break;
    case 3:
      puts("Read me in: ");
      read(0, read_reference, 0x8);
      break;
    case 4:
      bye();
    }
    puts("BANG!");
  }

  bye();
  return 0;
}