#include <linux/bug.h>
#include <linux/cred.h>
#include <linux/dcache.h>
#include <linux/file.h>
#include <linux/limits.h>
#include <linux/namei.h>
#include <linux/path.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/spinlock.h>
#include <linux/uaccess.h>
#include <linux/uidgid.h>

#include "syscall.h"
#include "rules.h"
#include "syms.h"
//#include "mem_dbg.h"

static LIST_HEAD(ldw_rules);
static DEFINE_RWLOCK(ldw_rules_lock);
static DEFINE_SPINLOCK(ldw_ctl_lock);
static int default_action = LDW_RES_DENY;

static inline void _trim(char *str, const char *testing) {
  int total_len = strlen(str), top_len = strlen(testing);
  if (total_len < top_len)
    return;

  if (!strcmp(testing, str + (total_len - top_len)))
    str[total_len - top_len] = 0;
}

static int seq_puts_i(struct seq_file *m, void *v)
{
  seq_puts(m, m->private);
  return 0;
}

static char* __resolve_path(const char *name, struct delayed_call *clean) {
  int res;
  struct path pout;
  char *out;

  if (!name)
    return NULL;

  res = kern_path(name, LOOKUP_FOLLOW, &pout);
  if (res < 0)
    return ERR_PTR(res);

  out = kmalloc(PATH_MAX, GFP_KERNEL);
  if (!out)
    return ERR_PTR(-ENOMEM);
  set_delayed_call(clean, (void (*)(void*))kfree, out);

  out = d_path(&pout, out, PATH_MAX);
  if (!IS_ERR(out))
    _trim(out, " (deleted)");

  return out;
}

static int __apply_rule(struct ldw_rule *cur, const char *name)
{
  DEFINE_DELAYED_CALL(clean_resname);
  char *resname = NULL;
  const char *cur_name = (cur->name ? cur->name : "");
  int res = LDW_RES_NOMATCH, filt;
  size_t filt_len = 0, name_len = strlen(name), res_filt_len = 0;

  filt = cur->filt_mode;

  resname = __resolve_path(cur_name, &clean_resname);
  if (IS_ERR(resname) || !resname)
    resname = NULL;
  else {
    res_filt_len = strlen(resname);
    filt_len = strlen(cur_name);
  }

  if ((filt & LDW_RULE_FILT_USER) && !uid_eq(current_fsuid(), cur->tgtUser))
    goto clean;
  if ((filt & LDW_RULE_FILT_GROUP) && !gid_eq(current_fsgid(), cur->tgtGroup))
    goto clean;

  switch (filt & LDW_RULE_FILT_MODE) {
    case LDW_RULE_MODE_UNCOND:
      break;
    case LDW_RULE_MODE_PREFIX:
      if (!resname || strncmp(name, resname, res_filt_len))
        goto clean;
      break;
    case LDW_RULE_MODE_MATCH:
      if (!resname || strcmp(name, resname))
        goto clean;
      break;
    case LDW_RULE_MODE_PREFDIR:
      if (!resname || strncmp(name, resname, res_filt_len))
        goto clean;
      if (res_filt_len < name_len && name[res_filt_len] != '/')
        goto clean;
      break;
    case LDW_RULE_MODE_SUFFIX:
      if (!resname || filt_len >= name_len ||
          strcmp(cur_name, name + name_len - filt_len))
        goto clean;
      break;
    default:
      BUG();
  }

  if (filt & LDW_RULE_FILT_PERMIT)
    res = LDW_RES_ALLOW;
  else
    res = LDW_RES_DENY;

clean:
  do_delayed_call(&clean_resname);
  return res;
}

// Must have lock set
static int __ldw_rule_set_name(struct ldw_rule *r, const char __user *u_name, size_t size)
{
  int len = strnlen_user(u_name, size);
  char *name;

  if (r->name_len < size) {
    name = kmalloc(size, GFP_KERNEL);
    if (!name)
      return -ENOMEM;
    r->name_len = size;
  } else {
    name = r->name;
    BUG_ON(!name);
  }

  if (copy_from_user(name, u_name, size)) {
    kfree(name);
    return -EFAULT;
  }

  if (r->name != name) {
    kfree(r->name);
    r->name = name;
  }

  if (len >= size)
    // Truncate the file name if too long
    name[len - 1] = 0;
  else
    // Otherwise zero out rest of string
    memset(name + len, 0, size - len);

  return 0;
}

