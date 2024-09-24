#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

#define MAX_COOKIES 0x21
#define MAX_FORTUNE_ENTRIES 0xa

struct cookie_s {
  char fortune[0x68];
  unsigned int *next;
};

struct cookie_LL {
  struct cookie_s *prev, *next;
};

struct eightball {
  char* question;
  char response[0x20];
};

struct {
  char* sign;
  long curr_cookie_index;
  char* oracle_file;
  long oracle_file_lines;
  char* cookie_file;
  long cookie_file_lines;
  long num_8ball_fortunes;
  unsigned long* lucky_number;
  char* name;
} globals = {0, 0, "oracle.txt\0", 11, "cookies.txt\0", 52, 0, 0};

struct cookie_LL c[MAX_COOKIES];
struct eightball f[MAX_FORTUNE_ENTRIES];


void clear_stdin(void) {
  char x = 0;
  while(1) {
      x = getchar();
      if(x == '\n' || x == EOF)  break;
  }
}

unsigned long get_ulong(void)
{
  unsigned long res = 0;
  scanf("%lu", &res);
  clear_stdin();
  return res;
}

unsigned int get_unum(void)
{
  unsigned int res = 0;
  scanf("%u", &res);
  clear_stdin();
  return res;
}

char get_char(void)
{
  char res = 0;
  scanf("%c", &res);
  clear_stdin();
  return res;
}

unsigned char get_random_number(long max_len) {
  int rand_fd = open("/dev/urandom", O_RDONLY);
  if (rand_fd < 0) {
    printf(" Error opening server file, please contact a CSAW administrator\n");
    exit(1);
  }
  unsigned char rand_num;
  int r = read(rand_fd, &rand_num, 1);
  if (r != 1) {
    printf(" Error reading server file, please contact a CSAW administrator\n");
    exit(1);
  }
  close(rand_fd);
  return rand_num % max_len;
}

void sign() {
  printf(" Please enter your sign\n > ");
  if (globals.sign == NULL)
    globals.sign = calloc(1, 12);
  int index = read(0, globals.sign, 12);
  globals.sign[index - 1] = '\0';

  if (strcmp(globals.sign, "Aries") == 0)
    printf(" Baah! Your birthday is between: March 21 and April 19\n");
  else if (strcmp(globals.sign, "Taurus") == 0)
    printf(" Moo! Your birthday is between: April 20 and May 20\n");
  else if (strcmp(globals.sign, "Gemini") == 0)
    printf(" Nice! (nice!) Your birthday is between: May 21 and June 20\n");
  else if (strcmp(globals.sign, "Cancer") == 0)
    printf(" (Scuttle!) Your birthday is between: June 21 and July 22\n");
  else if (strcmp(globals.sign, "Leo") == 0)
    printf(" Rawr!  birthday is between: July 23 and August 22\n");
  else if (strcmp(globals.sign, "Virgo") == 0)
    printf(" Hooray! Your birthday is between: August 23 and September 22\n");
  else if (strcmp(globals.sign, "Libra") == 0)
    printf(" Meh. Your birthday is between: September 23 and October 22\n");
  else if (strcmp(globals.sign, "Scorpio") == 0)
    printf(" (Scuttle!) Your birthday is between: October 23 and November 21\n");
  else if (strcmp(globals.sign, "Sagittarius") == 0)
    printf(" Neigh! Your birthday is between: November 22 and December 21\n");
  else if (strcmp(globals.sign, "Capricorn") == 0)
    printf(" Baah! Your birthday is between: December 22 and January 19\n");
  else if (strcmp(globals.sign, "Aquarius") == 0)
    printf(" Splash! Your birthday is between: January 20 and February 18\n");
  else if (strcmp(globals.sign, "Pisces") == 0)
    printf(" Splash! Your birthday is between: February 19 and March 20\n");
  else 
    printf(" Unable to match choice, please try again\n");
}

void ask_8ball() {
  char* question = malloc(0x70);
  char resp[0x20];
  long sum = 0;
  strcpy(question, "Oh Magic 8 Ball, ");
  printf(" Ask a question to the magic 8 ball\n > ");
  read(0, question + 17, 0x70 - 17);
  question[0x6f] = '\0';
  char* q = question;
  while (*q != '\0') {
    sum += (int)*q;
    q++;
  }
  sum = sum % 15;
  switch (sum) {
  case 0:
    strcpy(resp, "It is certain\0");
    break;
  case 1:
    strcpy(resp, "Without a doubt\0");
    break;
  case 2:
    strcpy(resp, "Most likely\0");
    break;
  case 3:
    strcpy(resp, "Yes, definitely\0");
    break;
  case 4:
    strcpy(resp, "Yes\0");
    break;
  case 5:
    strcpy(resp, "Outlook good\0");
    break;
  case 6:
    strcpy(resp, "Reply hazy try again\0");
    break;
  case 7:
    strcpy(resp, "Better not tell you now\0");
    break;
  case 8:
    strcpy(resp, "Ask again later\0");
    break;
  case 9:
    strcpy(resp, "Cannot predict now\0");
    break;
  case 10:
    strcpy(resp, "Don’t count on it\0");
    break;
  case 11:
    strcpy(resp, "Outlook not so good\0");
    break;
  case 12:
    strcpy(resp, "My sources say no\0");
    break;
  case 13:
    strcpy(resp, "Very doubtful\0");
    break;
  case 14:
    strcpy(resp, "My reply is no\0");
    break;
  default:
    printf(" Error parsing your message, please try again\n");
    free(question);
    return;
  }

  printf(" The Magic 8 Ball says: %s\n", resp);
  printf(" Do you want to save this fortune? (%ld remaining) [Y/N]\n > ", (MAX_FORTUNE_ENTRIES - globals.num_8ball_fortunes));
  char r = get_char();
  if (r != 'Y') {
    free(question);
    return;
  }
  if (globals.num_8ball_fortunes < (MAX_FORTUNE_ENTRIES)) {
    f[globals.num_8ball_fortunes].question = question;
    strcpy(f[globals.num_8ball_fortunes].response, resp);
    globals.num_8ball_fortunes++;
  }
  else {
    printf(" No space remaining, please delete an entry before continuing\n");
  }
}

void get_random_line(unsigned char rand_num) {
  size_t pagesize = getpagesize();
  int scope_fd = open(globals.cookie_file, O_RDONLY);
  if (scope_fd == 0) {
    printf(" Error opening server file, please contact a CSAW administrator\n");
    exit(1);
  }
  char* buf = mmap(NULL, pagesize, PROT_WRITE | PROT_READ, MAP_PRIVATE, scope_fd, 0);
  if ((unsigned long)buf < (long)1) {
    printf(" Error reading server file, please contact a CSAW administrator\n");
    exit(1);
  }
  unsigned int r = strlen(buf);

  char* j = buf;
  char* k = j;

  // match random number with line number from file by iterating
  for (int i = 0; j < buf + r; i++) {
    k = strchr(j, '\n');
    if (i == rand_num) 
      break;
    j = k + 1;
  }
  *k = '\0';

  // alloc horoscope 
  struct cookie_s* cookie = calloc(1, sizeof(struct cookie_s));
  sprintf(cookie->fortune, "%s", j);
  printf(" Your fortune is: %s\n", cookie->fortune);

  c[globals.curr_cookie_index].next = cookie;
  if (globals.curr_cookie_index > 0)   c[globals.curr_cookie_index].prev = c[globals.curr_cookie_index-1].next;
  else                  c[globals.curr_cookie_index].prev = 0;
  cookie->next = (unsigned int *)&c[globals.curr_cookie_index++];
  munmap(buf, pagesize);
  close(scope_fd);
}

void delete_cookie() {
  printf(" You have no room to save any more fortunes. Please choose one to delete\n > ");
  unsigned int index;
  while(1) {
    index = get_unum();
    if (index > globals.curr_cookie_index) {
      printf(" Invalid choice, please choose again\n  ");
      continue;
    }
    break;
  }
  
  // check that linked list is not corrupted 
  if (c[index].next->next != (unsigned int *)&c[index] || 
    (index < (MAX_COOKIES - 1) && (c[index + 1].prev != c[index].next)) ||
    (index > 0 && (c[index - 1].next != c[index].prev)) || 
    (c[index].next == c[index].prev)) {
    printf(" Error: link list corruption detected\n");
    exit(1);
  }
  
  // update linked lists
  free(c[index++].next);
  for (; index < globals.curr_cookie_index; index++) {
    if (index != 0) {
      c[index].prev = c[index].next;
      c[index].next->next = (unsigned int *)&c[index - 1];
    }
    if (index != MAX_COOKIES - 1) {
      c[index].next = c[index + 1].next;
    }
    else {
      c[index].prev = 0;
      c[index].next = 0;
      globals.curr_cookie_index--;
    }
  }
}

void get_cookie() { 
  if (globals.curr_cookie_index == MAX_COOKIES) {
    delete_cookie();
    return;
  }
  
  unsigned char rand_num = get_random_number(globals.cookie_file_lines);
  get_random_line(rand_num);
}

void print_cookie_fortune() {
  printf(" Please enter a fortune index\n > ");
  unsigned int index = get_unum();
  if (index > globals.curr_cookie_index - 1) {
    printf(" Invalid index, please try again\n");
    return;
  }
  printf(" %s\n", c[index].next->fortune);
}

