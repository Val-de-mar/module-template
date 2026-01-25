

// static struct inode *l4fs_read_inode_from_disk(struct super_block *sb, struct inode *inode, unsigned long ino) {
//     struct buffer_head *bh = NULL;
//     struct l4fs_disk_inode *raw_inode;
//     struct l4fs_inode_info *l4fs_inode = l4fs_i(inode);
//     struct l4fs_sb_info *sbi = l4fs_sb(sb);
//
//     /* first, read the inode bitmap block */
//
//     if (!ino || ino > sbi->s_ninodes) {
//         L4FS_PRINT_ERR("Invalid inode number: %lu", ino);
//         goto err;
//     }
//
//     /* [Q] What bytes of the raw disk does this call read?
//      *
//      */
//     bh = sb_bread(sb, sbi->s_inode_table); // we have a single block for the inode table, so we can read directly
//     if (!bh) {
//         L4FS_PRINT_ERR("Unable to read inode table from disk");
//         goto err;
//     }
//
//     raw_inode = l4fs_disk_inode_at_ino(bh->b_data, ino);
//
//     // now populate the in-mem inode from the on-disk one
//
//     inode->i_mode = raw_inode->i_mode;
//     inode->i_size = raw_inode->i_size;
//     for (int i = 0; i < L4FS_INODE_IDX_BLOCKS; i++) {
//         l4fs_inode->i_block[i] = raw_inode->i_block[i];
//     }
//
//     // Here is where you will set inode and file _operations depending on if i_mode is S_ISDIR or S_ISREG
//
//     /* [Q] Why do we call brelse() below?
//      *
//      */
//     brelse(bh);
//     unlock_new_inode(inode);
//     return inode;
//
// err:
//     return NULL;
//
// }
//
// struct inode *l4fs_get_inode(struct super_block *sb, unsigned long ino) {
//   struct inode *inode;
//
//   /* [Q] Why do we call iget_locked()?
//    *
//    */
//   inode = iget_locked(sb, ino);
//   if (!inode) {
//     goto err;
//   }
//
//   if (!(inode->i_state & I_NEW)) {
//     /* [Q] Why do we just return the inode in the conditional below?
//      *
//      */
//     return inode;
//   }
//
//   // read the inode from disk
//   inode = l4fs_read_inode_from_disk(sb, inode, ino);
//
//   return inode;
// err:
//     return ERR_PTR(-ENOMEM);
// }
