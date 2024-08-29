#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


int64_t get_number() {
    char buf[0x10];
    fgets(buf, sizeof(buf), stdin);
    return strtoul(buf, NULL, 10);
}

int main() {
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin, NULL, _IONBF, 0);

  puts("Here's stdout:");
  printf("%p\n", stdout);

  puts("How much do you want to write?");
  unsigned int num_bytes = get_number();
  if (num_bytes > 256) {
    puts("That's just too much");
    exit(-1);
  }

  puts("Where do you want to write?");
  void * addr = (void *) get_number();

  puts("What do you want to write?");
  read(0, addr, num_bytes);

  puts("Bye!");
  return 0;
}
