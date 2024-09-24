#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RESOURCE_GEN
#include "resources.h"

int packcb(const char *path, uint64_t bytes_in, uint64_t bytes_out, resource_cb_type cb_type) {
    if (cb_type == RESOURCE_CB_BEFORE) {
        // Skip credits.tar.xz and flag.txt
        if (strstr(path, "credits.tar.xz") || strstr(path, "flag.txt")) {
            printf("Skipping %s\n", path);
            return 0;
        }
        else if (!strstr(path, ".txt")) {
            printf("Skipping %s\n", path);
            return 0;
        }
        else {
            return 1;
        }
    }
    return 1;
}

int main(int argc, char **argv) {
    // Pack the img directory into a blob and write it out as a source/header file
    if (argc != 4) {
        printf("Usage: %s <input directory> <output filename> <blob_var_name>\n", argv[0]);
        return 1;
    }
    unsigned char *blob;
    size_t blob_size;
    chdir(argv[1]);
    if (pack_dir(".", &blob, &blob_size, packcb) != Z_OK) {
        printf("Failed to pack directory\n");
        return 1;
    }
    printf("Packed %zu bytes\n", blob_size);
    char fullpath[PATH_MAX];
    sprintf(fullpath, "%s.h", argv[2]);
    FILE *out = fopen(fullpath, "w");
    if (!out) {
        printf("Failed to open output file %s\n", fullpath);
        return 1;
    }
    fprintf(out, "#pragma once\n\n");
    fprintf(out, "#include <stddef.h>\n");
    fprintf(out, "#include <stdint.h>\n\n");
    fprintf(out, "extern const uint8_t %s[%zu];\n", argv[3], blob_size);
    fprintf(out, "extern const size_t %s_size;\n", argv[3]);
    fclose(out);
    sprintf(fullpath, "%s.c", argv[2]);
    out = fopen(fullpath, "w");
    if (!out) {
        printf("Failed to open output file %s\n", fullpath);
        return 1;
    }
    fprintf(out, "#include \"%s.h\"\n\n", argv[2]);
    fprintf(out, "const uint8_t %s[%zu] = {\n", argv[3], blob_size);
    for (size_t i = 0; i < blob_size; i++) {
        fprintf(out, "0x%02x, ", blob[i]);
        if (i % 16 == 15) fprintf(out, "\n");
    }
    fprintf(out, "};\n\n");
    fprintf(out, "const size_t %s_size = %zu;\n", argv[3], blob_size);
    fclose(out);
    free(blob);

    return 0;
}
