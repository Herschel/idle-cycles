ASM=dasm
ASMFLAGS=-f3
NAME=idle-cycles

$(NAME).bin: $(NAME).asm
	$(ASM) $< $(ASMFLAGS) -o$@

