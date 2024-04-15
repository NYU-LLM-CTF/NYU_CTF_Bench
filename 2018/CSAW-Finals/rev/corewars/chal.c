#include <stdio.h>
#include <fcntl.h>
#include <sys/resource.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <dlfcn.h>
#include <gnu/libc-version.h>


/*
		if (cprm.limit == 1) {
			/ *
			 * Normally core limits are irrelevant to pipes, since
			 * we're not writing to the file system, but we use
			 * cprm.limit of 1 here as a speacial value. Any
			 * non-1 limit gets set to RLIM_INFINITY below, but
			 * a limit of 0 skips the dump.  This is a consistent
			 * way to catch recursive crashes.  We can still crash
			 * if the core_pattern binary sets RLIM_CORE =  !1
			 * but it runs as root, and can do lots of stupid things
			 * Note that we use task_tgid_vnr here to grab the pid
			 * of the process group leader.  That way we get the
			 * right pid if a thread in a multi-threaded
			 * core_pattern process dies.
			 * /
			printk(KERN_WARNING
				"Process %d(%s) has RLIMIT_CORE set to 1\n",
				task_tgid_vnr(current), current->comm);
			printk(KERN_WARNING "Aborting core\n");
			goto fail_unlock;
		}
		cprm.limit = RLIM_INFINITY;
*/


/*
void xor(const char* in, char* out, const char* key, int len) {
    for (int i=0; i<len; in++, i++, out++) {
        *out = *in^key[i%5];
    }
}
*/
void parse();
void* core;
FILE* f;

void cleanup() {
    free(core);
    //fflush(f);
}


int depth;

/*
void crash() {
    //fflush(f);
    //fclose(f);
    *(char*)(0) = 1;
}
*/

struct vm_reg {
    uint64_t magic;
    uint64_t r0;
    uint64_t r1;
    uint64_t ip;
    char flag[64];
};

void start() {
    struct vm_reg* vm = calloc(sizeof(struct vm_reg),1);
    vm->magic = 0x57415343;
    vm->ip=0;

    //fprintf(f,"vm at %p\n",vm);
    //fflush(f);
    //fclose(f);
    //*(char*)(0) = 1;
    depth = 1/0;
}


uint8_t* read_fd(int fd) {
    size_t size = 4096;
    size_t filled = 0;
    uint8_t* core = malloc(size);
    while (1) {
        size_t n = read(fd, core+filled, size-filled);
        if (n == 0)
            break;
        filled += n;
        if (filled == size) {
            size *= 2;
            core = realloc(core, size);
        }
    }
    return core;
}


struct vmap {
    uint32_t p_type;
    uint32_t p_flags;
    uint64_t p_offset;
    uint64_t p_vaddr;
    uint64_t p_paddr;
    uint64_t p_filesz;
    uint64_t p_memsz;
    uint64_t p_align;
}* maps;

uint16_t phnum;
uint64_t heap;

struct sig {
    int	si_signo;
    int	si_code;
    int	si_errno;
    int pr_cursig;
}* sig_info;

struct user_regs_struct {
	unsigned long	r15;
	unsigned long	r14;
	unsigned long	r13;
	unsigned long	r12;
	unsigned long	rbp;
	unsigned long	rbx;
	unsigned long	r11;
	unsigned long	r10;
	unsigned long	r9;
	unsigned long	r8;
	unsigned long	rax;
	unsigned long	rcx;
	unsigned long	rdx;
	unsigned long	rsi;
	unsigned long	rdi;
	unsigned long	orig_ax;
	unsigned long	rip;
	unsigned long	rcs;
	unsigned long	flags;
	unsigned long	rsp;
	unsigned long	ss;
	unsigned long	fs_base;
	unsigned long	gs_base;
	unsigned long	ds;
	unsigned long	es;
	unsigned long	fs;
	unsigned long	gs;
}* regs;

uint64_t addr_of(void* addr) {
    if (addr == (void*)-1)
        return -1;
    for (int i = 0; i<phnum; i++) {
        if (maps[i].p_type != 1)
            continue;
        uint64_t diff = (uint64_t)addr-maps[i].p_vaddr;
        if (maps[i].p_vaddr <= (uint64_t)addr && diff < maps[i].p_filesz) {
            return maps[i].p_offset+diff;
        }
    }
    return -1;
}

