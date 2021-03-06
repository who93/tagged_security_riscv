# See LICENSE for license details.

#include "encoding.h"

#ifdef __riscv64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

  .data
  .align 6
trap_table:
#define HTIF_INTERRUPT_VECTOR 0
  .word htif_interrupt
#define TRAP_FROM_MACHINE_MODE_VECTOR 1
  .word trap_from_machine_mode
#define IO_INTERRUPT_VECTOR 2
  .word io_irq_service

.comm zaehler, 8
  .text
  .align 6
user_trap_entry:
  j trap_entry

  .align 6
supervisor_trap_entry:
  j supervisor_trap_entry

  .align 6
hypervisor_trap_entry:
  j hypervisor_trap_entry

  .align 6
machine_trap_entry:
  j trap_entry

  .align 6
  .globl _start
_start:
  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0

  li t0, MSTATUS_PRV1; csrc mstatus, t0    # run tests in user mode
  li t0, MSTATUS_IE1;  csrs mstatus, t0    # enable interrupts in user mode
  li t0, MSTATUS_FS;   csrs mstatus, t0    # enable FPU
  li t0, MSTATUS_XS;   csrs mstatus, t0    # enable accelerator

#ifdef __riscv64
  csrr t0, mcpuid
  # make sure processor supports RV64 if this was compiled for RV64
  bltz t0, 1f
  li a0, 1234
  j exit
1:
#endif

  # csrr t0, mstatus
  # li t1, MSTATUS_XS
  # and t1, t0, t1
  # sw t1, have_vec, t2

  ## if that didn't stick, we don't have a FPU, so don't initialize it
  li t1, MSTATUS_FS
  and t1, t0, t1
  beqz t1, 1f

#ifdef __riscv_hard_float
  fssr    x0
  fmv.s.x f0, x0
  fmv.s.x f1, x0
  fmv.s.x f2, x0
  fmv.s.x f3, x0
  fmv.s.x f4, x0
  fmv.s.x f5, x0
  fmv.s.x f6, x0
  fmv.s.x f7, x0
  fmv.s.x f8, x0
  fmv.s.x f9, x0
  fmv.s.x f10,x0
  fmv.s.x f11,x0
  fmv.s.x f12,x0
  fmv.s.x f13,x0
  fmv.s.x f14,x0
  fmv.s.x f15,x0
  fmv.s.x f16,x0
  fmv.s.x f17,x0
  fmv.s.x f18,x0
  fmv.s.x f19,x0
  fmv.s.x f20,x0
  fmv.s.x f21,x0
  fmv.s.x f22,x0
  fmv.s.x f23,x0
  fmv.s.x f24,x0
  fmv.s.x f25,x0
  fmv.s.x f26,x0
  fmv.s.x f27,x0
  fmv.s.x f28,x0
  fmv.s.x f29,x0
  fmv.s.x f30,x0
  fmv.s.x f31,x0
#endif

1:

  # initialize global pointer
  la gp, _gp

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 4KB of stack + TLS
#define STKSHIFT 12
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp

 # la t0, _init
 # la a3, zaehler
 # sd t0, (a3)
 # li t0, 1
 # stag t0, (a3)
 # ld t0, (a3)

  la t0, _init
  csrw mepc, t0
  eret

trap_entry:
  addi sp, sp, -272

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause
  bltz a0, .Linterrupt
  csrr a1, mepc
  mv a2, sp
  jal handle_trap
  csrw mepc, a0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 272
  eret

  .global asm_set_iobase0
asm_set_iobase0:
  csrw    0x7b0, a0
  csrw    0x7b1, a1
  ret

  .global asm_set_iobase1
asm_set_iobase1:
  csrw    0x7b4, a0
  csrw    0x7b5, a1
  ret

  .global asm_set_iobase2
asm_set_iobase2:
  csrw    0x7b8, a0
  csrw    0x7b9, a1
  ret

  .global asm_set_iobase3
asm_set_iobase3:
  csrw    0x7bc, a0
  csrw    0x7bd, a1
  ret

  .global asm_update_iospace
asm_update_iospace:
  csrw    0x7bf, a0
  ret

  .global asm_set_membase0
asm_set_membase0:
  csrw    0x7a0, a0
  csrw    0x7a1, a1
  csrw    0x7a2, a2
  ret

  .global asm_set_membase1
asm_set_membase1:
  csrw    0x7a4, a0
  csrw    0x7a5, a1
  csrw    0x7a6, a2
  ret

  .global asm_set_membase2
asm_set_membase2:
  csrw    0x7a8, a0
  csrw    0x7a9, a1
  csrw    0x7aa, a2
  ret

  .global asm_set_membase3
asm_set_membase3:
  csrw    0x7ac, a0
  csrw    0x7ad, a1
  csrw    0x7ae, a2
  ret

  .global asm_update_memspace
asm_update_memspace:
  csrw    0x7af, a0
  ret

  .global asm_set_tagctrl
asm_set_tagctrl:
  csrw    0x400, a0
  ret

  .align 6
  .globl asm_soft_reset
asm_soft_reset:
    csrw 0x7af, a0
    li a1, 100
    li a0, 0
1:  add a1, a1, -1
    bne a1, a0, 1b
    csrw mreset, a0


