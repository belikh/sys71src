#include "mac_hardware.h"

// Simple 8x8 font bitmap (A subset for "Hello World")
// Minimal font data would be here. For now, let's just draw blocks or simple lines.
// Or we can define a very small font.

// 8x8 bitmap for 'A' (example)
// 00111100
// 01100110
// 01100110
// 01111110
// 01100110
// 01100110
// 00000000

// We need a simple `put_char` function.

void clear_screen() {
    uint32_t *screen = (uint32_t *)ScrnBase;
    uint16_t rowBytes = ScreenRow;
    uint32_t rows = SCREEN_HEIGHT;
    uint32_t stride = rowBytes / 4; // Stride in 32-bit words

    for (uint32_t y = 0; y < rows; y++) {
        for (uint32_t x = 0; x < stride; x++) {
            screen[y * stride + x] = 0x00000000; // White (0 is white on Mac usually? No, 0 is White, 1 is Black)
            // Wait, standard Mac video is 1 bit per pixel.
            // 0 = White, 1 = Black usually.
            // Let's invert it to be sure we see something.
            // 0xFFFFFFFF = Black bar.
            // 0xAAAAAAAA = Striped.
        }
    }
}

void draw_test_pattern() {
    uint32_t *screen = (uint32_t *)ScrnBase;
    uint16_t rowBytes = ScreenRow;

    // Draw a black line at the top
    for (int i=0; i < (rowBytes/4) * 10; i++) {
        screen[i] = 0xFFFFFFFF;
    }
}

// Very minimal font rendering (monochrome)
// x, y are in pixels
void draw_pixel(int x, int y, int color) {
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT) return;

    uint8_t *screen_byte = (uint8_t *)(ScrnBase + (y * ScreenRow) + (x / 8));
    uint8_t bit = 1 << (7 - (x % 8));

    if (color) {
        *screen_byte |= bit; // Set bit (Black)
    } else {
        *screen_byte &= ~bit; // Clear bit (White)
    }
}

// Simple "Bitmap Font" - just hardcoding 'H' 'e' 'l' 'l' 'o' for MVP to save space
// In a real OS, we'd include a font.h
const uint8_t FONT_A[8] = {0x3C, 0x66, 0x66, 0x7E, 0x66, 0x66, 0x66, 0x00};
// We will just implement a "Print String" that draws blocks for now if font is missing.

void kprint(const char* str) {
    // Placeholder: Draws a pattern to prove code execution
    draw_test_pattern();
}
