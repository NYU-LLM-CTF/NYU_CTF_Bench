#!/usr/bin/env python3

import argparse
import json
import os
from colormath.color_diff import delta_e_cie2000
from colormath.color_objects import LabColor, sRGBColor
from colormath.color_conversions import convert_color
import re
import sys
from collections import defaultdict, OrderedDict
from unicodedata import east_asian_width

# workaround since numpy deprecated asscalar
# from: https://github.com/gtaylor/python-colormath/issues/104
import numpy
def patch_asscalar(a):
    return a.item()
setattr(numpy, "asscalar", patch_asscalar)

rgb_re = re.compile(r'<rgb:(\d+),(\d+),(\d+)>')
bg_rgb_re = re.compile(r'<bg_rgb:(\d+),(\d+),(\d+)>')
color_re = re.compile(r'<(\w+)>')
bg_color_re = re.compile(r'<bg_(\w+)>')
markup_re = re.compile(r'<[^>]+>')

def warn_once(message):
    if not hasattr(warn_once, 'warned'):
        warn_once.warned = set()
    if message not in warn_once.warned:
        print(markup['<reset>'] + f'WARN: {message}', file=sys.stderr)
        warn_once.warned.add(message)

class AnsiColor:
    track_colors = False
    def __init__(self, r, g, b, name=None, code=None, unique_name=None):
        self.r = r
        self.g = g
        self.b = b
        self.name = name
        self.code = code
        self.unique_name = unique_name

    @classmethod
    def track(cls):
        cls.track_colors = True
        cls.colors = set()

    @classmethod
    def from_json(cls, j, unique_name=None):
        rgb = j['rgb']
        return cls(rgb['r'], rgb['g'], rgb['b'], j['name'], j['colorId'], unique_name)

    @property
    def hex(self):
        return f'#{self.r:02x}{self.g:02x}{self.b:02x}'

    @property
    def rgb(self):
        return (self.r, self.g, self.b)

    def __repr__(self):
        return f'<AnsiColor {self.name} {self.code} rgb:{self.r},{self.g},{self.b}>'

    def __str__(self):
        return self.name if self.name is not None else self.hex

    def to_json(self):
        return {
            'r': self.r,
            'g': self.g,
            'b': self.b,
            'name': self.name,
            'colorId': self.code,
        }

    def to_ansi(self, bg=False):
        if AnsiColor.track_colors:
            AnsiColor.colors.add((self, bg))
        if bg:
            return f'\033[48;5;{self.code}m'
        else:
            return f'\033[38;5;{self.code}m'

def rgb2xterm(r, g, b):
    rgb = sRGBColor(r, g, b)
    lab = convert_color(rgb, LabColor)
    nearest_color = None
    nearest_distance = 1000000
    for color in xterm_colors.values():
        color_rgb = sRGBColor(*color.rgb)
        color_lab = convert_color(color_rgb, LabColor)
        distance = delta_e_cie2000(lab, color_lab)
        if distance < nearest_distance:
            nearest_color = color
            nearest_distance = distance
    warn_once(f'replacing RGB color {rgb} with nearest color {nearest_color.name} (distance {nearest_distance:.2f})')
    return nearest_color

def rgbsub(match):
    r, g, b = map(int, match.groups())
    return rgb2xterm(r, g, b).to_ansi()

def bg_rgbsub(match):
    r, g, b = map(int, match.groups())
    return rgb2xterm(r, g, b).to_ansi(bg=True)

def colornamesub(match):
    name = match.group(1)
    return xterm_colors[name.lower()].to_ansi()

def bg_colornamesub(match):
    name = match.group(1)
    return xterm_colors[name.lower()].to_ansi(bg=True)

markup = {
    '<reset>': '\033[0m',
    '<bold>': '\033[01m',
    '<dim>': '\033[02m',
    '<italic>': '\033[03m',
    '<underlined>': '\033[04m',
    '<blink>': '\033[05m',
    '<reverse>': '\033[07m',
    '<hidden>': '\033[08m',
    '<strikethrough>': '\033[09m',
}

def styles():
    return [s[1:-1] for s in markup]

xterm_colors = {}
def load_colors():
    name_counter = defaultdict(int)
    # get current directory of this script
    script_dir = os.path.dirname(os.path.realpath(__file__))
    for j in json.load(open(os.path.join(script_dir, 'xterm_colors.json'))):
        name = j['name'].lower()
        if name in xterm_colors:
            name_counter[name] += 1
            name = f'{name}_{name_counter[name]}'
        xterm_colors[name] = AnsiColor.from_json(j, name)
