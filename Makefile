INITRAMFS := initramfs.cpio.gz
VARS := KBUILD_BUILD_TIMESTAMP='' LLVM=1 CC="ccache clang"
KERNEL := linux/arch/x86/boot/bzImage

default: linux/.config $(KERNEL) $(INITRAMFS) 

linux/.config:
	cd linux && \
	$(MAKE) $(VARS) kvm_guest.config && \
	./scripts/config --enable CONFIG_MODULES && \
	./scripts/config --enable CONFIG_MODULE_UNLOAD && \
	./scripts/config --enable CONFIG_BLOCK && \
	./scripts/config --enable CONFIG_BLK_DEV_INITRD && \
	./scripts/config --enable CONFIG_BINFMT_ELF && \
	./scripts/config --enable CONFIG_DEVTMPFS && \
	./scripts/config --enable CONFIG_TTY && \
	./scripts/config --enable CONFIG_VT && \
	./scripts/config --enable CONFIG_VT_CONSOLE && \
	./scripts/config --enable CONFIG_SERIAL_8250 && \
	./scripts/config --enable CONFIG_SERIAL_8250_CONSOLE && \
	./scripts/config --enable CONFIG_DEVTMPFS && \
	./scripts/config --enable CONFIG_DEVTMPFS_MOUNT && \
	$(MAKE) $(VARS) olddefconfig

$(KERNEL):
	$(MAKE) $(VARS) -C linux

module/hello.ko:
	$(MAKE) $(VARS) -C module

MODULE := hello.ko
ROOTFS_MODULE_PREFIX := rootfs/modules

ROOTFS_MODULE := "$(ROOTFS_MODULE_PREFIX)/$(MODULE)"
$(ROOTFS_MODULE): module/$(MODULE)
	mkdir -p rootfs/modules
	cp module/hello.ko $@

INITRAMFS_ABS := $(abspath $(INITRAMFS))

$(INITRAMFS): $(ROOTFS_MODULE)
	mkdir -p rootfs/bin rootfs/dev rootfs/etc rootfs/proc rootfs/sys
	cd rootfs && find . | cpio -o -H newc | gzip > $(INITRAMFS_ABS)

clean:
	$(MAKE) $(VARS) -C linux clean || true
	$(MAKE) $(VARS) -C module clean || true
	rm $(INITRAMFS) || true
	rm $(ROOTFS_MODULE) || true
