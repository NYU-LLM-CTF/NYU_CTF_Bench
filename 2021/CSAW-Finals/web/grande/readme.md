# Grande

Description:

```
I tried to report a bug in this popular blogging site. But it seems like the admin did not appreciate it :(

https://grande-blog.site/

Note: The admin is using Chrome
```

Handout: [grande.tar.gz](grande.tar.gz)

Points: 400-500

<details>
  <summary>Spoiler warning</summary>
Flag: `flag{__is__proto__a__feature__or__a__bug__}`
</details>

## Solution

<details>
  <summary>Spoiler warning</summary>
  














































































  <!--Spoilers! [8;41;31m/-->
  We can see there is XSS on the redirect page. However the browser will redirect away before the html is parsed.
  Express allows complex objects to be passed via url args. This also includes `__proto__`! If we can construct an array for our url, then we can cause the slice operation to return an empty array. This means no redirect header will not be sent. 
  However there is a check for Array.isArray() we can bypass this by using `[__proto_][]=` and `[length]=2` which will give it a working indexOf function.

  Now you have html injection but the CSP is blocking us. The final trick we need is to mess up the csp nonce. If we request logout cross origin, it will *only* reset the nounce cookie (session is not sent bc of samesite lax). Now nonce won't get reloaded and is the string `undefined`!

  We now have full XSS and can just request and exfil the flag!
  <!--[0m/-->
</details>
