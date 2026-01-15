
obj-m := hello.o

#KDIR ?= /lib/modules/`uname -r`/build
KDIR ?= $(realpath ../linux/)

all:
	$(MAKE) -C $(KDIR) M=$$PWD

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean
