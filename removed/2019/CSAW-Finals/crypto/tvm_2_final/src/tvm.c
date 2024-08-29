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
#define IV_LEN 12
#define BLK_LEN 16
#define STACK_SIZE 2048
#define STACK_MAX_ADDR (STACK_SIZE * sizeof(uint64_t))
#define TRUST_SIZE 0x1000

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
    RDK = 0x92,

    // Standards insts
    MOV  = 0x88,
    MOVI = 0x89,
    MOVK = 0x91,
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

    // Auth insts
    ACB = 0xC4,
    ACR = 0xC5,

    // Crypto insts
    AGE = 0x9B,
    AGD = 0x7F,
} OP;

typedef struct {
    uint8_t IV[12];
    uint8_t key[32];
} gcm_t;


#pragma pack(push, 1)
typedef struct {
    uint8_t IV[12];
    uint8_t ctxt[8];
    uint8_t tag[12];
} chal_resp_t;
#pragma pack(pop)

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

    // Auth challenge
    bool     auth;
    bool     chal_given;
    uint64_t auth_chal;

    // Misc state
    bool     running;
    uint8_t* bc;
    uint64_t bc_len;
    gcm_t*   gcm;
    uint64_t stack[STACK_SIZE];
    uint8_t  trustzone[TRUST_SIZE];
} tvm_state_t;

// Crypto stuff {{{
void init_crypto(gcm_t *gcm) {
    // Generate a new IV + key
    memset(gcm, 0, sizeof(gcm_t));
    /*RAND_bytes(gcm->IV, sizeof(gcm->IV));*/

    if (!access("./key", F_OK)) {
        // Saved key exists
        int fd = open("./key", O_RDONLY);
        read(fd, gcm->key, sizeof(gcm->key));
        close(fd);
    } else {
        // Generate a new key
        RAND_bytes(gcm->key, sizeof(gcm->key));
        int fd = open("./key", O_WRONLY | O_CREAT | O_TRUNC, 0666);
        write(fd, gcm->key, sizeof(gcm->key));
        close(fd);
    }
}

void load_flag_trustzone(tvm_state_t *tvm) {
    uint8_t *ptr = tvm->trustzone;
    uint8_t flag[32] = {0};

    // load the flag
    int fd = open("./flag", O_RDONLY);
    int r = read(fd, flag, sizeof(flag));
    close(fd);
    if (r != sizeof(flag)) {
        printf("ERROR LOADING FLAG\n");
        exit(1);
    }

    // ehhh I think this has been hard enough, just have the flag there
    memcpy(tvm->trustzone, flag, sizeof(flag));
}

void gcm_encrypt(gcm_t *gcm, uint8_t *pt, uint8_t pt_len, uint8_t *ct, uint8_t *tag_out) {
    int len = 0;
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, gcm->key, gcm->IV);
    EVP_CIPHER_CTX_set_padding(ctx, 0);
    EVP_EncryptUpdate(ctx, ct, &len, pt, pt_len);
    EVP_EncryptFinal_ex(ctx, ct + len, &len);
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, BLK_LEN, tag_out);
    EVP_CIPHER_CTX_free(ctx); ctx = NULL;
}

void gcm_decrypt(gcm_t *gcm, uint8_t *ct, uint8_t ct_len, uint8_t *pt) {
    int len = 0;
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, gcm->key, gcm->IV);
    EVP_CIPHER_CTX_set_padding(ctx, 0);
    EVP_DecryptUpdate(ctx, pt, &len, ct, ct_len);
    EVP_CIPHER_CTX_free(ctx); ctx = NULL;
}
// }}}

// "signal handlers" {{{

void _SIGSEGV(tvm_state_t *tvm, uint64_t addr) {
    printf("\n!!! SIGSEGV: Illegal memory access at 0x%016lX !!!\n", addr);
    tvm->running = false;
}

