// Memstrings with some modification to make it work on new panda version....

// This needs to be defined before anything is included in order to get
// the PRIx64 macro
#define __STDC_FORMAT_MACROS

#include <cstdio>
#include <cstdlib>
#include <ctype.h>
#include <math.h>
#include <map>
#include <fstream>
#include <sstream>
#include <string>
#include <iostream>

#include "panda/plugin.h"

extern "C" {
#include "memstrings.h"
}

#include "callstack_instr/callstack_instr.h"
#include "callstack_instr/callstack_instr_ext.h"

using namespace std;

// These need to be extern "C" so that the ABI is compatible with
// QEMU/PANDA, which is written in C
#include <wctype.h>
#include <zlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <map>

// These need to be extern "C" so that the ABI is compatible with
// QEMU/PANDA, which is written in C
extern "C" {

bool init_plugin(void *);
void uninit_plugin(void *);
int mem_write_callback(CPUState *env, target_ulong pc, target_ulong addr, target_ulong size, void *buf);
int mem_read_callback(CPUState *env, target_ulong pc, target_ulong addr, target_ulong size, void *buf);

}

//I did not know but apparently you can't just use the char buffer. You need to have something that is copy constructorable..
struct str_index {
    int counter;
    uint8_t flag[MAX_STRLEN];
};

struct ustr_index {
    int counter;
    uint8_t flag[MAX_STRLEN];
};



//code from memstrings and searchstrings plugin
std::map<target_ulong,str_index> read_text_tracker;
std::map<target_ulong,str_index> write_text_tracker;
std::map<target_ulong,ustr_index> read_utext_tracker;
std::map<target_ulong,ustr_index> write_utext_tracker;



gzFile gz_target = NULL;
int min_strlen;

int mem_callback(CPUState *env, target_ulong pc, target_ulong addr,
                       target_ulong size, void *buf, bool is_write) {

    //
    str_index & buffer = is_write ? write_text_tracker[pc] : read_text_tracker[pc];

    ustr_index &ubuffer = is_write ? write_utext_tracker[pc] : read_utext_tracker[pc];
    for (unsigned int i = 0; i < size; i++) {
	//get the char
        uint8_t character = ((uint8_t *)buf)[i];
	//catch all printable character..
        if (isprint(character)) {
            	buffer.flag[buffer.counter++] = character;
            // The length of the flag is unknown to the player but anywhere between 30-50 should catch the flag from the replay.
            if (buffer.counter == 31) {
                gzprintf(gz_target, "Instruction Counter - %llx, Possible Flag:%.*s\n", rr_get_guest_instr_count(), buffer.counter, buffer.flag);
                buffer.counter = 0;
            }
        }
        else {
	    //just reset the counter
            buffer.counter = 0;
        }
    }

    // Don't consider one-byte reads/writes for UTF-16
    if (size < 2) {
        return 1;
    }

    // UTF-16-LE
    for (unsigned int i = 0; i < size; i+=2) {
        uint8_t vall = ((uint8_t *)buf)[i];
        uint8_t valh = ((uint8_t *)buf)[i+1];
        uint16_t val = (valh << 8) | vall;
        if (iswprint(val)) {
            ubuffer.flag[ubuffer.counter++] = val;
            // If we max out the string, chop it
            if (ubuffer.counter == MAX_STRLEN - 1) {
                gsize bytes_written = 0;
                gchar *out_str = g_convert((gchar *)ubuffer.flag, ubuffer.counter*2,
                    "UTF-8", "UTF-16LE", NULL, &bytes_written, NULL);
                gzprintf(gz_target, "%llu:%s\n", rr_get_guest_instr_count(), out_str);
                g_free(out_str);
                ubuffer.counter = 0;
            }
        }
        else {
            // Don't bother with strings shorter than min
            if (ubuffer.counter >= min_strlen) {
                gsize bytes_written = 0;
                gchar *out_str = g_convert((gchar *)ubuffer.flag, ubuffer.counter*2,
                    "UTF-8", "UTF-16LE", NULL, &bytes_written, NULL);
                gzprintf(gz_target, "%llu:%s\n", rr_get_guest_instr_count(), out_str);
                g_free(out_str);
            }
            ubuffer.counter = 0;
        }
    }

    return 1;
}

int mem_read_callback(CPUState *env, target_ulong pc, target_ulong addr,
                       target_ulong size, void *buf) {
    return mem_callback(env, pc, addr, size, buf, false);

}

int mem_write_callback(CPUState *env, target_ulong pc, target_ulong addr,
                       target_ulong size, void *buf) {
    return mem_callback(env, pc, addr, size, buf, true);
}

bool init_plugin(void *self) {
    panda_cb pcb;

    printf("Initializing plugin memstrings\n");

    panda_arg_list *args = panda_get_args("memstrings");

    const char *prefix = panda_parse_string(args, "name", "memstrings");
    min_strlen = panda_parse_ulong(args, "len", 4);

    char matchfile[128] = {};
    sprintf(matchfile, "%s_strings.txt.gz", prefix);
    gz_target = gzopen(matchfile, "w");
    if(!gz_target) {
        printf("Couldn't write report:\n");
        perror("fopen");
        return false;
    }

    // Need this to get EIP with our callbacks
    panda_enable_precise_pc();
    // Enable memory logging
    panda_enable_memcb();



    pcb.virt_mem_before_write = mem_write_callback;
    panda_register_callback(self, PANDA_CB_VIRT_MEM_BEFORE_WRITE, pcb);
    pcb.virt_mem_after_read = mem_read_callback;
    panda_register_callback(self, PANDA_CB_VIRT_MEM_AFTER_READ, pcb);

    return true;
}

void uninit_plugin(void *self) {
    // Save any that we haven't flushed yet
    for (auto &kvp : read_text_tracker) {
        if (kvp.second.counter > min_strlen) {
            gzprintf(gz_target, "%llu:%.*s\n", rr_get_guest_instr_count(), kvp.second.counter, kvp.second.flag);
        }
    }
    for (auto &kvp : write_text_tracker) {
        if (kvp.second.counter > min_strlen) {
            gzprintf(gz_target, "%llu:%.*s\n", rr_get_guest_instr_count(), kvp.second.counter, kvp.second.flag);
        }
    }
    for (auto &kvp : read_utext_tracker) {
        if (kvp.second.counter > min_strlen) {
            gsize bytes_written = 0;
            gchar *out_str = g_convert((gchar *)kvp.second.flag, kvp.second.counter*2,
                "UTF-8", "UTF-16LE", NULL, &bytes_written, NULL);
            gzprintf(gz_target, "%llu:%s\n", rr_get_guest_instr_count(), out_str);
            g_free(out_str);
        }
    }
    for (auto &kvp : write_utext_tracker) {
        if (kvp.second.counter > min_strlen) {
            gsize bytes_written = 0;
            gchar *out_str = g_convert((gchar *)kvp.second.flag, kvp.second.counter*2,
                "UTF-8", "UTF-16LE", NULL, &bytes_written, NULL);
            gzprintf(gz_target, "%llu:%s\n", rr_get_guest_instr_count(), out_str);
            g_free(out_str);
        }
    }

    gzclose(gz_target);
}
