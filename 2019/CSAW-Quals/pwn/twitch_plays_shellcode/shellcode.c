#include <sys/mman.h>
#include <unistd.h>

int main() {
  void * shellcode = mmap(0, 0x1000, PROT_EXEC | PROT_READ | PROT_WRITE,  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (read(0, shellcode, 0x1000) < 0) {
    return 1;
  }

  ((void (*)())shellcode)();
  return 0;
}
