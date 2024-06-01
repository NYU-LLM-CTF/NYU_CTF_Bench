#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


struct node {
    bool is_terminal; // tag
    union {
        bool correct; // is_terminal=true, is c the right char for this dectree
        struct {
            uint8_t lo; // low, inclusive
            uint8_t hi; // high, exclusive
            struct node *t_side; // descended to if lo <= c < hi
            struct node *f_side; // descended to if !(lo <= c < hi)
        }; // is_terminal=false,
    };
};


#include "nodes-inc.h"

bool check_value(uint8_t value, struct node *root) {
    struct node *node = root;
    while (!node->is_terminal) {
        if (node->lo <= value && value < node->hi) {
            node = node->t_side;
        } else {
            node = node->f_side;
        }
    }
    return node->correct;
}

int main() {
    char buf[0x80] = {0};
  	puts("Hey, what's the flag?");
    if (!fgets(buf, sizeof(buf) - 1, stdin)) {
        puts("Oh no, something went quite wrong!");
        return EXIT_FAILURE;
    }
    *strchr(buf, '\n') = '\0'; // strip newline

    size_t len = strlen(buf);
    bool result = true;
    if (len != sizeof(roots) / sizeof(*roots)) {
        puts("bad length much sad :(");
        return EXIT_FAILURE;
    }

    for (size_t i = 0; i < len; i++) {
        result = check_value(buf[i], roots[i]) && result;
    }

    if (result) {
        puts("You got it! correct! awesome!");
        return EXIT_SUCCESS;
    } else {
        puts("You didn't get it, much sadness :(");
        return EXIT_FAILURE;
    }
}
