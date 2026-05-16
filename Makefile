MOLD ?= mold
OBJDUMP ?= objdump

MOLD_LD_FLAG = $(if $(filter-out file,$(origin MOLD)),--ld-path=$(MOLD),-fuse-ld=mold)

.PHONY: all
all: repro

repro.o: repro.s
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

repro: repro.o
	$(CC) -nostdlib -static $(MOLD_LD_FLAG) -Wl,--emit-relocs -o $@ $<

.PHONY: disasm
disasm: repro
	$(OBJDUMP) --disassemble --reloc $<

.PHONY: clean
clean:
	rm -f repro.o repro
