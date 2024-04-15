/*
 * Copyright (c) 2018 theKidOfArcrania
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.  *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <linux/capability.h>
#include <linux/err.h>
#include <linux/errno.h>
#include <linux/fcntl.h>
#include <linux/file.h>
#include <linux/fs.h>
#include <linux/mman.h>
#include <linux/namei.h>
#include <linux/random.h>
#include <linux/string.h>
#include <linux/syscalls.h>

#include "syscall.h"
#include "rules.h"
#include "syms.h"
//#include "mem_dbg.h"

#define PASS_ROUNDS 52

static void** sys_call_table;
void* old_sys_table[__NR_syscall_max+1];

static int state = -1;
static int pass[PASS_ROUNDS];


static struct hook_res check_file(struct path *path);
static int resolve_path(int dfd, const char __user *filename, int flags, 
    struct path *path);

SYSCALL_HOOK3(execve, 
    const char __user*, filename,
    const char __user *const __user *, argv,
    const char __user *const __user *, envp) 
{
  int error;
  struct path fpath;
  error = resolve_path(AT_FDCWD, filename, 0, &fpath);
  if (error < 0)
    HOOK_RET(error);
  return check_file(&fpath);
}

SYSCALL_HOOK5(execveat, 
    int, fd, const char __user*, filename,
    const char __user *const __user *, argv,
    const char __user *const __user *, envp, 
    int, flags) 
{
  int error;
  struct path fpath;
  error = resolve_path(fd, filename, flags, &fpath);
  if (error < 0)
    HOOK_RET(error);
  return check_file(&fpath);
}

SYSCALL_HOOK1(uselib, const char __user *, library)
{
  int error;
  struct path fpath;
  error = resolve_path(AT_FDCWD, library, 0, &fpath);
  if (error < 0)
    HOOK_RET(error);
  return check_file(&fpath);
}

static int resolve_path(int dfd, const char __user* filename, int flags, 
    struct path *path)
{
  int lookup_flags = LOOKUP_FOLLOW;

  if (flags & AT_EMPTY_PATH)
    lookup_flags |= LOOKUP_EMPTY;
  if (flags & AT_SYMLINK_NOFOLLOW)
    lookup_flags &= ~LOOKUP_FOLLOW;
  
  return user_path_at(dfd, filename, lookup_flags, path);
}

static inline void _trim(char *str, const char *testing) {
  int total_len = strlen(str), top_len = strlen(testing);
  if (total_len < top_len)
    return;

  if (!strcmp(testing, str + (total_len - top_len)))
    str[total_len - top_len] = 0;
}

static struct hook_res check_file(struct path *fpath)
{
  char *buff, *name;

  if (d_is_symlink(fpath->dentry))
    HOOK_RET(-ELOOP);
  if (!d_is_reg(fpath->dentry))
    HOOK_RET(-EPERM); // Don't check if this is not a regular file!

  buff = kmalloc(PATH_MAX, GFP_KERNEL);
  if (!buff)
    HOOK_RET(-ENOMEM);

  name = d_path(fpath, buff, PATH_MAX);
  if (IS_ERR(name))
    HOOK_RET(PTR_ERR(name));

  _trim(name, " (deleted)");

  printk("[+] Testing >%s<\n", name);

  if (capable(CAP_LDW_RULE)) {
    printk("[*] Overriding whitelist rules.\n");
  } else {
    if (ldw_check_file(name) < 0) {
//    if (strncmp("/bin", name, 4)  && strncmp("/usr/bin", name, 8) &
//        strncmp("/sbin", name, 5) && strncmp("/usr/sbin", name, 9) &&
//        strncmp("/lib", name, 4) && strcmp("/etc/init.d/rcS", name)) {
      printk("[!] Binary not in whitelist!\n");

      kfree(buff);
      HOOK_KILL;
    }
  }

  kfree(buff);

  HOOK_CONT;
}

void inithooks(void)
{
  unsigned int i;
  struct __hook_data* hooks;
  unsigned long val;

  sys_call_table = (void**)DEF_SYS_CALL_TABLE;
  for (i = 0; i <= __NR_syscall_max; i++) {
    old_sys_table[i] = sys_call_table[i];
  }

  // Force cr0 write to clear WP flag
  val = read_cr0 () & (~ 0x10000);
  asm volatile("mov %0,%%cr0": "+r" (val));
  
  for (hooks = &__start_hooks; hooks < &__stop_hooks; hooks++) {
    sys_call_table[hooks->hook_nr] = hooks->hook_proc;
    printk("[*] Hooked sys_call_table[%d]\n", hooks->hook_nr);
  }

  write_cr0 (read_cr0 () | 0x10000);

  printk("[*] Hooks installed!\n");
}
