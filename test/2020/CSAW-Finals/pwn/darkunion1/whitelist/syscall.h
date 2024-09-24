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

#ifndef _WL_SYSCALL_H
#define _WL_SYSCALL_H

#include <linux/kernel.h>
#include <linux/syscalls.h>
#include <linux/sched/signal.h>
#include <asm/asm-offsets.h>

#include "hooks.h"

#define HOOK_ACTION_CONT 1
#define HOOK_ACTION_RETN 2
#define HOOK_ACTION_KILL 3

#define HOOK_CONT return (struct hook_res){.action=HOOK_ACTION_CONT,.res=0}
#define HOOK_RET(r) return (struct hook_res){.action=HOOK_ACTION_RETN,.res=(r)}
#define HOOK_KILL return (struct hook_res){.action=HOOK_ACTION_KILL,.res=0}


#define SYSCALL_HOOK1(name, ...) __SYSCALL_HOOKx(1, _##name, __VA_ARGS__)
#define SYSCALL_HOOK2(name, ...) __SYSCALL_HOOKx(2, _##name, __VA_ARGS__)
#define SYSCALL_HOOK3(name, ...) __SYSCALL_HOOKx(3, _##name, __VA_ARGS__)
#define SYSCALL_HOOK4(name, ...) __SYSCALL_HOOKx(4, _##name, __VA_ARGS__)
#define SYSCALL_HOOK5(name, ...) __SYSCALL_HOOKx(5, _##name, __VA_ARGS__)
#define SYSCALL_HOOK6(name, ...) __SYSCALL_HOOKx(6, _##name, __VA_ARGS__)

typedef asmlinkage long (*syshook_t)(const struct pt_regs *regs);

#define __SYSCALL_HOOKx(x, name, ...) \
  static inline struct hook_res _hk##name(__MAP(x,__SC_DECL,__VA_ARGS__)); \
  static asmlinkage struct hook_res __se_syshook##name(__MAP(x,__SC_LONG, __VA_ARGS__)); \
  static asmlinkage long __x64_syshook##name(const struct pt_regs *regs) { \
    struct hook_res ret = __se_syshook##name(SC_X86_64_REGS_TO_ARGS(x, __VA_ARGS__)); \
    switch (ret.action) {                                                  \
      case HOOK_ACTION_CONT:                                               \
        return ((syshook_t)old_sys_table[__NR##name])(regs);               \
      case HOOK_ACTION_RETN:                                               \
        return ret.res;                                                    \
      case HOOK_ACTION_KILL:                                               \
        kill_pid(task_pid(current), SIGKILL, 1);                           \
        return 0;                                                          \
      default:                                                             \
        printk(KERN_ERR "Unknown hook action");                            \
    }                                                                      \
    return -1;                                                             \
  }                                                                        \
  static asmlinkage struct hook_res __se_syshook##name(__MAP(x,__SC_LONG, __VA_ARGS__)) { \
    return _hk##name(__MAP(x, __SC_CAST, __VA_ARGS__));                    \
  }                                                                        \
  struct __hook_data _hdata##name __attribute__((section(".hooks"))) =     \
    {.hook_nr = __NR##name, .hook_proc = __x64_syshook##name};             \
  static inline struct hook_res _hk##name(__MAP(x,__SC_DECL,__VA_ARGS__))

extern void* old_sys_table[__NR_syscall_max+1];


#endif

