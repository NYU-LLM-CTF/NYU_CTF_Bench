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

#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#include "ldw_rules.h"

#define CTL(action, ...) _CTL(ldw_ctl_##action, __VA_ARGS__)
#define _CTL(func, ...) ({       \
  int __res = func(__VA_ARGS__); \
  if (__res < 0)                 \
    perror(#func "() failed");   \
  __res;                         \
})

static int cfd;

static char __buff[4096];
#define tmp_rule ((struct ldw_rule*)__buff)
static char __buff2[4096];
#define rule_out ((struct ldw_rule*)__buff2)

static int nscanf(const char* format, ...);
static void end_line();
static int prompt_rule(int reset, struct ldw_rule *out, size_t name_len);
static void print_rule(struct ldw_rule *rule);

static inline int get_and_print()
{
  if (CTL(get, cfd, tmp_rule) < 0)
    return -1;

  print_rule(tmp_rule);
  return 0;
}

void ldw_interactive() 
{
  unsigned int choice;
  size_t name_len;

  rule_out->size = tmp_rule->size = sizeof(__buff);
  name_len = sizeof(__buff) - sizeof(*tmp_rule);

  cfd = open("/proc/ldw/ctl", O_RDONLY);
  if (cfd < 0) {
    perror("/proc/ldw/ctl");
    puts("(Are you root?)");
    exit(1);
  }

  // Advance to first one
  if (CTL(next, cfd) == LDW_LIST_EOF)
    puts("There are no rules.");
  else {
    get_and_print();
  }

  while (1) {
    fputs("Input a selection: \n"
         "  0. Next rule\n"
         "  1. Previous rule\n"
         "  2. Insert before current\n"
         "  3. Insert after current\n"
         "  4. Edit current rule\n"
         "  5. Delete rule\n"
         "  6. Exit\n"
         "$ ", stdout);
    if (nscanf("%d", &choice) != 1)
      exit(0);
    
    switch (choice) {
      case 0: // next
        if (CTL(next, cfd) == LDW_LIST_EOF)
          puts("You have reached the end.");
        else
          get_and_print();
        break;
      case 1: // prev
        if (CTL(prev, cfd) == LDW_LIST_EOF)
          puts("You have reached the end.");
        else
          get_and_print();
        break;
      case 2: // insert before
        if (prompt_rule(1, rule_out, name_len))
          CTL(insert_before, cfd, rule_out);
        break;
      case 3: // insert after
        if (prompt_rule(1, rule_out, name_len))
          CTL(insert_after, cfd, rule_out);
        break;
      case 4: // edit
        if (get_and_print() < 0)
          continue;
        memcpy(rule_out, tmp_rule, sizeof(__buff));
        if (prompt_rule(0, rule_out, name_len))
          CTL(edit, cfd, rule_out);
        break;
      case 5: // delete
        if (CTL(delete, cfd) == LDW_LIST_EOF)
          puts("You have reached the end.");
        else
          get_and_print();
        break;
      case 6: // exit
        exit(0);
    }
  }
}

int nscanf(const char *format, ...) 
{
  int ret;
  va_list args;

  va_start(args, format);
  ret = vscanf(format, args);
  va_end(args);
end_line();
  return ret;
}

static void end_line() 
{
  int c;
  while ((c = getchar()) != EOF) {
    if (c == '\n')
      return;
  }

  exit(0);
}

static void prompt_rule_mode(struct ldw_rule *out, size_t name_len)
{
  unsigned int choice;

  fputs("Input rule filter mode:\n"
        "  0. Unconditional\n"
        "  1. Match prefix\n"
        "  2. Match full\n"
        "  3. Match directory path\n"
        "  4. Match suffix\n"
        "  5. Cancel\n"
        "$ ", stdout);

  if (nscanf("%d", &choice) != 1)
    return;
  switch (choice) {
    case 0:
      break;
    case 1 ... 4:
      puts("Input path name:");
      if (!fgets(out->name, name_len, stdin))
        exit(0);
      name_len = strlen(out->name);
      if (out->name[name_len - 1] == '\n')
        out->name[name_len - 1] = 0;
      break;
    default:
      return;
  }
  out->filt_mode = (out->filt_mode & ~LDW_RULE_FILT_MODE) | choice;
}

