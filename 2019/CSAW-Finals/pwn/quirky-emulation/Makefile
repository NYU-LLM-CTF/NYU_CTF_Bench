.PHONY: docker

quirky-emulation: quirky-emulation.c Makefile
	gcc -m32 -O2 -o quirky-emulation -no-pie -fno-pie -Wl,-z,relro,-z,now quirky-emulation.c
	strip quirky-emulation

docker: quirky-emulation Dockerfile
	docker image build -t quirky-emulation:latest .