//Lock must be set already if rule_replace is non-null
static int ldw_from_user(struct ldw_rule *ret, struct ldw_rule_user __user *rule)
{
  struct ldw_rule_user copy;
  int has_name = 1, name_len, filt_mode;
  kuid_t user = INVALID_UID;
  kgid_t group = INVALID_GID;

  if (!ret)
    return -EINVAL;
  if (copy_from_user(&copy, rule, sizeof(copy)))
    return -EFAULT;
  if (copy.size < sizeof(copy))
    return -EINVAL;

  filt_mode = copy.filt_mode;
  name_len = copy.size - sizeof(copy);

  if (unlikely(filt_mode & ~LDW_RULE_FILT_MASK))
    return -EINVAL;

  if (filt_mode & LDW_RULE_FILT_USER) {
    user = make_kuid(current_user_ns(), copy.tgtUser);
    if (!uid_valid(user))
      return -EINVAL;
  }

  if (filt_mode & LDW_RULE_FILT_GROUP) {
    group = make_kgid(current_user_ns(), copy.tgtGroup);
    if (!gid_valid(group))
      return -EINVAL;
  }

  switch (filt_mode & LDW_RULE_FILT_MODE) {
    case LDW_RULE_MODE_UNCOND:
      has_name = 0;
      break;
    case LDW_RULE_MODE_PREFIX...LDW_RULE_MODE_SUFFIX:
      if (!name_len)
        return -EINVAL;
      break;
    default:
      return -EINVAL;
  }

  ret->filt_mode = filt_mode;
  ret->tgtUser = user;
  ret->tgtGroup = group;

  if (has_name)
    return __ldw_rule_set_name(ret, rule->name, name_len);
  else {
    if (ret->name)
      kfree(ret->name);
    ret->name = NULL;
    ret->name_len = 0;
  }

  return 0;
}

int ldw_check_file(const char *name)
{
  struct ldw_rule *cur;
  int rule_res, res = 0;

  read_lock(&ldw_rules_lock);
  list_for_each_entry(cur, &ldw_rules, rules) {
    rule_res = __apply_rule(cur, name);
    switch(rule_res) {
      case LDW_RES_NOMATCH: break;
      case LDW_RES_ALLOW:   goto out;
      case LDW_RES_DENY:    res = -1; goto out;
    }
  }

  if (default_action == LDW_RES_DENY)
    res = -1;
out:
  read_unlock(&ldw_rules_lock);
  return res;
}

static int ldw_ctl_delete(struct ldw_rule **ptarget,
    struct ldw_rule_user __user *unused)
{
  struct ldw_rule *target = *ptarget;
  struct list_head *tmp;
  int end = LDW_LIST_MORE;

  printk("[*] ldw_ctl_delete()\n");

  // Some basic checks
  if (unlikely(!target))
    return -EINVAL;
  if (unlikely(unused))
    return -EINVAL;

  write_lock(&ldw_rules_lock);

  // Make sure this isn't a removed rule
  if (!target->added) {
    write_unlock(&ldw_rules_lock);
    return -EINVAL;
  }

  // Move pointer forward after deleted node.
  if (target->rules.prev != &ldw_rules)
    tmp = target->rules.prev;
  else if (target->rules.next != &ldw_rules)
    tmp = target->rules.next;
  else {
    *ptarget = NULL;
    end = LDW_LIST_EOF;
    goto skip_pin;
  }

  __get_rule(*ptarget = list_entry(tmp, struct ldw_rule, rules));
  __put_rule(target);

skip_pin:
  // Remove target from list
  target->added = 0;
  list_del(&target->rules);
  __put_rule(target);

