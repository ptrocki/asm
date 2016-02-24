funkcja: zamiana.s
	as  -g --32 -o lab1.o zamiana.s
	ld -m elf_i386 -o lab1 lab1.o
