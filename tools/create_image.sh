#!/bin/bash
set -e

echo "Creating boot.img..."

KERNEL_BIN="kernel.bin"
IMG="boot.img"

if [ ! -f "$KERNEL_BIN" ]; then
    echo "Error: $KERNEL_BIN not found. Run make first."
    exit 1
fi

# 1. Create a blank 1.44MB floppy image
dd if=/dev/zero of=$IMG bs=1024 count=1440 2>/dev/null

# 2. Format as HFS (Mac ROM expects HFS volume to check for boot blocks)
# We use 'NewOS' as the volume name.
hformat -l "NewOS" $IMG > /dev/null

# 3. Install Boot Blocks
# The Mac ROM looks at the first 1024 bytes (Boot Blocks) of the disk.
# Even if HFS is present, the boot blocks are in sectors 0 and 1.
# `hformat` writes a standard boot block. We need to OVERWRITE it with our kernel code.
#
# IMPORTANT: The HFS volume header (MDB) is at sector 2 (offset 1024).
# We MUST NOT overwrite sector 2.
# Our kernel.bin must be <= 1024 bytes for this method.
# If it is larger, we would need to write it to a file and have the boot block load it.
# For MVP (360 bytes), we just overwrite the boot blocks.

KERNEL_SIZE=$(stat -c%s "$KERNEL_BIN")
if [ "$KERNEL_SIZE" -gt 1024 ]; then
    echo "Error: Kernel size ($KERNEL_SIZE bytes) exceeds Boot Block limit (1024 bytes)."
    echo "This MVP requires the kernel to fit in the boot blocks."
    exit 1
fi

# Write our kernel over the first 1024 bytes (preserving the rest of the disk)
dd if=$KERNEL_BIN of=$IMG conv=notrunc bs=1024 count=1 2>/dev/null

echo "Done. $IMG is ready (HFS formatted with custom Boot Blocks)."
