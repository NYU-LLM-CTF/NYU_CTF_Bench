# SCP Terminal

Description:

```
Every since you started working this administrative government job, things have gotten strange.

Its not just because your day is spent cataloging an archive of anomalous objects. In your dreams you see a burning number: 31337

Maybe this terminal can help uncover the meaning of these dreams.

https://scp-terminal.foundation/
```

Handout: None 

Points: 300-350

Flag: `flag{CSP_def3a7s_SCP_n0t_s0_s3cure_n0w_huh}`

## Solution

<details>
  <summary>Spoiler warning</summary>
  














































































  <!--Spoilers! [8;41;31m/-->
  You can give this page SCP urls (e.g. https://scp-wiki.wikidot.com/scp-105) and it will take a screenshot with chrome. Additionally it will download images in a div with class `scp-image-block` (This div exists on the scp-wiki.wikidot.com pages).

  We can give it an arbitrary url if `scp-` is in it somewhere. This is easy to do as we can add it after a `?`. The server header reveals the server is running nginx. So we can request with the file:// protocol for a known configuration file such as `file:///etc/nginx/sites-enabled/default?scp-`. Using this we can read parts of the source at `/server/server.py`, `/server/scp_contain.py`, and `/server/scp_secure.py`.

  In the source code you can see the flag is in `/server/templates/scp-31337.html` accessed from `/scp-31337`. However if we try to load that, css in the html will redact the flag from the page. If we can load the page without CSS we will be able to see the flag.

  In the scp_secure.py file we can see that pages have curl ran against them and stores the contents in a /site_19/ directory with a UID and preserves 3 characters of the extension. The url is obtained by pulling the "src" attribute of an img tag. The admin can access `/scp-31337` and also any file ext on `/site_19`, so if we make a web page with the `scp-image-block` div with the url `file:///server/templates/scp-31337.html`, it will download it to the /site_19/ directory so that the chrome bot can view. Additionally this url won't have inline style scp so the redacted will be removed.
  
  *Note the extension is up to 3 characters so html will be shortened to htm)
  
  We can then provide the URL (.../site_19/UID.htm) to the screenshot program and get the unredacted version of the flag page.
  <!--[0m/-->
</details>
