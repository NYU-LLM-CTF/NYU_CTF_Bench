#ifndef HEAP_
#define HEAP_
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>

const size_t PAGE_SIZE = 4096;

class Page {
  public:
    Page() { 
      memory = reinterpret_cast <unsigned char*> (
          mmap(NULL, PAGE_SIZE, 
              PROT_WRITE | PROT_READ, 
              MAP_SHARED | MAP_ANONYMOUS, 
              -1, 0));
      if (memory == reinterpret_cast <void*>(-1))
        exit(-1);
    }
    ~Page() { munmap(memory, PAGE_SIZE); }
    unsigned char* get_memory() const { return memory; }
  private:
    unsigned char* memory = nullptr;
};
#endif
