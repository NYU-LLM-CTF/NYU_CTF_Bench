## brainflop

### tldr

This is a C++ pwn challenge about subverting CFI (control-flow integrity) with a data-only exploit that enables arbitrary SQL queries. The vulnerability is a trivial heap-based out-of-bounds read/write in a custom Brainfuck interpeter called BRAINFLOP. The exploit requires using BF programs to groom the heap, do an infoleak, tamper pointers and overwrite SQL queries.

### Description

The Universal Coalition of Klaznogoth, a preeminent interstellar federation, invites you, the brightest minds of Earth to be closed beta testers to our new Earth startup's line of products. The federation has recently developed a cutting-edge computing VM - BRAINFLOP. This new system utilizes the latest cosmic cloud technology of SQLite3!

## Solution

Check out comments in `exp.py` for in-depth details.

### Vulnerability

There is no bounds check on whether the BRAINFLOP data pointer is being decremented/incremented out of bounds on the `std::vector`-based tape. Since BRAINFLOP allows for input/output per-cell, this allows for a heap-based out-of-bounds read/write.

### Exploitation

To test exploit locally:

```
$ python3 exp.py --workspace $(python3 server.py --gen)
```

To test remotely:

```
$ python3 exp.py --remote localhost:9999
```

This was my method for exploitation:

1. __Infoleak:__ create a `BFTask`. When a loop command `[` is interpreted in the user-supplied program, the current data pointer is pushed onto a `std::list`-based loop stack, which in turn will also spray an adjacent `0x20` chunk to the current tape. 

A `std::list` contains two node pointers `_M_next` and `_M_prev`. If it is the only `std::list` node, then both pointers will point back the original "head" that resides within the instantiated `BFTask` object.

Thus a program like:

```
+[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.>.>.>.>.>.>.>.>
```

will move the data pointer to that target chunk, and leak that heap pointer and thus allow for calculating the ASLR slide. We use this to leak `BFTask->db_file`'s pointer and calculate an offset into another empty `std::vector` chunk we can reuse later.

2. __Heap feng shui:__ create/spray another `BFTask`, and such that subsequent input programs don't refill tcachebin chunks / consolidate above the current tape. This makes such that underflowing the data pointer and doing writes on chunks before possible without a growing program chunk preventing us from reaching it.

3. __Arbitrary write__: with an ideal heap shape, the first `BFTask` is reused to do some arbirary writes:

Player will notice the `todo_delete_me.db` comment, and will deduce that we should be disclosing stuff from there. We can fill up the empty `std::vector` chunk with that string with something like this:

```
[*] Reusing BFTask 1 to write todo_delete_this.db to std::vector @ 0x55cae2098280
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,>,>,>,>,>,>,>,>,>,>,>,>,>,>,>,>,>,>,>
```

The `this->db_file` will be modified to point to that chunk:

```
[*] Reusing BFTask 1 to now overwrite this->db_file with 0x55cae2098280
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,>,>,>,>,>,>,>,>
```

The `this->sql_query` will point to a backing buffer on the heap with the SQL query that gets executed during backup. This is modified with SQL queries of our choice.

We can trigger the object's destructor at the end of program runtime, which will now allow us to read into the new database.

4. __SQL injection__:
    a. leak the table with flag by overwriting the SQL query with `SELECT name FROM sqlite_master WHERE type='table';`.
    b. see that the data was just overwritten with `SELECT * FROM leaked_table`, realize SQlite3 triggers are the culprit.
    c. introspect the triggers with `SELECT * from sqlite_master WHERE type = 'trigger';`
