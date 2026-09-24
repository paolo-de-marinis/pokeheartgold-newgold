#!/usr/bin/env python3
"""Measure sizeof(BattleContext) less the added moves and the script buffer,
as BattleContextSizeCheck writes it, by compiling candidates with mwcc.

usage: probe_size.py [NEWGOLD_DIAG]   (run in the worktree, after env.sh)
PROBE_INCLUDE=dir puts dir first on the include path (another battle.h).
Prints the size in hex. Every candidate but the true one fails to compile.
"""
import os
import re
import subprocess
import sys
from pathlib import Path

lines = ['#include "global.h"', '#include "battle/battle_controller_player.h"', '#include "constants/moves.h"']
# 64 candidates around the size the check has now: one error each, and mwcc
# gives up after too many.
now = re.search(r"sizeof\(BattleContext\) == (0x[0-9A-F]+) \+", Path("src/battle/battle_controller_player.c").read_text())
centre = int(now.group(1), 16) if now else 0x3280
cands = range(centre - 0x80, centre + 0x80, 4)
for n in cands:
    lines.append(f"typedef char probe_{n:X}[sizeof(BattleContext) == 0x{n:X} + NUM_ADDED_MOVES * sizeof(MoveTbl) + BATTLE_SCRIPT_BUFFER_WORDS * 4 ? 1 : -1];")
src = Path("build/probe_size.c")
src.parent.mkdir(exist_ok=True)
src.write_text("\n".join(lines) + "\n")
defs = "-DHEARTGOLD -DGAME_REMASTER=0 -DENGLISH -DPM_KEEP_ASSERTS -DSDK_ARM9 -DSDK_CODE_ARM -DSDK_FINALROM".split()
if len(sys.argv) > 1:
    defs.append("-DNEWGOLD_DIAG")
cmd = ["wine", "tools/mwccarm/2.0/sp2p2/mwccarm.exe", *defs, "-O4,p", "-enum", "int", "-lang", "c99", "-Cpp_exceptions", "off",
       "-gccext,on", "-proc", "arm946e", "-msgstyle", "gcc", "-gccinc", *([] if not os.environ.get("PROBE_INCLUDE") else ["-i", os.environ["PROBE_INCLUDE"]]), "-i", "./src", "-i", "./include", "-i", "./include/library",
       "-i", "./files", "-I./lib/include", "-interworking", "-char", "signed", "-c", "-o", "build/probe_size.o", str(src)]
out = subprocess.run(cmd, capture_output=True, text=True, env=None)
text = out.stdout + out.stderr
failed = {int(m) for m in re.findall(r"probe_size\.c:(\d+): illegal constant expression", text)}
ok = [n for i, n in enumerate(cands) if i + 4 not in failed]
src.unlink()
if len(ok) != 1 or len(failed) != len(cands) - 1:
    sys.exit(f"probe failed ({len(ok)} candidates left):\n" + text[-2000:])
print(f"0x{ok[0]:X}")
