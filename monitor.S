#include "context.h"

.section .text
.global monitor_init

monitor_init:
    ldr x0, =monitor_vectors
    msr vbar_el3, x0 

    mrs x0, sctlr_el3
    orr w0, w0, #(1<<19)    // WXN
    orr w0, w0, #(1<<3)     // SA
    orr w0, w0, #(1<<1)     // A
    msr sctlr_el3, x0 

    mrs x1, cptr_el3
    bic w1, w1, #(1<<31)    // TCPAC
    bic w1, w1, #(1<<20)    // TTA
    orr w1, w1, #(1<<10)    // TFP
    msr cptr_el3, x1 

    ldr x30, =stack
    mov sp, x30 
    bl monitor_start

    // NS
    // SCR_EL3 -> X10
    // SPSR_EL3 -> X3
    // ELR_EL3 -> X2

    // S
    // SCR_EL3 -> X9
    // SPSR_EL3 -> X1
    // ELR_EL3 -> X0

    // SCTLR_EL3 -> X12
    // SCTLR_EL1 -> X8

    mrs x9, scr_el3 
    mov w10, #0x78f         // RW, SIF, HCE, SMD, EA, FIQ, IRQ, NS
    bic w9, w9, w10
    orr w9, w9, #(1<<9)     // SIF
    orr w10, w9, #1         // NS
    mrs x12, sctlr_el3
    ubfx w12, w12, 25, 1    // w12[0] = EE

    mov x3, 5
    orr w10, w10, #(1<<10)  // RW
    orr w3, w3, #0x3c0      // D, A, I, F

    mov x1, 5
    orr w9, w9, #(1<<10)    // RW
    orr w1, w1, #0x3c0      // D, A, I, F

    mrs x8, sctlr_el1
    bfi w8, w12, 25, 1      // w8[0] = EE
    mov w11, #(1<<12)|(1<<2)|(1<<0)     // I, C, M
    bic w8, w8, w11
    msr sctlr_el1, x8 

    msr vbar_el1, xzr 

    mov x2, 0x60000000
    add x11, sp, #CTX_SIZE 
    str x8, [x11, #CTX_SCTLR_EL1]
    str x10, [x11, #CTX_SCR_EL3]
    str x2, [x11, #CTX_ELR_EL3]
    str x3, [x11, #CTX_SPSR_EL3]

    mov x10, sp 
    msr tpidr_el3, x10 
    mrs x11, cptr_el3 
    bic w11, w11, #(1<<10)  // TFP
    msr cptr_el3, x11  

    msr scr_el3, x9 
    msr elr_el3, x0 
    msr spsr_el3, x1 

    eret 


monitor_save_context:
    stp x0, x1, [sp, #CTX_X0]
    stp x2, x3, [sp, #CTX_X2]
    stp x4, x5, [sp, #CTX_X4]
    stp x6, x7, [sp, #CTX_X6]
    stp x8, x9, [sp, #CTX_X8]
    stp x10, x11, [sp, #CTX_X10]
    stp x12, x13, [sp, #CTX_X12]
    stp x14, x15, [sp, #CTX_X14]
    stp x16, x17, [sp, #CTX_X16]
    stp x18, x19, [sp, #CTX_X18]
    stp x20, x21, [sp, #CTX_X20]
    stp x22, x23, [sp, #CTX_X22]
    stp x24, x25, [sp, #CTX_X24]
    stp x26, x27, [sp, #CTX_X26]
    stp x28, x29, [sp, #CTX_X28]
    mrs x4, sp_el0
    stp x30, x4, [sp, #CTX_X30]
    
    mrs x4, spsr_el3 
    mrs x5, spsr_el1
    mrs x6, elr_el3  
    mrs x7, elr_el1  
    mrs x8, sctlr_el1
    mrs x9, cpacr_el1
    mrs x10, sp_el1 
    mrs x11, vbar_el1
    mrs x12, scr_el3 

    stp x4, x5, [sp, #CTX_SPSR_EL3]
    stp x6, x7, [sp, #CTX_ELR_EL3]
    stp x8, x9, [sp, #CTX_SCTLR_EL1]
    stp x10, x11, [sp, #CTX_SP_EL1]
    str x12, [sp, #CTX_SCR_EL3]

    ret 

monitor_restore_context:
    ldp x4, x5, [sp, #CTX_SPSR_EL3]
    ldp x6, x7, [sp, #CTX_ELR_EL3]
    ldp x8, x9, [sp, #CTX_SCTLR_EL1]
    ldp x10, x11, [sp, #CTX_SP_EL1]
    ldr x12, [sp, #CTX_SCR_EL3]
    ldr x13, [sp, #CTX_SP_EL0]

    msr spsr_el3, x4 
    msr spsr_el1, x5
    msr elr_el3, x6  
    msr elr_el1, x7  
    msr sctlr_el1, x8
    msr cpacr_el1, x9
    msr sp_el1, x10 
    msr vbar_el1, x11
    msr scr_el3, x12  
    msr sp_el0, x13

    ldp x0, x1, [sp, #CTX_X0]
    ldp x2, x3, [sp, #CTX_X2]
    ldp x4, x5, [sp, #CTX_X4]
    ldp x6, x7, [sp, #CTX_X6]
    ldp x8, x9, [sp, #CTX_X8]
    ldp x10, x11, [sp, #CTX_X10]
    ldp x12, x13, [sp, #CTX_X12]
    ldp x14, x15, [sp, #CTX_X14]
    ldp x16, x17, [sp, #CTX_X16]
    ldp x18, x19, [sp, #CTX_X18]
    ldp x20, x21, [sp, #CTX_X20]
    ldp x22, x23, [sp, #CTX_X22]
    ldp x24, x25, [sp, #CTX_X24]
    ldp x26, x27, [sp, #CTX_X26]
    ldp x28, x29, [sp, #CTX_X28]
    ldr x30, [sp, #CTX_X30]

    eret 


.section .vectors
.align 11
.global monitor_vectors

monitor_vectors:
    b .
    .align 7
    b .
    .align 7
    b .
    .align 7
    b .
    .align 7

    b .
    .align 7
    b .
    .align 7
    b .
    .align 7
    b .
    .align 7

sync_exception:
    bl monitor_save_context
    mrs x10, scr_el3 
    mov w11, #CTX_SIZE
    tst x10, #1
    cneg w11, w11, ne 
    add sp, sp, w11, sxtw
    bl monitor_restore_context

    .align 7
    b .
    .align 7
    b .
    .align 7
    b .
    .align 7

    b .
    .align 7
    b .
    .align 7
    b .
    .align 7
    b .
    .align 7
