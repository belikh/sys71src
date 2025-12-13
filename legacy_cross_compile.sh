#!/bin/bash

# cross_compile.sh
# Script to setup and run a cross-compilation environment for Macintosh System 7.1 on Linux.

# 1. Define Paths
SRC_ROOT=$(pwd)
BUILD_DIR="$SRC_ROOT/Build"
MPW_ROOT="$SRC_ROOT/MPW"
GENERATED_BUILD_SCRIPT="$SRC_ROOT/build_system7.sh"
BINARIES_DIR="$SRC_ROOT/Binaries"

# 2. Check for MPW Tools
echo "Checking for MPW tools..."
if [ ! -d "$MPW_ROOT" ]; then
    echo "Warning: MPW directory not found at $MPW_ROOT"
    echo "You must copy the MPW Shell and Tools into a 'MPW' directory in the root of this repo."
fi

# 3. Download Reference Binaries (Optional but recommended)
echo "Checking for Reference Binaries..."
if [ ! -d "$BINARIES_DIR/Extracted" ]; then
    echo "Downloading System 7.1 binaries (approx 5MB)..."
    mkdir -p "$BINARIES_DIR"

    # Using Internet Archive link for System 7.1.2 (closest available direct link)
    wget -q -O "$BINARIES_DIR/disks.rar" "https://archive.org/download/disks_202111/disks.rar"

    if command -v unrar &> /dev/null; then
        echo "Extracting..."
        unrar x -o+ "$BINARIES_DIR/disks.rar" "$BINARIES_DIR/" > /dev/null

        # Extract System and Finder if hfsutils available
        if command -v hmount &> /dev/null; then
            mkdir -p "$BINARIES_DIR/Extracted"
            echo "Mounting Disk Tools image..."
            # Note: Path depends on extraction. Trying common known name.
            IMG_PATH=$(find "$BINARIES_DIR" -name "*DiskTools*.IMA" -o -name "*Disk Tools*.image" | head -n 1)
            if [ -n "$IMG_PATH" ]; then
                hmount "$IMG_PATH"
                hcopy ":System Folder:Finder" "$BINARIES_DIR/Extracted/Finder"
                hcopy ":System Folder:System" "$BINARIES_DIR/Extracted/System"
                humount
                echo "Extracted 'Finder' and 'System' to Binaries/Extracted/"
            else
                echo "Disk Tools image not found in extracted files."
            fi
        else
            echo "hfsutils not found. Skipping file extraction from disk images."
            echo "Install hfsutils (sudo apt-get install hfsutils) to extract Finder/System."
        fi
    else
        echo "unrar not found. Skipping download extraction."
        echo "Install unrar (sudo apt-get install unrar) to get reference binaries."
    fi
else
    echo "Binaries already present in $BINARIES_DIR/Extracted"
fi

# 4. Create the Build Wrapper Script
echo "Creating build wrapper script: $GENERATED_BUILD_SCRIPT"

cat <<EOF > "$GENERATED_BUILD_SCRIPT"
#!/bin/bash
# Wrapper to run MPW commands via empw

if ! command -v empw &> /dev/null; then
    echo "Error: 'empw' is not in your PATH."
    echo "Please install it from https://github.com/ksherlock/mpw"
    exit 1
fi

export MPW="$MPW_ROOT"
export KS_MPW="$MPW_ROOT"

echo "Starting Build in MPW..."
empw -c "Directory '$SRC_ROOT'"
empw -c "Set BuildResults '$BUILD_DIR'"
empw -c "Build -f Make/Universal.make"
EOF

chmod +x "$GENERATED_BUILD_SCRIPT"

# 5. Integrate Missing Pieces (Stubs)
echo "Checking for Missing Pieces Stubs..."
# Ensure target directories exist
mkdir -p Internal/C Internal/Asm

# Verify files exist
STUBS=("Internal/C/MiniFinder.c" "Internal/C/VirtualMemoryStub.c" "Internal/Asm/Emulator68kStub.a")
for stub in "${STUBS[@]}"; do
    if [ ! -f "$stub" ]; then
        echo "Error: $stub missing."
    else
        echo "Verified: $stub"
    fi
done

# 6. Patch the Makefile
./patch_makefile.sh

echo "================================================================"
echo "Setup Complete."
echo ""
echo "NEXT STEPS:"
echo "1. Install 'empw' and MPW binaries."
echo "2. Review 'Make/MainCode.Make' and finalize the link list as instructed."
echo "3. Run './build_system7.sh' to start the build."
echo "================================================================"

exit 0
