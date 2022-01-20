.section .text
.global secure_init

secure_init:
    mrs x4, cpacr_el1
    orr w4, w4, #(3<<20)
    msr cpacr_el1, x4 

    ldr x30, =stack
    mov sp, x30 
    bl secure_start

    smc #0
