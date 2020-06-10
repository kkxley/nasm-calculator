FILENAME=calculator

build: clear
	nasm -f elf $(FILENAME).asm
	ld -m elf_i386 $(FILENAME).o -o $(FILENAME)
	./$(FILENAME)

clear:
	rm -f $(FILENAME).o
	rm -f $(FILENAME)