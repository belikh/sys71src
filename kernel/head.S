    .global _start
    .global _halt

    .text
_start:
    /*
     * Boot Block Header (standard Mac)
     * The first 2 bytes must be 'LK' (0x4C, 0x4B)
     * The next 2 bytes are a branch to the code.
     */

    /* Signature 'LK' */
    .byte 0x4C, 0x4B

    /* Branch to Entry (offset will be calculated by assembler) */
    bra.w entry_point

    /* Configuration variables (Boot Block structure) */
    /* 0x04: Entry point for version (unused) */
    .byte 0x00, 0x00
    /* 0x06: Version */
    .byte 0x00, 0x00
    /* ... Padding to standard boot block header size if needed ... */

entry_point:
    /* Disable interrupts */
    ori.w   #0x0700, %sr

    /* Setup Stack - ROM usually provides a stack, but we should be safe */
    /* Let's use the top of memory minus some buffer. MemTop is at 0x108. */
    move.l  0x108, %sp
    sub.l   #0x1000, %sp  /* Leave 4KB buffer */

    /* Call C kernel (using PC-relative BSR or JSR) */
    /* Since we are -fPIC, we should use bsr if it's close, or load address relative to PC */
    bsr.w     kernel_main

_halt:
    stop    #0x2700
    bra.s   _halt
