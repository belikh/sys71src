# Operating System (OS) Module

The `OS/` directory contains the core low-level components of Macintosh System 7.1. These components run in the kernel address space and provide essential services to the rest of the system.

## Key Components

### 1. Memory Manager (`MemoryMgr/`)
Responsible for managing the system heap and application heaps.
*   **Concepts:** Pointers, Handles (relocatable blocks), Heap Zones.
*   **Responsibilities:** Allocation, Deallocation, Compaction, Purging.

### 2. Process Manager (`ProcessMgr/`)
Implements the cooperative multitasking model introduced in System 7.
*   **Responsibilities:**
    *   Creating and destroying processes.
    *   Scheduling (context switching on `WaitNextEvent`).
    *   Apple Events (Inter-Process Communication).

### 3. File System (`HFS/`)
Implements the Hierarchical File System (HFS).
*   **Features:** Forks (Data Fork, Resource Fork), Catalog Tree, Extents Overflow.
*   **Interaction:** Accessed via the File Manager API.

### 4. Trap Dispatcher (`TrapDispatcher/`)
The mechanism that intercepts m68k "A-Line" instructions (0xAxxx) and routes them to the appropriate system routine.
*   **Role:** Provides binary compatibility and allows patching of system functions.

### 5. Other Managers
*   **TimeMgr:** Manages time-based tasks and delayed execution.
*   **PowerMgr:** Manages power states (crucial for Portables/PowerBooks).
*   **SlotMgr:** Manages NuBus expansion slots.
*   **StartMgr:** Handles the boot process.

## Directory Structure

| Directory | Description |
|-----------|-------------|
| `MemoryMgr/` | Memory management implementation. |
| `ProcessMgr/` | Process scheduling and IPC. |
| `HFS/` | HFS file system driver. |
| `Traps/` | Trap dispatch tables and logic. |
| `StartMgr/` | Boot logic. |
| `MMU/` | Memory Management Unit control (Virtual Memory support). |

## Dependencies
*   **Hardware:** Relies heavily on m68k specific instructions and hardware mapping.
*   **Drivers:** Uses drivers in `Drivers/` to access physical storage and devices.
