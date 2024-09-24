#include <string.h>

#include "parsers.h"

sensor_command_t parse_sensor_input(char *buffer, size_t buflen, char **arg) {
    // Scan for newline
    for (int i = 0; i < buflen; i++) {
        if (buffer[i] == '\n') {
            buffer[i] = 0;
            buflen = i;
            break;
        }
    }
    if (buflen >= 4 && strncmp(buffer, "LIST", 4) == 0) {
        return SENSOR_CMD_LIST;
    }
    else if (buflen >= 7 && strncmp(buffer, "EXAMINE", 7) == 0) {
        char *ptr = &buffer[7];
        char *end = &buffer[buflen];
        // Skip whitespace
        while (ptr < end && (*ptr == ' ' || *ptr == '\t')) ptr++;
        if (ptr == end) {
            return SENSOR_CMD_EXAMINE | SENSOR_CMD_INVALID;
        }
        *arg = ptr;
        return SENSOR_CMD_EXAMINE;
    }
    else if (buflen >= 6 && strncmp(buffer, "REPORT", 6) == 0) {
        return SENSOR_CMD_REPORT;
    }
    else if (buflen >= 4 && strncmp(buffer, "QUIT", 4) == 0) {
        return SENSOR_CMD_QUIT;
    }
    else if (buflen >= 4 && strncmp(buffer, "HELP", 4) == 0) {
        return SENSOR_CMD_HELP;
    }
    else {
        return SENSOR_CMD_UNKNOWN;
    }
}
