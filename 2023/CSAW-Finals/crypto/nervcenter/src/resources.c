#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <dirent.h>
#include <sys/stat.h>
#include <errno.h>

#include "resources.h"

static int compress_file(const char *filepath, unsigned char **compressed_data, uint64_t *compressed_size) {
    FILE *file = fopen(filepath, "rb");
    if (!file) return Z_ERRNO;

    fseek(file, 0, SEEK_END);
    size_t original_size = ftell(file);
    fseek(file, 0, SEEK_SET);

    unsigned char *data = malloc(original_size);
    if (fread(data, 1, original_size, file) != original_size) {
        free(data);
        fclose(file);
        return Z_ERRNO;
    }
    fclose(file);

    uLongf dest_size = compressBound(original_size);
    *compressed_data = malloc(dest_size);

    if (compress(*compressed_data, &dest_size, data, original_size) != Z_OK) {
        free(data);
        free(*compressed_data);
        return Z_BUF_ERROR;
    }

    *compressed_size = dest_size;
    free(data);
    return Z_OK;
}

static int pack_dir_rec(const char *path, unsigned char **blob, size_t *blob_size, size_t *current_offset, progress_callback cb) {
    DIR *dir = opendir(path);
    if (!dir) return Z_ERRNO;

    struct dirent *entry;
    char fullpath[PATH_MAX];

    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
        snprintf(fullpath, sizeof(fullpath), "%s/%s", path, entry->d_name);

        struct stat st;
        stat(fullpath, &st);

        if (S_ISDIR(st.st_mode)) {
            if (pack_dir_rec(fullpath, blob, blob_size, current_offset, cb) != Z_OK) {
                closedir(dir);
                return Z_ERRNO;
            }
        } else if (S_ISREG(st.st_mode)) {
            unsigned char *compressed_data = NULL;
            uint64_t compressed_size = 0;

            if (cb && cb(fullpath, st.st_size, 0, RESOURCE_CB_BEFORE) == 0) continue;

            if (compress_file(fullpath, &compressed_data, &compressed_size) != Z_OK) {
                closedir(dir);
                return Z_ERRNO;
            }

            resource_header header;
            // This might truncate in theory but not with any of the paths we have
            snprintf(header.name, sizeof(header.name), "%.*s", (int)sizeof(header.name), fullpath);
            header.size = compressed_size;

            if (cb) cb(fullpath, st.st_size, compressed_size, RESOURCE_CB_AFTER);

            *blob = realloc(*blob, *current_offset + sizeof(header) + compressed_size);
            memcpy(*blob + *current_offset, &header, sizeof(header));
            *current_offset += sizeof(header);
            memcpy(*blob + *current_offset, compressed_data, compressed_size);
            *current_offset += compressed_size;
            free(compressed_data);
        }
    }

    closedir(dir);
    return Z_OK;
}

int pack_dir(const char *path, unsigned char **out, size_t *out_size, progress_callback cb) {
    *out = NULL;
    *out_size = 0;
    return pack_dir_rec(path, out, out_size, out_size, cb);
}

static int decompress_data(const unsigned char *compressed_data, uint64_t compressed_size, unsigned char **decompressed_data, uLongf *decompressed_size) {
    *decompressed_size = compressed_size * 10;  // rough initial estimate; adjust as needed
    *decompressed_data = malloc(*decompressed_size);

    int ret;
    while ((ret = uncompress(*decompressed_data, decompressed_size, compressed_data, compressed_size)) == Z_BUF_ERROR) {
        *decompressed_size *= 2;
        *decompressed_data = realloc(*decompressed_data, *decompressed_size);
    }

    if (ret != Z_OK) {
        free(*decompressed_data);
        return ret;
    }

    return Z_OK;
}

// recursively create a direcotry and all parent directories
// it is not an error if the directory already exists
static int mkdir_p(const char *path, mode_t mode) {
    // Create a mutable copy of the path.
    char tmp[PATH_MAX];
    char *p = NULL;
    struct stat sb;
    size_t len;

    snprintf(tmp, sizeof(tmp), "%s", path);
    len = strlen(tmp);
    if (tmp[len - 1] == '/')
        tmp[len - 1] = 0;

    for (p = tmp + 1; *p; p++)
        if (*p == '/') {
            *p = 0;
            // Check if directory exists.
            if (stat(tmp, &sb) != 0) {
                // Directory does not exist, create it.
                if (mkdir(tmp, mode) != 0) {
                    return -1;
                }
            } else if (!S_ISDIR(sb.st_mode)) {
                // Path exists but it's not a directory.
                errno = ENOTDIR;
                return -1;
            }
            *p = '/';
        }

    if (stat(tmp, &sb) != 0) {
        // End directory does not exist, create it.
        if (mkdir(tmp, mode) != 0) {
            return -1;
        }
    } else if (!S_ISDIR(sb.st_mode)) {
        // Path exists but it's not a directory.
        errno = ENOTDIR;
        return -1;
    }

    return 0;
}

