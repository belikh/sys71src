# Drivers Module

The `Drivers/` directory contains the low-level software that controls the Macintosh hardware. These drivers provide a standard interface for the OS and Toolbox to interact with devices.

## Driver Structure
Macintosh drivers typically follow a standard structure:
*   **Open:** Initialize the driver/device.
*   **Close:** Shut down the driver.
*   **Control:** Send commands to the device.
*   **Status:** Get information from the device.
*   **Prime:** Perform I/O operations (Read/Write).

## Key Drivers

### 1. Sony (`Drivers/Sony/`)
The driver for the 3.5" Floppy Disk Drive.
*   **Role:** Handles raw track reading/writing, GCR encoding/decoding.
*   **Importance:** Often the primary boot device.

### 2. Video (`Drivers/Video/`)
Manages the frame buffer and display hardware.
*   **Role:** Sets video modes, handles vertical blanking interrupts (VBL).

### 3. IOP (`Drivers/IOP/`)
Support for I/O Processors found in machines like the Mac IIfx and Quadra 900/950.
*   **Role:** Offloads I/O tasks from the main CPU.

### 4. EDisk (`Drivers/EDisk/`)
Likely an emulator or RAM disk driver used for testing or specific boot scenarios.

## Interfaces
Drivers interact with the system via:
*   **Device Manager:** The OS component that loads and manages drivers.
*   **Interrupts:** Drivers install Interrupt Service Routines (ISRs) to handle hardware events asynchronously.

## Configuration
Driver configuration is often hardcoded or determined at runtime by the `SlotMgr` (for NuBus cards) or `StartMgr` (for built-in devices).