uint64_t read64(void* addr) {
    uint64_t pa = addr_of(addr);
    if (pa == -1)
        return pa;
    return *(uint64_t*)pa;
}

uint64_t code[] = \
                  {0x1,0x0,0x5,0x8,0x3,0x35,0x4,0x2,0x5,0x8,0x3,0x1a,0x4,0x2,0x5,0x8,0x3,0x28,0x4,0x2,0x5,0x8,0x3,0xe,0x4,0x2,0x3,0xd305d17c482b0422,0x2,0x3,0xd305d17c10126448,0x6,0x1,0x0,0x5,0x8,0x3,0x27,0x4,0x2,0x5,0x8,0x3,0x19,0x4,0x2,0x5,0x8,0x3,0x1c,0x4,0x2,0x5,0x8,0x3,0x13,0x4,0x2,0x3,0xd202f9023db7d10e,0x2,0x3,0xd202f90265d99d20,0x6,0x1,0x0,0x5,0x8,0x3,0x32,0x4,0x2,0x5,0x8,0x3,0x22,0x4,0x2,0x5,0x8,0x3,0x31,0x4,0x2,0x5,0x8,0x3,0x17,0x4,0x2,0x3,0xcbc9cb73cc0c9b2c,0x2,0x3,0xcbc9cb738575b951,0x6,0x1,0x0,0x5,0x8,0x3,0x26,0x4,0x2,0x5,0x8,0x3,0x2c,0x4,0x2,0x5,0x8,0x3,0x23,0x4,0x2,0x5,0x8,0x3,0x25,0x4,0x2,0x3,0xff4a3497f543cb12,0x2,0x3,0xff4a3497947fab44,0x6,0x1,0x0,0x5,0x8,0x3,0xd,0x4,0x2,0x5,0x8,0x3,0x37,0x4,0x2,0x5,0x8,0x3,0x5,0x4,0x2,0x5,0x8,0x3,0x30,0x4,0x2,0x3,0x4b14ac742fc2716,0x2,0x3,0x4b14ac771fc0567,0x6,0x1,0x0,0x5,0x8,0x3,0x24,0x4,0x2,0x5,0x8,0x3,0x4,0x4,0x2,0x5,0x8,0x3,0x1f,0x4,0x2,0x5,0x8,0x3,0x8,0x4,0x2,0x3,0xb7e2f67c78709172,0x2,0x3,0xb7e2f67c2022dd19,0x6,0x1,0x0,0x5,0x8,0x3,0x1e,0x4,0x2,0x5,0x8,0x3,0x2d,0x4,0x2,0x5,0x8,0x3,0x29,0x4,0x2,0x5,0x8,0x3,0x16,0x4,0x2,0x3,0xa6362bdf7263ff6b,0x2,0x3,0xa6362bdf452adb1c,0x6,0x1,0x0,0x5,0x8,0x3,0x2a,0x4,0x2,0x5,0x8,0x3,0x33,0x4,0x2,0x5,0x8,0x3,0x14,0x4,0x2,0x5,0x8,0x3,0xa,0x4,0x2,0x3,0x5f852a92e1e19e02,0x2,0x3,0x5f852a92938bd275,0x6,0x1,0x0,0x5,0x8,0x3,0x7,0x4,0x2,0x5,0x8,0x3,0x18,0x4,0x2,0x5,0x8,0x3,0x2e,0x4,0x2,0x5,0x8,0x3,0x1d,0x4,0x2,0x3,0xf5007e1fab6338a,0x2,0x3,0xf5007e1a2e47fd7,0x6,0x1,0x0,0x5,0x8,0x3,0x10,0x4,0x2,0x5,0x8,0x3,0x11,0x4,0x2,0x5,0x8,0x3,0x2b,0x4,0x2,0x5,0x8,0x3,0x15,0x4,0x2,0x3,0x39d98cfd990bc965,0x2,0x3,0x39d98cfdec36aa49,0x6,0x1,0x0,0x5,0x8,0x3,0x1b,0x4,0x2,0x5,0x8,0x3,0xf,0x4,0x2,0x5,0x8,0x3,0x36,0x4,0x2,0x5,0x8,0x3,0x20,0x4,0x2,0x3,0x72bf4cb8c184e70a,0x2,0x3,0x72bf4cb8a8d6d57f,0x6,0x1,0x0,0x5,0x8,0x3,0xc,0x4,0x2,0x5,0x8,0x3,0x6,0x4,0x2,0x5,0x8,0x3,0x9,0x4,0x2,0x5,0x8,0x3,0x2f,0x4,0x2,0x3,0xfbf4642fa8238b1b,0x2,0x3,0xfbf4642ff05acd56,0x6,0x1,0x0,0x5,0x8,0x3,0x34,0x4,0x2,0x5,0x8,0x3,0xb,0x4,0x2,0x5,0x8,0x3,0x21,0x4,0x2,0x5,0x8,0x3,0x12,0x4,0x2,0x3,0x412a1140866f3ec8,0x2,0x3,0x412a1140b4571dbe,0x6,0x7};

