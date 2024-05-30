all: src/main.c src/gen_trees.py
	python src/gen_trees.py > src/nodes-inc.h
	gcc -Os src/main.c -o rabbithole

run: all
	./rabbithole
