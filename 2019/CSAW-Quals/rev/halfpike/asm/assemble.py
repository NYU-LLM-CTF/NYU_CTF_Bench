#!/usr/bin/env python3

import argparse
import sys
import struct
from ast import literal_eval
from typing import Dict, List, Tuple, Set, Optional, NoReturn
from dataclasses import dataclass

OPCODES_MAP = {
    "nop": 0b0000,
    "jcn": 0b0001,
    "fim": 0b0010,
    "src": 0b0010,
    "fin": 0b0011,
    "jin": 0b0011,
    "jun": 0b0100,
    "jms": 0b0101,
    "inc": 0b0110,
    "isz": 0b0111,
    "add": 0b1000,
    "sub": 0b1001,
    "ld": 0b1010,
    "xch": 0b1011,
    "bbl": 0b1100,
    "ldm": 0b1101,
    "wrm": 0b1110,
    "wmp": 0b1110,
    "wrr": 0b1110,
    "wpm": 0b1110,
    "wr0": 0b1110,
    "wr1": 0b1110,
    "wr2": 0b1110,
    "wr3": 0b1110,
    "sbm": 0b1110,
    "rdm": 0b1110,
    "rdr": 0b1110,
    "adm": 0b1110,
    "rd0": 0b1110,
    "rd1": 0b1110,
    "rd2": 0b1110,
    "rd3": 0b1110,
    "clb": 0b1111,
    "clc": 0b1111,
    "iac": 0b1111,
    "cmc": 0b1111,
    "cma": 0b1111,
    "ral": 0b1111,
    "rar": 0b1111,
    "tcc": 0b1111,
    "dac": 0b1111,
    "tcs": 0b1111,
    "stc": 0b1111,
    "daa": 0b1111,
    "kbp": 0b1111,
    "dcl": 0b1111,
}

INSN_BYTE_LENGTHS = {
    "nop": 1,
    "jcn": 2,
    "fim": 2,
    "src": 1,
    "fin": 1,
    "jin": 1,
    "jun": 2,
    "jms": 2,
    "inc": 1,
    "isz": 2,
    "add": 1,
    "sub": 1,
    "ld": 1,
    "xch": 1,
    "bbl": 1,
    "ldm": 1,
    "wrm": 1,
    "wmp": 1,
    "wrr": 1,
    "wpm": 1,
    "wr0": 1,
    "wr1": 1,
    "wr2": 1,
    "wr3": 1,
    "sbm": 1,
    "rdm": 1,
    "rdr": 1,
    "adm": 1,
    "rd0": 1,
    "rd1": 1,
    "rd2": 1,
    "rd3": 1,
    "clb": 1,
    "clc": 1,
    "iac": 1,
    "cmc": 1,
    "cma": 1,
    "ral": 1,
    "rar": 1,
    "tcc": 1,
    "dac": 1,
    "tcs": 1,
    "stc": 1,
    "daa": 1,
    "kbp": 1,
    "dcl": 1,
}

REGULAR_REGISTERS = [
    "r0",
    "r1",
    "r2",
    "r3",
    "r4",
    "r5",
    "r6",
    "r7",
    "r8",
    "r9",
    "r10",
    "r11",
    "r12",
    "r13",
    "r14",
    "r15",
]

PAIR_REGISTERS = [
    "p0",
    "p1",
    "p2",
    "p3",
    "p4",
    "p5",
    "p6",
    "p7",
    "r0|r1",
    "r2|r3",
    "r4|r5",
    "r6|r7",
    "r8|r9",
    "r10|r11",
    "r12|r13",
    "r14|r15",
]

# numbers for registers (and registerpairs)
REGISTER_NUMBERS = {
    # regular:
    "r0": 0,
    "r1": 1,
    "r2": 2,
    "r3": 3,
    "r4": 4,
    "r5": 5,
    "r6": 6,
    "r7": 7,
    "r8": 8,
    "r9": 9,
    "r10": 10,
    "r11": 11,
    "r12": 12,
    "r13": 13,
    "r14": 14,
    "r15": 15,
    # pairs (p notation):
    "p0": 0,
    "p1": 1,
    "p2": 2,
    "p3": 3,
    "p4": 4,
    "p5": 5,
    "p6": 6,
    "p7": 7,
    # pairs (| notation):
    "r0|r1": 0,
    "r2|r3": 1,
    "r4|r5": 2,
    "r6|r7": 3,
    "r8|r9": 4,
    "r10|r11": 5,
    "r12|r13": 6,
    "r14|r15": 7,
}


