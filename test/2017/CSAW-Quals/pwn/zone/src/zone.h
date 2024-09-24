#ifndef ZONE_
#define ZONE_

#include <stdlib.h>
#include "heap.h"
class Environment;

struct Block {
  size_t size;
  Block* next;
};

class Zone {
  public:
    Zone(size_t block_size);
    void* alloc();
    void free(Block* block);
  private:
    size_t block_size_;
    Block* get_next_block(Block* cur_block) {
      return reinterpret_cast<Block*>(reinterpret_cast<unsigned char*>(cur_block) 
          + sizeof(Block) + block_size_);
    }

    Block* free_head;
    Page page_;
};


void* ZoneAlloc(Environment* env, size_t size);
void ZoneFree(Environment* env, void* addr);

#endif