load_colors()

def markup2ansi(text):
    for markup_tag, ansi_code in markup.items():
        text = text.replace(markup_tag, ansi_code)
    # replace <rgb:r,g,b> with nearest xterm color
    text = rgb_re.sub(rgbsub, text)
    # replace <bg_rgb:r,g,b> with nearest xterm color
    text = bg_rgb_re.sub(bg_rgbsub, text)
    # replace <colorname> with xterm color by name
    text = color_re.sub(colornamesub, text)
    # replace <bg_colorname> with xterm color by name
    text = bg_color_re.sub(bg_colornamesub, text)
    return text

def strip_markup(text):
    return markup_re.sub('', text)

def getcolors(text):
    AnsiColor.track()
    markup2ansi(text)
    return AnsiColor.colors

def line_width(line):
    return sum(2 if east_asian_width(c) == 'W' else 1 for c in line)

# typedef struct {
#     unsigned char bytes[CELL_MAXBYTES]; // the character bytes (with no ANSI escapes)
#     uint8_t len;                        // the number of bytes used
#     int16_t fg;                         // foreground color, -1 for default
#     int16_t bg;                         // background color, -1 for default
#     uint32_t flags;                     // cell flags
# } ui_cell_t;
# typedef struct {
#     ui_cell_t *cells;
#     int width;
#     int height;
# } ui_surface_t;
# typedef enum {
#     UI_SKIP                 = 0,    // Skip this cell (e.g. for wide characters)
#     UI_STYLE_RESET          = 1,    // Reset all attributes
#     UI_STYLE_BOLD           = 2,    // Bold text
#     UI_STYLE_DIM            = 4,    // Dim text
#     UI_STYLE_ITALIC         = 8,    // Italic text
#     UI_STYLE_UNDERLINE      = 16,   // Underlined text
#     UI_STYLE_BLINK          = 32,   // Blinking text
#     UI_STYLE_REVERSE        = 64,   // Reverse video
#     UI_STYLE_HIDDEN         = 128,  // Hidden text
#     UI_STYLE_STRIKETHROUGH  = 256,  // Strikethrough text
#     UI_STYLE_NONE           = 512,  // No style
#     UI_WIDE                 = 1024, // Wide character
# } ui_cell_flags_t;

class Character:
    NO_NL = object()
    def __init__(self, c, fg, bg, style):
        self.c = c
        self.fg = fg
        self.bg = bg
        self.style = style
        if not set(self.style) < set(styles()):
            raise ValueError(f'invalid style: {self.style}')
        if self.c != self.NO_NL:
            self.clen = len(self.c.encode())
            self.display_len = 2 if east_asian_width(self.c) == 'W' else 1
        else:
            self.clen = 0
            self.display_len = 0

    def chr2array(self, byte_len=4):
        enc = self.c.encode('utf-8').ljust(byte_len, b'\0')
        return '{ ' + ', '.join(f'0x{b:02x}' for b in enc)+ ' }'

    def ui_flags(self):
        flags = []
        if self.display_len == 2:
            flags.append('UI_WIDE')
        if not self.style:
            flags.append('UI_STYLE_NONE')
        else:
            flags += [f'UI_STYLE_{s.upper()}' for s in self.style]
        return '|'.join(flags)

    @staticmethod
    def ui_color(c):
        return 'XTERM_COLOR_' + c.unique_name.upper() if c else '-1'

    def ui_fg(self):
        return self.ui_color(self.fg)

    def ui_bg(self):
        return self.ui_color(self.bg)

    def to_ansi(self):
        fgcolor = self.fg.to_ansi() if self.fg else ''
        bgcolor = self.bg.to_ansi(bg=True) if self.bg else ''
        return fgcolor + bgcolor + ''.join(markup[s] for s in self.style) + self.c

    def to_struct(self, indent=2):
        assert self.c != self.NO_NL, 'NO_NL should never be rendered as a struct'
        ind = ' ' * indent*4
        ind_1 = ' ' * (indent+1)*4
        return \
f"""{ind}{{
{ind_1}.bytes = {self.chr2array()},
{ind_1}.len = {self.clen},
{ind_1}.fg = {self.ui_fg()},
{ind_1}.bg = {self.ui_bg()},
{ind_1}.flags = {self.ui_flags()},
{ind}}}"""

