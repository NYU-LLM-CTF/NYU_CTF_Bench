- in this chal, we have an impossible-looking CSP that we need to bypass in order to read the admin bot's FLAG cookie
- we can use CSRF to create an upload on behalf of the admin bot, using some Form and Blob shenanigans
- we can control the served file's content-type and contents
- it turns out, in Firefox, the content type "multipart/x-mixed-replace" allows you to serve multiple responses in 1.
- the CSP of these responses get *appended* to the main document CSP
- so, we can append a `script-src 'unsafe-inline'` to obtain XSS

