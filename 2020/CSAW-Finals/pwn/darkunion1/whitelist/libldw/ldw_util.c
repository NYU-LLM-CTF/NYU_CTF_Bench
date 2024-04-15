/*
 * Copyright (c) 2018 theKidOfArcrania
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#define _GNU_SOURCE

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "ldw_rules.h"

#define VERS "v0.9-alpha"

#define FLAG_VERSION 0

int long_flag;
const char *sh_opts = "Bc:hi";
const struct option long_opts[] = {
  {"no-buffer",   no_argument, 0,          'B'          },
  {"help",        no_argument, 0,          'h'          },
  {"interactive", no_argument, 0,          'i'          },
  {"version",     no_argument, &long_flag, FLAG_VERSION },
  {0,             0,           0,           0           }
};

extern void set_ldw_from_file(FILE* fconfig, int *out_errs, int *out_warns);
extern void ldw_interactive();

void version(void);
void usage(const char *prog);

int main(int argc, char **argv) 
{
  FILE *fconf;
  const char *file = NULL, *prog = argv[0];
  int has_req_flag = 0, interactive = 0, errs = 0;
  char c;


  while((c = getopt_long(argc, argv, sh_opts, long_opts, NULL)) != -1) {
    switch (c) {
      case 0:
        if (long_flag == FLAG_VERSION)
          version();
        break;
      case 'B':
        // Buffering might be a source of nuisance. So let's just disable it.
        setbuf(stdin, NULL);
        setbuf(stdout, NULL);
        break;
      case 'c':
        if (has_req_flag) {
          puts("Multiple -c, -i options not supported\n");
          usage(prog);
        }
        has_req_flag = 1;
        file = optarg;
        break;
      case 'i':
        if (has_req_flag) {
          puts("Multiple -c, -i options not supported\n");
          usage(prog);
        }
        has_req_flag = 1;
        interactive = 1;
        break;
      case 'h':
      case '?':
        usage(prog);
    }
  }

  if (!has_req_flag)
    usage(prog);

  if (interactive) 
    ldw_interactive();
  else {
    fconf = fopen(file, "r");
    if (!fconf) {
      perror("fopen() failed");
      exit(1);
    }
    set_ldw_from_file(fconf, &errs, NULL);
    exit(errs ? 1 : 0);
  }
}

void version(void)
{
  puts(
   "ldw_util "VERS"\n"
   "\n"
   "Copyright (C) 2018 theKidOfArcrania \n"
   "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.\n"
   "This is free software: you are free to change and redistribute it.\n"
   "There is NO WARRANTY, to the extent permitted by law.\n"
   "\n"
   "(It's open-sourced, but you do NOT get the source code during the competition.\n"
   "Maybe if you ask nicely afterwards, you can have the source code. :P )\n"
   "\n"
   "Hahaha I guess you found one of the dev programs. Hello, hello here!\n"
   "\n"
   "Anyways, this particular program (here's a hint) isn't of much direct use to \n"
   "you. You could possibly use this one to figure out how to interface with the \n"
   "/proc/ldw/ctl file, but you'll have to find another way to actually do that! xD"
  );
  exit(1);
}

void usage(const char *prog) 
{
  printf("Usage: %s [-i] [-c file] [--version] [-h] [OPTS...]\n\n", prog);
  puts(
   "You must specify either -i, -c\n"
   "Please specify --version for some more information!\n"
   "\n"
   "ldw_util "VERS" -- utility to manipulate Lock-Down Whitelist (LDW) rules.\n"
   "\n"
   "OPTIONS:\n"
   "  -B,  --no-buffer      Disables stdin/stdout buffering.\n"
   "  -c file               Loads ldw rules into /proc/ldw/ctl from file. (Must\n"
   "                          be root user to do that!)\n"
   "  -h,  --help           Prints this help message. \n"
   "  -i,  --interactive    Fires up an interactive shell to manipulate /proc/ldw/ctl.\n"
   "                          (Also requires root user.)\n"
   "       --version        Prints an extended version information."
  );
  exit(1);
}
