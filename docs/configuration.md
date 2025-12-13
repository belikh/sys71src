# Configuration

This document explains the build configuration system for the repository.

## Build System Overview
The build is driven by MPW `Make` tools. Configuration is primarily defined in `.make` files located in the `Make/` directory.

## Key Configuration Files

### `Make/MainCode.Make` / `Make/Universal.make`
The master makefile.
*   **Defines:** Source directories, include paths, build options.
*   **Rules:** How to compile C, Pascal, and Assembly files.
*   **Link List:** The list of object files to link into the final system image.

### `Make/Build.txt`
Likely defines build versioning or specific build targets.

## Environment Variables

The `cross_compile.sh` and `build_system7.sh` scripts set up the following environment variables for `empw`:

| Variable | Description |
|----------|-------------|
| `MPW` | Root of the MPW tools directory. |
| `KS_MPW` | Alias for `MPW` (used by `empw`). |
| `BuildResults` | Output directory for artifacts (`Build/`). |
| `ObjDir` | Directory for intermediate object files. |
| `AIncludes` | Path to public Assembly includes. |
| `CIncludes` | Path to public C includes. |
| `IntAIncludes` | Path to internal Assembly includes. |

## Feature Flags and Defines
Conditional compilation is handled via compiler flags passed in the Makefile (e.g., `-d DEBUG`).

*   **debug:** Enables debug symbols and assertions.
*   **uni:** Likely refers to "Universal" build (supporting multiple machines).

## Patching
The `patch_makefile.sh` script dynamically modifies `Make/MainCode.Make` to inject dependencies.
*   **Mechanism:** Appends lines to the end of the file.
*   **Purpose:** To add `MiniFinder.c.o`, `VirtualMemoryStub.c.o`, etc., without manually editing the complex makefile.

To change the configuration manually, you can edit `Make/MainCode.Make` (carefully, preserving line endings and encoding) or modify the `patch_makefile.sh` script.
