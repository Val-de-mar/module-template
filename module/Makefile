VARS := KBUILD_BUILD_TIMESTAMP='' LLVM=1 CC="ccache clang"
obj-m := hello.o
hello-y := adapter.o impl.o
no-clean-files := zg/zig-out/imply.o

#KDIR ?= /lib/modules/`uname -r`/build
KDIR ?= $(realpath ../linux/)
PWD := $(shell pwd)

.PHONY: all clean zg/zig-out/imply.o

all: generated/stub.h
	$(MAKE) $(VARS) -C $(KDIR) M=$(PWD)

impl.o: zg/zig-out/imply.o
	cp zg/zig-out/imply.o impl.o

zg/zig-out/imply.o: FORCE_BUILD
	cd zg && zig build

FORCE_BUILD:

generated/stub.h: stub.c
	mkdir -p generated
	$(MAKE) $(VARS) -C $(KDIR) M=$(PWD) stub.i
	sed '/^#/d' stub.i > $@

clean:
	rm -r zg/zig-out zg/.zig-cache
	rm stub.i
	rm generated/stub.h
	$(MAKE) $(VARS) -C $(KDIR) M=$(PWD) clean

