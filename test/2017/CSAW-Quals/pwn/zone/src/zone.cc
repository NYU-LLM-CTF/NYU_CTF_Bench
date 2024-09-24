#include <stdlib.h>
#include <stdio.h>
#include "heap.h"
#include "zone.h"
#include "environment.h"

Zone::Zone(size_t block_size)
  : block_size_(block_size) {
  Block* cur_block = reinterpret_cast<Block*>(page_.get_memory());
  void* end = page_.get_memory() + PAGE_SIZE;
  free_head = cur_block;
  Block* tmp = nullptr;

  do {
    cur_block->size = block_size_;
    tmp = get_next_block(cur_block);
    cur_block->next = tmp;

    if (get_next_block(tmp) < end)
      cur_block = tmp;

  } while (get_next_block(tmp) < end);

  cur_block->next = nullptr;
}

void* Zone::alloc() {
  Block* tmp = free_head;

  if (tmp) {
    if (tmp->next) {
      free_head = tmp->next;
    } else {
      free_head = nullptr;
    }
    tmp->next = nullptr;

    return reinterpret_cast<unsigned char*>(tmp)+sizeof(Block);
  }
  return nullptr;
}

void Zone::free(Block* block) {
  if (block) {
    block->next = free_head;
    free_head = block;
  }
}


void* ZoneAlloc(Environment* env, size_t size) {
  if (size <= 64)
    return env->Alloc64();
  else if (size <= 128)
    return env->Alloc128();
  else if (size <= 256)
    return env->Alloc256();
  else if (size <= 512)
    return env->Alloc512();
  return nullptr;
}

void ZoneFree(Environment* env, void* addr) {
  if (addr) {
    Block* block = reinterpret_cast<Block*>(
          reinterpret_cast<unsigned char*>(addr) - sizeof(Block));
    printf("Free size %lu\n", block->size);
    switch (block->size) {
      case 64:
        env->Free64(block);
        break;
      case 128:
        env->Free128(block);
        break;
      case 256:
        env->Free256(block);
        break;
      case 512:
        env->Free512(block);
        break;
      default:
        exit(-1);
    }
  }
}
