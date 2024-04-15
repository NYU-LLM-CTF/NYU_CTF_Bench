obj-m += whitelist.o
whitelist-y = main.o hooks.o rules.o

needed_syms = proc_reg_open sys_call_table

PWD := $(shell pwd)
DESTDIR := $(PWD)/../ramdisk

MFLAGS := -j10 CC=$(CC) CXX=$(CXX) DESTDIR=$(DESTDIR) "LDFLAGS=$(LDFLAGS)"

.PHONY: all install clean



all: syms.h 
	make -C ../obj/linux-x86-basic/ M=$(PWD) modules "LD=ld -dT $(PWD)/hooklinker.ld"
	make -C libldw $(MFLAGS)
	#strip --strip-unneeded whitelist.ko
syms.h: ../obj/linux-x86-basic/System.map update_syms
	@echo "Updating kernel symbols"
	SYSTEM_MAPS=$< ./update_syms $(needed_syms) > $@.tmp
	mv $@.tmp $@
install: all
	cp $(obj-m:%.o=%.ko) $(DESTDIR)/
	make -C libldw $(MFLAGS) install NOSAVE=yes
ifneq ($(NOSAVE),yes)
	cd .. && ./save.sh
endif
clean:
	make -C ../obj/linux-x86-basic/ M=$(PWD) clean
	make -C libldw clean
