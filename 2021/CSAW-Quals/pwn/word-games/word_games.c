#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

struct node {
  struct node* next;
  struct node* prev;
  char* str;
};

struct LL {
  struct node* head;
  char* fav;
};

struct LL* mine;
struct node* yours;
char fun[3] = "fun";
int quota = 0;

void clear_stdin(void)
{
    char x = 0;
    while(1)
    {
        x = getchar();
        if(x == '\n' || x == EOF)
            break;
    }
}

unsigned int get_unum(void)
{
    unsigned int res = 0;
    fflush(stdout);
    scanf("%u", &res);
    clear_stdin();
    return res;
}

struct node* get_tail(struct node* h) {
  while (h->next != NULL) {
    h = h->next;
  } 
  return h;
}

char* add_to_list(struct node* head, char* str, int copy) {
  struct node* tail = get_tail(head);
  struct node* new_node = malloc(sizeof(struct node));
  tail->next = new_node;
  new_node->prev = tail;
  new_node->next = NULL;
  if (copy) {
    int len = strlen(str); 
    new_node->str = strdup(str);
  }
  else {
    new_node->str = str;
  }
  return new_node->str;
}

char* get_input() {
  char* in = NULL;
  printf("How long is your word? > ");
  int len = get_unum();
  if ((in = malloc(len)) == NULL) {
    exit(0);
  }
  printf("What is your word? > ");
  read(0, in, len);
  in[strcspn(in, "\n")] = '\0';
  add_to_list(yours, in, 0);
  return in;
}

void copy() {
  char* new_word;
  new_word = add_to_list(mine->head, get_tail(yours->next)->str, 1);
  if (mine->fav == NULL || (strlen(new_word) > strlen(mine->fav))) {
    printf("In fact, that's my favorite word so far!\n");
    if (mine->fav) free(mine->fav);
    mine->fav = strdup(new_word);
  }
  quota++;
}

void delete_list(struct node* head) {
  struct node* tail = get_tail(head);
  struct node* tmp;
  while (tail->prev != NULL) {
    tmp = tail;
    tail = tail->prev;
    if (tmp->str) free(tmp->str);
    if (tmp != head) free(tmp);
  } 
  if (head == yours) {
    yours->next = NULL;
  }
  else {
    if (mine)       free(mine);
    if (mine->fav)  free(mine->fav);
    mine->head = NULL;
  }
}

char* check_input(char* str) {
  if (strstr(str, fun) != NULL) {
    if (mine->head) {
      printf("\nWhat a fun word, I'm copying that to my list!\n");
      copy();
    }
    else {
      printf("\nThat's another fun word, but I already have enough of those\n");
    }
  }
  else {
    printf("\nNah, I don't like that word. You keep it in your list\n");
  }
}

void menu() {
  printf(" \
  1. Suggest word\n \
  2. Scrap your list\n \
  3. Hear my favorite word so far\n \
  4. Leave\n \
  > ");
}

void fav_word() {
  if (mine->fav == NULL) {
    printf("I don't have a favorite word yet. Give me some more words!\n");
  }
  else {
    printf("My favorite word so far is: %s\n", mine->fav);
  }
}

void init_structs() {
  mine = malloc(sizeof(struct LL));
  yours = malloc(sizeof(struct node));
  mine->head = malloc(sizeof(struct node));
  mine->head->next = NULL;
  mine->head->prev = NULL;
  mine->head->str = NULL;
  mine->fav = NULL;
  yours->next = NULL;
  yours->prev = NULL;
  yours->str = NULL;
}

int main() {
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stdin,  NULL, _IONBF, 0);
  init_structs();
  
  printf("Hi! I need your help. I'm writing a paper and I need some fun words to add to it.\n");
  printf("Can you give me some words??\n");

  int choice;
  char* in_str = NULL;

  while (1) {
    menu();
    choice = get_unum();
    if (choice == 1) {
      in_str = get_input();
      check_input(in_str);
      printf("Do you have any more words for me?\n");
    } 
    else if (choice == 2) {
      delete_list(yours);
      printf("Done! Do you have any more words for me?\n");
    }
    else if (choice == 3) {
      fav_word();
      printf("Do you have any more words for me?\n");
    }
    else {
      printf("Fine! I'll find someone else to help.\n");
      exit(0);
    }
    if (quota >= 4) {
      delete_list(mine->head);
      printf("You have given me so many words! I am going to store this list in a safe place.\n");
      printf("Can you give me a couple of your favorite words?\n");
      quota = -1;
    }
  }

  return 0;
}