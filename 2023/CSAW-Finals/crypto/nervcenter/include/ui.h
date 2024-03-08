#pragma once

#include <sys/select.h>
#include <stdint.h>

#include "nervcenter.h"

#define CELL_MAXBYTES 4

#define ANSI_FGCOLOR_FMT ("\033[38;5;%dm")
#define ANSI_BGCOLOR_FMT ("\033[48;5;%dm")
#define ANSI_RESET "\033[0m"
#define ANSI_BOLD "\033[01m"
#define ANSI_DIM "\033[02m"
#define ANSI_ITALIC "\033[03m"
#define ANSI_UNDERLINED "\033[04m"
#define ANSI_BLINK "\033[05m"
#define ANSI_REVERSE "\033[07m"
#define ANSI_HIDDEN "\033[08m"
#define ANSI_STRIKETHROUGH "\033[09m"

// Represents a logical character cell on the surface (which may be multiple
// bytes in UTF-8 or with ANSI escape sequences)
typedef struct {
    unsigned char bytes[CELL_MAXBYTES]; // the character bytes (with no ANSI escapes)
    uint8_t len;                        // the number of bytes used
    int16_t fg;                         // foreground color, -1 for default
    int16_t bg;                         // background color, -1 for default
    uint32_t flags;                     // cell flags
} ui_cell_t;

typedef struct {
    ui_cell_t *cells;
    int width;
    int height;
#ifdef CHALDEBUG
    // accounting fields
    size_t bytes_written;
    suseconds_t last_render;
#endif
} ui_surface_t;

typedef enum {
    UI_SKIP                 = 0,    // Skip this cell (e.g. for wide characters)
    UI_STYLE_RESET          = 1,    // Reset all attributes
    UI_STYLE_BOLD           = 2,    // Bold text
    UI_STYLE_DIM            = 4,    // Dim text
    UI_STYLE_ITALIC         = 8,    // Italic text
    UI_STYLE_UNDERLINE      = 16,   // Underlined text
    UI_STYLE_BLINK          = 32,   // Blinking text
    UI_STYLE_REVERSE        = 64,   // Reverse video
    UI_STYLE_HIDDEN         = 128,  // Hidden text
    UI_STYLE_STRIKETHROUGH  = 256,  // Strikethrough text
    UI_STYLE_NONE           = 512,  // No style
    UI_WIDE                 = 1024, // Wide character
} ui_cell_flags_t;

void render_surface_naive(int fd, ui_surface_t *surface);
void render_surface_opt(int fd, ui_surface_t *surface);
void render_fdsets_cells(ui_surface_t *surface, session_t *s);

// default renderer
#define render_surface render_surface_opt

#define CELL_AT(surface, row, column) ((surface)->cells + (row) * (surface)->width + (column))
