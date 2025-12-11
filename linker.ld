SECTIONS
{
    . = 0x00000000; /* Boot Blocks are loaded at a specific address, often relocatable. */
    /*
     * However, Mac ROMs often load Boot Blocks into a pointer passed in registers.
     * Or they might be Position Independent Code (PIC).
     * We should compile as PIC if possible, or assume an address.
     * Usually Boot Blocks are loaded at heap or stack.
     * Safe bet: Compile as PIC (-fPIC).
     * But for linker script, we can set 0 and use PC-relative addressing.
     */

    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}