void _SIGSEGV_auth(tvm_state_t *tvm, uint64_t addr) {
    printf("\n!!! SIGSEGV: Unauthenticated memory access at 0x%016lX !!!\n", addr);
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
    return tvm->ksp <= (STACK_SIZE - 1) * sizeof(uint64_t);
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
    int n = 10;
    int64_t end_addr = tvm->ksp - n*sizeof(uint64_t);
    if (end_addr < 0) end_addr = 0;

    for (int64_t addr=tvm->ksp; addr >= end_addr; addr -= sizeof(uint64_t)) {
        if (addr <= (STACK_SIZE - 1) * sizeof(uint64_t)) {
            printf("0x%016lX: 0x%016lX\n", addr, tvm->stack[addr / sizeof(uint64_t)]);
        } else {
            printf("<!!! Illegal memory access at 0x%016lX !!!>\n", addr);
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

INST_NEW(MOVK, KRX_LEN)
    // Copy the provided data into KRX
    memcpy(tvm->krx, &tvm->bc[tvm->kpc + 1], KRX_LEN);
INST_END

INST_NEW(RDK, 1)
    // Get the length to read
    uint8_t rlen = tvm->bc[tvm->kpc + 1];
    if (rlen > KRX_LEN) {
        _SIGILL(tvm);
        return;
    }

    // Read from stdin
    read(0, tvm->krx, rlen);
INST_END

void __push(tvm_state_t *tvm, uint64_t val) {
    tvm->ksp += sizeof(uint64_t);

    // Push the value
    if (ksp_range_valid(tvm)) {
        tvm->stack[tvm->ksp / sizeof(uint64_t)] = val;
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


INST_NEW(ACB, 0)
    tvm->chal_given = true;
    RAND_bytes((uint8_t *) &tvm->auth_chal, sizeof(tvm->auth_chal));
    tvm->kcx = tvm->auth_chal;
INST_END


INST_NEW(ACR, 0)
    if (!tvm->chal_given) {
        tvm->kax = 3;
        return;
    }

    chal_resp_t resp;
    int len = 0;
    uint64_t pt = 0;

    // Copy in the response data
    memcpy((uint8_t *) &resp, tvm->krx, sizeof(resp));

    // Decrypt and verify the challenge
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, tvm->gcm->key, resp.IV);
    EVP_CIPHER_CTX_set_padding(ctx, 0);
    EVP_DecryptUpdate(ctx, (uint8_t *) &pt, &len, resp.ctxt, sizeof(resp.ctxt));
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, sizeof(resp.tag), resp.tag);
    int res = EVP_DecryptFinal_ex(ctx, NULL, &len);
    EVP_CIPHER_CTX_free(ctx); ctx = NULL;

    if (res <= 0) tvm->kax = 2;
    else if (pt != tvm->auth_chal) tvm->kax = 1;
    else {
        tvm->kax = 0;
        tvm->auth = true;
    }

    // Always clear challenge state
    tvm->chal_given = false;
    tvm->auth_chal = 0;
INST_END


void __push_tag(tvm_state_t *tvm, uint8_t *tag) {
    uint64_t *tag_vals = (uint64_t *) tag;
    __push(tvm, 0);
    __push(tvm, 0);
    __push(tvm, tag_vals[0]);
    __push(tvm, tag_vals[1]);
}


INST_NEW(AGE, 1)
    uint64_t src_addr = get_reg(tvm, tvm->bc[tvm->kpc + 1]);
    uint8_t tag[BLK_LEN] = {0};
    memcpy(tvm->gcm->IV, tvm->krx, IV_LEN);

    // Check if this is within the stack
    if (src_addr <= (STACK_SIZE - 4) * sizeof(uint64_t)) {
        gcm_encrypt(tvm->gcm, &((uint8_t *) tvm->stack)[src_addr], KRX_LEN, tvm->krx, tag);
        __push_tag(tvm, tag);
    } else if (STACK_MAX_ADDR <= src_addr &&
               src_addr <= STACK_MAX_ADDR + TRUST_SIZE - (4 * sizeof(uint64_t))) {
        // Encrypt data from trust zone ONLY if authenticated
        if (!tvm->auth) {
            _SIGSEGV_auth(tvm, src_addr);
        } else {
            src_addr -= STACK_MAX_ADDR;
            gcm_encrypt(tvm->gcm, &tvm->trustzone[src_addr], KRX_LEN, tvm->krx, tag);
            __push_tag(tvm, tag);
        }
    } else {
        _SIGSEGV(tvm, src_addr);
    }
INST_END


INST_NEW(AGD, 0)
    gcm_decrypt(tvm->gcm, tvm->krx, KRX_LEN, tvm->krx);
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
    init_crypto(tvm.gcm);
    load_flag_trustzone(&tvm);

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
            ICASE(MOVK);
            ICASE(RDK);
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
            ICASE(ACB);
            ICASE(ACR);
            ICASE(AGE);
            ICASE(AGD);

            case HALT:
                tvm.running = false;
                break;

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
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);

    uint8_t bcode[BCODE_LEN];
    memset(bcode, 0xFF, sizeof(bcode));

    printf("###################################################\n");
    printf("### Welcome to the Trusted Virtual Machine v2.0 ###\n");
    printf("###################################################\n\n");
    printf("Enter your bytecode:\n");

    // Read in raw bytecode
    int r = read(0, bcode, sizeof(bcode) - 1);
    if (r > 0) {
        bcode[r] = HALT;
        exec_bytecode(bcode, r + 1);
    } else {
        printf("ERROR: no bytecode provided. Exiting tvm...\n");
        return 1;
    }

    return 0;
}
// }}}