void op_1() {
}

uint64_t code_r(struct vm_reg* vm) {
    return code[vm->ip++];
}

uint64_t start_next(struct vm_reg* vm) {
    char buff[0];
    uint64_t imm = 0;
    uint64_t op = code_r(vm);
    //fprintf(f, "[%lx] Op is %lx\n",vm->ip-1, op);

    cleanup();

    if (op == 1) {
        imm = code_r(vm);
        //fprintf(f, "Imm is %lx\n",imm);
        //fflush(f);
        //fclose(f);
        depth = imm / 0;
    }
    if (op == 3) {
        imm = code_r(vm);
        //fprintf(f, "Imm is %lx\n",imm);
        //fflush(f);
        ((void(*)(uint64_t))0x5647455347495300)(imm);
    }
    if (op == 2) {
        char* bad = malloc(10);
        free(bad);
        free(bad);
    }
    if (op == 5) {
        //fprintf(f, "copying onto stack\n");
        //fflush(f);
        strcpy(buff, "So much space on the stack, what could go wrong, you never know!");
        return code_r(vm);
    }
    if (op == 4) {
        //fprintf(f, "Causing an abort\n");
        //fflush(f);
        abort();

    }
    if (op == 6) {
        //fprintf(f, "Causing int3\n");
        //fflush(f);
        void (*p)(void) = (void(*)(void))(((uint64_t)parse)+780);
        p();
    }

    if (op == 7) {
        //fprintf(f, "WON!\n");
        //fflush(f);
        FILE* flag_f = fopen("/tmp/flag","w");
        fprintf(flag_f, "flag{%s}\n", vm->flag+4);
        fflush(flag_f);
        fclose(flag_f);
        exit(0);
    }
    return 0;
}

int walk_abort() {
    if (sig_info->si_signo != 6)
        return 0;
    void* frame = (void*)regs->rbp;
    uint64_t last_call = read64(frame+8);
    //fprintf(f, "last_call is %p\n",last_call);
    //fflush(f);
    if ((last_call & (~0xffffff)) == 0)  {
        return 1;
    }
    return 0;
}

int walk_double_free() {
    void* frame = (void*)regs->rbp;
    uint64_t last_call = read64(frame+8);
    //fprintf(f, "last_call is %p\n",last_call);
    last_call = (uint64_t)addr_of((void*)last_call);
    //fprintf(f, "last_call is %p\n",last_call);
    fflush(f);
    if (last_call == 0xffffffffffffffff) {
        return 0;
    }
    for (int i=0; i<0x100; i++) {
        uint64_t v = *(uint32_t*)(last_call-i);
        if ((v&0xffffff) == 0x358d48) {
            //fprintf(f, "Found lea\n");
            fflush(f);
            v = *(uint32_t*)(last_call-i+3);
            v += last_call-i+7;
            //fprintf(f, "Addr = %p\n",v);
            //fprintf(f, "str = %s\n",v);
            if (*(uint32_t*)v == 0x202a2a2a) {
                return 1;
            }
        }
    }
    return 0;
}

