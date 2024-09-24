# Run
```
docker-compose up
```


# Credentials

### Web Server:
```
user:ppXr5yGXe2g83X0
```

### FTP 128.238.66.77
```
ftp_base:r5TgKiP18L1VwuX0K0JZEX7V4j31wh
ftp_dev:vOc!&6k(G;uNSqjQBt=M
```

# Writeup
## Step 1

Given this binary and running, we get an output of the files on some ftp server somewhere. We can't do anything else with the binary as it doesn't take input and purely does this operation.

When we run the file, we get a string output:
```
[+] Successful Log in.
```


Rust does not have much work done in terms of decompiling tools so we can be tactical with how we try get some info from this binary. 
As we can see, these strings must be residing at some memory address. Possibly near some other important info as they will probably be close in memory addresses.

```
> strings ftp-conn | grep -a1 -b1 Successful

23275-PASS src/ftp.rs Expected code , got response: 128.238.66.77:21{invalid syntax}TryDemangleErrorerror: could not read reply codecould not convert slice to arraylibrary/core/src/char/methods.rsindex out of bounds: the len is library/core/src/fmt/builders.rslibrary/core/src/slice/memchr.rserror: could not parse reply code:
23597:/rustc/cc66ad468955717ab92600c770da8c1601a4ff33/library/std/src/io/mod.rsstream did not contain valid UTF-8/rustc/cc66ad468955717ab92600c770da8c1601a4ff33/library/std/src/io/readbuf.rsfailed to write whole bufferError connecting to ftp serversrc/main.rsftp_baseCLICOLORNO_COLORextern "NulErrorr5TgKiP18L1VwuX0K0JZEX7V4j31wh Successful Ftp Login
23942- There was is an issue with the running challenge. Please contact an admin
```

We can find the creds.

We can now ftp in where there is one file, note.txt giving info. 

## Step 2
Doing some reconnaissance on this ip, we see a web server running on a port. Heading over to it, we see a login portal.

Analyse how the requests are sent by intercepting. Will notice there is a request to /initiateRateLimit which causes the ratelimiting. So if we just make our requests and observe the response, we can determine if the password is correct beforehand and also observe the errorcode.

Determine that the errorcode represents the number of chars from the beginning that match the user password. Write a script that fuzzes printable characters until a match is found, then proceed to next char until password found.

Solver script in solver.py

Truncated Tail of Output
```
...
...
Processing char: V
Password: ppXr5yGXe2g83
Found. Redirecting to http://localhost:3000/issueRateLimit?u=user&p=ppXr5yGXe2g83W&error=13
Processing char: W
Password: ppXr5yGXe2g83
Found. Redirecting to http://localhost:3000/issueRateLimit?u=user&p=ppXr5yGXe2g83X&error=14
Processing char: X
Password: ppXr5yGXe2g83X
{"msg":"ftp_dev:vOc!&6k(G;uNSqjQBt=M"}
```

## Step 3
Now when we ftp in, we now have more privs than before. We can see the node server code. 

There is an RCE exploit within the time logging functionality of the server that only executes when the ratelimiting is triggered. There is an optional t parameter that can be manually overwritten which represents the time that a request was made for the logger. There is a vulnerable eval within the functionality. However, there is a safeguard function safeT(). You can reverse this obfuscation (see encryption-solver.js) and then can get the RCE. 
