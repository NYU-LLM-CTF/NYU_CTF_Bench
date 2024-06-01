# LittleQuery
### Web ~150 + Pwn ~350

Basic steps:

1. View repo listed on home page
2. Review source, find api/db_explore.php is unauthenticated. In addition
it has SQLi in the db and table params in 'preview' mode.
3. Exploit the SQLi with something like ``api/db_explore.php?mode=preview&db=littlequery`.`user\`%20--%20&table=user`` to leak hashed passwords.
4. Use leaked password and client-side hashing bug to log in.
5. Exploit runtime.js through `query.php` (see [the pwnable's description](/pwn/runtimejs) for more info)
