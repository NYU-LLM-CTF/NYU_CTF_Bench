/*
 * 		Name:		got_milk
 * 		Author:		Alan Cao
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <mylib.h>

int main(int argc, char **argv) {
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin, NULL, _IONBF, 0);
  setvbuf(stderr, NULL, _IONBF, 0);

  printf("Simulating loss...\n");
  lose();
  printf("Hey you! GOT milk? ");

  char input[BUF_SIZE];
  fgets(input, sizeof(input), stdin);

  printf("Your answer: ");
  printf(input);

  lose();
  return 0;
}
