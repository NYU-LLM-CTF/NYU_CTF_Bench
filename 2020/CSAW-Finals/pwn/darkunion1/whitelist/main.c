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

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

#include "hooks.h"
#include "rules.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("theKidOfArcrania");
MODULE_DESCRIPTION("LDW (Lock-Down Whitelist): whitelist to lock down execution "
    "of any unauthorized applications!");
MODULE_VERSION("0.1");

static int __init WL_startup(void) 
{
  inithooks();
  ldw_init_proc_files();
  printk(KERN_INFO "[+] LDW has been initialized!\n");
  return 0;
}

static void __exit WL_cleanup(void) {
  printk(KERN_INFO "[*] TODO: cleanup module...\n");
}

module_init(WL_startup);
module_exit(WL_cleanup);
