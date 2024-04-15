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

#ifndef _LDWRULES_H
#define _LDWRULES_H

#include <sys/types.h>
#include <unistd.h>
#include <stdint.h>

#define __NR_ldw_ctl 17
#define SYS_ldw_ctl __NR_ldw_ctl

#define LDW_RULE_MODE_UNCOND    0
#define LDW_RULE_MODE_PREFIX    1
#define LDW_RULE_MODE_MATCH     2
#define LDW_RULE_MODE_PREFDIR   3
#define LDW_RULE_MODE_SUFFIX    4

#define LDW_RULE_FILT_MODE   0x07
#define LDW_RULE_FILT_USER   0x08
#define LDW_RULE_FILT_GROUP  0x10
#define LDW_RULE_FILT_PERMIT 0x20


#define LDW_LIST_EOF  0
#define LDW_LIST_MORE 1

enum ldw_ctl_requests {
  LDW_CTL_NEXT = 0, LDW_CTL_PREV, LDW_CTL_EDIT, LDW_CTL_INSERT_AFTER, 
  LDW_CTL_INSERT_BEFORE, LDW_CTL_DELETE, LDW_CTL_GET
};

struct ldw_rule {
  uint32_t size;
  uid_t tgtUser;
  gid_t tgtGroup;
  int filt_mode;
  char name[];
}  __attribute__((__packed__));


static inline ssize_t ldw_ctl(int fd, unsigned long request, 
    struct ldw_rule *arg) 
{
  return syscall(__NR_ldw_ctl, fd, request, arg);
}

int ldw_ctl_delete(int fd);
int ldw_ctl_edit(int fd, struct ldw_rule *item);
ssize_t ldw_ctl_get(int fd, struct ldw_rule *ret);
int ldw_ctl_insert_before(int fd, struct ldw_rule *item);
int ldw_ctl_insert_after(int fd, struct ldw_rule *item);
int ldw_ctl_next(int fd);
int ldw_ctl_prev(int fd);



#endif
