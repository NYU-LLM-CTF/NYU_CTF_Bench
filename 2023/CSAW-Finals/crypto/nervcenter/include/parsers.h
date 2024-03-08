#pragma once

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    SENSOR_CMD_LIST         = 1,
    SENSOR_CMD_EXAMINE      = 2,
    SENSOR_CMD_REPORT       = 4,
    SENSOR_CMD_QUIT         = 8,
    SENSOR_CMD_HELP         = 16,
    SENSOR_CMD_UNKNOWN      = 32, // Unknown command
    SENSOR_CMD_INVALID      = 64, // Known command, but invalid arguments
} sensor_command_t;

sensor_command_t parse_sensor_input(char *buffer, size_t buflen, char **arg);

#ifdef __cplusplus
}
#endif
