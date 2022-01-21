ENTRY(monitor_init)

MEMORY
{
    secure_rom (rx) : org = 0x00000000, l = 0x00020000
    secure_sram     : org = 0x0e000000, l = 0x00060000
    secure_dram     : org = 0x0e100000, l = 0x00f00000
    normal_dram     : org = 0x40000000, l = 0xc0000000
}

SECTIONS
{
    /DISCARD/ : { *(.ARM.attributes);}

    .text : {
        *(.text)
    } > secure_rom

    .rodata : {
        *(.strings)
        *(.rodata)
        *(.rodata.*)
    } > secure_rom

    .data : {
        *(.data)
    } > secure_sram AT> secure_rom

    .bss : {
        *(.bss)
        *(COMMON)
    } > secure_sram AT> secure_rom

    stack = 0x0e005000;
}