.Linterrupt:
  sll a0, a0, 1    # discard MSB

  # See if this is a timer interrupt; post a supervisor interrupt if so.
  li a1, IRQ_TIMER * 2
  bne a0, a1, 1f
  li a0, MIP_MTIP
  csrc mip, a0
  li a1, MIP_STIP
  csrc mie, a0
  csrs mip, a1

1:

  # See if this is an HTIF interrupt; if so, handle it in machine mode.
  li a1, IRQ_HOST * 2
  bne a0, a1, 1f
  li a0, HTIF_INTERRUPT_VECTOR
  j .Lhandle_trap_in_machine_mode

1:
  # See if this is a peripheral IRQ; if so, handle it in machine mode.
  li a1, IRQ_IO * 2
  bne a0, a1, .Lbad_trap
  li a0, IO_INTERRUPT_VECTOR

.Lhandle_trap_in_machine_mode:
  # Preserve the registers.  Compute the address of the trap handler.
  SREG ra, 1*REGBYTES(sp)
  csrrw ra, mscratch, sp           # ra <- user sp
  SREG gp, 3*REGBYTES(sp)
  SREG tp, 4*REGBYTES(sp)
  SREG t0, 5*REGBYTES(sp)
1:auipc t0, %pcrel_hi(trap_table)  # t0 <- %hi(trap_table)
  SREG t1, 6*REGBYTES(sp)
  sll t1, a0, 2                    # t1 <- mcause << 2
  SREG t2, 7*REGBYTES(sp)
  add t0, t0, t1                   # t0 <- %hi(trap_table)[mcause]
  SREG s0, 8*REGBYTES(sp)
  lw t0, %pcrel_lo(1b)(t0)         # t0 <- trap_table[mcause]
  SREG s1, 9*REGBYTES(sp)
  mv a1, sp                        # a1 <- regs
  SREG a2,12*REGBYTES(sp)
  SREG a3,13*REGBYTES(sp)
  SREG a4,14*REGBYTES(sp)
  SREG a5,15*REGBYTES(sp)
  SREG a6,16*REGBYTES(sp)
  SREG a7,17*REGBYTES(sp)
  SREG s2,18*REGBYTES(sp)
  SREG s3,19*REGBYTES(sp)
  SREG s4,20*REGBYTES(sp)
  SREG s5,21*REGBYTES(sp)
  SREG s6,22*REGBYTES(sp)
  SREG s7,23*REGBYTES(sp)
  SREG s8,24*REGBYTES(sp)
  SREG s9,25*REGBYTES(sp)
  SREG s10,26*REGBYTES(sp)
  SREG s11,27*REGBYTES(sp)
  SREG t3,28*REGBYTES(sp)
  SREG t4,29*REGBYTES(sp)
  SREG t5,30*REGBYTES(sp)
  SREG t6,31*REGBYTES(sp)
  SREG ra, 2*REGBYTES(sp)         # sp

#ifndef __riscv_hard_float
  lw tp, (sp) # Move the emulated FCSR from x0's save slot into tp.
#endif
  SREG x0, (sp) # Zero x0's save slot.



  # Invoke the handler.
  jalr t0

#ifndef __riscv_hard_float
  sw tp, (sp) # Move the emulated FCSR from tp into x0's save slot.
#endif

  # Restore all of the registers.
  LREG ra, 1*REGBYTES(sp)
  LREG gp, 3*REGBYTES(sp)
  LREG tp, 4*REGBYTES(sp)
  LREG t0, 5*REGBYTES(sp)
  LREG t1, 6*REGBYTES(sp)
  LREG t2, 7*REGBYTES(sp)
  LREG s0, 8*REGBYTES(sp)
  LREG s1, 9*REGBYTES(sp)
  LREG a1,11*REGBYTES(sp)
  LREG a2,12*REGBYTES(sp)
  LREG a3,13*REGBYTES(sp)
  LREG a4,14*REGBYTES(sp)
  LREG a5,15*REGBYTES(sp)
  LREG a6,16*REGBYTES(sp)
  LREG a7,17*REGBYTES(sp)
  LREG s2,18*REGBYTES(sp)
  LREG s3,19*REGBYTES(sp)
  LREG s4,20*REGBYTES(sp)
  LREG s5,21*REGBYTES(sp)
  LREG s6,22*REGBYTES(sp)
  LREG s7,23*REGBYTES(sp)
  LREG s8,24*REGBYTES(sp)
  LREG s9,25*REGBYTES(sp)
  LREG s10,26*REGBYTES(sp)
  LREG s11,27*REGBYTES(sp)
  LREG t3,28*REGBYTES(sp)
  LREG t4,29*REGBYTES(sp)
  LREG t5,30*REGBYTES(sp)
  LREG t6,31*REGBYTES(sp)

  bnez a0, 1f

  # Go back whence we came.
  LREG a0, 10*REGBYTES(sp)
  LREG sp, 2*REGBYTES(sp)
  nop
  nop
  nop
  nop
  nop
  eret

1:# Redirect the trap to the supervisor.
  LREG a0, 10*REGBYTES(sp)
  LREG sp, 2*REGBYTES(sp)
  mrts

.Lbad_trap:
  j bad_trap


.section ".tdata.begin"
.globl _tdata_begin
_tdata_begin:

.section ".tdata.end"
.globl _tdata_end
_tdata_end:

.section ".tbss.end"
.globl _tbss_end
_tbss_end:
