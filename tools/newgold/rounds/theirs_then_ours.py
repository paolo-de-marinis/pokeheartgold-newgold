#!/usr/bin/env python3
"""theirs_then_ours.py FILE: resolve every conflict block in FILE as theirs,
then the lines only ours has (a comment both sides extended at the same place)."""
import re, sys
from pathlib import Path
if len(sys.argv) != 2:
    sys.exit(__doc__)
p = Path(sys.argv[1])
def fix(m):
    ours, theirs = m.group(1).splitlines(True), m.group(2).splitlines(True)
    return "".join(theirs + [l for l in ours if l not in theirs])
t, n = re.subn(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", fix, p.read_text(), flags=re.S)
p.write_text(t)
print(f"{p}: {n} blocks")