@dataclass
class CodeInsn:
    opcode: str
    argument: Optional[str] = None
    argument2: Optional[str] = None


@dataclass
class CodeStmt:
    line_num: int
    filename: str
    kind: str  # "pragma", "label", "insn"
    stmt: str
    insn: Optional[CodeInsn] = None

    def assembled_byte_length(self, ip: int) -> int:
        if self.kind == "insn":
            assert self.insn, "Missing insn!"
            return INSN_BYTE_LENGTHS[self.insn.opcode]

        if self.kind == "pragma":
            # string pragmas have length of str+1 (to account for the nullbyte)
            if self.stmt.startswith("str "):
                return len(literal_eval(self.stmt[len("str ") :])) + 1
            # bytes are always 1-long (duh)
            if self.stmt.startswith("byte "):
                return len([x for x in self.stmt.split(" ") if x][1:])
            # align pragmas align to 256 byte boundaries
            if self.stmt.startswith("pagealign"):
                # if we're already page aligned, do nothing
                if ip & 0xf00 == ip:
                    return 0
                next_page = (ip & 0xf00) + 0x100
                return next_page - ip
            if self.stmt.startswith("nibblealign"):
                if ip & 0xff0 == ip:
                    return b""  # already page aligned
                next_nibble = (ip & 0xff0) + 0x10
                return next_nibble - ip
        return 0


