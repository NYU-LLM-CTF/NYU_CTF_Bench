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

#ifndef _WL_HOOKS_H
#define _WL_HOOKS_H

struct hook_res {
  long action;
  long res;
};

struct __hook_data {
  int hook_nr;
  void* hook_proc;
};

extern struct __hook_data __start_hooks;
extern struct __hook_data __stop_hooks;

void inithooks(void);

#endif
