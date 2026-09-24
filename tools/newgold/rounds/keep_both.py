#!/usr/bin/env python3
"""keep_both.py [--fn] FILE...: resolve every conflict block in the given files
as ours, then theirs.

--fn: the two blocks are two new functions whose closing brace the files
share, so one "}" and a blank line go between them.
"""
import re
import sys
from pathlib import Path

args = sys.argv[1:]
join = ""
if args and args[0] == "--fn":
    join, args = "}\n\n", args[1:]
if not args:
    sys.exit(__doc__)
for name in args:
    p = Path(name)
    t, n = re.subn(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", lambda m: m.group(1) + join + m.group(2), p.read_text(), flags=re.S)
    p.write_text(t)
    print(f"{name}: {n} blocks")
