import re
import sys

def fix(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    lines = content.splitlines()
    new_lines = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            new_lines.append(line)
            continue

        if stripped.startswith('.L') and not stripped.endswith(':') and ' ' not in stripped:
             line = stripped + ':'

        if stripped == '=' or stripped == '0' or stripped == 'main':
            line = "/* " + line + " */"

        new_lines.append(line)

    return "\n".join(new_lines)

if __name__ == '__main__':
    print(fix(sys.argv[1]))
