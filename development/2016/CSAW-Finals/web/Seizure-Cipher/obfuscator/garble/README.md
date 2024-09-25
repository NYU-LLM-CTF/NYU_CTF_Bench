_**garble** is a python tool that takes javascript obfuscation to the extreme._

###Why should I use garble ?
- You want to double , even tripple the file size of your javascript.(optional)
- You want deployed code to become unreadable and extraordinarily difficult to debug.

##How to use.

###_**garble**_ depends on python 2.7 and slimit.

1. install python 2.7
2. install slimit
3. install unidecode (This is helps standardize input from various encodings Latin-1,UTF-16,etc)

#####Invoke garble.py with an input and desired output and specify wether or not you'd like to use compression.
**NOTE** by gziping the garbled files you will need to configure your server to set the Content-Encoding response header, as well as write some additional ajax code that will need to be eval'd in the dom. Please reference the **server.js** file for a node.js example of how to do this , as well as the **js/main.js** file for the general ajax call.
```
python garble.py "PATH_TO_INPUT/INPUT_FILE.js" "PATH_TO_OUTPUT/OUTPUT_FILE.js" "yes||no" 
```

enjoy success.

See the 'sample' directory for some common examples of garbled libraries.