class Row:
    def __init__(self, chars, cols=None):
        self.chars = chars
        self.cols = cols

    def __len__(self):
        return len(self.chars)

    def __iter__(self):
        return iter(self.chars)

    def display_len(self):
        return sum(c.display_len for c in self.chars)

    def append(self, c):
        self.chars.append(c)

    def __bool__(self):
        return bool(self.chars)

    def pop(self):
        return self.chars.pop()

    def to_struct(self, indent=1):
        ind = ' ' * indent*4
        ind_1 = ' ' * (indent+1)*4
        s = ''
        s += f'{ind}{{\n'
        num_cols = 0
        for c in self.chars:
            s += c.to_struct(indent=indent+1) + ',\n'
            if c.display_len == 2:
                s += f'{ind_1}{{}}, // cjk padding\n'
                num_cols += 1
            num_cols += 1
            if num_cols == self.cols:
                break
        if num_cols < self.cols:
            s += f'{ind_1}// padding\n'
            s += f'{ind_1}{{}},\n' * (self.cols - num_cols)
        s += f'{ind}}}'
        return s

def chars2structs_h(chars, rows=24, cols=80, varname='cells'):
    s = f'extern ui_cell_t {varname}_cells[{rows}][{cols}];\n'
    # Surface
    s += '\n'
    s += f'extern ui_surface_t {varname};\n'

    return s

def chars2structs_c(chars, rows=24, cols=80, varname='cells'):
    s = f'ui_cell_t {varname}_cells[{rows}][{cols}] = {{\n'
    num_rows = 0
    current_row = Row([], cols)
    for c in chars:
        current_row.append(c)
        if c.c == '\n' or c.c == Character.NO_NL:
            if c.c == Character.NO_NL: # nonl
                current_row.pop()
            s += current_row.to_struct(indent=1) + ',\n'
            num_rows += 1
            current_row = Row([], cols)
        if num_rows == rows:
            break
    if current_row:
        s += current_row.to_struct(indent=1) + ',\n'
        num_rows += 1
    if num_rows < rows:
        for _ in range(rows - num_rows):
            s += Row([], cols).to_struct(indent=1) + ',\n'
    s += '};\n'
    # Surface
    s += '\n'
    s += f'ui_surface_t {varname} = {{\n'
    s += f'    .cells = (ui_cell_t *){varname}_cells,\n'
    s += f'    .width = {cols},\n'
    s += f'    .height = {rows},\n'
    s += '};\n'
    return s

# scanner regexes
# <rgb:r,g,b>
# <bg_rgb:r,g,b>
# <colorname>
# <bg_colorname>
# <[style]>
scanner_rgb_re = re.compile(r'<(bg_)?rgb:(\d+),(\d+),(\d+)>')
scanner_color_re = re.compile(r'<(bg_)?(\w+)>')
scanner_style_re = re.compile(r'<(' + '|'.join(s[1:-1] for s in markup) + r')>')
def scan(text):
    cursor = text
    chars = []
    current_fg = None
    current_bg = None
    current_style = OrderedDict()
    while cursor:
        if cursor.startswith('<nonl>\n'):
            # nonl is a special tag that prevents the next character from being a newline
            # while still allowing the row width to be calculated correctly
            chars.append(Character(Character.NO_NL, current_fg, current_bg, list(current_style.keys())))
            cursor = cursor[len('<nonl>\n'):]
        elif match := scanner_rgb_re.match(cursor):
            bg, r, g, b = match.groups()
            if bg:
                current_bg = rgb2xterm(int(r), int(g), int(b))
            else:
                current_fg = rgb2xterm(int(r), int(g), int(b))
            cursor = cursor[match.end():]
        elif match := scanner_style_re.match(cursor):
            style = match.group(1)
            if style == 'reset':
                current_fg = None
                current_bg = None
                current_style = OrderedDict()
            else:
                current_style[style] = True
            cursor = cursor[match.end():]
        elif match := scanner_color_re.match(cursor):
            bg, name = match.groups()
            if bg:
                current_bg = xterm_colors[name.lower()]
            else:
                current_fg = xterm_colors[name.lower()]
            cursor = cursor[match.end():]
        else:
            c = cursor[0]
            chars.append(Character(c, current_fg, current_bg, list(current_style.keys())))
            cursor = cursor[1:]
    return chars

def display_size(text):
    lines = text.splitlines()
    max_line_width = max(line_width(line) for line in lines) + 1
    max_line_height = len(lines)
    return max_line_width, max_line_height

