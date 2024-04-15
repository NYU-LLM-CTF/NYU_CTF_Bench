# Writeup

Imagine two parts of a computer system, Nginx and Node.js. Nginx has rules that say, "Don't let anyone visit the `/ram` page." However, Node.js has a special way of understanding web addresses. It can sometimes "ignore" certain characters in the address.

Nginx is configured with rules to deny access to the `/profile/ram` and `/profile/ram/` endpoints. However, Node.js, using Express, employs character normalization that "ignores" specific characters like `\x09`, `\xa0`, and `\x0c` from the URL.

Got the point? Nginx includes these characters in the URL, while Node.js removes them. As a result, Nginx forwards HTTP requests to the backend when it should deny them, effectively bypassing the ACL rules.

**Solution**

- Use hex `\xA0` at the end of profile: `GET /profile/ram\xA0 HTTP/1.1`
- Now, Nodejs will trim `\xA0` and NGINX will allow this character as we are using `location = /profile/ram` (equals to some parameter)

**Fix**
Alright, so this may not be as crucial as the meaning of life or finding the perfect pizza topping, but it's helpful nonetheless, so here we go!

- Use this instead of equal sign `location ~* ^/ram`.
- This expression will check for `ram` string in the URL. If that word is present, it will block it!
