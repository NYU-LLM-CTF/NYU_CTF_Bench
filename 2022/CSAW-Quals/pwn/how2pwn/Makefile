target = public/bin/all/chal1 public/bin/all/chal2 public/bin/all/chal3 public/bin/all/chal4

all: $(target)

public/bin/all/chal1: chal/chal1/chal1.c
	gcc -z execstack $^ -o $@

public/bin/all/chal2: chal/chal2/chal2.c
	gcc -z execstack $^ -o $@

public/bin/all/chal3: chal/chal3/chal3.c
	gcc -z execstack $^ -o $@

public/bin/all/chal4: chal/chal4/chal4.c
	gcc $^ -o $@

clean:
	rm $(target) 