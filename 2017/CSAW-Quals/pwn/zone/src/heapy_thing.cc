#include <stdlib.h>
#include <string.h>
#include <stack>
#include <unistd.h>
#include "environment.h"
#include "zone.h"

int PrintMenu();
void* AllocBlock(Environment* env, size_t size);

int main(void) {
  setvbuf(stdout, NULL, _IONBF, 0);
  Environment env;
  printf("Environment setup: %p\n", &env);
  std::stack<unsigned char*> blocks;
  std::stack<size_t> sizes;
 
  int choice = 0;
  unsigned char* tmp = nullptr;
  size_t tmp_size = 0;
  do {
    choice = PrintMenu();
    switch (choice) {
      case 1: {
          scanf("%lu", &tmp_size);
          tmp = reinterpret_cast<unsigned char*>(AllocBlock(&env, tmp_size));
          if (tmp) {
            blocks.push(tmp);
            sizes.push(tmp_size);
          }
      } break;
      case 2: {
        if (blocks.size() > 0) {
          tmp = blocks.top();
          ZoneFree(&env, tmp);
          blocks.pop();
          sizes.pop();
        } 
      } break;
      case 3: {
        if (blocks.size() > 0) {
          char c = '\x00';
          int len = 0;
          tmp = blocks.top();
          tmp_size = sizes.top();
          for (size_t i = 0; i <= tmp_size; ++i) {
            len = read(STDIN_FILENO, &c, 1);
            if (len == -1) {
              exit(-1);
            } else if (c == '\n') {
              break;
            } else {
              *tmp = c;
              tmp++;
            }
          }
        } else {
          puts("No blocks");
        }
      } break;
      case 4: {
        if (blocks.size() > 0) {
          tmp = blocks.top();
          tmp_size = sizes.top();
          printf("%s\n", tmp);
        }
      } break;
      default:
        break;
    }
  } while (choice != 5);
} 

int PrintMenu() {
  int choice;
  printf("1) Allocate block\n"
         "2) Delete block\n"
         "3) Write to last block\n"
         "4) Print last block\n"
         "5) Exit\n");
  scanf("%d", &choice);
  return choice;
}

void* AllocBlock(Environment* env, size_t size) {
  
  unsigned char* mem = reinterpret_cast<unsigned char*>(ZoneAlloc(env, size));
  if (!mem) {
    puts("Nope sorry can't allocate that");
    return nullptr;
  }
  return mem;
}

