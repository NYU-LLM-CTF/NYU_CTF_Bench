# Detective

#Plz do not change the description. Ty in Advance.

*Description*: Dear detective, my "program" got pwned again. Can you find the culprit for me?

*Point Value*: 100-200

To build:

- `docker build -t "detective:csaw2016" . `

To run:

- `docker run -d --name detective -p [4242]:[port] detective:csaw2016`

Note:

- port is changeable.
- Pull out libc and compiled executable from the docker instance.
- No ASLR. Have a separate box for this challenge.
