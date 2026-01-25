pub const c = @import("../generated/stub.zig");
pub const L4FS_BLOCK_SIZE = 4096;
pub const L4FS_DEFAULT_MODE = 0o755;
pub const l4FS_MAGIC = 0xa5b10c47;
pub const l4FS_ROOT_INO = 2;


pub const buffer_head = c.struct_buffer_head;

const super_block = struct {
    s_ninodes: u16, // total # of inodes supported by the file system
    s_imap_block: u16, // Inode bitmap block number
    s_bmap_block: u16, // Block bitmap block number
    s_inode_table: u16, // Inode table block number
    s_magic: u32, // L4FS magic number, set to L4FS_MAGIC from mkf
};

// // in-mem super block structure
// const l4fs_sb_info = struct {
//     s_ninodes: u64,
//     s_imap_block: u64,
//     s_bmap_block: u64,
//     s_inode_table: u64,
//     s_sb: *hbuffer_head, // superblock buffer_head
//     struct l4fs_super_block *s_sb, // on-disk sb
// };

// /* on-disk super block structure */
// struct l4fs_super_block {
//     __u16 s_ninodes; /* total # of inodes supported by the file system */
//     __u16 s_imap_block; /* Inode bitmap block number */
//     __u16 s_bmap_block; /* Block bitmap block number */
//     __u16 s_inode_table; /* Inode table block number */
//     __u32 s_magic; /* L4FS magic number, set to L4FS_MAGIC from mkfs*/
//     // TODO: fill any more relevant data
// };
//
// /* in mem inode info */
// #define L4FS_INODE_IDX_BLOCKS 14
// struct l4fs_inode_info {
//     uint16_t i_block[L4FS_INODE_IDX_BLOCKS];
//     struct inode vfs_inode;
// };
//
// /* on-disk inode object */
// struct l4fs_disk_inode {
//     uint16_t i_mode; // S_IFREG and S_IFDIR. maybe custom flag for journal?
//     uint16_t i_size; // file size. tbd if we want to increment in 4KBs or 
//     uint16_t i_block[L4FS_INODE_IDX_BLOCKS];
// };
//
// /* inode helpers */
//
// static inline struct l4fs_inode_info *l4fs_i(struct inode *inode) {
//     /* [Q] Why do we call container_of() below? 
//      *
//      *
//      *   
//      */
//     return container_of(inode, struct l4fs_inode_info, vfs_inode);
//
// }
//
// static inline struct l4fs_disk_inode *l4fs_disk_inode_at_ino(void *data, unsigned long ino) {
//     return &((struct l4fs_disk_inode *)data)[ino-1];
// }
//
// extern struct inode *l4fs_get_inode(struct super_block *sb, unsigned long ino);
//
// /* sb helpers */
// static inline struct l4fs_sb_info *l4fs_sb(struct super_block *sb) {
//     return sb->s_fs_info;
// }

