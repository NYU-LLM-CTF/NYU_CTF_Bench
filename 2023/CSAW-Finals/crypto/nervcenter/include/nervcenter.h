#pragma once

#include <sys/select.h>
#include <pthread.h>

#ifdef __cplusplus
extern "C" {
#endif

#define RSA_EXPONENT 65537
#define RSA_KEY_SIZE 1024
typedef struct {
    int server_fd;
    int control_fd;
    int authenticated;
    unsigned long maxfds;
    int *sensor_sockets;
    int nfds;
    // For the halt/resume logic
    pthread_mutex_t halt_resume_mutex;
    pthread_cond_t halt_cond;
    pthread_cond_t ack_cond;
    int sensor_is_running;
    int acknowledged;
    // For the fdset viewer
    pthread_mutex_t sensor_lock;
    fd_set readfds;
    long pad1;
    fd_set writefds;
    long pad2;
    fd_set exceptfds;
    unsigned char pubkey[RSA_KEY_SIZE/8];
} session_t;

#ifdef __cplusplus
}
#endif