  write_unlock(&ldw_rules_lock);

  return end;
}

static int ldw_ctl_edit(struct ldw_rule **ptarget,
    struct ldw_rule_user __user *newrule)
{
  struct ldw_rule *target = *ptarget;
  int err;

  printk("[*] ldw_ctl_edit()\n");

  if (unlikely(!target))
    return -EINVAL;
  if (unlikely(!newrule))
    return -EFAULT;

  // Edit target in place
  write_lock(&ldw_rules_lock);

  // Make sure this isn't a removed rule
  if (!target->added) {
    write_unlock(&ldw_rules_lock);
    return -EINVAL;
  }

  err = ldw_from_user(target, newrule);
  if (unlikely(err < 0))
    return err;

  write_unlock(&ldw_rules_lock);

  return 0;
}

static int ldw_ctl_get(struct ldw_rule **prule,
    struct ldw_rule_user __user *ret)
{
  struct ldw_rule *rule = *prule;
  struct ldw_rule_user copy;
  size_t written;

  printk("[*] ldw_ctl_get()\n");

  if (unlikely(!rule))
    return -EINVAL;
  if (unlikely(copy_from_user(&copy, ret, sizeof(copy))))
    return -EFAULT;
  if (unlikely(copy.size < sizeof(copy)))
    return -EINVAL;

  // Copy in rule data into user copy
  read_lock(&ldw_rules_lock);
  copy.filt_mode = rule->filt_mode;
  copy.tgtUser = from_kuid(current_user_ns(), rule->tgtUser);
  copy.tgtGroup = from_kgid(current_user_ns(), rule->tgtGroup);

  if (copy.size - sizeof(copy) < rule->name_len)
    goto errRange;

  written = rule->name_len;
  if (unlikely(copy_to_user(ret->name, rule->name, written)))
    goto errFault;

  read_unlock(&ldw_rules_lock);

  if (unlikely(copy_to_user(ret, &copy, sizeof(copy))))
    return -EFAULT;

  return written + sizeof(copy);

errRange:
  read_unlock(&ldw_rules_lock);
  return -ERANGE;

errFault:
  read_unlock(&ldw_rules_lock);
  return -EFAULT;
}

static int __ldw_ctl_insert_common(struct ldw_rule **ppivot_rule, int is_before,
    struct ldw_rule_user __user *rule)
{
  int err;
  struct ldw_rule *insert, *pivot_rule = *ppivot_rule;
  struct list_head *pivot;

  // Create new rule.
  insert = __get_rule(NULL);
  if (unlikely(IS_ERR(insert)))
    return PTR_ERR(insert);

  err = ldw_from_user(insert, rule);
  if (unlikely(err < 0)) {
    __put_rule(insert);
    return err;
  }

  write_lock(&ldw_rules_lock);

  // Check if pivot is a dangling rule
  if (likely(pivot_rule) && unlikely(!pivot_rule->added)) {
    __put_rule(insert);
    write_unlock(&ldw_rules_lock);
    return -EINVAL;
  }

  pivot = likely(pivot_rule) ? &pivot_rule->rules : &ldw_rules;

  // Insert new rule
  insert->added = 1;
  if (is_before)
    list_add_tail(&insert->rules, pivot);
  else
    list_add(&insert->rules, pivot);

  // Move pointer to the insertion node
  __get_rule(insert);
  *ppivot_rule = insert;
  if (likely(pivot_rule))
    __put_rule(pivot_rule);

  write_unlock(&ldw_rules_lock);
  return 0;
}

static int ldw_ctl_insert_before(struct ldw_rule **ppivot, struct
    ldw_rule_user __user *rule)
{
  printk("[*] ldw_ctl_insert_before()\n");
  return __ldw_ctl_insert_common(ppivot, 1, rule);
}

static int ldw_ctl_insert_after(struct ldw_rule **ppivot, struct
    ldw_rule_user __user *rule)
{
  printk("[*] ldw_ctl_insert_after()\n");
  return __ldw_ctl_insert_common(ppivot, 0, rule);
}

