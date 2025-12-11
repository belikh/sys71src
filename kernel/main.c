#include "mac_hardware.h"

extern void clear_screen();
extern void kprint(const char* str);
extern void draw_test_pattern();

void kernel_main() {
    // 1. Initialize Video
    // (Assuming ScrnBase is valid from ROM)

    // 2. Clear Screen
    // clear_screen(); // Commented out to avoid clearing if it's already white, let's just draw on top.

    // 3. Print Welcome Message
    // kprint("Welcome to NewOS");

    // Draw something visible immediately
    draw_test_pattern();

    // 4. Infinite Loop (Shell Prompt)
    while (1) {
        // Blink a pixel or wait for interrupt
        volatile int i;
        for (i=0; i<100000; i++);
        // TODO: Blink cursor
    }
}
