#include <stdio.h>
#include <string.h>

// translation table
struct tbl_entry {
    char src;
    char dst;
} trans_tbl[] = {
#include "table-inc.h"
};

char get_tbl_entry(char c)  {
    for (size_t i = 0; i < sizeof(trans_tbl) / sizeof(struct tbl_entry); i++) {
        if (trans_tbl[i].src == c) return trans_tbl[i].dst;
    }
    // wuttt
    return 0;
}

int main() {
    char buf[128];
    size_t len;
#include "flag-inc.h"
    printf("Please enter the flag:\n");
    fgets(buf, sizeof(buf), stdin);
    buf[strlen(buf)-1] = '\0';
    len = strlen(buf);
    for (size_t i = 0; i < len; i++) {
        buf[i] = get_tbl_entry(buf[i]);
    }
    if (len != sizeof(ans)-1) {
        printf("WRONG\n");
        return 1;
    }
	if (strncmp(buf, ans, sizeof(ans)) == 0) {
        printf("CORRECT <3\n");
        return 0;
	}
    printf("WRONG\n");
    return 1;
}
