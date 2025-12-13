# Development Guide

This guide describes the workflow for contributing to the project and understanding the codebase structure.

## Directory Layout

*   `OS/`: Kernel and core services.
*   `Drivers/`: Hardware drivers.
*   `Interfaces/`: Public API headers.
*   `Internal/`: Private headers and stubs.
*   `Make/`: Build configuration.
*   `Build/`: Generated artifacts (created during build).

## Code Style
The codebase follows Apple's internal style from the early 90s.
*   **Languages:** Pascal, C, Assembly (68k).
*   **Naming:** PascalCase is dominant (e.g., `InitWindows`, `NewPtr`).
*   **Comments:** mostly `/* ... */` in C, `(* ... *)` in Pascal, `;` in Assembly.

## Workflow

### 1. Adding a New Feature
1.  Identify the appropriate module in `OS/` or `Drivers/`.
2.  Add your source file (e.g., `.c` or `.a`).
3.  Update the `Make/MainCode.Make` file to include your new object in the link list.
    *   *Tip:* You can use `patch_makefile.sh` logic to append it if you don't want to edit the makefile directly.

### 2. Modifying Existing Code
1.  Locate the source file.
2.  Edit the code.
3.  Run `./build_system7.sh` to rebuild.

### 3. Debugging
Since this is a cross-compiled OS kernel, debugging is challenging.
*   **Emulation:** Run the built image in a Macintosh emulator (e.g., Mini vMac, BasiliskII, MAME).
*   **Debug Output:** You can write to a specific memory address or use a serial driver (if implemented) to log messages.
*   **Stubs:** Use `Internal/C/MiniFinder.c` to create simple test harnesses that run immediately after boot.

## Testing
There is no unit test framework in the modern sense. Testing involves:
1.  Building the system.
2.  Booting the image in an emulator.
3.  Verifying behavior manually or via the `MiniFinder` logic.

## Tools
*   **empw:** The core tool for running the compiler.
*   **ResEdit:** (On a real Mac/Emulator) Useful for inspecting resource files (`.rsrc`).
*   **Disassemblers:** Tools like IDA Pro or Ghidra (with m68k support) are useful for analyzing binary blobs if source is missing.
