#!/usr/bin/env python3
"""stage_hunks.py FILE PATTERN...: stage only the hunks of FILE's diff that
contain one of the PATTERNs (substring match on the hunk text)."""
import subprocess, sys
if len(sys.argv) < 3:
    sys.exit(__doc__)
path, patterns = sys.argv[1], sys.argv[2:]
diff = subprocess.run(["git", "diff", "-U3", "--", path], capture_output=True, text=True, check=True).stdout
lines = diff.splitlines(keepends=True)
head, hunks, cur = [], [], None
for line in lines:
    if line.startswith("@@"):
        cur = [line]; hunks.append(cur)
    elif cur is None:
        head.append(line)
    else:
        cur.append(line)
chosen = [h for h in hunks if any(p in "".join(h) for p in patterns)]
if not chosen:
    sys.exit("no hunk matched")
patch = "".join(head) + "".join("".join(h) for h in chosen)
subprocess.run(["git", "apply", "--cached", "--recount", "-"], input=patch, text=True, check=True)
print(f"staged {len(chosen)} of {len(hunks)} hunks")
