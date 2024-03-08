#pragma once

#include <stddef.h>
#include <stdint.h>
#include <zlib.h>

// representation of a resource on disk
// packed so we can read it directly into memory without parsing
typedef struct __attribute__((packed, aligned(8))) {
    char name[256];
    uint64_t size;
} resource_header;

// hash table for fast lookup of resources
typedef struct resource_entry_ {
    struct resource_entry_ *next;
    char name[256];
    uint64_t size;
    unsigned char *data;
} resource_entry;

typedef struct {
    uint64_t size;
    resource_entry **entries;
} resource_table;

typedef enum {
    RESOURCE_CB_BEFORE,
    RESOURCE_CB_AFTER,
} resource_cb_type;

// callback types for compress/decompress
// Called before and after each file is compressed/decompressed. If before, the return value
// can set to 0 to skip the file. If after, the return value is ignored.
// path is the path to the file being compressed/decompressed
// bytes_in is the number of bytes in the file before compression/decompression
// bytes_out is the number of bytes in the file after compression/decompression (or 0 if before)
// cb_type is RESOURCE_CB_BEFORE if before compression/decompression, RESOURCE_CB_AFTER if after
typedef int (*progress_callback)(const char *path, uint64_t bytes_in, uint64_t bytes_out, resource_cb_type);

// recursively pack a directory into a blob
// path is the path to the directory to pack
// out is a pointer to a pointer to the output blob, which will be allocated
// returns Z_OK on success, zlib error (negative) on failure
// out_size is set to the size of the output blob
int pack_dir(const char *path, unsigned char **out, size_t *out_size, progress_callback cb);

// unpack a blob into a directory
int unpack_blob(const char *path, const unsigned char *blob, size_t blob_size, size_t *out_size, progress_callback cb);
int unpack_blob_to_table(const unsigned char *blob, size_t blob_size, resource_table *table, progress_callback cb);
resource_table *resource_table_init(uint64_t size);
void resource_table_free(resource_table *table);
void resource_table_print(resource_table *table);
resource_entry *resource_table_get(resource_table *table, const char *name);