char* find_flag() {
    char* ptr = (char*)addr_of((void*)regs->rsp);

    while(1) {
        if (!strncmp(ptr,"key=",4))
            return ptr;
        ptr++;
    }
}

int check_for_call() {
    if (sig_info->si_signo != 11)
        return 0;
    uint64_t pc = regs->rip;
    uint16_t* pcp = (char*)(pc);
    if (*pcp == 0xd0ff)
        return 1;
    return 0;
}

int check_for_return() {
    if (sig_info->si_signo != 11)
        return 0;
    uint64_t pc = regs->rip;
    uint8_t* pcp = (char*)(pc);
    if (*pcp == 0xc3)
        return 1;
    return 0;
}

void step_vm(struct vm_reg* vm) {
    // Find what the crash was to tell what opcode to run
    //
    //fprintf(f,"signum = %u\n",sig_info->si_signo);


    // OP 2
    // xor r0, r1
    // Trigger: Double Free
    if (walk_double_free()) {
        vm->r0 ^= vm->r1;
        //fprintf(f,"set r0 to %p via r0^r1\n",vm->r0);
        start_next(vm);
    }


    // OP 6
    // compare and exit if wrong
    if (sig_info->si_signo == 5) {
        //fprintf(f,"checking if r0 == r1 (%p == %p)\n",vm->r0,vm->r1);
        //fflush(f);
        if (vm->r0 != vm->r1) {
            exit(0);
        }
        start_next(vm);
    }
    // OP 5
    // shift up r0 by imm
    if (check_for_return()) {
        vm->r0 <<= regs->rax;
        //fprintf(f,"set r0 to %p via r0<<%lx\n",vm->r0,regs->rax);
        start_next(vm);
    }
    // OP 3
    // mov r1, imm
    // Trigger: bad call
    if (check_for_call()) {
        vm->r1 = regs->rdi;
        //fprintf(f,"set r1 to %p\n",regs->rdi);
        start_next(vm);
    }


    // OP 1
    // mov r0, imm
    // Trigger: Divide by 0
    if (sig_info->si_signo == 8) {
        vm->r0 = regs->rax;
        //fprintf(f,"set r0 to %p\n",regs->rax);
        start_next(vm);
    }




    // OP 4
    // fetch byte of flag
    // Trigger: abort
    if (walk_abort()) {
        //fprintf(f,"flag is: %s\n",vm->flag);
        uint64_t off = vm->r1&0x3f;
        vm->r1 = vm->flag[off];
        if (vm->r1 != 0) {
            //fprintf(f,"xoring flag[%lx] by %lx\n",off,(vm->ip & 0x1f));
            
            vm->flag[off] ^= (vm->ip & 0x1f);
        }
        
        //fprintf(f,"set r1 to %p via flag[%lx]\n",vm->r1, off);
        //fprintf(f,"%s\n",&(vm->flag[off]));
        start_next(vm);
    }
}

void* find_vm_reg() {
    void* ptr = (void*)heap;
    while (1) {
        //fprintf(f,"ptr %p\n",ptr);
        //fflush(f);
        uint64_t magic = read64(ptr+0x10);
        if (magic == 0x0000000057415343)
            return (void*)addr_of(ptr+0x10);
        uint64_t size = read64(ptr+8);
        size &= ~0xf;
        ptr += size;
    }
}


void* find_current_mapping(char* name, void* off) {
    char iname[128];

    int fd = open("/proc/self/maps",0,0);
    char* buff2 = read_fd(fd);
    //fprintf(f,"%s\n",buff2);
    //fflush(f);

    char* ptr = buff2;
    uint64_t start, end, ioff;

    while(1) {
        int res = sscanf(ptr, "%lx-%lx r--p %lx %*u:%*u %*u %s", &start, &end, &ioff, iname);
        if (res !=4)
            res = sscanf(ptr, "%lx-%lx r-xp %lx %*u:%*u %*u %s", &start, &end, &ioff, iname);
        if (res !=4)
            res = sscanf(ptr, "%lx-%lx ---p %lx %*u:%*u %*u %s", &start, &end, &ioff, iname);
        //fprintf(f, "res = %u Start is %p end is %p name is %s\n",res, start, end, iname);

        if (res == 4 && !strcmp(iname, name) && ioff/0x1000 == (uint64_t)off) {
            //fprintf(f,"Valid\n");
            //fflush(f);
            free(buff2);
            return (void*)start;
        }

        char* end = strchr(ptr, '\n');
        if (!end)
            break;
        *end = '\0';
        //fprintf(f,"%s\n",ptr);
        //fflush(f);
        ptr = end+1;
    }
    free(buff2);
    return NULL;
}

