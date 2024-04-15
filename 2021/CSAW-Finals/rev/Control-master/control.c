
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>

#define DEBUG 0

// Control flags.
#define REG_r0_R_DATA (1 << 0)
#define REG_r0_W_DATA (1 << 1)
#define REG_r0_W_ADDR (1 << 2)

#define REG_r1_R_DATA (1 << 3)
#define REG_r1_W_DATA (1 << 4)
#define REG_r1_W_ADDR (1 << 5)

#define REG_r2_R_DATA (1 << 6)
#define REG_r2_W_DATA (1 << 7)
#define REG_r2_W_ADDR (1 << 8)

#define REG_r3_R_DATA (1 << 9)
#define REG_r3_W_DATA (1 << 10)
#define REG_r3_W_ADDR (1 << 11)

#define REG_sp_R_DATA (1 << 12)
#define REG_sp_W_DATA (1 << 13)
#define REG_sp_W_ADDR (1 << 14)

#define ALU_R_X (1 << 15)
#define ALU_R_Y (1 << 16)
#define ALU_SHF (1 << 17)
#define ALU_ADD (1 << 18)
#define ALU_MUL (1 << 19)
#define ALU_XOR (1 << 20)
#define ALU_EQ (1 << 21)

#define RAM_R (1 << 22)
#define RAM_W (1 << 23)

#define OUT_R (1 << 24)
#define IN_W (1 << 25)

#define ROM_W_IP (1 << 26)
#define ROM_W_ADDR (1 << 27)

#define IP_ADD_1 (1 << 28)
#define IP_ADD_2 (1 << 29)
#define IP_R_DATA (1 << 30)

#define HLT (1 << 31)


static uint32_t r0 = 0;
static uint32_t r1 = 0;
static uint32_t r2 = 0;
static uint32_t r3 = 0;
static uint32_t sp = 0;

static uint32_t alu_x = 0;
static uint32_t alu_y = 0;

static uint32_t ip = 0;
static uint32_t val = 0;

static uint32_t data_bus = 0;
static uint32_t addr_bus = 0;

uint32_t *rom;
uint32_t ram[0x10000];

int main(int argc, char **argv) {

    setbuf(stdout, NULL);
    setbuf(stdin, NULL);

    if (argc != 2) {
        printf("Usage: %s control.bin\n", argv[0]);
        exit(0);
    }

    FILE *fd = fopen(argv[1], "rb");
    fseek(fd, 0, SEEK_END);
    size_t size = ftell(fd);
    fseek(fd, 0, SEEK_SET);
    rom = malloc(size);
    fread(rom, 1, size, fd);

    while (!(val & HLT)) {
        // Load instruction.a
        val = rom[ip];

        #if DEBUG == 1
        printf("[%04x] 0x%08x :: 0x%08x ;; \tr0=0x%08x\tr1=0x%08x\tr2=0x%08x\tr3=0x%08x\tsp=0x%08x\tax=0x%08x\tay=0x%08x\t\n", ip, val, rom[ip+1], r0, r1, r2, r3, sp, alu_x, alu_y);
        printf("Mem: ");
        for (int i = 0; i < 0x10; ++i) {
            printf("0x%08x ", ram[i]);
        }
        printf("\n");
        #endif

        // Alu op.
        if (val & ALU_ADD) data_bus = alu_x + alu_y;
        if (val & ALU_MUL) data_bus = alu_x * alu_y;
        if (val & ALU_SHF) data_bus = (((int32_t)alu_y)) > 0 ? alu_x >> alu_y : alu_x << (-((int32_t)alu_y));
        if (val & ALU_XOR) data_bus = alu_x ^ alu_y;
        if (val & ALU_EQ) data_bus = (alu_x == alu_y ? 1 : 0);

        // Address writes.
        if (val & REG_r0_W_ADDR) addr_bus = r0;
        if (val & REG_r1_W_ADDR) addr_bus = r1;
        if (val & REG_r2_W_ADDR) addr_bus = r2;
        if (val & REG_r3_W_ADDR) addr_bus = r3;
        if (val & REG_sp_W_ADDR) addr_bus = sp;

        // Data writes.
        if (val & REG_r0_W_DATA) data_bus = r0;
        if (val & REG_r1_W_DATA) data_bus = r1;
        if (val & REG_r2_W_DATA) data_bus = r2;
        if (val & REG_r3_W_DATA) data_bus = r3;
        if (val & REG_sp_W_DATA) data_bus = sp;
        if (val & RAM_W) data_bus = ram[addr_bus];
        if (val & ROM_W_IP) data_bus = rom[ip + 1];
        if (val & ROM_W_ADDR) data_bus = rom[addr_bus];
        if (val & IN_W) data_bus = getchar();

        // Data reads.
        if (val & REG_r0_R_DATA) r0 = data_bus;
        if (val & REG_r1_R_DATA) r1 = data_bus;
        if (val & REG_r2_R_DATA) r2 = data_bus;
        if (val & REG_r3_R_DATA) r3 = data_bus;
        if (val & REG_sp_R_DATA) sp = data_bus;
        if (val & ALU_R_X) alu_x = data_bus;
        if (val & ALU_R_Y) alu_y = data_bus;
        if (val & RAM_R) ram[addr_bus] = data_bus;
        if (val & OUT_R) putchar(data_bus);

        // IP increment.
        if (val & IP_ADD_1) ip += 1;
        if (val & IP_ADD_2) ip += 2;
        if (val & IP_R_DATA) ip = data_bus;
    }
}
