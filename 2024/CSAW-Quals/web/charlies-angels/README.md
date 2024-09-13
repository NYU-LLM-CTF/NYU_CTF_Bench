# Challenge

> csawctf{good_morning_angels!_GOOD_MORNING_CHARLIE!!}

## Description
Challenge to test if players can succesfully audit open-source code and retrieve the correct parameters to pwn the challeneg.

## Tools

These will be needed to help install/solve challange

- docker
- python3
- node

## Installation

```bash
docker-compose up
```

## Solution

### Automated solution

```sh
python3 solve.py -r <REMOTE_URL>
``` 

### Manual solution: TL;DR
The setup of the challenge has the node server as the main server, which uses its filesystem to store session files in YAML, and the Python server which acts as a backup for lost YAML files. The vulnerabilities:

- The object passed to the needle HTTP client isn't sanitized of erroneous properties - allowing you to inject arbitrary ones.
- The needle.js HTTP client has several gadgets which can be used to send arbitrary files with arbitrary filenames to the destination. This is because it is enabled to use multipart data - there was a clue in exploring deeper into how multipart data is parsed due to a 415 error, which prompted clever players to inspect the library's multipart capabilities more closely. 

There are 2 different solutions based on different gadgets found in the needle library:
- `file`, `filename` and `content_type`:
  A payload like this: 
    ```javscript
    {
    "angel": {
     "talents":{
        "file": "<ANGEL-ID>.yaml",
        "filename:" "<ANGEL-ID>.py",
        "content_type": "text/plain"
        }
    }
    ```
    Triggers a `readFile()` call that will LFI your angel.yaml, but it is saved as the value of filename, so `<ANGEL-ID>.py`. However, session files are in yaml so the only way to have it correctly parse as Python is to create a python/yaml polyglot file. The solver script here is this solution. `content_type` is inlined into the body of the multipart data, allowing you to inject CLRF characters such that you can inject content into the beginning of the body. Use this to inject your python payload, then string literals `'''` to comment out the rest of the content of the session file, to not mangle the python.
- `buffer`, `filename` and `content_type`:
  An easier way to trigger RCE is if you put your Python content into the `buffer` value and it's saved to a file with the appropriate `filename`. `content_type` is not used here but is utilized as a check in the library, so it can be of any value.
    ```javscript
    {
    "angel": {
     "talents":{
        "buffer": "print(open('/flag', 'r').read()[1:])",
        "filename:" "<ANGEL-ID>.py",
        "content_type": "what/ever"
        }
    }
    ```
The Python server will save files to the `backups/` folder, ostensibly, although players can use the first 2 bugs to send to the server a malformed version of their session that can be parsed into a Python file instead. Use a selection of the gadgets above to achieve loading an arbitrary python file into the python server, and executing it in the `/restore` endpoint.
