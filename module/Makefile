VARS := KBUILD_BUILD_TIMESTAMP='' LLVM=1 CC="ccache clang"
obj-m := hello.o
hello-y := adapter.o impl.o
no-clean-files := zg/zig-out/imply.o

#KDIR ?= /lib/modules/`uname -r`/build
KDIR ?= $(realpath ../linux/)
PWD := $(shell pwd)

.PHONY: all clean zg/zig-out/imply.o

all: zg/generated/stub.zig
	$(MAKE) $(VARS) -C $(KDIR) M=$(PWD)

impl.o: zg/zig-out/imply.o
	cp zg/zig-out/imply.o impl.o

zg/zig-out/imply.o: FORCE_BUILD
	cd zg && zig build

FORCE_BUILD:

zg/generated/stub.h: stub.c
	mkdir -p zg/generated
	$(MAKE) $(VARS) -C $(KDIR) M=$(PWD) stub.i
	sed '/^#/d' stub.i > $@

zg/generated/stub.zig: zg/generated/stub.h
	zig translate-c -cflags -fintegrated-as -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -fcf-protection=branch -fno-jump-tables -falign-loops=1 -fno-asynchronous-unwind-tables -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -fstack-protector-strong -fomit-frame-pointer -ftrivial-auto-var-init=zero -fno-stack-clash-protection -falign-functions=16 -fstrict-flex-arrays=3 -fms-extensions -fno-strict-overflow -fno-stack-check -fno-builtin-wcslen -- $^ > $@
	sed -i 's/@""/unnamed_0/g' $@ # A dirty hack to patch an error caused by a bug in zig translate-c

clean:
	rm -r zg/zig-out zg/.zig-cache
	rm stub.i
	rm zg/generated/stub.*
	$(MAKE) $(VARS) -C $(KDIR) M=$(PWD) clean

