#!/usr/bin/env python3
"""Was every commit picked whole? For each 'OLD -> NEW subject' line of a
round's map.txt, the two commits' patches compared file by file, as
multisets of added and removed lines, and their messages.

    cmp_pairs.py MAP.txt      (in the repository that has both commits)

'same' is a commit carried over unchanged; 'DIFF' lists what only the
original or only the pick has -- a renumbering the shift made, a conflict
resolved -- to be read against the integrator's account.
"""
import collections
import re
import subprocess
import sys


def git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True, errors="replace").stdout


def patch(commit):
    files, current = collections.defaultdict(collections.Counter), None
    for line in git("show", "--format=", "--no-renames", "-U0", commit).splitlines():
        if line.startswith("diff --git"):
            current = line.split(" b/", 1)[1]
            files[current]
        elif line.startswith(("+++", "---", "@@", "index ", "new file", "deleted file", "Binary")):
            if line.startswith("Binary"):
                files[current]["BINARY " + line] += 1
        elif line.startswith(("+", "-")) and current:
            files[current][line] += 1
    return files


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    pairs = [m.groups() for line in open(sys.argv[1])
             for m in [re.match(r"([0-9a-f]{7,40}) -> ([0-9a-f]{7,40}) ", line)] if m]
    print(len(pairs), "pairs")
    for old, new in pairs:
        a, b = patch(old), patch(new)
        diffs = []
        if git("log", "-1", "--format=%B", old).strip() != git("log", "-1", "--format=%B", new).strip():
            diffs.append("  MESSAGE differs")
        empty = collections.Counter()
        for f in sorted(set(a) | set(b)):
            if a.get(f) != b.get(f):
                diffs.append(f"  {f}: {'(file only in orig)' if f not in b else ''}{'(file only in picked)' if f not in a else ''}")
                diffs += [f"     orig  {k[:160]}" for k in list(a.get(f, empty) - b.get(f, empty))[:12]]
                diffs += [f"     pick  {k[:160]}" for k in list(b.get(f, empty) - a.get(f, empty))[:12]]
        print(("DIFF " if diffs else "same ") + f"{old} -> {new} " + git("log", "-1", "--format=%s", new).strip())
        for d in diffs:
            print(d)


if __name__ == "__main__":
    main()
