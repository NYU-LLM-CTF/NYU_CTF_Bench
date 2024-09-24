#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "base64.h"

// char *base64_encode(const unsigned char *data,
//                     size_t input_length,
//                     size_t *output_length);
// unsigned char *base64_decode(const char *data,
//                              size_t input_length,
//                              size_t *output_length);
int main(int argc, char **argv) {
    const unsigned char s[] = "Hello, world!";
    const char *e = "SGVsbG8sIHdvcmxkIQ==";
    const char *t = NULL;
    const unsigned char *u = NULL;
    size_t n = 0;
    int r = 0;

    t = base64_encode(s, sizeof(s)-1, &n);
    if (!t) {
        printf("base64_encode returned NULL\n");
        r = 1; goto cleanup;
    }
    if (strcmp(t, e) != 0) {
        printf("base64_encode failed: expected %s, got %s\n", e, t);
        r = 1; goto cleanup;
    }

    u = base64_decode(e, strlen(e), &n);
    if (!u) {
        printf("base64_decode returned NULL\n");
        r = 1; goto cleanup;
    }
    if (memcmp(u, s, sizeof(s)-1) != 0) {
        printf("base64_decode failed: expected %s, got %s\n", s, u);
        r = 1; goto cleanup;
    }
cleanup:

    if(t) free((void*)t);
    if(u) free((void*)u);

    return r;
}
