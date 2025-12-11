#ifndef MAC_HARDWARE_H
#define MAC_HARDWARE_H

// Type definitions
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef int int32_t;

// Mac Low Memory Globals
// Updated based on SysEqu.a findings
#define ScrnBase    (*(volatile uint32_t*)0x824)
// ScreenRow at 0x106? SysEqu.a said 0x106 is ScreenRow.
// Let's verify. 0x106 seems low. But if SysEqu says so.
// Wait, 0x106 is often "MemTop"? No, MemTop is 0x108.
// Let's stick with 0x826 if I can verify it, OR use 0x106 if SysEqu is clear.
// SysEqu: "ScreenRow EQU $106"
#define ScreenRow   (*(volatile uint16_t*)0x106)
#define MemTop      (*(volatile uint32_t*)0x108)
#define ROMBase     (*(volatile uint32_t*)0x2AE)

// VIA1 Addresses (SE/30)
#define VIA1_BASE   0x50F00000

// Video parameters
#define SCREEN_WIDTH  512
#define SCREEN_HEIGHT 342

#endif
