const c = @cImport({
    @cInclude("stub.h");
});

export fn logy() void {
    _ = c._printk("hi again from module %d\n", @as(c.s32, 0));

    // just to check access
    const gg = c.LOCKDEP_STILL_OK;
    _ = gg;
}

