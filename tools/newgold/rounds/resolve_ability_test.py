#!/usr/bin/env python3
"""Resolve tests/newgold/test_ability_effects.py during a cherry-pick.

PENDING becomes HEAD's set less what the picked commit took out of its own
parent's, STILL_TO_DO its size; every other conflict block keeps both sides,
ours first. Run in the worktree, after the conflict.
"""
import re
import subprocess
from pathlib import Path

PATH = "tests/newgold/test_ability_effects.py"


def show(rev):
    return subprocess.run(["git", "show", f"{rev}:{PATH}"], capture_output=True, text=True, check=True).stdout


def pending(text):
    body = re.search(r"^PENDING = (?:set\(\)|\{(.*?)^\})", text, re.S | re.M).group(1) or ""
    return set(re.findall(r'"([A-Z0-9_]+)"', body))


gitdir = subprocess.run(["git", "rev-parse", "--git-dir"], capture_output=True, text=True, check=True).stdout.strip()
commit = Path(gitdir, "CHERRY_PICK_HEAD").read_text().strip()
taken = pending(show(f"{commit}^")) - pending(show(commit))
added = pending(show(commit)) - pending(show(f"{commit}^"))
left = (pending(show("HEAD")) - taken) | added

text = Path(PATH).read_text()


def keep_both(m):
    ours, theirs = m.group(1), m.group(2)
    if "STILL_TO_DO =" in ours or "STILL_TO_DO =" in theirs:
        lines = [l for l in ours.splitlines(True) if "STILL_TO_DO =" not in l]
        lines += [l for l in theirs.splitlines(True) if "STILL_TO_DO =" not in l and l not in lines]
        return "".join(lines) + "    STILL_TO_DO = 0\n"
    return ours + theirs


text = re.sub(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", keep_both, text, flags=re.S)
names = sorted(left)
rows, row = [], "   "
for name in names:
    piece = f' "{name}",'
    if len(row) + len(piece) > 80:
        rows.append(row)
        row = "   "
    row += piece
rows.append(row.rstrip(","))
# an empty one is set(): {} is a dict
written = "PENDING = {\n" + "\n".join(rows) + "\n}" if names else "PENDING = set()"
text = re.sub(r"^PENDING = (?:set\(\)|\{.*?^\})", lambda m: written, text, count=1, flags=re.S | re.M)
text = re.sub(r"^(    STILL_TO_DO = )\d+", lambda m: f"{m.group(1)}{len(left)}", text, count=1, flags=re.M)
Path(PATH).write_text(text)
print(f"took {sorted(taken)}; {len(left)} pending")
