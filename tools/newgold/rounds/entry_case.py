#!/usr/bin/env python3
"""Resolve a conflict where both sides added switch-in steps before 'end'.

Ours ends with 'case N: // end'; theirs adds its steps and its own end. Theirs'
steps are renumbered from N on, and end follows them.
"""
import re
from pathlib import Path

p = Path("src/battle/overlay_12_0224E4FC.c")
t = p.read_text()


def fix(m):
    ours, theirs = m.group(1), m.group(2)
    end = re.fullmatch(r"\s*case (\d+): // end\n", ours)
    if not end:
        return m.group(0)
    n = int(end.group(1))
    cases = re.findall(r"^        case (\d+): //", theirs, re.M)
    first = int(cases[0])
    return re.sub(r"^(        case )(\d+)(: //)", lambda c: f"{c.group(1)}{int(c.group(2)) - first + n}{c.group(3)}", theirs, flags=re.M)


t2 = re.sub(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", fix, t, flags=re.S)
p.write_text(t2)
print(re.findall(r"^        case \d+: // .*$", t2, re.M)[-6:])
