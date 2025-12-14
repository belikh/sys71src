/*
 * Boot1.S
 * Ported from OS/StartMgr/Boot1.a to GAS syntax.
 */

#include "StartMgrDefs.h"

.global BootBlocks
.global main

BootBlocks:
main:
    .byte   0x4C, 0x4B      /* 'LK' */
    bra.w   Boot

/* Entry Point */
Boot:
    jeq     MainBootCode
    bsr     MainBootCode

    /* Return handling */
NextROM:
    move.w  8(%a0),%d1
    moveq   #-2,%d6

LoopROM:
    addq.w  #2,%d6
    move.w  ROMVersionTable(%pc,%d6.w),%d0
    jeq     BadROM
    cmp.w   %d0,%d1
    bne     LoopROM

    cmp.b   #0x76,%d1
    bhi     NoSysZoneResizeNeeded

    move.l  SysZone,%a0
    add.l   SystemHeapSize(%pc),%a0
    .word   _SetAppBase
    move.l  SysZone,TheZone

NoSysZoneResizeNeeded:
    addq.l  #4,%sp
    move.l  %sp,%d7
    bsr     MainBootCode

    move.w  AfterInitResourcesTable(%pc,%d6.w),%d1
    tst.w   %d0
    jeq     JoinROM
    move.w  RebootTable(%pc,%d6.w),%d1

JoinROM:
    move.l  ROMBase,%a0
    jmp     0(%a0,%d1.w)

BadROM:
    moveq   #dsNoPatch,%d0
    .word   _SysError

/* Tables */
ROMVersionTable:
    .short  0x0075, 0x0276, 0x0178, 0x037A, 0x067C, 0

AfterInitResourcesTable:
    .short  0x0A44, 0x090E, 0x0F1C, 0x30E6, 0x1D96

RebootTable:
    .short  0x0B82, 0x0A52, 0x11AE, 0x336E, 0x203E

SystemHeapSize:
    .long   0x20000

/* Main Boot Code */
MainBootCode:
    lea     SystemFileName(%pc),%a0
    lea     SysResName(%pc),%a1
    moveq   #16,%d0
    .word   _BlockMove

    lea     FinderFileName(%pc),%a0
    lea     FinderName(%pc),%a1
    moveq   #16,%d0
    .word   _BlockMove

    lea     ClipboardFileName(%pc),%a0
    lea     ScrapTag,%a1
    move.l  %a1,ScrapName
    moveq   #16,%d0
    .word   _BlockMove

    move.w  NumEvents(%pc),%d0
    .word   _InitEvents

    move.w  NumFCBs(%pc),%d0
    .word   _InitFS

    move.l  %d7,%a0
    move.w  BootDrive,ioDrvNum(%a0)
    .word   _MountVol
    bne     Return

    clr.l   ioFileName(%a0)
    clr.w   ioVolIndex(%a0)
    .word   _HGetVInfo
    bne     UnmountAndReturn

    move.l  ioVFndrInfo+4(%a0),%a4
    move.l  ioVFndrInfo(%a0),ioWDDirID(%a0)
    beq     NoFolder

    move.l  #0x4552494B,ioWDProcID(%a0) /* 'ERIK' */
    .word   _OpenWD
    bne     UnmountAndReturn
    .word   _SetVol

NoFolder:
    subq.l  #2,%sp
    .word   _InitResources
    tst.w   (%sp)+
    bmi     InitResourcesFailed

    subq.l  #4,%sp
    move.l  #0x626F6F74,-(%sp)
    move.w  #2,-(%sp)
    .word   _GetResource
    move.l  (%sp)+,%d0
    beq     Return

    addq.l  #4,%sp
    move.l  %d0,%a3
    move.l  (%a3),%a0
    jmp     (%a0)

InitResourcesFailed:
    moveq   #dsSystemFileErr,%d0

UnmountAndReturn:
    move.w  %d0,-(%sp)
    move.l  %d7,%a0
    .word   _UnmountVol
    move.w  (%sp)+,%d0

Return:
    rts

NumEvents: .short 20
NumFCBs:   .short 10

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