void parse() {
    core = read_fd(0);
    if (*(uint16_t*)(core+0x10) != 0x4) { //e_type == ET_CORE
        //fprintf(f,"Not a core\n");
        return;
    }
    phnum = *(uint16_t*)(core+0x38);

    uint16_t phsize = *(uint16_t*)(core+0x36);
    if (phsize != sizeof(struct vmap)) {
        //fprintf(f,"program headersize is bad\n");
        return;
    }

    uint64_t ph_off = *(uint64_t*)(core+0x20);
    maps = core+ph_off;

    struct vmap* note = NULL;

    //fprintf(f,"phnum = %u\n",phnum);
    for (int i = 0; i<phnum; i++) {
        if (maps[i].p_type == 4) // PT_NOTE
            note = &maps[i];
        if (maps[i].p_type != 1)
            continue;
        maps[i].p_offset += (uint64_t)core;
        if (maps[i].p_vaddr >= 0x0000000000604000 && maps[i].p_vaddr < 0x0000700000000000)
            heap = maps[i].p_vaddr;
        //fprintf(f,"%p + %p\n",maps[i].p_vaddr, maps[i].p_filesz);
    }

    if (note == NULL) {
        //fprintf(f,"no note section\n");
        return;
    }

    if (heap == 0) {
        //fprintf(f,"no heap section\n");
        return;
    }

    //fprintf(f,"Heap at %p\n",heap);

    note->p_offset += (uint64_t)core;
    void* ptr = (void*)note->p_offset;

    // Parse notes
    for (int i = 0; ptr-note->p_offset < note->p_filesz; i++) {
        uint32_t ns = *(uint32_t*)(ptr);
        uint32_t ds = *(uint32_t*)(ptr+4);
        uint32_t nt = *(uint32_t*)(ptr+0x8);

        // Padding because aaaa
        if (ns & 0x7)
            ns += 8-(ns & 0x7);
        if (ds & 0x7)
            ds += 8-(ds & 0x7);

        //fprintf(f, "ns is %u '%s'\n",ns,note->p_offset+0xc);
        //fprintf(f, "ds is %x\n",ds);
        //fprintf(f, "nt is %u\n",nt);

        ptr += 0xc+ns;
        if (nt == 1) { //prstatus
            sig_info = ptr;
            regs = ptr+14*8;
        }

        if (nt == 0x46494c45) { //file info
            uint64_t fc = *(uint64_t*)(ptr);
            ptr += 0x10;
            void* fend = ptr+0x18*fc;
            for (int i=0; i<fc; i++) {
                char* name = fend;
                fend += strlen(name) + 1;

                uint64_t f_start = *(uint64_t*)(ptr);
                uint64_t f_end = *(uint64_t*)(ptr+8);
                uint64_t f_off = *(uint64_t*)(ptr+0x10);
                //fprintf(f,"%p-%p %x, %s\n",f_start, f_end, f_off, name);

                // Check if missing
                for (int j = 0; j<phnum; j++) {
                    if (maps[j].p_type != 1)
                        continue;
                    //if (maps[j].p_vaddr < f_start || maps[j].p_vaddr >= f_end || maps[j].p_filesz != 0)
                    if (maps[j].p_vaddr != f_start || maps[j].p_filesz != 0)
                        continue;
                    //fprintf(f,"found match %p %p %p\n",maps[j].p_vaddr, maps[j].p_offset, maps[j].p_filesz);

                    void* new_addr = find_current_mapping(name, f_off);
                    //fprintf(f,"new addr = %p\n",new_addr);
                    if (new_addr) {
                        maps[j].p_vaddr -= f_off*0x1000;
                        maps[j].p_offset = new_addr-f_off*0x1000;
                        maps[j].p_filesz = f_end-f_start;
                    }
                    //fprintf(f,"== it is now %p %p %p\n",maps[j].p_vaddr, maps[j].p_offset, maps[j].p_filesz);
                    //fprintf(f,"test addr %p\n",addr_of(maps[j].p_vaddr));
                    //fflush(f);
                    break;

                }

                ptr += 0x18;
            }
        }
        ptr += ds;
    }
    
    /*
    for (int i=0; i<32*2; i++) {
        uint64_t d = *(uint64_t*)(ptr+8*i);
        fprintf(f, "%016lx\n",d);
    }
    */

    depth = read64(&depth)+1;
    //fprintf(f, "Current depth is %u\n",depth);
    //fflush(f);
    if (depth>400) {
        exit(0);
    }

    struct vm_reg* vm = calloc(sizeof(struct vm_reg),1);
    void* old_vm = find_vm_reg();
    memcpy(vm, old_vm, sizeof(struct vm_reg));

    //fprintf(f, "r0 is 0x%lx\n", vm->r0);
    //fprintf(f, "r1 is 0x%lx\n", vm->r1);
    //fprintf(f, "ip is 0x%lx\n", vm->ip);
    //fflush(f);

    if (vm->flag[0] == '\0') {
        char* flag = find_flag();
        strncpy(vm->flag, flag, 64);
    }

    step_vm(vm);
    //crash();
}

