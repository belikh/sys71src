# Internal Module

The `Internal/` directory contains private implementation details, glue code, and stubs that are not part of the public API.

## Subdirectories

### `C/` and `Pascal/`
Private headers and source files. These contain:
*   **Private APIs:** Functions shared between system components but not exposed to developers.
*   **Internal Data Structures:** Structs and records used internally by managers.
*   **Stubs:** `MiniFinder.c` and `VirtualMemoryStub.c` are located here.

### `Asm/`
Private assembly definitions and macros.
*   `SysPrivateEqu.a`: Private system globals.
*   `Emulator68kStub.a`: Stub for the 68k emulator (used on PPC or for specific build configs).

## Key Files

### `MiniFinder.c`
A reconstructed stub application that serves as a placeholder for the Finder.
*   **Purpose:** Allows the system to boot into a known state without requiring the proprietary Finder source code.
*   **Functionality:** Initializes the Toolbox, draws a desktop pattern, and runs a basic event loop.

### `VirtualMemoryStub.c`
A placeholder for Virtual Memory functionality.
*   **Purpose:** Satisfies link-time dependencies for VM calls if the full VM implementation is missing or excluded.

## Role in Build
The `cross_compile.sh` script specifically checks for and compiles files in this directory to ensure a complete link. `patch_makefile.sh` ensures these objects are included in the final link list.
