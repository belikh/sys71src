# Interfaces Module

The `Interfaces/` directory contains the public API definitions for the system. These files define the structures, constants, and function prototypes used by applications and system components.

## Languages Supported
The interfaces are provided for multiple languages, reflecting the development environment of the era:
*   **C (`CIncludes/`):** Headers for C programming.
*   **Pascal (`PInterfaces/`):** Interfaces for Pascal (the primary language of the original Mac OS).
*   **Assembly (`AIncludes/`):** Equate files (`.a`) for assembly language development.

## Organization

### `CIncludes/` & `PInterfaces/`
Contains high-level definitions for Toolbox managers.
*   `Windows.h` / `Windows.p`: Window Manager.
*   `Menus.h` / `Menus.p`: Menu Manager.
*   `Files.h` / `Files.p`: File Manager.
*   `Memory.h` / `Memory.p`: Memory Manager.

### `AIncludes/`
Contains low-level offsets and bit definitions.
*   `SysEqu.a`: System global variables.
*   `Traps.a`: Trap numbers.

## Usage
These files are essential for compiling any code that interacts with the System 7.1 API. The build system includes these directories in the search path (e.g., `-i {AIncludes}`).
