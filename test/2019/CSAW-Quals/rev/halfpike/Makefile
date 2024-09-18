challenge.zip: emu/emu emu/main.cpp binja_plugin/__init__.py chal.rom
	zip challenge.zip emu/emu emu/main.cpp binja_plugin/__init__.py chal.rom

chal.rom: asm/* chal/*
	./asm/assemble.py ./chal/main.s ./chal.rom

emu/emu: emu/*.cpp
	$(MAKE) -C emu

run: chal.rom emu/emu
	./emu/emu ./chal.rom

clean:
	rm emu/emu chal.rom challenge.zip
