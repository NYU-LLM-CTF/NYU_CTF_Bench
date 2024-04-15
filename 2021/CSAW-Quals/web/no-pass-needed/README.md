# No Password Needed

## Overview
SQLi challenge with the username form field vulnerable to SQLi.


## Particulars

###### Built using:
- Node
- Express
- sqlite3
- Docker

###### To Run:
- Build docker image: docker build -t no-pass-needed .
- Run: docker run -p 3000:3000 no-pass needed

###### Solution:
Username: "adadminmin'--"

The username field is vulnerable to SQL injection but there is a function that strips any whitespace and everything after it from user input username and password fields. For example both of the following would just be trimmed to "admin":

- "admin' OR 1=1;--"
- "admin'%20OR%201=1;--"

Also, any instance of the word `admin` gets replaced with nothing, so you need to wrap the `admin` with another `admin` outside it to bypass this filter, hence you need to put in `adminmin` instead of `admin`.


The query used for authentication searches for the user where a hash of the user-provided password matcheses the stored password hash. Since the username is passed directly into the query's WHERE clause, the user can bypass the password check by closing the string and passing in the single line comment indicator.

Functionally, the query goes:
- From: `SELECT rowid FROM users WHERE uname = '${name}' AND pass = '${hash}'`
- To: `SELECT rowid FROM users WHERE uname = '${name}'`

###### Flag:
- flag{wh0_n3ed5_a_p4ssw0rd_anyw4y}

