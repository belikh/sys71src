# System Architecture

This document provides a detailed overview of the Macintosh System 7.1 architecture as implemented in this repository.

## Architectural Style

The system follows a **Monolithic Kernel** design combined with a **Toolbox** API layer.
-   **Monolithic:** The core OS services (Memory, Process, File System) run in a single address space (privileged mode on 680x0).
-   **Toolbox:** A rich library of high-level services (Windows, Menus, Controls) that applications link against or call via the Trap Dispatcher.
-   **Cooperative Multitasking:** The Process Manager switches tasks only when an application explicitly yields control (e.g., calling `WaitNextEvent`).

## Component Diagram

```mermaid
graph TB
    subgraph User Space
        App[Application]
        Finder[Finder / MiniFinder]
    end

    subgraph Toolbox Layer
        WM[Window Manager]
        MM[Menu Manager]
        QD[QuickDraw]
        Dlg[Dialog Manager]
    end

    subgraph OS Layer
        Trap[Trap Dispatcher]
        PM[Process Manager]
        Mem[Memory Manager]
        HFS[File System (HFS)]
        Res[Resource Manager]
    end

    subgraph Hardware Abstraction
        Drivers[Device Drivers]
        ADB[ADB Manager]
        SCSI[SCSI Manager]
    end

    subgraph Hardware
        CPU[m68k CPU]
        RAM[Memory]
        Disk[Disk Drive]
        Video[Video Card]
    end

    App --> WM
    App --> MM
    App --> QD
    Finder --> WM

    WM --> Trap
    MM --> Trap

    Trap --> PM
    Trap --> Mem
    Trap --> Res

    Res --> HFS
    HFS --> SCSI
    SCSI --> Drivers
    Drivers --> Hardware
```

## Key Data Flows

### Application Launch
1.  **User Action:** User double-clicks an icon in the Finder.
2.  **Finder:** Calls `LaunchApplication`.
3.  **Process Manager:**
    *   Allocates a partition in memory for the new application.
    *   Loads the code segments (CODE resources) from the executable file.
    *   Sets up the A5 world (globals and jump table).
    *   Transfers control to the application's entry point.

### Event Processing
1.  **Hardware:** Mouse move or Key press triggers an interrupt.
2.  **ISR:** Interrupt Service Routine stores raw event data.
3.  **OS Event Manager:** Converts raw data into an `EventRecord` and places it in the System Event Queue.
4.  **Application:** Calls `WaitNextEvent`.
5.  **OS:** Moves the event from the System Queue to the Application's Event Queue and returns it to the app.
6.  **Application:** Dispatches the event to the appropriate handler (e.g., `HandleClick`).

## Module Interaction

*   **Trap Dispatcher:** The central hub. All Toolbox calls (A-Traps) go through the dispatch table to find the implementation address in ROM or RAM.
*   **Memory Manager:** Fundamental dependency. Almost every other module (Drivers, Toolbox, Process Mgr) needs to allocate memory blocks (pointers or handles).
*   **Resource Manager:** The primary data loading mechanism. Code, dialogs, strings, and fonts are all loaded as resources.

## Build Architecture

The build system transforms source code into a "System" file (technically a suitcase of resources).

```mermaid
graph LR
    Src[Source Code (.c, .p, .a)] --> Compiler[MPW Compilers]
    Compiler --> Obj[Object Files (.o)]
    Obj --> Linker[MPW Linker]
    Linker --> CodeRes[CODE Resources]
    ResSrc[Resource Definitions (.r)] --> Rez[Rez Compiler]
    Rez --> Rsrc[Resource Files (.rsrc)]
    CodeRes --> System[System File]
    Rsrc --> System
```
