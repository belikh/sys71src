#!/bin/bash

# patch_makefile.sh
# Automates the integration of Missing Pieces into the Build System.

MAKEFILE="Make/MainCode.Make"

if [ ! -f "$MAKEFILE" ]; then
    echo "Error: $MAKEFILE not found."
    exit 1
fi

if grep -q "MiniFinder.c.o" "$MAKEFILE"; then
    echo "Makefile already patched."
    exit 0
fi

echo "Patching $MAKEFILE..."

# Append instructions
cat <<EOF >> "$MAKEFILE"

# --- PATCHED BY AUTOMATED SCRIPT ---
# The following objects satisfy the missing components.
# Add these to your Link command or MainCodeLibs variable.
# "{ObjDir}MiniFinder.c.o"
# "{ObjDir}VirtualMemoryStub.c.o"
# "{ObjDir}Emulator68kStub.a.o"
# -----------------------------------
EOF

echo "Appended integration instructions to $MAKEFILE."
exit 0
