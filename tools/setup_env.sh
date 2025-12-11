#!/bin/bash
set -e

# Update package list
sudo apt-get update

# Install m68k cross-compiler (Linux target is close enough for bare metal if we use -nostdlib)
sudo apt-get install -y gcc-m68k-linux-gnu binutils-m68k-linux-gnu make

# Install HFS utilities for disk image manipulation
sudo apt-get install -y hfsutils hfsplus

# Install hex editor for debugging (optional)
# sudo apt-get install -y hexedit

echo "Environment setup complete."
