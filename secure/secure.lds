ENTRY(secure_init)

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
    } > secure_dram

    .rodata : {
        *(.strings)
        *(.rodata)
        *(.rodata.*)
    } > secure_dram

    .data : {
        *(.data)
    } > secure_dram 

    .bss : {
        *(.bss)
        *(COMMON)
    } > secure_dram

    . = ALIGN(8);
    stack = . + 0x10000;
}
