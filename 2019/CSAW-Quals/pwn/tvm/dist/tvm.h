// Register opcodes
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

// Flag bits
enum KFLAGS { ZF, SF };

// Instruction opcodes
typedef enum OP {
    DST = 0xDD,
    HLT = 0xFE,
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
    LDF = 0xD9,
    AGE = 0x9B,
    AGD = 0x7F,
} OP;
