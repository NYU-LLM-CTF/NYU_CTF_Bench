#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <fcntl.h>
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#define BCODE_LEN 8096
#define KRX_LEN 32
#define STACK_SIZE 2048
#define MEM_ILLEGAL 0x7ffff0000000

typedef enum REG {
    KAX = 0x0A,
    KBX,
    KCX,
    KDX,
    KPC,
    KRX,
    KSP,
    KFLAGS
} REG;

enum KFLAGS { ZF, SF };

// Any opcodes not here are considered invalid
typedef enum OP {
    // Special for TVM
    DUMP_STATE = 0xDD,
    HALT = 0xFE,

    // Standards insts
    MOV  = 0x88,
    MOVI = 0x89,
    PUSH = 0xED,
    POP = 0xB1,
    ADD = 0xD3,
    ADDI = 0xC6,
    SUB = 0xD8,
    SUBI = 0xEF,
    MUL = 0x34,
    DIV = 0xB9,
    XOR = 0xB7,
    CMP = 0xCC,
    JMP = 0x96,
    JE = 0x81,
    JNE = 0x9E,
    JG = 0x2F,
    JGE = 0xF4,
    JL = 0x69,
    JLE = 0x5F,

    // Crypto insts
    LDF = 0xD9,
    AGE = 0x9B,
    AGD = 0x7F,

    // SECRET
    RSC = 0x42,
    RSC_1 = 0x3F
} OP;

typedef struct {
    uint32_t usage_ctr;
    uint8_t IV[12];
    EVP_CIPHER_CTX *ctx;
} gcm_t;

typedef struct {
    // General purpose registers
    uint64_t kax;
    uint64_t kbx;
    uint64_t kcx;
    uint64_t kdx;

    uint64_t kpc;          // Instruction pointer
    uint8_t  krx[KRX_LEN]; // Array reg
    uint64_t ksp;          // Stack pointer
    uint8_t  kflags;       // Comparison flags

    // Misc state
    bool     running;
    uint8_t* bc;
    uint64_t bc_len;
    gcm_t*   gcm;
    uint8_t  gcm_key[32];
    uint64_t stack[STACK_SIZE];
} tvm_state_t;

// Crypto stuff {{{
void init_crypto(gcm_t *gcm, EVP_CIPHER_CTX *ctx) {
    // Generate a new IV
    memset(gcm, 0, sizeof(gcm_t));
    RAND_bytes(gcm->IV, sizeof(gcm->IV));

    // Init the ctx
    if (ctx == NULL) ctx = EVP_CIPHER_CTX_new();
    gcm->ctx = ctx;
}

void gcm_encrypt(gcm_t *gcm, uint8_t *key, uint8_t *pt, uint8_t pt_len, uint8_t *ct) {
    int len = 0;
    EVP_EncryptInit_ex(gcm->ctx, EVP_aes_256_gcm(), NULL, key, gcm->IV);
    EVP_EncryptUpdate(gcm->ctx, ct, &len, pt, pt_len);
    EVP_EncryptFinal_ex(gcm->ctx, ct + len, &len);
}

void gcm_decrypt(gcm_t *gcm, uint8_t *key, uint8_t *ct, uint8_t ct_len, uint8_t *pt) {
    int len = 0;
    EVP_DecryptInit_ex(gcm->ctx, EVP_aes_256_gcm(), NULL, key, gcm->IV);
    EVP_DecryptUpdate(gcm->ctx, pt, &len, ct, ct_len);
}
// }}}

// "signal handlers" {{{

void _SIGSEGV(tvm_state_t *tvm, uint64_t addr) {
    printf("\n!!! SIGSEGV: Illegal memory access at 0x%016lX !!!\n", addr);
    tvm->running = false;
}

void _SIGSEGV_bc(tvm_state_t *tvm) {
    printf("\n!!! SIGSEGV: Illegal bytecode access at 0x%016lX !!!\n", tvm->kpc);
    tvm->running = false;
}

