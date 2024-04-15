## slithery

* __Category:__ - pwn
* __Description:__ - Python sandbox that restricts commonly used payloads for escape. User must instead figure out from obfuscated source what dependency is being used (numpy), and use that in order to craft a specialized payload to cause a segmentation fault, which returns the flag.

```
Setting up a new coding environment for my data science students. Some of them are l33t h4ck3rs that got RCE and crashed my machine a few times :(

Can you help test this before I use it for my class? Hopefully two sandboxes is better than one...
```

## Usage

`sandbox.py` is given to the user.

```
$ python runner.py
```
