#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

const int NUM_STACKS = 0x100000;

void win() {
  system("/bin/sh");
}

int hide_needle() {
  srand((unsigned int)time(NULL));
  return rand() % NUM_STACKS;
}

void guess(int* haystacks) {
  int hidden_index = hide_needle();
  haystacks[hidden_index] = 0x1337;

  char stack_nbr[32] = {'\0'};
  int guess_num = 0;
  while (guess_num < 3) {
    fputs("Which haystack do you want to check?\n", stdout);
    fgets(stack_nbr, 32, stdin);
    int haystack = atoi(stack_nbr);

    if (haystack > (NUM_STACKS)) {
      fputs("I don't have that many haystacks!\n", stdout);
    } 
    else if (haystack == hidden_index) {
      printf("Hey you found a needle! And its number is 0x%08x! That's it!\n", haystacks[haystack]);
      win();
    } 
    else {
      printf("Hey, you found a needle, but it's number is 0x%08x. I don't like that one\n", haystacks[haystack]);
      if (guess_num == 0) 
        printf("Shoot, I forgot to tell you that I hid a needle in every stack. But I only have one favorite needle\n");
      else if (guess_num == 1) 
        printf("Did I mention I'm in a hurry? I need you to find it on your next guess\n");
      }
    if (guess_num == 2) {
      printf("I'm out of time. Thanks for trying...\n");
      return;
    }
    else {
      printf("Let's try again!\n");
    }
    guess_num++;
  }
}

void setup_haystacks()
{
  int haystacks[0x100000];
  
  for (int i = 0; i < NUM_STACKS; i++) {
    haystacks[i] = 0xb00;
  } 

  guess(haystacks);

  return;
}

int main(int argc, char **argv) {
  setvbuf(stdout, NULL, _IONBF, 0);
  printf("Help! I have lost my favorite needle in one of my 4096 identical haystacks!\n");
  printf("Unfortunately, I can't remember which one. Can you help me??\n");
  setup_haystacks();
  exit(0);
} 
