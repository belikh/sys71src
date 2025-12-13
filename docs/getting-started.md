# Getting Started

This guide will help you set up your development environment to cross-compile Macintosh System 7.1 on Linux.

## Prerequisites

Before you begin, ensure you have the following installed on your Linux machine (e.g., Ubuntu/Debian):

*   **Bash:** The shell used for build scripts.
*   **Git:** Version control.
*   **Wget & Unrar:** For downloading and extracting reference binaries.
*   **HFSUtils:** For manipulating HFS disk images.
*   **Build Essentials:** `make`, `gcc` (standard Linux build tools).

### Installation (Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install git wget unrar hfsutils build-essential
```

## Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone <repository-url> system7-source
cd system7-source
```

### 2. Install `empw`

The build system relies on `empw` (Emulated MPW) to run the original Macintosh Programmer's Workshop tools.

1.  Download or build `empw` from [ksherlock/mpw](https://github.com/ksherlock/mpw).
2.  Ensure the `empw` binary is in your system `$PATH`.

```bash
empw --version
# Should output version information
```

### 3. Setup MPW Tools

You need to populate the `MPW/` directory in the root of this repository with the MPW Shell and Tools. These are proprietary files and are not included in this repository.

*   Create a directory named `MPW` in the repo root.
*   Copy your MPW environment (Shell, Tools, Libraries) into it.

### 4. Run the Setup Script

The `cross_compile.sh` script automates the remaining setup:

*   Checks for MPW tools.
*   Downloads and extracts reference binaries (System, Finder).
*   Creates the build wrapper `build_system7.sh`.
*   Patches the Makefiles to include necessary stubs.

```bash
./cross_compile.sh
```

**Note:** If you are missing the `MPW/` directory, the script will warn you.

### 5. Build the System

Once setup is complete, use the generated wrapper script to start the build:

```bash
./build_system7.sh
```

This will:
1.  Launch `empw`.
2.  Execute the build instructions in `Make/Universal.make` (or `Make/MainCode.Make`).
3.  Output artifacts to the `Build/` directory.

## "Hello World" Example

To verify your environment, you can look at the `Internal/C/MiniFinder.c`. This is a minimal application that replaces the Finder.

If the build succeeds, you should see an object file or binary corresponding to this stub in the build output.

```bash
ls -l Build/
```