int unpack_blob(const char *path, const unsigned char *blob, size_t blob_size, size_t *out_size, progress_callback cb) {
    size_t offset = 0;
    char fullpath[4096];

    while (offset < blob_size) {
        resource_header local_header;
        memcpy(&local_header, blob + offset, sizeof(local_header));
        resource_header *header = &local_header;

        offset += sizeof(resource_header);

        snprintf(fullpath, sizeof(fullpath), "%s/%s", path, header->name);

        unsigned char *decompressed_data = NULL;
        uLongf decompressed_size = 0;

        if (cb && cb(fullpath, header->size, 0, RESOURCE_CB_BEFORE) == 0) {
            offset += header->size;
            continue;
        }

        if (decompress_data(blob + offset, header->size, &decompressed_data, &decompressed_size) != Z_OK) {
            return Z_DATA_ERROR;
        }
        offset += header->size;

        // Ensure the directory structure exists
        char *slash = strrchr(fullpath, '/');
        if (slash) {
            *slash = '\0';
            if (mkdir_p(fullpath, 0755) == -1) {
                free(decompressed_data);
                return Z_ERRNO;
            }
            *slash = '/';
        }

        FILE *file = fopen(fullpath, "wb");
        if (!file) {
            free(decompressed_data);
            return Z_ERRNO;
        }

        fwrite(decompressed_data, 1, decompressed_size, file);
        fclose(file);

        if (cb) cb(fullpath, header->size, decompressed_size, RESOURCE_CB_AFTER);

        free(decompressed_data);
    }

    *out_size = offset;
    return Z_OK;
}

resource_table *resource_table_init(uint64_t size) {
    resource_table *table = malloc(sizeof(resource_table));
    table->size = size;
    table->entries = calloc(sizeof(resource_entry *), size);
    return table;
}

void resource_table_free(resource_table *table) {
    for (uint64_t i = 0; i < table->size; i++) {
        resource_entry *entry = table->entries[i];
        while (entry) {
            resource_entry *next = entry->next;
            free(entry->data);
            free(entry);
            entry = next;
        }
    }
    free(table->entries);
    free(table);
}

static unsigned long resource_hash(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}

resource_entry *resource_table_get(resource_table *table, const char *name) {
    uint64_t hash = resource_hash((unsigned char *)name) % table->size;
    resource_entry *entry = table->entries[hash];
    while (entry) {
        if (strcmp(entry->name, name) == 0) return entry;
        entry = entry->next;
    }
    return NULL;
}

void resource_table_set(resource_table *table, const char *name, uint64_t size, unsigned char *data) {
    uint64_t hash = resource_hash((unsigned char *)name) % table->size;
    resource_entry *entry = table->entries[hash];
    while (entry) {
        if (strcmp(entry->name, name) == 0) {
            entry->size = size;
            entry->data = data;
            return;
        }
        entry = entry->next;
    }

    entry = malloc(sizeof(resource_entry));
    snprintf(entry->name, sizeof(entry->name), "%s", name);
    entry->size = size;
    entry->data = data;
    entry->next = table->entries[hash];
    table->entries[hash] = entry;
}

void resource_table_remove(resource_table *table, const char *name) {
    uint64_t hash = resource_hash((unsigned char *)name) % table->size;
    resource_entry *entry = table->entries[hash];
    resource_entry *prev = NULL;
    while (entry) {
        if (strcmp(entry->name, name) == 0) {
            if (prev) {
                prev->next = entry->next;
            } else {
                table->entries[hash] = entry->next;
            }
            free(entry->data);
            free(entry);
            return;
        }
        prev = entry;
        entry = entry->next;
    }
}

void resource_table_print(resource_table *table) {
    for (uint64_t i = 0; i < table->size; i++) {
        resource_entry *entry = table->entries[i];
        while (entry) {
            printf("%s (%zu bytes)\n", entry->name, entry->size);
            entry = entry->next;
        }
    }
}

int unpack_blob_to_table(const unsigned char *blob, size_t blob_size, resource_table *table, progress_callback cb) {
    size_t offset = 0;
    char fullpath[4096];

    while (offset < blob_size) {
        resource_header local_header;
        memcpy(&local_header, blob + offset, sizeof(local_header));
        resource_header *header = &local_header;

        offset += sizeof(resource_header);

        snprintf(fullpath, sizeof(fullpath), "%s", header->name);

        unsigned char *decompressed_data = NULL;
        uLongf decompressed_size = 0;

        if (cb && cb(fullpath, header->size, 0, RESOURCE_CB_BEFORE) == 0) {
            offset += header->size;
            continue;
        }

        if (decompress_data(blob + offset, header->size, &decompressed_data, &decompressed_size) != Z_OK) {
            return Z_DATA_ERROR;
        }
        offset += header->size;

        resource_table_set(table, fullpath, decompressed_size, decompressed_data);

        if (cb) cb(fullpath, header->size, decompressed_size, RESOURCE_CB_AFTER);
    }

    return Z_OK;
}