class Parser:
    def __init__(self, filename):
        self.filename = filename

    def report_error_simple(self, line_num: int, line: str, error: str) -> NoReturn:
        raise ValueError(
            f"Error in file {self.filename}, line {line_num}: {error}: {line!r}"
        )

    def report_error(self, stmt: CodeStmt, error: str) -> NoReturn:
        self.report_error_simple(stmt.line_num, stmt.stmt, error)

    def report_warning(self, stmt: CodeStmt, warning: str):
        print(
            f"Warning in file {self.filename}, line {stmt.line_num}: {warning}: {stmt.stmt!r}"
        )

    def get_arg1(self, stmt: CodeStmt) -> str:
        """
        Get the value of arg1 for a stmt, reporting an error if that is impossible
        """
        if not stmt.insn:
            self.report_error(stmt, "Internal Compiler Error!")
        if not stmt.insn.argument:
            self.report_error(stmt, "Missing arg1")
        return stmt.insn.argument

    def get_arg2(self, stmt: CodeStmt) -> str:
        """
        Get the value of arg2 for a stmt, reporting an error if that is impossible
        """
        if not stmt.insn:
            self.report_error(stmt, "Internal Compiler Error!")
        if not stmt.insn.argument2:
            self.report_error(stmt, "Missing arg2")
        return stmt.insn.argument2

    def parse_insn(self, line_num: int, insn: str) -> CodeInsn:
        stuff = insn.split()
        if len(stuff) not in {1, 2, 3}:
            self.report_error_simple(
                line_num, insn, f"Incorrect number of thing in an insn: {len(stuff)}"
            )
        if len(stuff) == 1:
            return CodeInsn(stuff[0])
        elif len(stuff) == 2:
            return CodeInsn(stuff[0], stuff[1])
        else:
            return CodeInsn(stuff[0], stuff[1], stuff[2])

    def extract_line_elements(
        self, line_num: int, line: str
    ) -> Tuple[Optional[str], Optional[str], Optional[str]]:
        """
        Given a single line of code, extract the pragma, label, and instruction, if any
        Each one can be None if they do not exist
        """
        has_pragma = "%" in line
        has_label = ":" in line

        # can't have both a pragma and a label
        if has_pragma and has_label:
            self.report_error_simple(
                line_num, line, "Cannot have both a pragma and a label on the same line"
            )

        if has_pragma:
            if line[0] != "%":
                self.report_error_simple(
                    line_num, line, "Pragma does not start with '%'"
                )
            return line[1:], None, None

        if has_label:
            stuff = [x.strip() for x in line.split(":")]
            if len(stuff) == 1:
                return None, stuff[0], None
            if len(stuff) == 2:
                return None, stuff[0], stuff[1]
            self.report_error_simple(line_num, line, "More than one colon on a line")

        # just a plain insn
        if not has_pragma and not has_label:
            return None, None, line
        self.report_error_simple(line_num, line, f"Unable to extract statements")

    def split_statements(self, code: str) -> List[CodeStmt]:
        """
        Take a program, and return all the statements in it
        """
        stmts = []
        for line_num, line in enumerate(code.splitlines()):
            line_num += 1  # lines aren't 0-indexed :P
            # remove comments, whitespace
            # only insert nonblank lines
            line = line.split(";")[0]
            line = line.strip()
            pragma, label, insn = self.extract_line_elements(line_num, line)
            if pragma:
                stmts.append(
                    CodeStmt(
                        line_num=line_num,
                        filename=self.filename,
                        kind="pragma",
                        stmt=pragma,
                    )
                )
            if label:
                stmts.append(
                    CodeStmt(
                        line_num=line_num,
                        filename=self.filename,
                        kind="label",
                        stmt=label,
                    )
                )
            if insn:
                stmts.append(
                    CodeStmt(
                        line_num=line_num,
                        filename=self.filename,
                        kind="insn",
                        stmt=insn,
                        insn=self.parse_insn(line_num, insn),
                    )
                )

        return stmts

    def assign_label_addresses(self, stmts: List[CodeStmt]) -> Dict[str, int]:
        """
        scan through the program and assign addresses to each label.
        """
        ip = 0
        label_addresses: Dict[str, int] = {}
        for stmt in stmts:
            if stmt.kind == "label":
                if stmt.stmt in label_addresses:
                    self.report_error(stmt, "Duplicate label!")
                label_addresses[stmt.stmt] = ip
            ip += stmt.assembled_byte_length(ip)
        return label_addresses

    def assign_variables(self, stmts: List[CodeStmt]) -> Dict[str, str]:
        """
        scan through the program and assign values to each variable, based on pragmas in the form:
        %let name = value
        """
        ip = 0
        variables: Dict[str, str] = {}
        for stmt in stmts:
            if stmt.kind == "pragma" and stmt.stmt.startswith("let "):
                lhs, rhs = stmt.stmt[len("let ") :].split(" = ")
                lhs, rhs = lhs.strip(), rhs.strip()
                if lhs in variables:
                    self.report_error(stmt, "Duplicate variable!")
                variables[lhs] = rhs
            ip += stmt.assembled_byte_length(ip)
        return variables

    def parse_insn_argument(
        self, stmt: CodeStmt, arg: str, variables: Dict[str, str]
    ) -> int:
        """
        parse an instruction argument, which might be a label
        (in which case it will be resolved to an address),
        or an integer in some base (in which case it will jsut be parsed)
        """
        if arg in variables:
            # recursively expand the variable name until we get the last value
            # we apply a recursion limit, and error out if we expand more than
            # that many levels deep
            value = arg
            expansion_count = 0
            while value in variables:
                value = variables[value]
                expansion_count += 1

                if expansion_count > 1024:
                    self.report_error(
                        stmt, "Too many levels of variable nesting to expand!"
                    )
            return int(value, 0)  # variables are all _really_ ints at this level
        return int(arg, 0)

    def assemble_single_op_reg_insn(
        self, stmt: CodeStmt, valid_registers: Set[str], combine_func
    ) -> bytes:
        assert stmt.insn
        op = OPCODES_MAP[stmt.insn.opcode]
        if stmt.insn.argument not in valid_registers:
            self.report_error(
                stmt, f"Invalid register type (must be one of {valid_registers})"
            )
        arg = REGISTER_NUMBERS[stmt.insn.argument]
        return bytes([combine_func(op, arg)])

    def assemble_acc_insn(self, stmt: CodeStmt, combine_func) -> bytes:
        assert stmt.insn
        op = OPCODES_MAP[stmt.insn.opcode]
        return bytes([combine_func(op)])

    def assemble_insn(
        self, stmt: CodeStmt, variables: Dict[str, str], ip: int
    ) -> bytes:
        if stmt.kind != "insn":
            return b""

        insn = stmt.insn
        assert insn

        if insn.opcode == "inc":
            return self.assemble_single_op_reg_insn(
                stmt, REGULAR_REGISTERS, lambda op, arg: (op << 4) | (arg)
            )

        if insn.opcode == "fin":
            return self.assemble_single_op_reg_insn(
                stmt, PAIR_REGISTERS, lambda op, arg: (op << 4) | (arg << 1)
            )

        if insn.opcode == "add":
            return self.assemble_single_op_reg_insn(
                stmt, REGULAR_REGISTERS, lambda op, arg: (op << 4) | (arg)
            )

        if insn.opcode == "sub":
            return self.assemble_single_op_reg_insn(
                stmt, REGULAR_REGISTERS, lambda op, arg: (op << 4) | (arg)
            )

        if insn.opcode == "ld":
            return self.assemble_single_op_reg_insn(
                stmt, REGULAR_REGISTERS, lambda op, arg: (op << 4) | (arg)
            )

        if insn.opcode == "xch":
            return self.assemble_single_op_reg_insn(
                stmt, REGULAR_REGISTERS, lambda op, arg: (op << 4) | (arg)
            )

        if insn.opcode == "clb":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0000)

        if insn.opcode == "clc":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0001)

        if insn.opcode == "iac":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0010)

        if insn.opcode == "cmc":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0011)

        if insn.opcode == "cma":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0100)

        if insn.opcode == "ral":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0101)

        if insn.opcode == "rar":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0110)

        if insn.opcode == "tcc":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0111)

        if insn.opcode == "dac":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1000)

        if insn.opcode == "tcs":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1001)

        if insn.opcode == "stc":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1010)

        if insn.opcode == "daa":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1011)

        if insn.opcode == "kbp":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1100)

        if insn.opcode == "fim":
            op = OPCODES_MAP[insn.opcode]
            arg = self.get_arg1(stmt)
            arg2 = self.get_arg2(stmt)
            if arg not in PAIR_REGISTERS:
                self.report_error(
                    stmt, f"Invalid register type (must be one of {PAIR_REGISTERS})"
                )
            reg = REGISTER_NUMBERS[arg]
            data = self.parse_insn_argument(stmt, arg2, variables)
            if data > 255:
                self.report_warning(
                    stmt,
                    f"data for fim instruction is larger than a page-size, and will be truncated (data = 0x{data:x})",
                )
            data &= 0xff
            return bytes([(op << 4) | (reg << 1), data])

        if insn.opcode == "ldm":
            op = OPCODES_MAP[insn.opcode]
            arg = self.get_arg1(stmt)
            imm = int(arg, 0)
            if not (0 <= imm < 16):
                self.report_error(stmt, "Invalid imm, must be in range [0, 16)")
            return bytes([(op << 4) | (imm)])

        if insn.opcode == "jun":
            op = OPCODES_MAP[insn.opcode]
            target = self.parse_insn_argument(stmt, self.get_arg1(stmt), variables)
            return bytes([(op << 4) | ((target & 0xf00) >> 8), (target & 0xff)])

        if insn.opcode == "jin":
            return self.assemble_single_op_reg_insn(
                stmt, PAIR_REGISTERS, lambda op, arg: (op << 4) | (arg << 1) | 1
            )

        if insn.opcode == "jcn":
            op = OPCODES_MAP[insn.opcode]
            codes = self.get_arg1(stmt)
            flags = 0
            # instead of making you write bit codes for conditions,
            # we let you put letters (t,c,a,n) to indicate the bit.
            # Any order is fine.
            if "t" in codes:  # test
                flags |= 0b0001
            if "c" in codes:  # carry
                flags |= 0b0010
            if "a" in codes:  # acc
                flags |= 0b0100
            if "n" in codes:  # invert
                flags |= 0b1000
            # TODO: make sure label is on the same page as the instruction,
            #       otherwise this will be BUGGY!!
            target = self.parse_insn_argument(stmt, self.get_arg2(stmt), variables)
            if ip & 0xf00 != target & 0xf00:
                self.report_warning(
                    stmt,
                    "Target IP and current IP are on different pages, which is probably not the behavior you expect!",
                )
            target &= 0xff
            return bytes([(op << 4) | flags, target])

        if insn.opcode == "isz":
            op = OPCODES_MAP[insn.opcode]
            arg = self.get_arg1(stmt)
            if arg not in REGULAR_REGISTERS:
                self.report_error(
                    stmt, f"Invalid register type (must be one of {REGULAR_REGISTERS})"
                )
            reg = REGISTER_NUMBERS[arg]
            # TODO: make sure label is on the same page as the instruction,
            #       otherwise this will be BUGGY!!
            target = self.parse_insn_argument(stmt, self.get_arg2(stmt), variables)
            if ip & 0xf00 != target & 0xf00:
                self.report_warning(
                    stmt,
                    "Target IP and current IP are on different pages, which is probably not the behavior you expect!",
                )
            target &= 0xff
            return bytes([(op << 4) | reg, target])

        if insn.opcode == "jms":
            op = OPCODES_MAP[insn.opcode]
            target = self.parse_insn_argument(stmt, self.get_arg1(stmt), variables)
            return bytes([(op << 4) | ((target & 0xf00) >> 8), (target & 0xff)])

        if insn.opcode == "bbl":
            op = OPCODES_MAP[insn.opcode]
            data = int(self.get_arg1(stmt), 0)
            return bytes([(op << 4) | data])

        if insn.opcode == "nop":
            return bytes([0])

        if insn.opcode == "dcl":
            return bytes([0b11111101])

        if insn.opcode == "src":
            return self.assemble_single_op_reg_insn(
                stmt, PAIR_REGISTERS, lambda op, arg: (op << 4) | (arg << 1) | 1
            )

        if insn.opcode == "wrm":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0000)

        if insn.opcode == "wmp":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0001)

        if insn.opcode == "wrr":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0010)

        if insn.opcode == "wpm":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0011)

        if insn.opcode == "wr0":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0100)

        if insn.opcode == "wr1":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0101)

        if insn.opcode == "wr2":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0110)

        if insn.opcode == "wr3":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b0111)

        if insn.opcode == "sbm":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1000)

        if insn.opcode == "rdm":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1001)

        if insn.opcode == "rdr":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1010)

        if insn.opcode == "adm":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1011)

        if insn.opcode == "rd0":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1100)

        if insn.opcode == "rd1":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1101)

        if insn.opcode == "rd2":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1110)

        if insn.opcode == "rd3":
            return self.assemble_acc_insn(stmt, lambda op: (op << 4) | 0b1111)

        self.report_error(stmt, "Do not know how to assemble")

    def assemble_stmt(
        self, stmt: CodeStmt, variables: Dict[str, str], ip: int
    ) -> bytes:
        if stmt.kind == "label":
            return b""
        elif stmt.kind == "insn":
            return self.assemble_insn(stmt, variables, ip)
        elif stmt.kind == "pragma":
            if stmt.stmt.startswith("str "):
                return literal_eval(stmt.stmt[len("str ") :]).encode("ascii") + b"\x00"
            if stmt.stmt.startswith("byte "):
                bz = [x for x in stmt.stmt.split(" ") if x][1:]
                out = b""
                for b in bz:
                    out += struct.pack("B", literal_eval(b))
                return out
            if stmt.stmt.startswith("pagealign"):
                if ip & 0xf00 == ip:
                    return b""  # already page aligned
                next_page = (ip & 0xf00) + 0x100
                return b"\x00" * (next_page - ip)
            if stmt.stmt.startswith("nibblealign"):
                if ip & 0xff0 == ip:
                    return b""  # already page aligned
                next_nibble = (ip & 0xff0) + 0x10
                return b"\x00" * (next_nibble - ip)
            return b""

        self.report_error(
            stmt, f"Dont know how to assemble this type of stmt: {stmt.kind}"
        )

    def assemble(self, program: str) -> bytes:
        program = program.lower()  # we're case insensitive
        stmts = self.split_statements(program)
        variables = self.assign_variables(stmts)
        label_addresses = self.assign_label_addresses(stmts)
        # labels are just fancy variables :)
        for k, v in label_addresses.items():
            variables[k] = str(v)

        assembled = b""
        ip = 0
        for stmt in stmts:
            asm = self.assemble_stmt(stmt, variables, ip)
            length = stmt.assembled_byte_length(ip)
            if len(asm) != length:
                self.report_error(
                    stmt,
                    f"Mismatch in actual assembled length ({len(asm)}) and predicted assembled length ({length})",
                )
            assembled += asm
            ip += length

        if len(assembled) > 4096:
            self.report_error(stmts[0], "ROM too large!")

        print(f"ROM is {len(assembled) / 4096 * 100:.2f}% full")
        return assembled.ljust(4096, b"\x00")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Assemble Intel 4004 assembly")
    parser.add_argument("infile", type=argparse.FileType("r"))
    parser.add_argument(
        "outfile", nargs="?", type=argparse.FileType("wb"), default="a.out"
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    parser = Parser(args.infile.name)
    assembled = parser.assemble(args.infile.read())
    args.outfile.write(assembled)


if __name__ == "__main__":
    main()
