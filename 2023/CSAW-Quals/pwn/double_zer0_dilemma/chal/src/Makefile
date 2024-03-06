dzd: roulette.c
	echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
	gcc -fno-stack-protector -fno-pie -m32 -Wl,--section-start=.text=0x808a000 roulette.c -o double_zer0_dilemma -ldl
