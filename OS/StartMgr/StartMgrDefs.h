/* StartMgrDefs.h - Constants for Boot1.s */

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

/* SysErr.a */
#define dsNoPatch 98
#define dsSystemFileErr 20

/* FSEqu.a */
#define fsSBPartialName 0
#define fsSBFullName 1

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
