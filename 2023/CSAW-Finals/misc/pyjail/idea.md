# PyJail

The core of pyjails is finding and recovering:
* Strings
* getattr
* imports/modules (specifically os module)

# AST - Abstract Syntax Trees

"The `ast` module helps Python applications to process trees of the Python abstract syntax grammar".

Or in other words, pre-compile codes into processable events, each event symbolized by a class in ast

we have classes ranging from ast.import, ast.Attribute, etc.

## Python 3.10 Match

With the introduction of match statement, we have other means of achieving "getattr" and "assign", more specifically

ast.MatchClass and ast.MatchAs. See snipplet of code below:

```
import ast

for n in ast.walk(ast.parse('''match a:
    case object(__doc__=a):
        pass''')):
    print(type(n))

```

with the parsed code matching the below:

```
match a:
    case object(__doc__=a):
        pass
```

The output of the ast code above is:

```
<class 'ast.Module'>
<class 'ast.Match'>
<class 'ast.Name'>
<class 'ast.match_case'>
<class 'ast.Load'>
<class 'ast.MatchClass'>
<class 'ast.Pass'>
<class 'ast.Name'>
<class 'ast.MatchAs'>
<class 'ast.Load'>
```

and notice how ast.Attribute is no where to be found, while running the match statement

results in `a` being assigned `a.__doc__`. This is documented here: https://docs.python.org/3/library/ast.html

This can result in a violation in security requirements for existing codes that haven't been updated when systems migrate to 3.10 from earlier


Now we have getattribute, we can easily recover strings by walking through strings and using the wildcard match, now all we need is modules,

and it is not going to be this easy.

# Python Audits

Introduced in Python 3.8, we have python audits that captures events such as imports, function calls, and object serialization.

https://docs.python.org/3/library/audit_events.html

with this, we can easily implement a callback that fires everytime an event occurs, but the function is going to be as useful as

the naive calls to functions that would've otherwise been tampered with, more specifcally `exit()`.

## GC

You can recover __main__.__exit by going through the GC, see solve.py and solve_findindex.py

now you have getattr, you have import os, just cat flag.txt

