#include <stdint.h>
#include <stddef.h>

// load a resource table from a blob
int load_image_resources();
void unload_image_resources();
int get_image(const char *name, unsigned char **data, uint64_t *size);
void list_images();