void _SIGILL(tvm_state_t *tvm) {
    printf("\n!!! SIGILL: Illegal instruction found at 0x%016lX !!!\n", tvm->kpc);
    tvm->running = false;
}

void _SIGFPE_dz(tvm_state_t *tvm) {
    printf("\n!!! SIGFPE: Division by zero at 0x%016lX !!!\n", tvm->kpc);
    tvm->running = false;
}
// }}}

// Register helpers {{{

bool ksp_range_valid(tvm_state_t *tvm) {
    return tvm->ksp < (STACK_SIZE - 1) * sizeof(uint64_t);
    /*uint64_t ksp_tgt = (uint64_t ) tvm->ksp;*/
    /*printf("%p %lX %p\n", tvm->stack, tvm->ksp, &tvm->stack[STACK_SIZE - 1]);*/
    /*return tvm->stack <= ksp_tgt && ksp_tgt < &tvm->stack[STACK_SIZE - 1];*/
}

uint8_t get_bit(uint8_t n, uint8_t bit) {
    return (n >> bit) & 1;
}

uint8_t set_bit(uint8_t n, uint8_t bit) {
    return n | (1 << bit);
}

uint8_t get_flag(tvm_state_t *tvm, enum KFLAGS f) {
    return get_bit(tvm->kflags, f);
}

void set_flag(tvm_state_t *tvm, enum KFLAGS f) {
    tvm->kflags = set_bit(tvm->kflags, f);
}

void set_reg(tvm_state_t *tvm, REG r, uint64_t val) {
    switch (r) {
        case KAX: tvm->kax = val; break;
        case KBX: tvm->kbx = val; break;
        case KCX: tvm->kcx = val; break;
        case KDX: tvm->kdx = val; break;
        case KPC: tvm->kpc = val; break;
        case KSP: tvm->ksp = val; break;
        default: _SIGILL(tvm); break;
    }
}

uint64_t get_reg(tvm_state_t *tvm, REG r) {
    switch (r) {
        case KAX: return tvm->kax;
        case KBX: return tvm->kbx;
        case KCX: return tvm->kcx;
        case KDX: return tvm->kdx;
        case KPC: return tvm->kpc;
        case KSP: return tvm->ksp;
        default: _SIGILL(tvm); return -1;
    }
}

// }}}

// Instruction implementation {{{

bool __arg_fail(tvm_state_t *tvm, uint64_t n) {
    if (n > 0 && tvm->kpc + n >= tvm->bc_len) {
        _SIGSEGV_bc(tvm);
        return true;
    }
    return false;
}

#define INST_NEW(name, arglen) \
    void op_##name (tvm_state_t *tvm) { \
        int __n_args = (arglen); \
        if (__arg_fail(tvm, __n_args)) return;

#define INST_END \
        tvm->kpc += __n_args; }

INST_NEW(DUMP_STATE, 0)
    printf("\n----- TVM State Dump -----\n");
    printf("KAX: 0x%016lX\n", tvm->kax);
    printf("KBX: 0x%016lX\n", tvm->kbx);
    printf("KCX: 0x%016lX\n", tvm->kcx);
    printf("KDX: 0x%016lX\n", tvm->kdx);
    printf("KPC: 0x%016lX\n", tvm->kpc);
    printf("KSP: 0x%016lX\n", tvm->ksp);

    // Dump array reg as bytes
    printf("KRX: [ ");
    for (int i = 0; i < KRX_LEN; ++i) printf("%02X ", tvm->krx[i]);
    printf("]\n");

    // Dump all the flags
    printf("KFLAGS: ");
    printf(get_flag(tvm, ZF) ? "[ZF] " : "ZF ");
    printf(get_flag(tvm, SF) ? "[SF] " : "SF ");
    printf("\n");

    // Stack dump
    printf("\n----- TVM Stack Dump -----\n");
    // Dump full stack if we are in range
    if (ksp_range_valid(tvm)) {
        for (int64_t addr=tvm->ksp; addr >= 0; addr -= sizeof(uint64_t)) {
            printf("0x%016lX: 0x%016lX\n", addr, tvm->stack[addr / sizeof(uint64_t)]);
        }
    } else {
        // Dump some memory from wherever KSP is
        for (int i=0; i < 8; ++i) {
            uint64_t addr = tvm->ksp - (i * sizeof(uint64_t));
            if (addr < MEM_ILLEGAL) {
                printf("0x%016lX: 0x%016lX\n", addr, *((uint64_t *) addr));
            } else {
                printf("<!!! Illegal memory access at 0x%016lX !!!>\n", addr);
            }
        }
    }

    printf("\nTVM RUNNING: %d\n\n", tvm->running);
