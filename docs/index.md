# Macintosh System 7.1 Source Code

Welcome to the documentation for the Macintosh System 7.1 source code repository. This project aims to preserve, analyze, and build the classic Mac OS for research and educational purposes.

## Project Overview

This repository contains a leaked and reconstructed version of the Macintosh System 7.1 source code. It includes the core operating system, device drivers, and build tools necessary to compile a bootable system image for m68k Macintosh computers.

**Primary Goal:** Enable cross-compilation of System 7.1 on modern Linux systems.

## Key Features

-   **Cross-Compilation:** Build classic Mac software on Linux using `empw`.
-   **Core OS:** Source code for Memory Manager, Process Manager, HFS, and more.
-   **Hardware Support:** Drivers for Macintosh SE/30, IIci, and other m68k machines.
-   **Reconstruction:** Includes stubs and patches (e.g., `MiniFinder`) to replace missing proprietary components.

## Documentation Sections

-   [**Getting Started**](getting-started.md): Setup your environment and build the system.
-   [**Architecture**](architecture.md): High-level overview of the system design.
-   [**Modules**](modules/index.md): Detailed documentation of subsystems (OS, Drivers, etc.).
-   [**Configuration**](configuration.md): Understanding the build system and `.make` files.
-   [**Development Guide**](development-guide.md): How to contribute and debug.
-   [**Data Models**](data-models.md): Key data structures and schemas.
-   [**Troubleshooting**](troubleshooting.md): Common issues and solutions.
-   [**Deployment**](deployment.md): How to deploy the built system.

## Quick Links

-   [Repository Root](../)
-   [GitHub Issues](https://github.com/your-repo/issues)

---
*Disclaimer: This documentation is generated based on the analysis of the source code. Some sections may reflect the incomplete nature of the repository.*
