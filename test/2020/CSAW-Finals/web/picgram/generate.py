#!/usr/bin/env python3
import base64
import random
import string

import sqlite3
from sqlite3 import Error

def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Error as e:
        print(e)

    return conn


def create_table(conn, create_table_sql):
    try:
        c = conn.cursor()
        c.execute(create_table_sql)
    except Error as e:
        print(e)


def create_task(conn, task):
    sql = """ INSERT INTO projects(name,flag)
              VALUES(?,?) """
    cur = conn.cursor()
    cur.execute(sql, task)
    conn.commit()
    return cur.lastrowid


def main():
    db = "flag.db"
    create_table_sql = """ CREATE TABLE IF NOT EXISTS projects (
        id integer PRIMARY KEY,
        name text NOT NULL,
        flag text NOT NULL);"""

    conn = create_connection(db)
    if conn is None:
        return 1

    create_table(conn, create_table_sql)

    with open("flag.txt", "rb") as fd:
        flag = str(fd.read())

    fillers = []
    for _ in range(150):
        rand = ''.join(random.choice(string.ascii_letters) for i in range(20))
        res = "flag{" + rand + "}"
        res = base64.b64encode(res.encode("ascii"))
        example = ("iS thIs ThE flAg??", res)
        fillers += [example]

    fillers.insert(76, ("iS thIs ThE flAg??", flag))
    for f in fillers:
        create_task(conn, f)


if __name__ == "__main__":
    main()