INST_END


INST_NEW(MOV, 2)
    // Get regs
    REG dst = tvm->bc[tvm->kpc + 1];
    REG src = tvm->bc[tvm->kpc + 2];

    // Move value
    set_reg(tvm, dst, get_reg(tvm, src));
INST_END


INST_NEW(MOVI, 1 + sizeof(uint64_t))
    // Move value
    REG dst = tvm->bc[tvm->kpc + 1];
    uint64_t *src = (uint64_t *) &tvm->bc[tvm->kpc + 2];
    set_reg(tvm, dst, *src);
INST_END

void __push(tvm_state_t *tvm, uint64_t val) {
    tvm->ksp += sizeof(uint64_t);

    // Push the value
    if (ksp_range_valid(tvm)) {
        tvm->stack[tvm->ksp / sizeof(uint64_t)] = val;
    } else if (tvm->ksp < MEM_ILLEGAL) {
        *((uint64_t *) tvm->ksp) = val;
    } else {
        _SIGSEGV(tvm, tvm->ksp);
    }
}

INST_NEW(PUSH, 1)
    REG src = tvm->bc[tvm->kpc + 1];

    if (src == KRX) {
        // Push every 8 bytes onto the stack
        uint64_t *krx = (uint64_t *) tvm->krx;
        for (size_t i=0; i < KRX_LEN / sizeof(uint64_t); ++i) {
            __push(tvm, krx[i]);
        }
    } else {
        __push(tvm, get_reg(tvm, src));
    }
INST_END

uint64_t __pop(tvm_state_t *tvm) {
    if (ksp_range_valid(tvm)) {
        uint64_t res = tvm->stack[tvm->ksp / sizeof(uint64_t)];
        if (tvm->ksp >= sizeof(uint64_t)) {
            tvm->ksp -= sizeof(uint64_t);
        } else {
            tvm->ksp = 0;
        }
        return res;
    } else {
        _SIGSEGV(tvm, tvm->ksp);
        return -1;
    }
}

INST_NEW(POP, 1)
    REG dst = tvm->bc[tvm->kpc + 1];

    // Pop the value
    if (dst == KRX) {
        // Pop 8 bytes at a time, starting at the end
        uint64_t *krx = (uint64_t *) tvm->krx;
        for (ssize_t i = (KRX_LEN / sizeof(uint64_t)) - 1; i >= 0; --i) {
            krx[i] = __pop(tvm);
        }
    } else {
        set_reg(tvm, dst, __pop(tvm));
    }
INST_END


INST_NEW(ADD, 2)
    // Get regs
    REG dst = tvm->bc[tvm->kpc + 1];
    REG src = tvm->bc[tvm->kpc + 2];

    // Store sum
    set_reg(tvm, dst, get_reg(tvm, dst) + get_reg(tvm, src));
INST_END


INST_NEW(ADDI, 1 + sizeof(uint64_t))
    REG dst = tvm->bc[tvm->kpc + 1];
    uint64_t *src = (uint64_t *) &tvm->bc[tvm->kpc + 2];

    set_reg(tvm, dst, get_reg(tvm, dst) + *src);
INST_END