void print_8ball_fortune() {
  printf(" Please enter a fortune index\n > ");
  unsigned int index = get_unum();
  if (index > (MAX_FORTUNE_ENTRIES - 1)) {
    printf(" Invalid index, please try again\n");
    return;
  }
  else if (f[index].question == NULL) {
    printf(" You have not saved this fortune. Request another fortune!\n");
    return;
  }
  printf(" Your Question:       %s\n",   f[index].question);
  printf(" Magic 8 ball Answer: %s\n", f[index].response);
}

void delete_8ball_fortune() {
  if (globals.num_8ball_fortunes == 0) {
    printf(" No entries stored, go ask the Magic 8 Ball a question!\n");
    return;
  }
  globals.num_8ball_fortunes--;
  free(f[globals.num_8ball_fortunes].question);
  f[globals.num_8ball_fortunes].question = NULL;
  memset(f[globals.num_8ball_fortunes].response, 0, 0x20);
}

void oracle() {
  unsigned char rand_num = get_random_number(globals.oracle_file_lines);

  char* buf = malloc(0x390);
  char* j = buf;
  int fd = open(globals.oracle_file, O_RDONLY);
  if (fd == 0) {
    printf(" Error opening server file, please contact a CSAW administrator\n");
    exit(1);
  }
  int r = read(fd, buf, 0x1ef);
  if (r < 0) {
    printf(" Error reading server file, please contact a CSAW administrator\n");
    exit(1);
  }

  char* k = j;
  for (int i = 0; j < buf + r; i++) {
    k = strchr(j, '\n');
    if (i == rand_num) 
      break;
    j = k + 1;
  }
  *k = '\0';
  printf(" The oracle says: %s\n", j);

  free(buf);
  close(fd);
}

void store_lucky_num() {
  if (globals.lucky_number == NULL) {
    globals.lucky_number = calloc(1, 0x8);
    printf(" Please enter your lucky number\n > ");
    *globals.lucky_number = get_ulong();
    return;
  }
  printf(" Your lucky number is currently %lu. ", *globals.lucky_number);
  printf(" Would you like a new number? [Y/N]\n > ");
  char r = get_char();
  if (r == 'Y') {
    printf(" Please enter your new lucky number\n > ");
    read(0, globals.lucky_number, 8);
    return;
  }
  else {
    printf(" Would you like to delete your number? [Y/N]\n > ");
    char r = get_char();
    if (r == 'Y') {
      free(globals.lucky_number);
      globals.lucky_number = 0;
      printf(" Ok, your number is deleted\n");
      return;
    }
    printf(" Ok, your number is saved\n");
  }
  return;
}

void get_lucky_num() {
  int r = 0;
  if (globals.name == 0) {
    globals.name = calloc(1, 0x10);
    printf(" I will generate a personal lucky number for you!\n\n");
    printf(" First, I need some information from you!\n");
    printf(" Please enter your mother's maiden name followed by the last four digits of your social security number\n");
    printf("\n ...\n Just kidding!!\n");
    printf(" Please enter your name\n > ");
    r = read(0, globals.name, 0x10);
    globals.name[r - 1] = '\0';
  }
  char* q = globals.name;
  unsigned int sum = 0;
  while (*q != '\0') {
    sum += (int)*q;
    q++;
  }
  sum = sum % 100;
  printf(" %s, your lucky number is %d!\n Feel free to store it now!\n\n", globals.name, sum);
}

void menu() {
  printf("\n -----------------------------------------\n");
  printf(" Option 0: Query horoscope sign birthdates\n");
  printf(" Option 1: Ask the Magic 8 Ball a question\n");
  printf(" Option 2: Open a fortune cookie\n");
  printf(" Option 3: Read a saved 8 ball fortune\n");
  printf(" Option 4: Read a saved cookie fortune\n");
  printf(" Option 5: Delete a saved 8 ball fortune\n");
  printf(" Option 6: Visit the Oracle\n");
  printf(" Option 7: Get Lucky Number\n");
  printf(" Option 8: Save Lucky Number\n");
  printf(" Option 9: Exit\n > ");
}

int main() {
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin,  NULL, _IONBF, 0);

  printf("\n\nWelcome to the CSAW Oracle (v2.34)!!\n");
  printf("We offer all manners of predicting your future and fate!\n");
  printf("If you're lucky, that fate will include reading the ./flag.txt!!\n\n");
  while(1) {
    menu();
    unsigned int choice = get_unum();
    switch(choice) {
      case 0: 
        sign();
        break;
      case 1: 
        ask_8ball();
        break;
      case 2: 
        get_cookie();
        break;
      case 3: 
        print_8ball_fortune();
        break;
      case 4: 
        print_cookie_fortune();
        break;
      case 5: 
        delete_8ball_fortune();
        break;
      case 6: 
        oracle();
        break;
      case 7: 
        get_lucky_num();
        break;
      case 8: 
        store_lucky_num();
        break;
      case 9:
        exit(0);
      default:
        printf(" Error: please submit a valid choice\n");
    }
  }
}