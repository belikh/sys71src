/*
 * Boot1.s
 * Ported from OS/StartMgr/Boot1.a to GAS syntax.
 *
 * Macintosh disk-based boot code.
 */

#include "StartMgrDefs.h"

.global BootBlocks
.global main

/* Boot Block Header */
BootBlocks:
main:
    .byte   0x4C, 0x4B      /* 'LK' - Boot Code Identifier */
    bra.w   Boot            /* Kick off the boot code */

/* Entry Point */
Boot:
    jeq     MainBootCode
    bsr.s   MainBootCode    /* Do normal boot code */

    /* Return handling */
NextROM:
    move.w  8(%a0),%d1        /* Get ROM version */
    moveq   #-2,%d6          /* Start index at -2 */

LoopROM:
    addq.w  #2,%d6           /* Increment index */
    /* PC-relative indexing */
    move.w  ROMVersionTable(%pc,%d6.w),%d0
    jeq     BadROM          /* End of table, ROM not supported */
    cmp.w   %d0,%d1           /* Match ROM version? */
    bne.s   LoopROM

    /* Found supported ROM */
    cmp.b   #0x76,%d1
    bhi.s   NoSysZoneResizeNeeded

    move.l  SysZone,%a0
    add.l   SystemHeapSize(%pc),%a0
    .word   _SetAppBase          /* _SetAppBase */
    move.l  SysZone,TheZone

NoSysZoneResizeNeeded:
    addq.l  #4,%sp           /* Pop off return address */
    move.l  %sp,%d7           /* PB calls use space on stack? */
    bsr.s   MainBootCode

    move.w  AfterInitResourcesTable(%pc,%d6.w),%d1
    tst.w   %d0              /* Check error */
    jeq     JoinROM
    move.w  RebootTable(%pc,%d6.w),%d1

JoinROM:
    move.l  ROMBase,%a0
    jmp     0(%a0,%d1.w)

BadROM:
    moveq   #dsNoPatch,%d0
    .word   _SysError          /* _SysError */

/* Tables */
ROMVersionTable:
    .short  0x0075          /* Plus */
    .short  0x0276          /* SE */
    .short  0x0178          /* II */
    .short  0x037A          /* Portable */
    .short  0x067C          /* IIci */
    .short  0               /* End */

AfterInitResourcesTable:
    .short  0x0A44          /* Plus */
    .short  0x090E          /* SE */
    .short  0x0F1C          /* II */
    .short  0x30E6          /* Portable */
    .short  0x1D96          /* IIci */

RebootTable:
    .short  0x0B82          /* Plus */
    .short  0x0A52          /* SE */
    .short  0x11AE          /* II */
    .short  0x336E          /* Portable */
    .short  0x203E          /* IIci */

/* Data */
SystemHeapSize:
    .long   0x20000

/* Main Boot Code */
MainBootCode:
    /* GetFileNames */
    lea     SystemFileName(%pc),%a0
    lea     SysResName(%pc),%a1
    moveq   #16,%d0
    .word   _BlockMove          /* _BlockMove */

    lea     FinderFileName(%pc),%a0
    lea     FinderName(%pc),%a1
    moveq   #16,%d0
    .word   _BlockMove          /* _BlockMove */

    lea     ClipboardFileName(%pc),%a0
    lea     ScrapTag,%a1
    move.l  %a1,ScrapName
    moveq   #16,%d0
    .word   _BlockMove          /* _BlockMove */

    /* InitializeEventManager */
    move.w  NumEvents(%pc),%d0
    .word   _InitEvents          /* _InitEvents */

    /* InitializeFileSystem */
    move.w  NumFCBs(%pc),%d0
    .word   _InitFS          /* _InitFS */

    /* MountStartupDisk */
    move.l  %d7,%a0           /* Parameter block */
    move.w  BootDrive,ioDrvNum(%a0)
    .word   _MountVol          /* _MountVol */
    bne.s   Return

    /* FindBlessedFolder */
    clr.l   ioFileName(%a0)
    clr.w   ioVolIndex(%a0)
    .word   _HGetVInfo          /* _HGetVInfo */
    bne.s   UnmountAndReturn

    move.l  ioVFndrInfo+4(%a0),%a4
    move.l  ioVFndrInfo(%a0),ioWDDirID(%a0)
    beq.s   NoFolder

    move.l  #0x4552494B,ioWDProcID(%a0) /* 'ERIK' */
    .word   _OpenWD          /* _OpenWD */
    bne.s   UnmountAndReturn
    .word   _SetVol          /* _SetVol */

NoFolder:
    /* InitializeResourceManager */
    subq.l  #2,%sp
    .word   _InitResources          /* _InitResources */
    tst.w   (%sp)+
    bmi.s   InitResourcesFailed

    /* ContinueBooting */
    subq.l  #4,%sp
    move.l  #0x626F6F74,-(%sp) /* 'boot' */
    move.w  #2,-(%sp)
    .word   _GetResource          /* _GetResource */
    move.l  (%sp)+,%d0
    beq.s   Return          /* No 'boot' 2, return 0 (noErr) */

    addq.l  #4,%sp           /* Pop return addr */
    move.l  %d0,%a3
    move.l  (%a3),%a0
    jmp     (%a0)

InitResourcesFailed:
    moveq   #dsSystemFileErr,%d0

UnmountAndReturn:
    move.w  %d0,-(%sp)
    move.l  %d7,%a0
    .word   _UnmountVol          /* _UnmountVol */
    move.w  (%sp)+,%d0

Return:
    rts

/* Constants & Data */
NumEvents: .short 20
NumFCBs:   .short 10

/* String Data (Pascal Strings) */
SystemFileName:
    .byte   6
    .ascii  "System"
    .align 2
    .space 16

SysResName:
    .space 16

FinderFileName:
    .byte   6
    .ascii  "Finder"
    .align 2
    .space 16

FinderName:
    .space 16

ClipboardFileName:
    .byte   9
    .ascii  "Clipboard"
    .align 2
    .space 16
