maze:
	nasm -f elf64 maze.asm
	ld --omagic -o maze maze.o
	rm maze.o

maze_public:
	nasm -DPUBLIC -f elf64 maze.asm
	ld --omagic -o maze_public maze.o
	rm maze.o

all: maze maze_public
	strip maze maze_public

clean:
	rm maze maze_public
