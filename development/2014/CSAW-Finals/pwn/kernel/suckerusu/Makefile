obj-m += suckerusu.o
suckerusu-objs := main.o

default:
	@echo "To build Suckerusu:"
	@echo "  make TARGET KDIR=/path/to/kernel"
	@echo
	@echo "To clean the build dir:"
	@echo "  make clean KDIR=/path/to/kernel"
	@echo
	@echo "Supported targets:"
	@echo "linux-x86_64 	Linux, x86_64"

linux-x86_64:
ifndef KDIR
	@echo "Must provide KDIR!"
	@exit 1
endif
	$(MAKE) ARCH=x86_64 -C $(KDIR) M=$(PWD) modules

clean:
ifndef KDIR
	@echo "Must provide KDIR!"
	@exit 1
endif
	$(MAKE) -C $(KDIR) M=$(PWD) clean
