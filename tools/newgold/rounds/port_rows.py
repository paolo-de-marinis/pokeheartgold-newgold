#!/usr/bin/env python3
"""Resolve the FIRST_PORT_ROW + N conflict in test_battle_messages.py: ours
plus what the picked commit added to its parent's; other blocks keep both."""
import re
import subprocess
from pathlib import Path

PATH = "tests/newgold/test_battle_messages.py"
N = r"FIRST_PORT_ROW \+ (\d+)\)"
gitdir = subprocess.run(["git", "rev-parse", "--git-dir"], capture_output=True, text=True, check=True).stdout.strip()
commit = Path(gitdir, "CHERRY_PICK_HEAD").read_text().strip()
show = lambda rev: subprocess.run(["git", "show", f"{rev}:{PATH}"], capture_output=True, text=True, check=True).stdout
delta = int(re.search(N, show(commit)).group(1)) - int(re.search(N, show(f"{commit}^")).group(1))


def fix(m):
    ours, theirs = m.group(1), m.group(2)
    if re.search(N, ours) and re.search(N, theirs):
        return re.sub(N, lambda n: f"FIRST_PORT_ROW + {int(n.group(1)) + delta})", ours)
    return ours + theirs


p = Path(PATH)
p.write_text(re.sub(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", fix, p.read_text(), flags=re.S))
print(f"port rows +{delta}")
