#!/bin/bash

# analyze_binaries.sh
# Analyzes the extracted System 7.1 binaries.

EXTRACTED_DIR="Binaries/Extracted"
SYSTEM_BIN="$EXTRACTED_DIR/System"
FINDER_BIN="$EXTRACTED_DIR/Finder"
GONATIVE_OBJ="Misc/GoNativeROMLib.o"

echo "================================================================"
echo "BINARY ANALYSIS REPORT"
echo "================================================================"

if [ -f "$SYSTEM_BIN" ]; then
    echo "[*] System Binary Found: $SYSTEM_BIN"
    echo "Size: $(ls -lh $SYSTEM_BIN | awk '{print $5}')"
    echo "Strings Check (Top 10):"
    strings "$SYSTEM_BIN" | head -n 10
    echo "..."
    echo "Hex Dump (Header):"
    od -t x1 "$SYSTEM_BIN" | head -n 4
else
    echo "System binary not found."
fi

echo ""

if [ -f "$FINDER_BIN" ]; then
    echo "[*] Finder Binary Found: $FINDER_BIN"
    echo "Size: $(ls -lh $FINDER_BIN | awk '{print $5}')"
    echo "Strings Check (Top 10):"
    strings "$FINDER_BIN" | head -n 10
    echo "..."
    echo "Hex Dump (Header):"
    od -t x1 "$FINDER_BIN" | head -n 4
else
    echo "Finder binary not found."
fi

echo ""

if [ -f "$GONATIVE_OBJ" ]; then
    echo "[*] GoNativeROMLib.o (Repo Artifact):"
    echo "Size: $(ls -lh $GONATIVE_OBJ | awk '{print $5}')"
    strings "$GONATIVE_OBJ" | head -n 5
fi

echo "================================================================"
