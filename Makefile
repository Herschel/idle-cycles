ASM=dasm
ASMFLAGS=-f3
NAME=idle-cycles

$(NAME).bin: $(NAME).asm vcs.h macro.h
	$(ASM) $< $(ASMFLAGS) -o$@

