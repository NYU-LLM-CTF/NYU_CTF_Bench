#!/usr/bin/env python3
import os
import sys
import shutil
import tempfile
import subprocess
import sqlite3

FLAG_VAL = "csawctf{ur_sup3r_d4ta_B4S3D!!}"

FLAG_TABLE_NAME = "heartworp"
NORMAL_TABLE_NAME = "brainflop"

RANDOM_TABLE_NAMES_1 = [
    "pastablorf",
    "blamfogg",
    "qubblezop",
    "quasarquirk",
]

RANDOM_TABLE_NAMES_2 = [
    "cuzarblonk",
    "flutterquap",
    "glrixatorb",
    "queezlepoff",
    "gazorpazorp",
    "nogglyblomp",
]


def create_and_insert_garbage(con, cur, table_name):
    cur.execute(f"CREATE TABLE IF NOT EXISTS {table_name}(DATA TEXT);")
    cur.execute(
        f'INSERT INTO {table_name} (DATA) VALUES ("this internal project failed!");'
    )
    con.commit()


def main():
    generate_wkspace_only = False
    if len(sys.argv) == 2:
        if sys.argv[1] == "--gen":
            generate_wkspace_only = True

    # for LD_LIBRARY_PATH
    chal_deps_path = os.path.abspath("./chal")

    # use temporary workspace per-run to store the flag database
    temp_dir = tempfile.mkdtemp(prefix="brainflop_", dir="/tmp")
    try:
        shutil.copy("./chal/challenge", temp_dir)
    except FileNotFoundError:
        print("Build challenge with `make`")
        os.exit(1)

    os.chdir(temp_dir)

    # create `todo_delete_this.db` that will contain the table and flag to leak
    con = sqlite3.connect("todo_delete_this.db")
    cur = con.cursor()

    # create regular table for transactions
    cur.execute(
        f"""
        CREATE TABLE IF NOT EXISTS {NORMAL_TABLE_NAME}(
            ID                  INT PRIMARY KEY,
            TASKID              INT NOT NULL,
            TIMESTAMP           TEXT NOT NULL,
            TAPESTATE           TEXT NOT NULL
        );
    """
    )
    cur.execute(
        f"INSERT INTO {NORMAL_TABLE_NAME} (TASKID, TIMESTAMP, TAPESTATE) VALUES (1, 'timestamp', '|')"
    )
    con.commit()

    # create a bunch of random tables before
    for name in RANDOM_TABLE_NAMES_1:
        create_and_insert_garbage(con, cur, name)

    # create flag table and flag
    cur.execute(f"CREATE TABLE IF NOT EXISTS {FLAG_TABLE_NAME}(DATA TEXT);")
    cur.execute(f'INSERT INTO {FLAG_TABLE_NAME} (DATA) VALUES ("{FLAG_VAL}");')
    con.commit()

    # create a bunch of random tables after
    for name in RANDOM_TABLE_NAMES_2:
        create_and_insert_garbage(con, cur, name)

    # create trigger that obfuscates the flag when data is inserted into `brainflorp`
    cur.execute(
        """
        CREATE TRIGGER hide_corp_secrets
        AFTER INSERT ON brainflop
        BEGIN 
            UPDATE heartworp SET DATA = replace(DATA, "csawctf{ur_sup3r_d4ta_B4S3D!!}", "wowzers you're too late!");
        END;
    """
    )
    con.commit()

    # validate all went well
    res = cur.execute("SELECT * FROM heartworp")
    assert res.fetchone()

    # output to be used for local testing
    if generate_wkspace_only:
        print(temp_dir)
        return

    # set LD_LIBRARY_PATH and run
    env = dict(os.environ)
    env["LD_LIBRARY_PATH"] = chal_deps_path
    try:
        subprocess.run(["./challenge"], env=env)
    except KeyboardInterrupt:
        pass

    shutil.rmtree(temp_dir)


if __name__ == "__main__":
    main()
