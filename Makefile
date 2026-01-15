INITRAMFS := initramfs.cpio.gz
VARS := KBUILD_BUILD_TIMESTAMP='' LLVM=1 CC="ccache clang"

default: linux/.config linux/vmlinux $(INITRAMFS) 

linux/.config:
	cd linux && \
	$(MAKE) $(VARS) kvm_guest.config && \
	./scripts/config --enable CONFIG_MODULES && \
	./scripts/config --enable CONFIG_MODULE_UNLOAD && \
	./scripts/config --enable CONFIG_BLOCK && \
	./scripts/config --enable CONFIG_BLK_DEV_INITRD && \
	./scripts/config --enable CONFIG_BINFMT_ELF && \
	./scripts/config --enable CONFIG_DEVTMPFS && \
	$(MAKE) $(VARS) olddefconfig

linux/vmlinux:
	$(MAKE) $(VARS) -C linux

module/hello.ko:
	$(MAKE) $(VARS) -C module


ROOTFS_MODULE := rootfs/modules/hello.ko

$(ROOTFS_MODULE): module/hello.ko
	mkdir -p rootfs/modules
	cp module/hello.ko $@

INITRAMFS_ABS := $(abspath $(INITRAMFS))

$(INITRAMFS): $(ROOTFS_MODULE)
	mkdir -p rootfs/bin rootfs/dev rootfs/etc rootfs/proc rootfs/sys
	cd rootfs && find . | cpio -o -H newc | gzip > $(INITRAMFS_ABS)

clean:
	$(MAKE) $(VARS) -C linux clean
	$(MAKE) $(VARS) -C module clean
	rm $(INITRAMFS)
	rm $(ROOTFS_MODULE)