static int ldw_ctl_next(struct ldw_rule **pcur_rule,
    struct ldw_rule_user __user *xx)
{
  struct ldw_rule *cur_rule = *pcur_rule;
  struct list_head *next;

  printk("[*] ldw_ctl_next()\n");

  if (unlikely(xx))
    return -EINVAL;

  read_lock(&ldw_rules_lock);

  // Advance to next rule if any
  if (likely(cur_rule)) {

    // Check if rule is stale.
    if (unlikely(!cur_rule->added)) {
      __put_rule(cur_rule);
      next = ldw_rules.next;
      *pcur_rule = NULL;
      read_unlock(&ldw_rules_lock);
      return LDW_LIST_EOF;
    }

    // Advance to next rule, and unpin current rule.
    next = cur_rule->rules.next;
    __put_rule(cur_rule);
  } else {
    // Reset to the beginning, we have reached the end.
    next = ldw_rules.next;
  }

  // Check if we loop back to head.
  if (unlikely(next == &ldw_rules)) {
    *pcur_rule = NULL;
    read_unlock(&ldw_rules_lock);
    return LDW_LIST_EOF;
  } else {
    // Otherwise just set current rule and pin it.
    *pcur_rule = cur_rule = list_entry(next, struct ldw_rule, rules);
    __get_rule(cur_rule);
    read_unlock(&ldw_rules_lock);
    return LDW_LIST_MORE;
  }
}

static int ldw_ctl_prev(struct ldw_rule **pcur_rule,
    struct ldw_rule_user __user *xx)
{
  struct ldw_rule *cur_rule = *pcur_rule;
  struct list_head *prev;

  printk("[*] ldw_ctl_prev()\n");

  if (unlikely(xx))
    return -EINVAL;

  read_lock(&ldw_rules_lock);

  // Advance to next rule if any
  if (likely(cur_rule)) {

    // Check if rule is stale.
    if (unlikely(!cur_rule->added)) {
      __put_rule(cur_rule);
      prev = ldw_rules.prev;
      *pcur_rule = NULL;
      read_unlock(&ldw_rules_lock);
      return LDW_LIST_EOF;
    }

    // Advance to previous rule, and unpin current rule.
    prev = cur_rule->rules.prev;
    __put_rule(cur_rule);
  } else {
    // Reset to the end, we have reached the beginning.
    prev = ldw_rules.prev;
  }

  // Check if we loop back to head.
  if (unlikely(prev == &ldw_rules)) {
    *pcur_rule = NULL;
    read_unlock(&ldw_rules_lock);
    return LDW_LIST_EOF;
  } else {
    // Otherwise just set current rule and pin it.
    *pcur_rule = cur_rule = list_entry(prev, struct ldw_rule, rules);
    __get_rule(cur_rule);
    read_unlock(&ldw_rules_lock);
    return LDW_LIST_MORE;
  }
}

//****************************************
//* /proc/ldw/rules
//****************************************

struct ldw_itr {
  struct list_head *cur;
  loff_t cur_ind;
};

static int reset_itr(struct ldw_itr *itr, loff_t pos)
{
  struct list_head *lh;

  itr->cur_ind = pos;

  // Special case for header
  if (pos == (loff_t)-1) {
    itr->cur = &ldw_rules;
    return 1;
  }

  // Search for the nth element
  list_for_each(lh, &ldw_rules) {
    if (pos-- == 0) {
      itr->cur = lh;
      return 1;
    }
  }

  // Looped pass all elements. Exit iteration
  return 0;
}

