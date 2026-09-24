#!/usr/bin/env python3
"""Resolve the BattleContextSizeCheck conflict in battle_controller_player.c.

The size becomes ours plus what the picked commit added to its own parent's,
and the comment gains the picked commit's new clause. Compile to confirm.
"""
import re
import subprocess
import textwrap
from pathlib import Path

PATH = "src/battle/battle_controller_player.c"
SIZE = r"sizeof\(BattleContext\) == (0x[0-9A-F]+) \+"
gitdir = subprocess.run(["git", "rev-parse", "--git-dir"], capture_output=True, text=True, check=True).stdout.strip()
commit = Path(gitdir, "CHERRY_PICK_HEAD").read_text().strip()


def show(rev):
    return subprocess.run(["git", "show", f"{rev}:{PATH}"], capture_output=True, text=True, check=True).stdout


def words(block):
    return " ".join(l.strip()[2:].strip() for l in block.splitlines() if l.strip().startswith("//")).split()


def comment_before_check(text):
    lines = text[:text.index("typedef char BattleContextSizeCheck[")].splitlines()
    out = []
    for l in reversed(lines):
        if not l.startswith("//"):
            break
        out.append(l)
    return "\n".join(reversed(out))


parent, picked = show(f"{commit}^"), show(commit)
delta = int(re.search(SIZE, picked).group(1), 16) - int(re.search(SIZE, parent).group(1), 16)
pw, tw = words(comment_before_check(parent)), words(comment_before_check(picked))
import difflib
key = lambda ws: [w.rstrip(".,;") for w in ws]
ops = difflib.SequenceMatcher(None, key(pw), key(tw)).get_opcodes()
added = " ".join(" ".join(tw[j1:j2]) for op, i1, i2, j1, j2 in ops if op in ("insert", "replace"))

t = Path(PATH).read_text()
m = re.search(r"<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n", t, flags=re.S)
ours = m.group(1)
ours_size = int(re.search(SIZE, ours).group(1), 16)
comment_lines = [l for l in ours.splitlines() if l.startswith("//")]
code = ours[ours.index("typedef char BattleContextSizeCheck["):]
# the conflict starts mid-comment: rewrap the ours part of it with the new clause
text = " ".join(l[2:].strip() for l in comment_lines).rstrip(".") + " " + added
wrapped = textwrap.wrap(text, 76)
new = "".join(f"// {l}\n" for l in wrapped) + code.replace(f"0x{ours_size:X} +", f"0x{ours_size + delta:X} +")
Path(PATH).write_text(t[:m.start()] + new + t[m.end():])
print(f"size 0x{ours_size:X} + {delta} = 0x{ours_size + delta:X}; added: {added}")