void chal() {
    alarm(5);
    struct rlimit cl;
    getrlimit(RLIMIT_CORE,&cl);
    //fprintf(f, "rlimit is %u\n",cl.rlim_cur);
    //fprintf(f, "rlimit is %u\n",cl.rlim_max);

    // The kernel sets rlimit to 1 as a flag that we are in core pattern
    if (cl.rlim_cur != 1) {
        //fprintf(f, "This is not core_pattern as far as I can tell\n");
        parse();
        return;
    }
    //fprintf(f, "In core_pattern\n");

    // Clear that flag so we can recurse more (BE VERY CAREFUL!)
    cl.rlim_cur = RLIM_INFINITY;
    cl.rlim_max = RLIM_INFINITY;
    int res = setrlimit(RLIMIT_CORE, &cl);

    parse();
}

void install(char* key) {

    if (geteuid() != 0) {
        printf("sudo ./chal key=<key>\n");
        printf("Don't you trust me?\n");
        return;
    }

    if (strncmp(key,"key=",4)) {
        printf("sudo ./chal key=<key>\n");
        return;
    }

    struct rlimit cl;
    cl.rlim_cur = RLIM_INFINITY;
    cl.rlim_max = RLIM_INFINITY;
    int res = setrlimit(RLIMIT_CORE, &cl);

    char buff[128];

    buff[readlink("/proc/self/exe",buff, 128)] = '\0';
    //printf("%s\n",buff);

    char cmd[128];
    sprintf(cmd, "echo '|%s' > /proc/sys/kernel/core_pattern", buff);

    //printf("%s\n",cmd);
    system(cmd);
    start();
    return;
}

int main(int argc, char** argv) {
    if (gnu_get_libc_version()[2] >= '2' && gnu_get_libc_version()[3] > '5') {
        printf("woah that libc is a bit too new :( (try ubuntu 16 c:)\n");
        return;
    }

    depth = 0;
    //f = fopen("/tmp/log","a");
    //fprintf(f,"====\n");
    if (argc == 2) {
        install(argv[1]);
        return;
    }
    printf("sudo ./chal key=<key>\n");
    /*
    //dlopen("libgcc_s.so.1", RTLD_LAZY);
    if (argc == 3 && !strcmp(argv[1],"install"))
        install(argv[2]);
    else if (argc >= 2 && !strcmp(argv[1],"crash"))
        start();
    else
    */
        chal();
        /*
    if (argc == 2 && !strcmp(argv[1],"pcrash"))
        crash();
        */


    //chal();
    //install(argv);

    /*
    */


}
