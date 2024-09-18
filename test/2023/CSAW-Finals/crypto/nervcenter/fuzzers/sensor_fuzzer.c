#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "parsers.h"

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    char *arg;
    char *buffer = malloc(size);
    memcpy(buffer, data, size);
    parse_sensor_input(buffer, size, &arg);
    free(buffer);
    return 0;
}
