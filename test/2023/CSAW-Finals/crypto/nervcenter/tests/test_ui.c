#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include "nervcenter.h"
#include "ui.h"
#include "magi_ui.h"

int random_fdset(fd_set *s, int maxfds) {
    int nfds = 0;
    FD_ZERO(s);
    for (int j = 0; j < maxfds; j++) {
        if (rand() % 2) {
            FD_SET(j, s);
            if (j > nfds) nfds = j;
        }
    }
    return nfds;
}

#define ROUNDS 100

void runtest(session_t *s,
             int fd, ui_surface_t *surface, int use_opt_render,
             size_t *total_bytes, suseconds_t *total_time) {
    dprintf(1, "\033[H\033[2J\033[3J");
    dprintf(1, "\033[?25l");            // hide cursor
    for (int i = 0; i < ROUNDS; i++) {
    // Make up three fd_sets by setting random bits
        int n = random_fdset(&s->readfds, s->maxfds);
        if (n > s->nfds) s->nfds = n;
        n = random_fdset(&s->writefds, s->maxfds);
        if (n > s->nfds) s->nfds = n;
        n = random_fdset(&s->exceptfds, s->maxfds);
        if (n > s->nfds) s->nfds = n;
        dprintf(1, "\033[H");
        render_fdsets_cells(&magi_ui, s);
        if (use_opt_render) {
            render_surface_opt(1, &magi_ui);
        }
        else {
            render_surface_naive(1, &magi_ui);
        }
        s->maxfds++;
        if (s->maxfds > 1024+64) s->maxfds = 1024+64;
#ifdef CHALDEBUG
        printf("Rendering statistics (%s):\n", use_opt_render ? "opt" : "naive");
        printf("  bytes written: %zu\n", magi_ui.bytes_written);
        printf("  last render: %ld us\n", magi_ui.last_render);
        *total_bytes += magi_ui.bytes_written;
        *total_time += magi_ui.last_render;
#endif
        usleep(10000);
    };
    dprintf(1, "\033[?25h");            // show cursor
    dprintf(1, "\033[0m");              // reset attributes
    // clear scrollback buffer
    dprintf(1, "\033[3J");
}

int main(int argc, char **argv) {
    size_t total_bytes_naive = 0;
    suseconds_t total_time_naive = 0;
    size_t total_bytes_opt = 0;
    suseconds_t total_time_opt = 0;
    session_t s;
    if (argc < 2) {
        s.maxfds = 1024+64-ROUNDS;
    }
    else {
        s.maxfds = atoi(argv[1]);
    }
    s.nfds = 0;
    pthread_mutex_init(&s.sensor_lock, NULL);
    // time the two renderers
    struct timeval nstart, nend;
    gettimeofday(&nstart, NULL);
    runtest(&s, 1, &magi_ui, 0, &total_bytes_naive, &total_time_naive);
    gettimeofday(&nend, NULL);
    struct timeval ostart, oend;
    gettimeofday(&ostart, NULL);
    runtest(&s, 1, &magi_ui, 1, &total_bytes_opt, &total_time_opt);
    gettimeofday(&oend, NULL);
#ifdef CHALDEBUG
    printf("Naive renderer:\n");
    printf("  Total bytes written: %zu\n", total_bytes_naive);
    printf("  Total time: %ld us\n", total_time_naive);
    printf("  Average bytes per render: %zu\n", total_bytes_naive / ROUNDS);
    printf("  Average time: %ld us\n", total_time_naive / ROUNDS);
    printf("Optimized renderer:\n");
    printf("  Total bytes written: %zu\n", total_bytes_opt);
    printf("  Total time: %ld us\n", total_time_opt);
    printf("  Average bytes per render: %zu\n", total_bytes_opt / ROUNDS);
    printf("  Average time: %ld us\n", total_time_opt / ROUNDS);
    printf("Speedup: %.2fx\n", (float)total_time_naive / (float)total_time_opt);
    printf("Bytes saved: %zu\n", total_bytes_naive - total_bytes_opt);
#endif
    suseconds_t nelapsed = (nend.tv_sec - nstart.tv_sec) * 1000000 + (nend.tv_usec - nstart.tv_usec);
    suseconds_t oelapsed = (oend.tv_sec - ostart.tv_sec) * 1000000 + (oend.tv_usec - ostart.tv_usec);
    printf("Naive renderer:     %8ld us\n", nelapsed);
    printf("Optimized renderer: %8ld us\n", oelapsed);
    printf("Speedup:            %8.2f x\n", (float)nelapsed / (float)oelapsed);
    return 0;
}
