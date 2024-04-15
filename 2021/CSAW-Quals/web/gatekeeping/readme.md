# Gatekeeping

Description:

```
My previous flag file got encrypted by some dumb ransomware. They didn't even tell me how to pay them, so I'm totally out of luck. All I have is the site that is supposed to decrypt my files (but obviously that doesn't work either)

<server link>
 
```

Handout: [gatekeeping.tar.gz](gatekeeping.tar.gz)

Points: 400? Needs playtesting

Flag: `flag{gunicorn_probably_should_not_do_that}`

Setup: `docker build -t gatekeeping .` and then run the container with port 80 forwarded to whatever port you want

## Solution

<details>
  <summary>Spoiler warning</summary>
  














































































  <!--Spoilers! [8;41;31m/-->
  The WSGI protocol has a few special environmental variables it uses to control things like base path. `SCRIPT_NAME` will act as the base of the path: the WSGI app will only get values after it. Usually these variables are loaded from the environment, but gunicorn will actually load `SCRIPT_NAME` from the request headers.

  We can abuse this fact to modify our request path after nginx has approved it. By requesting `/asdf/admin/key` with `SCRIPT_NAME: asdf/`, the app will actually request `/admin/key`. However nginx only checks for the `/admin` at the start, so the request is allowed.

  Using thing we can get the encryption key and decrypt the flag
  <!--[0m/-->
</details>
