#include <linux/init.h>
#include <linux/module.h>

extern void logy(void);

static int __init init_hello(void) {
 printk(KERN_INFO "Hi!\n");
 logy();
 return 0;
}
static void __exit exit_hello(void) {
 printk(KERN_INFO "Bye!\n");
 logy();
}
module_init(init_hello);
module_exit(exit_hello);


MODULE_AUTHOR("Vladimir Melnikov");
MODULE_DESCRIPTION("MODULE EXAMPLE");
MODULE_LICENSE("GPL");