INST_NEW(SUB, 2)
    // Get regs
    REG dst = tvm->bc[tvm->kpc + 1];
    REG src = tvm->bc[tvm->kpc + 2];

    // Store difference
    set_reg(tvm, dst, get_reg(tvm, dst) - get_reg(tvm, src));
INST_END


INST_NEW(SUBI, 1 + sizeof(uint64_t))
    REG dst = tvm->bc[tvm->kpc + 1];
    uint64_t *src = (uint64_t *) &tvm->bc[tvm->kpc + 2];

    set_reg(tvm, dst, get_reg(tvm, dst) - *src);
INST_END


INST_NEW(MUL, 2)
    // Get regs
    REG dst = tvm->bc[tvm->kpc + 1];
    REG src = tvm->bc[tvm->kpc + 2];

    // Store product
    set_reg(tvm, dst, get_reg(tvm, dst) * get_reg(tvm, src));
INST_END


INST_NEW(DIV, 0)
    if (tvm->kcx == 0) {
        _SIGFPE_dz(tvm);
        return;
    }

    tvm->kax = tvm->kbx / tvm->kcx;
    tvm->kdx = tvm->kbx % tvm->kcx;
INST_END


INST_NEW(XOR, 2)
    // Get regs
    REG dst = tvm->bc[tvm->kpc + 1];
    REG src = tvm->bc[tvm->kpc + 2];

    // Store xor
    set_reg(tvm, dst, get_reg(tvm, dst) ^ get_reg(tvm, src));
INST_END


INST_NEW(CMP, 2)
    // Clear flags
    tvm->kflags = 0;

    // Get signed values to compare
    int64_t v1 = get_reg(tvm, tvm->bc[tvm->kpc + 1]);
    int64_t v2 = get_reg(tvm, tvm->bc[tvm->kpc + 2]);

    // Subtract and set flags
    v1 -= v2;
    if (v1 < 0)  set_flag(tvm, SF);
    if (v1 == 0) set_flag(tvm, ZF);
INST_END


INST_NEW(JMP, 2)
    tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
INST_END


INST_NEW(JE, 2)
    if (get_flag(tvm, ZF)) {
        tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
    }
INST_END


INST_NEW(JNE, 2)
    if (!get_flag(tvm, ZF)) {
        tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
    }
INST_END


INST_NEW(JG, 2)
    if(!get_flag(tvm, ZF) && !get_flag(tvm, SF)) {
        tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
    }
INST_END


INST_NEW(JGE, 2)
    if (!get_flag(tvm, SF)) {
        tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
    }
INST_END


INST_NEW(JL, 2)
    if (get_flag(tvm, SF)) {
        tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
    }
INST_END


INST_NEW(JLE, 2)
    if (get_flag(tvm, ZF) || get_flag(tvm, SF)) {
        tvm->kpc += *((int16_t *) &tvm->bc[tvm->kpc + 1]);
    }
INST_END


void __reset_crypto(tvm_state_t *tvm) {
    gcm_t *gcm = (gcm_t *) malloc(sizeof(gcm_t));
    init_crypto(gcm, tvm->gcm->ctx);
    tvm->gcm = gcm; // oops didn't free
}

INST_NEW(LDF, 0)
    uint8_t flag[KRX_LEN];
    memset(flag, 0, sizeof(flag));

    int fd = open("./flag", O_RDONLY);
    read(fd, flag, sizeof(flag));
    close(fd);

    // May need to regen IV
    if (tvm->gcm->usage_ctr != 0) {
        RAND_bytes(tvm->gcm->IV, sizeof(tvm->gcm->IV));
    }

    gcm_encrypt(tvm->gcm, tvm->gcm_key, flag, sizeof(flag), tvm->krx);

    memset(flag, 0, sizeof(flag));

    // CHANGE IV
    __reset_crypto(tvm);
INST_END


