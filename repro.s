.section .text
.globl _start
_start:
  .reloc ., R_LARCH_RELAX
  pcalau12i  $t0, %pc_hi20(sym)
  .reloc ., R_LARCH_RELAX
  addi.d     $t0, $t0, %pc_lo12(sym)

  .reloc ., R_LARCH_RELAX
  pcalau12i  $t1, %pc_hi20(sym)
  .reloc ., R_LARCH_RELAX
  addi.d     $t1, $t1, %pc_lo12(sym)

  # exit(0)
  li.d       $a7, 93
  li.d       $a0, 0
  syscall    0

.section .rodata
sym:
  .dword 0
