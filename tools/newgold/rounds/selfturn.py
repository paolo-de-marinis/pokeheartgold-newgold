#!/usr/bin/env python3
"""Resolve a SelfTurnData conflict in include/battle/battle.h where both
sides took bits of unk0_11: keep both sides' fields, ours first, and give
unk0_11 ours less what the picked commit took from its own parent's."""
import re, subprocess
from pathlib import Path
PATH = "include/battle/battle.h"
gitdir = subprocess.run(["git", "rev-parse", "--git-dir"], capture_output=True, text=True, check=True).stdout.strip()
commit = Path(gitdir, "CHERRY_PICK_HEAD").read_text().strip()
show = lambda rev: subprocess.run(["git", "show", f"{rev}:{PATH}"], capture_output=True, text=True, check=True).stdout
UNK = r"u32 unk0_11 : (\d+);"
taken = int(re.search(UNK, show(f"{commit}^")).group(1)) - int(re.search(UNK, show(commit)).group(1))
def fix(m):
    ours, theirs = m.group(1), m.group(2)
    if not (re.search(UNK, ours) and re.search(UNK, theirs)):
        return m.group(0)
    n = int(re.search(UNK, ours).group(1)) - taken
    keep = lambda s: "".join(l for l in s.splitlines(True) if not re.search(UNK, l))
    return keep(ours) + keep(theirs) + f"    u32 unk0_11 : {n};\n"
p = Path(PATH)
t = re.sub(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", fix, p.read_text(), flags=re.S)
p.write_text(t)
print("unk0_11 less", taken, "->", re.search(UNK, t).group(1), "; conflicts left:", t.count("<<<<<<<"))
