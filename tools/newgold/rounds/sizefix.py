#!/usr/bin/env python3
"""Resolve the BattleContextSizeCheck conflict as ours plus SENTENCE, with the
size measured by probe_size.py. usage: sizefix.py "SENTENCE" (after env.sh)"""
import re
import subprocess
import sys
import textwrap
from pathlib import Path

PATH = Path("src/battle/battle_controller_player.c")
t = PATH.read_text()
m = re.search(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", t, flags=re.S)
if m:
    t = t[:m.start()] + m.group(1) + t[m.end():]
head, tail = t.split("typedef char BattleContextSizeCheck[", 1)
lines = head.rstrip("\n").split("\n")
last = lines.pop()
assert last.startswith("// ")
if len(sys.argv) > 1 and sys.argv[1]:
    lines += ["// " + l for l in textwrap.wrap(last[3:] + " " + sys.argv[1], 76)]
else:
    lines.append(last)
PATH.write_text("\n".join(lines) + "\ntypedef char BattleContextSizeCheck[" + tail)
size = subprocess.run([sys.executable, str(Path(__file__).with_name("probe_size.py"))], capture_output=True, text=True, check=True).stdout.strip()
t = PATH.read_text()
t = re.sub(r"(sizeof\(BattleContext\) == )0x[0-9A-F]+ \+", lambda mm: f"{mm.group(1)}{size} +", t, count=1)
PATH.write_text(t)
print(size)
