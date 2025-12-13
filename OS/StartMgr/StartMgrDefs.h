/* StartMgrDefs.h - Constants for Start Manager Assembly */

/* SysEqu.a */
#define ioFileName 0x12
#define ioDrvNum 0x16
#define ioVolIndex 0x1C
#define ioWDProcID 0x1C
#define ioWDDirID 0x30
#define ioVFndrInfo 0x5A
#define TheZone 0x118
#define BootDrive 0x210
#define SysZone 0x2A6
#define ROMBase 0x2AE
#define ScrapName 0x96C
#define ScrapTag 0x970
#define CurStackBase 0x908
#define CurrentA5 0x904
#define ResumeProc 0xA8C
#define DefltStack 0x322
#define HeapEnd 0x114
#define bkLim 0x20 /* BlockLimit offset in heap zone? Check */

/* SysErr.a */
#define dsNoPatch 98
#define dsSystemFileErr 20
#define dsOldSystem 102

/* FSEqu.a */
#define fsSBPartialName 0
#define fsSBFullName 1

/* BootEqu.a StartGlobals */
#define sgTestSpace 0
#define sgRamTable 8
#define sgMaxChunks 8
#define sgWarmStart 8
#define sgTopOff 12
#define sgAllocOff 16
#define sgPhysicalTableOff 20
#define sgTotalRAM 24
#define sgPhys2Log 28
#define sgMMFlags 32
#define sgTypeMMU 33
#define MMUInfoSize 20
#define sg24Info 34
#define sg32Info (34 + MMUInfoSize)
#define sgRamDiskSize (34 + 2 * MMUInfoSize)
#define sgRamDiskBase (34 + 2 * MMUInfoSize + 4)
#define sgScratch (34 + 2 * MMUInfoSize + 8)
#define sgEDiskStealFlag (34 + 2 * MMUInfoSize + 24)
#define sgAlign (34 + 2 * MMUInfoSize + 25)
#define sgBottom (34 + 2 * MMUInfoSize + 26)

/* BootGlobals */
#define BootGlobals_initialSP -400
#define BootGlobals_paramBlock -400
#define BootGlobals_quickDrawGlobals -206
#define BootGlobals_initialA5 0
#define BootGlobals_quickDrawGlobalsPtr 0
#define BootGlobals_physicalMemTop 4
#define BootGlobals_logicalMemTop 8
#define BootGlobals_postBootNewPtrStartup 12
#define BootGlobals_bufPtrLimit 16
#define BootGlobals_resetFlag 20
#define BootGlobals_reservedForAfterBoot 22
#define BootGlobals_port (22 + 4 + 86)
#define BootGlobals_fileName (112 + 108)
#define BootGlobals_initialA6 624
#define BootGlobals_bootBlocks 624
#define BootGlobals_lowestBufPtr 1648
#define BootGlobals_fileBuffer 1648
#define BootGlobals_size (1648 + 524 - (-400))

#define minSysHeapFreeAfterBoot (100 * 1024)
#define minRAMNeededToBoot (3 * 512 * 1024)
#define vmDebugSignature 0x564D

/* Other constants */
#define kROMVersionPlus 0x0075
#define boxPlus 0
#define MapTrue 1
#define ROMMapInsert 0xB04
#define CurMap 0xA5A
#define SysMap 0xA58
#define SysMapHndl 0xA58
#define TopMapHndl 0xA50
#define mNext 0
#define ResLoad 0xA5E
#define ResErr 0xA60
#define kCPUGibblyFileType 0x67626C79
#define kGibblyResourceType 0x67626C79
#define kGibblyResourceID 0
#define bFInvisible 14
#define fdType 0
#define fdFlags 8
#define ioFlUsrWds 32
#define ioFDirIndex 28
#define ioDirID 48
#define ioVRefNum 22
#define ioFileType 26

/* Trap Codes */
#define _BlockMove 0xA02E
#define _InitEvents 0xA06D
#define _InitFS 0xA06C
#define _MountVol 0xA00F
#define _HGetVInfo 0xA307
#define _OpenWD 0xA200
#define _SetVol 0xA015
#define _InitResources 0xA995
#define _GetResource 0xA9A0
#define _UnmountVol 0xA00E
#define _SetAppBase 0xA9AF
#define _SysError 0xA9C9
#define _GetHandleSize 0xA025
#define _InitApplZone 0xA02C
#define _SetApplLimit 0xA02D
#define _CloseResFile 0xA99A
#define _HGetFileInfo 0xA308
#define _Get1Resource 0xA9A8
#define _ReleaseResource 0xA9A3
#define _HOpenResFile 0xA81A
#define _OpenResFile 0xA997
#define _GetVol 0xA014
