# Easiest Crackme part 1

Points: 200

Flag1: `flag{post_msg_delivers_flag}`


Description:
```
This will be the easiest crackme you have ever done, now with the added convience of doing it in your browser! http://crackme.web.chal.csaw.io:48394

Show us your crackme skills here to claim your flag:  http://crackme.web.chal.csaw.io:48394/visit
```

Walkthough:

The main page of the challenge will run the crackme with a given argument. If you send `web2hard` it will give you the first flag. However only the admin has the flag, and the extension only is loaded for the challenge site, so we must find a way to interact with the extension on other sites. This can be done by abusing a missing check on the message handler. By putting the website into an iframe, we can postMessage to the content script though the iframe. This lets us start the program with the correct input and read the output flag.

# Easiest Crackme part 2

Points: 300

Flag2: `flag{so_much_for_strings_being_harmless}`

Description:
```
We also have a flag tucked deep into our browser extension, see if you can grab it too.
```

Walkthough:

The second flag is a file within the extension itself. This means it will be available from the extension url: `chrome-extension://cegaaaajnnledpnkmnjenhbakdijgcjo/flag2.txt`. However we cannot read this from the normal we because it is not exposed in the manifest. To read it we must be running in the extension context, which means we need to get code execution first.

There are no code exec vectors in the content script, but looking at the debugger, it uses JQuery to build up html to render on the page when fetching register values. Specifically it will try to resolve strings that the registers are pointing to. If we can insert a XSS payload into one of these strings, we will be able to get code execution. We can do this by setting a breakpoint when RDI points to our input argument, this allows us to echo out an XSS playload. (Note there is a CSP enforced that should stop the payload, but JQuery is nice enough to parse out the script tags and run them directly, meaning we only need unsafe-eval which is set)

The XSS can simply load the flag file with fetch and exfil it.

# Easiest Crackme part 3

Points: 300

Flag3: `flag{RCE_is_my_favorite_flavor}`

Description:
```
Now prove your might get remote code execution to claim our final flag!
```

Walkthough:

For the final flag, we need to get code execution. The easiest way to do this is to use our XSS and abuse the GDB instance to spawn a shell. Most useful GDB commands are restricted, but there is a `set` command exposed though the `flavor` RPC call (normally used to change the disassembly flavor). We can use the set command to change the code in the binary, forcing the binary to call system once our program continues. We can set this up to use our input argv[1] in RDI making it easy to specify commands. All we have to do is run `./flag3.exe` and exfil the output.
