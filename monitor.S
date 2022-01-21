.section .text
.global monitor_init

monitor_init:
    msr vbar_el3, xzr

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

    mov x10, sp 
    msr tpidr_el3, x10 
    mrs x11, cptr_el3 
    bic w11, w11, #(1<<10)  // TFP
    msr cptr_el3, x11  

    msr scr_el3, x9 
    msr elr_el3, x0 
    msr spsr_el3, x1 

    eret 
