// gcc pow.c -o pow -lcrypto
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <openssl/sha.h>



void hexlify(const char *in, size_t in_size, char *out) {
  while (in_size) {
    sprintf(out, "%02hhx", *in);
    out += 2;
    in_size--;
    in++;
  }
}

char sum[0x100];
char *SHA256hex(char *s) {
  char *digest = SHA256(s, strlen(s), 0);
  hexlify(digest, SHA256_DIGEST_LENGTH, sum);
  return sum;
}

int checkwith(char *inp, char *pref) {
  char *hexdigest = SHA256hex(inp);
  return !strncasecmp(hexdigest, pref, strlen(pref));
}

const char *ascii = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890_";

int main(int argc, char **argv) {
  char buff[0x100];
  char pref[0x43];

  setbuf(stdout, NULL);

  int rd = open("/dev/urandom", O_RDONLY);
  if (rd < 0) err(-1, "open(/dev/urandom)");
  
  if (strstr(argv[0], "solve")) {
    int seed;
    if (read(rd, &seed, sizeof(seed)) != sizeof(seed)) err(-1, "read(rd)");
    srand(seed);

    if (argc <= 1) {
      printf("Prefix: ");
      fgets(pref, sizeof(pref), stdin);
      strtok(pref, "\n");
    } else if (argc > 2) {
      printf("Usage: %s [PREFIX]\n", argv[0]);
      return -1;
    } else {
      strncpy(pref, argv[1], sizeof(pref));
      pref[sizeof(pref) - 1] = 0;
    }
    while (1) {
      for (int i = 0; i < 20; i++) {
        buff[i] = ascii[rand() % strlen(ascii)];
      }
      buff[20] = 0;
      if (checkwith(buff, pref)) {
        puts(buff);
        return 0;
      }
    }
  } else {
    if (argc < 3) {
      printf("Usage: %s DIFF PROG [ARGS...]\n", argv[0]);
      return -1;
    }

    int diff = atoi(argv[1]);
    if (diff <= 0 || diff > 32)
      errx(-1, "Difficulty can only be between 1 and 32!");

    if (read(rd, buff, diff) != diff) err(-1, "read(rd)");
    hexlify(buff, diff, pref);

    printf("sha256(x).hexdigest()[:%1$d] = %2$s\n  `./solve %2$s`\nx = ",
        diff * 2, pref);

    alarm(60);
    fgets(buff, sizeof(buff), stdin);
    strtok(buff, "\n");

    if (checkwith(buff, pref)) {
      puts("Correct!");
      alarm(0);
      execvp(argv[2], argv + 2);
      err(-1, "%s", argv[2]);
    } else {
      puts("Incorrect!");
      return -1;
    }
  }
}
