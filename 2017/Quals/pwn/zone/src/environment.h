#ifndef ENVIRON_
#define ENVIRON_
#include "zone.h"

class Zone;

class Environment {
  public:
    Environment () 
      : zone64(64),
        zone128(128),
        zone256(256),
        zone512(512) {}
    void* Alloc64() { return zone64.alloc(); }
    void* Alloc128() { return zone128.alloc(); }
    void* Alloc256() { return zone256.alloc(); }
    void* Alloc512() { return zone512.alloc(); }
    void Free64(Block* block) { zone64.free(block); }
    void Free128(Block* block) { zone128.free(block); }
    void Free256(Block* block) { zone256.free(block); }
    void Free512(Block* block) { zone512.free(block); }
  private:
    Zone zone64;
    Zone zone128;
    Zone zone256;
    Zone zone512;
};

#endif
