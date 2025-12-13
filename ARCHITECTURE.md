# System Architecture

## Overview

This repository contains the source code for a reconstruction of Macintosh System Software 7.1. It is designed to be cross-compiled on Linux targeting the Motorola 680x0 (m68k) architecture. The system follows the classic Macintosh "Toolbox" architecture, where the Operating System serves as a foundation for a rich set of user interface and system service APIs.

## High-Level Diagram

```mermaid
graph TD
    User[User] --> Finder[Finder / MiniFinder]
    Finder --> Toolbox[Macintosh Toolbox]
    Toolbox --> OS[Operating System Core]
    OS --> Drivers[Device Drivers]
    Drivers --> Hardware[Macintosh Hardware (m68k)]
```

## Core Components

### 1. Operating System (OS)
The kernel of the system, located in the `OS/` directory. It manages hardware resources and provides fundamental services:
- **Memory Manager:** Manages the application heap and system memory.
- **Process Manager:** Implements cooperative multitasking.
- **File System (HFS):** Hierarchical File System support.
- **Trap Dispatcher:** The mechanism that routes Toolbox calls to their implementations.

### 2. Toolbox
A collection of high-level APIs located across `OS/`, `Interfaces/`, and `Libs/`. It provides the building blocks for Macintosh applications:
- **Window Manager:** Manages on-screen windows.
- **Menu Manager:** Handles drop-down menus.
- **QuickDraw:** The graphics primitive library.
- **Event Manager:** Handles user input (mouse, keyboard).

### 3. Drivers
Located in `Drivers/`, these modules handle low-level hardware interaction:
- **Sony:** Floppy disk driver.
- **Video:** Display drivers.
- **IOP/ADB:** Input/Output Processors and Apple Desktop Bus for peripherals.

### 4. Build System
The project uses a cross-compilation strategy:
- **Host:** Linux.
- **Toolchain:** MPW (Macintosh Programmer's Workshop) running under `empw` emulation.
- **Configuration:** `.make` files in the `Make/` directory define dependencies and build rules.

## Data Flow
The system operates primarily on an event-driven model:
1.  **Hardware Interrupts:** Input devices trigger interrupts.
2.  **OS Event Queue:** The OS places these events into a queue.
3.  **Event Loop:** The active application (e.g., Finder) polls `WaitNextEvent`.
4.  **Dispatch:** The application processes the event and calls Toolbox functions to update the display or state.

## Key Directories

| Directory | Description |
|-----------|-------------|
| `OS/` | Core system components (Memory, Process, HFS). |
| `Drivers/` | Hardware drivers. |
| `Interfaces/` | Public SDK headers (C, Pascal, Assembly). |
| `Internal/` | Private headers and stub implementations. |
| `Make/` | Build configuration files. |
| `Libs/` | Static libraries linked into the final system. |
