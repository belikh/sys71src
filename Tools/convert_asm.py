import re
import sys

def convert(filepath):
    try:
        with open(filepath, 'rb') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"File not found: {filepath}")
        return ""

    try:
        lines = content.decode('mac_roman').splitlines()
    except UnicodeDecodeError:
        print(f"Error decoding {filepath}")
        return ""

    converted_lines = []
    converted_lines.append('#include "StartMgrDefs.h"')

    for line in lines:
        if ';' in line:
            parts = line.split(';', 1)
            code = parts[0]
            comment = "/* " + parts[1].strip() + " */"
        else:
            code = line
            comment = ""

        stripped_code = code.strip()
        if not stripped_code:
            converted_lines.append(comment)
            continue

        if 'include' in stripped_code.lower() or 'load' in stripped_code.lower():
            continue

        replacements = {
            'dc.w': '.short',
            'dc.b': '.byte',
            'dc.l': '.long',
            'ds.b': '.space',
            'ds.w': '.space 2*',
            'ds.l': '.space 4*',
            'equ': '=',
            'bnz.s': 'bne',
            'bz.s': 'beq',
            'bnz': 'bne',
            'bz': 'beq',
            'bra.s': 'bra',
            'bsr.s': 'bsr',
            'bra.w': 'bra',
            'bsr.w': 'bsr',
            'jeq': 'jeq',
            'jne': 'jne'
        }

        new_line = code
        for mpw, gas in replacements.items():
            new_line = re.sub(r'\b' + re.escape(mpw) + r'\b', gas, new_line, flags=re.IGNORECASE)

        new_line = re.sub(r'\b(d[0-7])\b', r'%\1', new_line, flags=re.IGNORECASE)
        new_line = re.sub(r'\b(a[0-7])\b', r'%\1', new_line, flags=re.IGNORECASE)
        new_line = re.sub(r'\b(sp)\b', r'%sp', new_line, flags=re.IGNORECASE)
        new_line = re.sub(r'\b(pc)\b', r'%pc', new_line, flags=re.IGNORECASE)

        new_line = new_line.replace('@', '.L')

        if line and line[0] not in [' ', '\t', ';']:
             match = re.match(r'^([A-Za-z0-9_@.]+)', line)
             if match:
                 label = match.group(1)
                 if label.lower() not in ['main', 'proc', 'endp', 'end', 'bootblocks']:
                     if not label.endswith(':'):
                         new_line = new_line.replace(label, label + ':', 1)

        # Handle BootCode MAIN or BootBlocks main
        if 'MAIN' in line or 'main' in line:
             if 'BootBlocks' in new_line: new_line = 'BootBlocks:'
             if 'StartSystem' in new_line: new_line = 'StartSystem:'
             if 'BootCode' in new_line: new_line = 'BootCode:'

        if 'PROC' in new_line or 'ENDP' in new_line or 'END' == stripped_code.upper():
            new_line = ""

        # Struct/Const replacements (Boot2/3 specifics)
        for term in ["BootGlobals.initialSP", "BootGlobals.paramBlock", "BootGlobals.quickDrawGlobals",
                     "BootGlobals.initialA5", "BootGlobals.physicalMemTop", "BootGlobals.logicalMemTop",
                     "BootGlobals.postBootNewPtrStartup", "BootGlobals.bufPtrLimit", "BootGlobals.resetFlag",
                     "BootGlobals.reservedForAfterBoot", "BootGlobals.port", "BootGlobals.fileName",
                     "BootGlobals.lowestBufPtr", "BootGlobals.fileBuffer", "BootGlobals.bootBlocks",
                     "BootGlobals.initialA6", "BootGlobals.size"]:
            new_line = new_line.replace(term, term.replace('.', '_'))

        # Hex
        new_line = re.sub(r'#$([0-9A-Fa-f]+)', r'#0x\1', new_line)

        converted_lines.append(new_line + " " + comment)

    # Post-processing for logic fixes
    final_lines = []
    skip = False
    inserted_logic = False

    for line in converted_lines:
        # Boot2 logic fix
        if '_GetHandleSize' in line and not inserted_logic and 'Boot2' in filepath:
            final_lines.append('.word 0xA025 /* _GetHandleSize */')
            # Insert correct relocation logic
            final_lines.append('\t\tlea StartSystem(%pc),%a1')
            final_lines.append('\t\tlea .Lcontinue(%pc),%a0')
            final_lines.append('\t\tsub.l %a1,%a0')
            final_lines.append('\t\tsub.l %a0,%d0')
            final_lines.append('\t\tsub.l %d0,%sp')
            final_lines.append('\t\tmove.l %sp,%a1')
            final_lines.append('\t\tlea .Lcontinue(%pc),%a0')
            final_lines.append('\t\t.word 0xA02E /* _BlockMove */')
            final_lines.append('\t\tjmp (%a1)')
            final_lines.append('.Lcontinue:')
            final_lines.append('\t\t.word 0xA9A3 /* _ReleaseResource */')
            skip = True
            inserted_logic = True
            continue

        if skip:
            if 'ROMBase' in line:
                skip = False
                final_lines.append(line)
        else:
            # Traps - replace if standalone word
            # Just do simple text replacement for now, or regex
            # _Trap -> .word _Trap
            # But avoid replacing within comments or defines
            # This is hard to do perfectly in this script.
            # I will trust my previous approach of using StartMgrDefs.h macros if I use them.
            # But the script outputs the original text if not replaced.
            # _GetHandleSize -> 0xA025 (done above?) No, I removed that logic to simplify.
            # I'll rely on the assembler to handle macros if I used .
            # But the input has .
            # GAS treats  as a symbol.
            # If  is defined as  in header, then  works.
            # But the source has just .
            # So I need to prepend .

            match = re.search(r'^\s*(_[A-Za-z0-9]+)', line)
            if match:
                trap = match.group(1)
                # Check if it's a known trap
                # Just assume underscore means trap for now in this file
                line = line.replace(trap, f'.word {trap}')

            line = line.replace("'boot'", "0x626F6F74")
            final_lines.append(line)

    return "\n".join(final_lines)

if __name__ == '__main__':
    print(convert(sys.argv[1]))
