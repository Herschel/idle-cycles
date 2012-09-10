ASM=dasm
ASMFLAGS=-f3

idle-cycles.bin:
	$(ASM) idle-cycles.asm $(ASMFLAGS) -oidle-cycles.bin