// Returns <0 if error, 0 if eof, >0 if success
static int update_itr(struct ldw_itr *itr, loff_t pos)
{
  struct list_head *lh;
  struct ldw_rule *cur_rule;

  if (unlikely(!itr->cur)) {
    // User is still trying to iterate through this stale rule
    return -EINVAL;
  }

  cur_rule = list_entry(itr->cur, struct ldw_rule, rules);
  if (unlikely(!cur_rule->added) && unlikely(itr->cur != &ldw_rules)) {
    // We have a stale rule.
    itr->cur = NULL;
    __put_rule(cur_rule);
    printk("[*] update_itr(%lld), stale\n", pos);
    return -EINVAL;
  }

  printk("[*] update_itr(%lld)\n", pos);

  // If index has not changed, don't move forward. Otherwise we check if
  // position is incremented, then move forward.
  if (itr->cur_ind == pos)
    return 1;
  else if (itr->cur_ind + 1 == pos) {
    // Move iterator forward
    lh = cur_rule->rules.next;
    if (lh == &ldw_rules) {
      // Looped back to head. Exit iteration.
      return 0;
    }
    itr->cur = lh;
    itr->cur_ind++;
    return 1;
  } else
    // We might have to reset iterator here (rarely happens).
    return reset_itr(itr, pos);

}

static void *ldw_start(struct seq_file *m, loff_t *ppos)
{
  struct ldw_itr *itr;
  int err;

  printk("[*] ldw_start(%lld)\n", *ppos);

  // Lock for read.
  read_lock(&ldw_rules_lock);

  // Update iterator position.
  itr = m->private;
  err = update_itr(itr, *ppos - 1);
  if (unlikely(err < 0))
    return ERR_PTR(err);
  else if (unlikely(!err))
    return NULL;
  else
    return itr;
}

static void *ldw_next(struct seq_file *m, void *p, loff_t *ppos)
{
  int err;

  printk("[*] ldw_next(%lld)\n", *ppos);

  // Increment and update iterator
  err = update_itr(p, (*ppos)++); //Should technically be (++(*ppos) - 1)
  if (unlikely(err < 0))
    return ERR_PTR(err);
  else if (unlikely(!err))
    return NULL;
  else
    return p;
}

static const char* const ldw_modes[] = {"uncond", "prefix", "match",
  "prefdir", "suffix", "(???)", "(???)", "(???)"};

static int ldw_show(struct seq_file *m, void *p)
{
#define itr ((struct ldw_itr*)p)
#define rule list_entry(itr->cur, struct ldw_rule, rules)
  int flags;

  printk("[*] ldw_show()\n");

  if (itr->cur == &ldw_rules)
    // Print the header
    seq_puts(m, "ACTION   TYPE     FLAGS    USER     GROUP    NAME\n");
  else {
    //Print the rule data
    flags = rule->filt_mode;
    seq_printf(m, "%-8s %-8s %08x %-8d %-8d %s\n", (flags & LDW_RULE_FILT_PERMIT
          ? "PERMIT" : "DENY"), ldw_modes[flags & LDW_RULE_FILT_MODE], flags,
        from_kuid(current_user_ns(), rule->tgtUser),
        from_kgid(current_user_ns(), rule->tgtGroup), rule->name);
  }
  return 0;
#undef itr
#undef rule
}

static void ldw_stop(struct seq_file *m, void *p)
{
  // Give up lock done in ldw_start
  printk("[*] ldw_stop()\n");
  read_unlock(&ldw_rules_lock);
}

static const struct seq_operations ldw_seq_ops = {
  .start = ldw_start,
  .next = ldw_next,
  .show = ldw_show,
  .stop = ldw_stop
};

static int ldw_open(struct inode *inode, struct file *file)
{
  struct ldw_itr *itr;

  /* Put iterator inside seq_file private data so that we can cache the current
   * rule that we are on (in common case, we just pick up where we left off). */
  itr = __seq_open_private(file, &ldw_seq_ops, sizeof(struct ldw_itr));
  if (!itr)
    return -ENOMEM;
  printk("[*] Opened /proc/ldw/rules\n");

  reset_itr(itr, -1);
  return 0;
}

static const struct file_operations rules_ops = {
  .owner = THIS_MODULE,
  .open = ldw_open,
  .read = seq_read,
  .llseek = seq_lseek,
  .release = seq_release_private,
};

//****************************************
//* /proc/ldw/default_action
//****************************************

static const char *num_modes[] = {"0\n", "1\n"};

