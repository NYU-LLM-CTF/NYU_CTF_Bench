#ifndef _RULES_H
#define _RULES_H

#include <linux/atomic.h>
#include <linux/list.h>
#include <linux/types.h>
#include <linux/refcount.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/uidgid.h>

#define LDW_RULE_MODE_UNCOND    0
#define LDW_RULE_MODE_PREFIX    1
#define LDW_RULE_MODE_MATCH     2
#define LDW_RULE_MODE_PREFDIR   3
#define LDW_RULE_MODE_SUFFIX    4

#define LDW_RULE_FILT_MODE   0x07
#define LDW_RULE_FILT_USER   0x08
#define LDW_RULE_FILT_GROUP  0x10
#define LDW_RULE_FILT_PERMIT 0x20

#define LDW_RULE_FILT_MASK 0x3f

#define LDW_RES_NOMATCH -1
#define LDW_RES_DENY    0
#define LDW_RES_ALLOW   1

#define LDW_LIST_EOF  0
#define LDW_LIST_MORE 1

// syscall 17 is unimplemented, and thus a great candidate for our new syscall!
#define __NR_ldw_ctl 17

// completely unrelated magic number, but oh well.
#define LDW_MAGIC      0xCAFEFEED
#define LDW_MAGIC_DEAD 0xDEADBABE

struct ldw_rule {
  char* name;
  char __user *u_name;
  size_t name_len;
  int filt_mode;
  int magic; // for simplicity.
  int added;
  refcount_t refs;
  struct list_head rules;
  kuid_t tgtUser;
  kgid_t tgtGroup;
};

struct ldw_rule_user {
  uint32_t size;
  uid_t tgtUser;
  gid_t tgtGroup;
  int filt_mode;
  char name[];
} __attribute__((__packed__));

static inline struct ldw_rule *__get_rule(struct ldw_rule *obj) {
  if (obj) {
    if (unlikely(obj->magic != LDW_MAGIC)) {
      printk("Not a ldw_rule!\n");
      BUG();
    }
    if (!refcount_inc_not_zero(&obj->refs)) {
      // ERROR ERROR use after free!
      printk("Warning: detected use-after-free\n");
      BUG();
    }
  } else {
    obj = kmalloc(sizeof(struct ldw_rule), GFP_KERNEL);
    if (obj) {
      obj->refs = (refcount_t)REFCOUNT_INIT(1);
      obj->name = NULL;
      obj->magic = LDW_MAGIC;
      obj->name_len = 0;
    } else
      return ERR_PTR(-ENOMEM);
  }

  return obj;
}

static inline void __put_rule(struct ldw_rule *obj) {
  if (unlikely(obj->magic != LDW_MAGIC)) {
    printk("Not a ldw_rule!\n");
    BUG();
  }
  if (refcount_dec_and_test(&obj->refs)) {
    obj->magic = LDW_MAGIC_DEAD;
    kfree(obj);
  }
}

int ldw_check_file(const char *name);

int ldw_init_proc_files(void);

#endif