def display_size_chars(chars):
    lines = 0
    maxcols = 0
    current_col = 0
    for c in chars:
        # If it ends with a newline, we *do* want to count that newline
        # toward the number of columns, but if it ends with NO_NL, we don't.
        # This happens automatically because for NO_NL, c.display_len is 0.
        current_col += c.display_len
        if c.c == '\n' or c.c == Character.NO_NL:
            lines += 1
            maxcols = max(maxcols, current_col)
            current_col = 0
    if current_col > 0:
        lines += 1
        maxcols = max(maxcols, current_col)
    return maxcols, lines

def single_file_output(out_text, outfile, ansi_output=True):
    if outfile == '-':
        sys.stdout.write(out_text)
        # reset colors
        if sys.stdout.isatty() and ansi_output:
            sys.stdout.write('\033[0m')
    else:
        with open(outfile, 'w') as f:
            f.write(out_text)

def single_file_input(infile):
    if infile == '-':
        return sys.stdin
    else:
        return open(infile)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('infile', nargs='*', help='input file',
                        default=[])
    parser.add_argument('-o', '--output', help='output file',
                        default='-')
    parser.add_argument('--mode', choices=[ 'markup2ansi', 'markup2structs', 'stripmarkup', 'getcolors', 'dumpcolors'],
                        help='conversion mode', default='markup2ansi')
    parser.add_argument('-n', '--varname', action='append', default=[], help='(markup2structs) variable name(s)')
    args = parser.parse_args()

    if not args.infile:
        args.infile.append('-')

    if args.mode == 'markup2structs':
        if not args.varname:
            for i in range(len(args.infile)):
                args.varname.append(f'cells_{i}')
        if len(args.infile) != len(args.varname):
            parser.error('number of input files must match number of variable names')
        if args.output == '-':
            parser.error('output must be a file in markup2structs mode')

    if args.mode == 'dumpcolors':
        colors = xterm_colors.items()
        out_text = ''
        out_text += f'/* Generated by {sys.argv[0]} */\n'
        out_text += '#pragma once\n\n'
        for name, color in sorted(colors, key=lambda x: x[1].code):
            colorname_def = f'XTERM_COLOR_{name.upper()}'
            out_text += f'#define {colorname_def:<30s} {color.code}\n'
        colorname_def = 'XTERM_COLOR_COUNT'
        out_text += f'#define {colorname_def:<30s} {len(colors)}\n\n'
        # Color names
        out_text += 'static const char *xterm_color_names[] __attribute__((unused)) = {\n'
        for name, color in sorted(colors, key=lambda x: x[1].code):
            out_text += f'    "{color.name}",\n'
        out_text += '};\n'
        single_file_output(out_text, args.output, ansi_output=False)
        return
    if args.mode == 'markup2ansi':
        for infile in args.infile:
            text = single_file_input(infile).read()
            out_text = markup2ansi(text)
            single_file_output(out_text, args.output, ansi_output=True)
    elif args.mode == 'getcolors':
        colors = getcolors(text)
        out_text = '\n'.join(f'{color.name} {color.code} {bg=}' for color, bg in colors) + '\n'
        # How many rows/columns do we need to display the text? Tricky because
        # unicode full width characters are counted as two columns.
        plain_text = strip_markup(text)
        w,h = display_size(plain_text)
        print(f'Display size: {w}x{h}')
        single_file_output(out_text, args.output, ansi_output=False)
    elif args.mode == 'markup2structs':
        name_h = args.output + '.h'
        name_c = args.output + '.c'
        with open(name_h, 'w') as f_h, open(name_c, 'w') as f_c:
            c = '#include "ui.h"\n'
            c += '#include "xterm_colors.h"\n'
            c += f'#include "{os.path.basename(name_h)}"\n\n'
            h = '#pragma once\n\n'
            h += '#include "ui.h"\n\n'
            for infile, varname in zip(args.infile, args.varname):
                text = single_file_input(infile).read()
                # collapse trailing newlines to a single newline
                while text.endswith('\n'):
                    text = text[:-1]
                text += '\n'
                plain_text = strip_markup(text)
                chars = scan(text)
                width, height = display_size_chars(chars)
                h += chars2structs_h(chars, height, width, varname=varname) + '\n'
                c += chars2structs_c(chars, height, width, varname=varname) + '\n'
            f_h.write(h)
            f_c.write(c)
    elif args.mode == 'stripmarkup':
        out_text = strip_markup(text)
        single_file_output(out_text, args.output, ansi_output=False)
    else:
        parser.error('invalid mode')

if __name__ == '__main__':
    main()