static int prompt_rule(int reset, struct ldw_rule *out, size_t name_len)
{
  unsigned int choice;
  int c;
  int32_t uid;

  if (reset) {
    out->filt_mode = 0;
    out->tgtUser = -1;
    out->tgtGroup = -1;
    out->name[0] = 0;
  }

  while (1) {
loop:
    fputs("Select option to modify rule: \n"
         "  0. Set filter mode\n"
         "  1. Set filter user\n"
         "  2. Set filter group\n"
         "  3. Toggle permit/deny\n"
         "  4. Done\n"
         "  5. Cancel\n"
         "$ ", stdout);
    if (nscanf("%d", &choice) != 1)
      return 0;
    switch (choice) {
      case 0: // mode
        prompt_rule_mode(out, name_len);
        break;
      case 1: // user
        fputs("Input new UID target or -1 to disable: ", stdout);
        if (nscanf("%d", &uid) != 1)
          goto loop;
        if (uid == -1)
          out->filt_mode &= ~LDW_RULE_FILT_USER;
        else {
          out->filt_mode |= LDW_RULE_FILT_USER;
          out->tgtUser = uid;
        }
        break;
      case 2: // group
        fputs("Input new GID target or -1 to disable: ", stdout);
        if (nscanf("%d", &uid) != 1)
          goto loop;
        if (uid == -1)
          out->filt_mode &= ~LDW_RULE_FILT_GROUP;
        else {
          out->filt_mode |= LDW_RULE_FILT_GROUP;
          out->tgtGroup = uid;
        }
        break;
      case 3: // permit/deny
        out->filt_mode ^= LDW_RULE_FILT_PERMIT;
        if (out->filt_mode & LDW_RULE_FILT_PERMIT)
          puts("This is now a permit rule.");
        else 
          puts("This is now a deny rule.");
        break;
      case 4: // done
        print_rule(out);
        fputs("Do you want to continue? (y/n) ", stdout);
        while ((c = getchar()) != EOF) {
          if (c != '\n')
            end_line();
          c = tolower(c);
          if (c == 'y')
            return 1;
          else if (c == 'n')
            goto loop;
         
          fputs("(y/n) ", stdout);
        }
        exit(0); // EOF
      case 5: // cancel
        return 0;
    }
  }
}

static void print_rule(struct ldw_rule* rule) 
{
#define CASE_MODE(name) _CASE_MODE(LDW_RULE_MODE_##name)
#define _CASE_MODE(name) case (name): puts(#name); break;
  int flags;
  
  flags = rule->filt_mode;

  puts("Current rule: ");
  fputs("  Action: ", stdout);
  puts((flags & LDW_RULE_FILT_PERMIT) ? "Permit" : "Deny");

  fputs("  Flags: ", stdout);
  if (flags & LDW_RULE_FILT_USER)
    printf(" LDW_RULE_FILT_USER(%u) ", rule->tgtUser);
  if (flags & LDW_RULE_FILT_GROUP)
    printf(" LDW_RULE_FILT_GROUP(%u) ", rule->tgtGroup);
  puts("");

  fputs("  Mode: ", stdout);
  switch (flags & LDW_RULE_FILT_MODE) {
    CASE_MODE(UNCOND)
    CASE_MODE(PREFIX)
    CASE_MODE(MATCH)
    CASE_MODE(PREFDIR)
    CASE_MODE(SUFFIX)
    default:
      puts("<unknown>");
      goto no_path;
  }

  if (flags & LDW_RULE_FILT_MODE) {
    printf("  Path: \"%s\"\n", rule->name);
//    fwrite(rule->name, 1, 4080, stdout);
  }
no_path:
  puts("");
#undef CASE_MODE
#undef _CASE_MODE
}
