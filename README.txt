mold stale relocation after relaxation
======================================

mold does not update relocations after performing linker relaxation. This is
primarily observed on LoongArch, but RISC-V is likely affected since both
allows relaxation through a similar process.

LLVM previously suffered from similar problems; see [^0].


Build and run
-------------

Run the following command to examine the linked ELF:

        $ make CC=clang CFLAGS='--target=loongarch64-unknown-linux-gnu' disasm
        clang  --target=loongarch64-unknown-linux-gnu -c repro.s -o repro.o
        clang -nostdlib -static -fuse-ld=mold -Wl,--emit-relocs -o repro repro.o
        objdump --disassemble --reloc repro
        
        repro:     file format elf64-loongarch
        
        
        Disassembly of section .text:
        
        0000000000210278 <_start>:
          210278:       19f7ffcc        pcaddi          $t0, -16386
                                210278: R_LARCH_PCALA_HI20      sym
                                210278: R_LARCH_RELAX   *ABS*
          21027c:       19f7ffad        pcaddi          $t1, -16387
                                21027c: R_LARCH_PCALA_LO12      sym
                                21027c: R_LARCH_RELAX   *ABS*
          210280:       0381740b        li.w            $a7, 0x5d
                                210280: R_LARCH_PCALA_HI20      sym
                                210280: R_LARCH_RELAX   *ABS*
          210284:       03800004        li.w            $a0, 0x0
                                210284: R_LARCH_PCALA_LO12      sym
                                210284: R_LARCH_RELAX   *ABS*
          210288:       002b0000        syscall         0x0

Note the stale relocations left behind after relaxation. Neither of the li.w
is supposed to have relocations attached, and both pcaddi are attached (left
with?) wrong type of relocation.

---

[^0]: https://reviews.llvm.org/D159082
