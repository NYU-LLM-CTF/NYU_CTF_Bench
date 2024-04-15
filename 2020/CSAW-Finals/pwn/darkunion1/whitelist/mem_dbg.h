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


#define POISON 0xdeadb33f

#define kmalloc(size, type) ({                  \
  size_t __size = (size);                       \
  void *__mem = kmalloc(size, type);            \
  memset(__mem, 0xcc, __size);                  \
  printk("[*] kmalloc(%x) = %p", __size, __mem);\
  __mem;                                        \
})

#define kfree(mem) do {            \
  void *__xx = (mem);              \
  printk("[*] kfree(%p)", __xx);   \
  kfree(__xx);                     \
} while(0)
//  BUG_ON(*((int*)__xx) == POISON); 
//  *((int*)__xx) = POISON;          