INST_NEW(AGE, 1)
    uint64_t src_addr = get_reg(tvm, tvm->bc[tvm->kpc + 1]);

    // Check if this is within the stack
    if (src_addr <= (STACK_SIZE - 4) * sizeof(uint64_t)) {
        gcm_encrypt(tvm->gcm, tvm->gcm_key, &((uint8_t *) tvm->stack)[src_addr], KRX_LEN, tvm->krx);
    } else if (src_addr < MEM_ILLEGAL) {
        // Directly read from program memory
        gcm_encrypt(tvm->gcm, tvm->gcm_key, (uint8_t *) src_addr, KRX_LEN, tvm->krx);
    } else {
        _SIGSEGV(tvm, src_addr);
    }
    ++tvm->gcm->usage_ctr;
INST_END


INST_NEW(AGD, 0)
    gcm_decrypt(tvm->gcm, tvm->gcm_key, tvm->krx, KRX_LEN, tvm->krx);
INST_END


INST_NEW(RSC, 0)
    // Throw the old one's addr on the stack
    __push(tvm, (uint64_t) tvm->gcm);
    __reset_crypto(tvm);
INST_END

// }}}

// Main loop {{{

// Sorry anthony <3
# define ICASE(INST) \
    case INST: op_##INST(&tvm); break;

int exec_bytecode(uint8_t *bc, uint64_t bc_len) {
    // Initialize TVM state
    tvm_state_t tvm;
    memset(&tvm, 0, sizeof(tvm_state_t));
    tvm.bc = bc;
    tvm.bc_len = bc_len;
    tvm.running = true;

    // Init crypto state
    tvm.gcm = (gcm_t *) malloc(sizeof(gcm_t));
    init_crypto(tvm.gcm, NULL);
    RAND_bytes(tvm.gcm_key, sizeof(tvm.gcm_key));


    // Main execution loop
    while (tvm.running) {
        // Verify instruction ptr
        if (tvm.kpc >= bc_len) {
            // Invalid pc, kill TVM
            _SIGSEGV_bc(&tvm);
            break;
        }

        // Fetch instruction
        int op = bc[tvm.kpc];

        // Decode / Execute
        switch(op) {
            ICASE(MOV);
            ICASE(MOVI);
            ICASE(PUSH);
            ICASE(POP);
            ICASE(DUMP_STATE);
            ICASE(ADD);
            ICASE(ADDI);
            ICASE(SUB);
            ICASE(SUBI);
            ICASE(MUL);
            ICASE(DIV);
            ICASE(XOR);
            ICASE(CMP);
            ICASE(JMP);
            ICASE(JE);
            ICASE(JNE);
            ICASE(JG);
            ICASE(JGE);
            ICASE(JL);
            ICASE(JLE);
            ICASE(LDF);
            ICASE(AGE);
            ICASE(AGD);

            case HALT:
                tvm.running = false;
                break;

            case RSC:
                // Check for the second byte
                if(tvm.kpc < tvm.bc_len - 1 && \
                   tvm.bc[tvm.kpc + 1] == RSC_1) {
                    // Jump to the secret instruction
                    ++tvm.kpc;
                    op_RSC(&tvm);
                    break;
                }
                // Fall to SIGILL

            default:
                _SIGILL(&tvm);
                break;
        }

        // Move to next instruction
        ++tvm.kpc;
    }

    printf("\n\nTVM Halted! Dumping final state...\n\n");
    op_DUMP_STATE(&tvm);
    return 0;
}

int main() {

    uint8_t bcode[BCODE_LEN];
    memset(bcode, 0xFF, sizeof(bcode));

    printf("##############################################\n");
    printf("### Welcome to the Trusted Virtual Machine ###\n");
    printf("##############################################\n\n");
    printf("Enter your bytecode:\n");

    // Read in raw bytecode
    int r = read(0, bcode, sizeof(bcode) - 1);
    if (r > 0) {
        bcode[r] = HALT;
        exec_bytecode(bcode, r + 1);
    } else {
        printf("ERROR: no bytecode provided. Exiting tvm->..\n");
        return 1;
    }

    return 0;
}
// }}}
