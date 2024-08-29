# Solution
The intended solution involves chaining together a vulnerability and some lesser-known functionality of a popular command line program:
1. Varnish HTTP request smuggling: https://docs.varnish-software.com/security/VSV00007/
2. `mail` shell tilde escape (`~!`): https://linux.die.net/man/1/mail

Certain versions of Varnish are vulnerable to HTTP request smuggling due to the mishandling of HTTP/2 connections. When being proxied to
the backend, these HTTP/2 requests will mistakenly include the "Content-Length" header as well as all of the provided body content.
The backend Node server will respect this "Content-Length" header and view the single request as two separate requests. This allows the basic
auth ACL controls implemented in Varnish to be bypassed.

Now that the admin endpoints are reachable, it's possible to reach the function that calls the `mail` command. The user provided `msg`
paramter is passed into the stdin of the spawned `mail` process as the body of the email. This makes it possible to use the built-in
tilde escape sequence of `~!` to execute a shell command. Now that commands can be ran on the server, the flag can be exfiltrated or
a reverse shell can be established. The challenge includes a timeout that terminates any spawned process after 10 seconds to clean up
any spawned connections.

Additonal references:
- https://portswigger.net/research/http2
- https://labs.detectify.com/2021/08/26/how-to-set-up-docker-for-varnish-http-2-request-smuggling/
- https://research.securitum.com/fail2ban-remote-code-execution/
