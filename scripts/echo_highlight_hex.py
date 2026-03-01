import re
import sys


# ANSI escape for 24-bit truecolor
def colorize_hex(hexcode):
    r = int(hexcode[1:3], 16)
    g = int(hexcode[3:5], 16)
    b = int(hexcode[5:7], 16)
    return f"\033[38;2;{r};{g};{b}m{hexcode}\033[0m"


# Read input file
if len(sys.argv) != 2:
    print("Usage: python3 highlight_hex.py <file>")
    sys.exit(1)

filename = sys.argv[1]

# Regex to find hex codes like #ff5733
hex_pattern = re.compile(r"#(?:[0-9a-fA-F]{6})")

with open(filename, "r", encoding="utf-8") as f:
    for line in f:
        # Replace each hex with colorized version
        colored_line = hex_pattern.sub(lambda match: colorize_hex(match.group(0)), line)
        print(colored_line, end="")
