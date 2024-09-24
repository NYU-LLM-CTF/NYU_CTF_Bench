## Darkunion

**Description**: I dug up the source code for a *proprietary* kernel module that is
part of a certain unknown application whitelist software, with a few rashly documented
vulnerabilities. No one got a chance to exploit the vulns before the project got
altogether dropped. Maybe you could take a shot at it?

**Category**: pwn

**Suggested Points**: 200-250 and 400-500

**Public files**: handout.tar.gz

**Author's note**: This is a two-stage kernel challenge that revolves around an
(obviously) broken application whitelister/applocker like program. To make the
bugs more obvious, and to make this challenge more revolve around the
exploitation phase rather than the more (boring) reading and finding the bug
phase, a `KNOWN_BUGS` file is created, which hints at where the bug is located
(without really giving away how to exploit the bug).

All the files (with the obvious exception of the `flag.server.img` file) is
expected to be given to the player (i.e. including full source), since the
entire kernel module is considered substantial. While the player cannot actually
build the kernel module (as they do not have the kernel headers, nor the actual
kernel version that is built against), they can use the source code to expedite
the tedious reverse engineering step.

Deployment can simply be done using the dockerfile provided here. This will expose 
one port (port 1337).

**Solution**: You need to first install musl-gcc and nasm, and then you can just
run the Makefile on the exp/ folder. You need to also setup a public file host
server so that the qemu box can download all the exploit files. Use [this] as a
guide for how to run it. Sometimes the exploit may fail.

[1]: https://asciinema.org/a/jhlfTzzf2mebflBua1BG1YmM1
