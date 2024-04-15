/*
 * lfsr.h | Linear Feedback Shift Register
 *
 * Copyright (c) 2013 Alexander Taylor <ajtaylor@fuzyll.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */


#ifndef _LFSR_H_
#define _LFSR_H_

#include <stdint.h>

extern void _lfsr_init(uint32_t, uint8_t, uint8_t, uint8_t, uint8_t);
extern uint32_t _lfsr_next();

static struct {
    void (*init)(uint32_t, uint8_t, uint8_t, uint8_t, uint8_t);
    uint32_t (*next)();
    uint32_t state;
    uint8_t tap1;
    uint8_t tap2;
    uint8_t tap3;
    uint8_t tap4;
} lfsr = { &_lfsr_init, &_lfsr_next, 0, 0, 0, 0, 0 };

void _lfsr_init(uint32_t seed, uint8_t tap1, uint8_t tap2, uint8_t tap3, uint8_t tap4)
{
    // check for valid tap values
    if (tap1 > 32 || tap2 > 32 || tap3 > 32 || tap4 > 32) {
        warnx("Supplied tap values out of range");
        return;
    }

    // initialize LFSR state
    lfsr.state = seed;
    lfsr.tap1 = 32 - tap1;
    lfsr.tap2 = 32 - tap2;
    lfsr.tap3 = 32 - tap3;
    lfsr.tap4 = 32 - tap4;
}

uint32_t _lfsr_next()
{
    uint32_t bit  = ( (lfsr.state >> lfsr.tap1) ^ (lfsr.state >> lfsr.tap2) ^
                      (lfsr.state >> lfsr.tap3) ^ (lfsr.state >> lfsr.tap4) ) & 1;
    lfsr.state = (lfsr.state >> 1) | (bit << 31);
    return lfsr.state;
}

#endif