static int ldw_default_open(struct inode *inode, struct file *file)
{
  char* str = (char*)(num_modes[!!default_action]);
  printk("[*] Opened /proc/ldw/default_action\n");
  return single_open(file, seq_puts_i, str);
}

static ssize_t ldw_default_write(struct file *f, const char __user *buff, size_t s,
    loff_t * off)
{
  char c;
  if (!*off) {
    if (copy_from_user(&c, buff, 1))
      return -EFAULT;
    if (c == '0')
      default_action = 0;
    else if (c == '1')
      default_action = 1;
    else
      return -EINVAL;
  }

  // Ignore any additional writes.
  return s;
}

static const struct file_operations default_ops = {
  .owner = THIS_MODULE,
  .open = ldw_default_open,
  .read = seq_read,
  .write = ldw_default_write,
  .release = single_release,
};

//****************************************
//* /proc/ldw/ctl
//****************************************

// Be nice and not make this const
static int (*ldw_ctl_ops[])(struct ldw_rule **,
    struct ldw_rule_user __user *) = {
  ldw_ctl_next, ldw_ctl_prev, ldw_ctl_edit, ldw_ctl_insert_after,
  ldw_ctl_insert_before, ldw_ctl_delete, ldw_ctl_get
};

static int ldw_ctl_open(struct inode *inode, struct file *file)
{
  if (!capable(CAP_LDW_RULE)) {
    printk("[+] No sorry you don't get to access the ldw rules.\n");
    return -EPERM;
  }

  printk("[*] Opened /proc/ldw/ctl\n");
  file->private_data = NULL;
  return 0;
}

static int ldw_ctl_close(struct inode *inode, struct file *file)
{
  struct ldw_rule *cur_rule;

  printk("[*] Closing /proc/ldw/ctl\n");

  spin_lock(&ldw_ctl_lock);
  cur_rule = file->private_data;
  file->private_data = NULL;
  spin_unlock(&ldw_ctl_lock);

  if (cur_rule)
    __put_rule(cur_rule);
  return 0;
}

static const struct file_operations ctl_ops = {
  .owner = THIS_MODULE,
  .open = ldw_ctl_open,
  .release = ldw_ctl_close,
};


// Yes I know there is probably a more "standard" way to do this (via ioctl),
// but I want to make it as difficult to implement. Let's just invent a new
// system call!
SYSCALL_HOOK3(ldw_ctl, int, fd, unsigned long, request,
    struct ldw_rule_user __user*, arg)
{
  char buff[15], *name;
  struct file *f = fget(fd);
  int err;

  if (unlikely(!f))
    HOOK_RET(-EBADF);

  if (unlikely(request >= ARRAY_SIZE(ldw_ctl_ops)))
    HOOK_RET(-EINVAL);

  // Make sure we are using /proc/ldw/ctl file, and not something else.
  if (unlikely(f->f_op->open != DEF_PROC_REG_OPEN))
    HOOK_RET(-EINVAL);
  name = d_path(&f->f_path, buff, sizeof(buff));
  if (unlikely(IS_ERR(name)) || unlikely(strcmp(name, "/proc/ldw/ctl")))
    HOOK_RET(-EINVAL);

  spin_lock(&ldw_ctl_lock);
  err = ldw_ctl_ops[request]((struct ldw_rule**)(&f->private_data), arg);
  spin_unlock(&ldw_ctl_lock);


  HOOK_RET(err);
}


int ldw_init_proc_files(void)
{
  struct proc_dir_entry* ldw_root = proc_mkdir("ldw", NULL);
  if (unlikely(!ldw_root))
    return -ENOMEM;
  if (unlikely(!proc_create("rules", 00444, ldw_root, &rules_ops)))
    return -ENOMEM;
  if (unlikely(!proc_create("default_action", 00644, ldw_root, &default_ops)))
    return -ENOMEM;
  if (unlikely(!proc_create("ctl", 00444, ldw_root, &ctl_ops)))
    return -ENOMEM;

  printk("[+] /proc/ldw_rules initialized\n");
  return 0;
}
