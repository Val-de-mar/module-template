#include <linux/init.h>
#include <linux/module.h>

static char * aboba(void) {
  return "aboba";
}

static int __init init_hello(void) {
 printk(KERN_INFO "Hello, %s\n", aboba());
 return 0;
}
static void __exit exit_hello(void) {
 printk(KERN_INFO "Buy, %s\n", aboba());
}
module_init(init_hello);
module_exit(exit_hello);


MODULE_AUTHOR("Vladimir Melnikov");
MODULE_DESCRIPTION("MODULE EXAMPLE");
MODULE_LICENSE("GPL");
