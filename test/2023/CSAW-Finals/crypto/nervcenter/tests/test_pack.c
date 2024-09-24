#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "resources.h"

static void create_dirtree(void) {
    mkdir("a", 0755);
    mkdir("a/b", 0755);
    FILE *foo = fopen("a/foo.txt", "w");
    fprintf(foo, "Hello world");
    fclose(foo);
    FILE *bar = fopen("a/b/bar.txt", "w");
    fprintf(bar, "Goodbye world");
    fclose(bar);
}

static void remove_dirtree(void) {
    remove("a/b/bar.txt");
    remove("a/b");
    remove("a/foo.txt");
    remove("a");
}

static int check_dirtree() {
    struct stat st;
    if (stat("a", &st) != 0) {
        perror("stat (a)");
        return 1;
    }
    if (!S_ISDIR(st.st_mode)) {
        printf("a is not a directory\n");
        return 1;
    }
    if (stat("a/b", &st) != 0) {
        perror("stat (a/b)");
        return 1;
    }
    if (!S_ISDIR(st.st_mode)) {
        printf("a/b is not a directory\n");
        return 1;
    }
    if (stat("a/foo.txt", &st) != 0) {
        perror("stat (a/foo.txt)");
        return 1;
    }
    if (!S_ISREG(st.st_mode)) {
        printf("a/foo.txt is not a regular file\n");
        return 1;
    }
    if (stat("a/b/bar.txt", &st) != 0) {
        perror("stat (a/b/bar.txt)");
        return 1;
    }
    if (!S_ISREG(st.st_mode)) {
        printf("a/b/bar.txt is not a regular file\n");
        return 1;
    }
    char buf[256] = {};
    FILE *foo = fopen("a/foo.txt", "r");
    fgets(buf, sizeof(buf), foo);
    fclose(foo);
    if (strcmp(buf, "Hello world") != 0) {
        printf("a/foo.txt does not contain \"Hello world\"\n");
        return 1;
    }
    FILE *bar = fopen("a/b/bar.txt", "r");
    fgets(buf, sizeof(buf), bar);
    fclose(bar);
    if (strcmp(buf, "Goodbye world") != 0) {
        printf("a/b/bar.txt does not contain \"Goodbye world\"\n");
        return 1;
    }
    return 0;
}

static int print_progress(const char *path, uint64_t bytes_in, uint64_t bytes_out, resource_cb_type cb_type) {
    printf("%s path = %s, bytes_in = %lu, bytes_out = %lu\n",
        cb_type == RESOURCE_CB_BEFORE ? "before" : "after",
        path, bytes_in, bytes_out);
    return 1;
}

int main(void) {
    // Make a test directory tree
    //   a/
    //   a/foo.txt ("Hello world")
    //   a/b/
    //   a/b/bar.txt ("Goodbye world")

    unsigned char *blob;
    size_t blob_size;

    create_dirtree();

    printf("check_dirtree() before pack/unpack = %d\n", check_dirtree());

    int err = pack_dir("a", &blob, &blob_size, print_progress);
    if (err != Z_OK) {
        printf("pack_dir failed with error %d\n", err);
        return 1;
    }
    printf("blob_size = %zu\n", blob_size);

    remove_dirtree();

    size_t decompressed_size;
    err = unpack_blob(".", blob, blob_size, &decompressed_size, print_progress);

    if (err != Z_OK) {
        printf("unpack_blob failed with error %d\n", err);
        return 1;
    }

    // Check that the directory tree was restored
    if (check_dirtree() != 0) {
        printf("unpack_blob failed to restore directory tree\n");
        return 1;
    }

    free(blob);
    remove_dirtree();

    return 0;
}
