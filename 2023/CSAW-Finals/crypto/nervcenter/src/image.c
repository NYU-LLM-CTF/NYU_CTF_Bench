#include <stddef.h>

#include "imgresource.h"
#include "resources.h"

static resource_table *image_resources = NULL;

int load_image_resources() {
    if (image_resources) return 0;

    image_resources = resource_table_init(4096);
    if (unpack_blob_to_table(image_blob, image_blob_size, image_resources, NULL) != Z_OK) {
        return -1;
    }

    return 0;
}

void unload_image_resources(void) {
    if (!image_resources) return;

    resource_table_free(image_resources);
    image_resources = NULL;
}

int get_image(const char *name, unsigned char **data, uint64_t *size) {
    if (!image_resources) return -1;

    resource_entry *entry = resource_table_get(image_resources, name);
    if (!entry) return -1;

    *data = entry->data;
    *size = entry->size;
    return 0;
}

void list_images() {
    if (!image_resources) return;
    resource_table_print(image_resources);
}
