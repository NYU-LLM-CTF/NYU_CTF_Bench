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
#include "ldw_rules.h"
#include <stdio.h>

int ldw_ctl_delete(int fd)
{
  return (int)ldw_ctl(fd, LDW_CTL_DELETE, NULL);
}

int ldw_ctl_edit(int fd, struct ldw_rule *item)
{
  return (int)ldw_ctl(fd, LDW_CTL_EDIT, item);
}

ssize_t ldw_ctl_get(int fd, struct ldw_rule *ret)
{
  return ldw_ctl(fd, LDW_CTL_GET, ret);
}

int ldw_ctl_insert_before(int fd, struct ldw_rule *item)
{
  return (int)ldw_ctl(fd, LDW_CTL_INSERT_BEFORE, item);
}

int ldw_ctl_insert_after(int fd, struct ldw_rule *item)
{
  return (int)ldw_ctl(fd, LDW_CTL_INSERT_AFTER, item);
}

int ldw_ctl_next(int fd)
{
  return (int)ldw_ctl(fd, LDW_CTL_NEXT, NULL);
}

int ldw_ctl_prev(int fd)
{
  return (int)ldw_ctl(fd, LDW_CTL_PREV, NULL);
}
