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
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <wordexp.h>

#include "ldw_rules.h"

#define msg(m,...) fprintf(stderr, m "\n", ##__VA_ARGS__)
#define LERR(m, ...) do {                             \
  msg("ERROR (line %d): " m, linenum, ##__VA_ARGS__); \
  errors++;                                           \
} while (0)
#define LWARN(m, ...) do {                              \
  msg("WARNING (line %d): " m, linenum, ##__VA_ARGS__); \
  warnings++;                                           \
} while (0)
#define LINFO(m, ...) msg("INFO (line %d): " m, linenum, ##__VA_ARGS__)
#define GERR(m...) do { \
  msg("ERROR: " m);     \
  errors++;             \
} while(0)
#define GWARN(m...) do { \
  msg("WARNING: " m);    \
  warnings++;            \
} while(0)

#define CTL(action, ...) _CTL(ldw_ctl_##action, __VA_ARGS__)
#define _CTL(func, ...) ({                        \
  int __res = func(__VA_ARGS__);                  \
  if (__res < 0)                                  \
    GERR(#func "() failed: %s", strerror(errno)); \
  __res;                                          \
})

#define GINFO(m...) msg("INFO: " m)

enum ldw_file_state {
  LDW_FILE_NONE, LDW_FILE_INSERT_BEFORE, LDW_FILE_INSERT_AFTER
};

enum ldw_error_type {
  LDW_ERROR_WARNING, LDW_ERROR_INFO, LDW_ERROR_ERROR, LDW_ERROR_LAST = LDW_ERROR_ERROR
};

static int linenum, state = LDW_FILE_NONE, errors, warnings, fd_ldw;
static char buff[4096];

static void parse_line(void);
static int parse_ldw_rule(struct ldw_rule *out, const char *line);

void set_ldw_from_file(FILE* fconfig, int *out_errs, int *out_warns) 
{
  size_t len;

  errors = 0;
  warnings = 0;

  fd_ldw = open("/proc/ldw/ctl", O_RDONLY);
  if (fd_ldw < 0) {
    GERR("/proc/ldw/ctl: %s", strerror(errno));
    puts("(Are you root?)");
    goto out;
  }

  while (fgets(buff, sizeof(buff), fconfig)) {
    linenum++;
    len = strlen(buff);

    if (buff[len - 1] != '\n') {
      LERR("Line is too long!");
      return;
    } else
      buff[len - 1] = 0;

    parse_line();
  }

out:
  if (out_errs)
    *out_errs = errors;
  if (out_warns)
    *out_warns = warnings;
}

static void parse_line(void) 
{
  char __rule[4096];
  struct ldw_rule *rule = (struct ldw_rule*)__rule;
  char *line = buff, *end;

  rule->size = sizeof(__rule);

  if (isspace(*line)) {
    while (*line && isspace(*line))
      line++;
    if (*line) {
      switch (state) {
        case LDW_FILE_NONE:
          LERR("No valid target for item.");
          break;
        case LDW_FILE_INSERT_BEFORE:
          if (parse_ldw_rule(rule, line) < 0)
            break;
          CTL(insert_after, fd_ldw, rule);
          CTL(prev, fd_ldw);
          break;
        case LDW_FILE_INSERT_AFTER:
          if (parse_ldw_rule(rule, line) < 0)
            break;
          CTL(insert_before, fd_ldw, rule);
          CTL(next, fd_ldw);
          break;
        default:
          GERR("Invalid state (%d).", state);
      }
    }
  } else {
    if (!*line) {
      state = LDW_FILE_NONE;
      return;
    }
    
    end = strchr(line, ':');
    if (!end) {
      LERR("Invalid line.");
      return;
    }

    *end = 0;
    end++;
    while (*end && isspace(*end))
      end++;

    if (*end) {
      LERR("Invalid character(s) after target.");
      return;
    }

    if (!strcmp(line, "insert_after"))
      state = LDW_FILE_INSERT_AFTER;
    else if (!strcmp(line, "insert_before"))
      state = LDW_FILE_INSERT_BEFORE;
    else {
      LERR("Invalid target '%s'.", line);
    }
  }
}

static unsigned long parse_uid(const char *str)
{
  char *end;
  unsigned long res;

  errno = 0;
  res = strtol(str, &end, 10);
  if (errno || *end) {
    LERR("Invalid uid/gid: '%s'", str);
    return -1;
  }

  return res;
}

static int parse_ldw_rule(struct ldw_rule *out, const char *line)
{
  size_t name_len = out->size - sizeof(*out), i;
  unsigned long res;
  wordexp_t p;
  char **w;
  
  out->filt_mode = LDW_RULE_FILT_PERMIT;
  out->tgtUser = -1;
  out->tgtGroup = -1;
  out->name[0] = 0;

  if (wordexp(line, &p, 0)) {
    LERR("Syntax error!");
    return -1;
  }

  w = p.we_wordv;
  for (i = 0; i < p.we_wordc; i++) {
    if (!strcasecmp(w[i], "PERMIT"))
      out->filt_mode |= LDW_RULE_FILT_PERMIT;
    else if (!strcasecmp(w[i], "DENY"))
      out->filt_mode &= ~LDW_RULE_FILT_PERMIT;
    else if (!strcasecmp(w[i], "USER")) {
      res = parse_uid(w[++i]);
      if (res == (unsigned long)-1)
        goto errOut;
      out->filt_mode |= LDW_RULE_FILT_USER;
      out->tgtUser = res;
    } else if (!strcasecmp(w[i], "GROUP")) {
      res = parse_uid(w[++i]);
      if (res == (unsigned long)-1)
        goto errOut;
      out->filt_mode |= LDW_RULE_FILT_GROUP;
      out->tgtGroup = res;
    } else if (!strcasecmp(w[i], "NOUSER"))
      out->filt_mode &= ~LDW_RULE_FILT_USER;
    else if (!strcasecmp(w[i], "NOGROUP"))
      out->filt_mode &= ~LDW_RULE_FILT_GROUP;
    else if (!strcasecmp(w[i], "UNCOND")) {
      out->filt_mode = (out->filt_mode & ~LDW_RULE_FILT_MODE) | LDW_RULE_MODE_UNCOND;
      out->name[0] = 0;
    }
#define ELSE_IF_MODE(mode) else if (!strcasecmp(w[i], #mode)) { \
      out->filt_mode = (out->filt_mode & ~LDW_RULE_FILT_MODE) | \
        LDW_RULE_MODE_##mode;                                   \
      if (i + 1 >= p.we_wordc) {                                \
        LERR("Expected argument!");                             \
        goto errOut;                                            \
      }                                                         \
      if (strlen(w[++i]) >= name_len) {                         \
        LERR("Path name is too long!");                         \
        goto errOut;                                            \
      }                                                         \
      strcpy(out->name, w[i]);                                  \
    }
    ELSE_IF_MODE(PREFIX)
    ELSE_IF_MODE(MATCH)
    ELSE_IF_MODE(PREFDIR)
    ELSE_IF_MODE(SUFFIX)
#undef ELSE_IF_MODE
    else {
      LERR("Invalid rule argument: '%s'", w[i]);
      goto errOut;
    }
  }

  wordfree(&p);
  return 0;

errOut:
  wordfree(&p);
  return -1;
}

