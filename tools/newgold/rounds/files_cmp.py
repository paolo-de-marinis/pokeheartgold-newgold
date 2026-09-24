#!/usr/bin/env python3
"""Did every file a round's branches touched come through? File by file.

    files_cmp.py [--since REV] BASE TIP BRANCH...     (in the repository)

For each file any BRANCH changed since BASE: touched by one branch, whether
TIP holds that branch's version ('same' or 'DIFFERS'); touched by several,
the lines each branch added that TIP does not have. Files TIP changed that
no branch did are listed first. --since REV marks the files the integration
itself changed after REV (the closing tests commit, the fixes): those differ
from a branch on purpose, and are listed even when the same.
"""
import collections
import subprocess
import sys


def git(*args):
    return subprocess.run(["git", *args], capture_output=True, text=True, errors="replace").stdout


def show(rev, path):
    p = subprocess.run(["git", "show", f"{rev}:{path}"], capture_output=True)
    return p.stdout if p.returncode == 0 else None


def main():
    args, since = sys.argv[1:], None
    if args[:1] == ["--since"]:
        since, args = args[1], args[2:]
    if len(args) < 3:
        sys.exit(__doc__)
    base, tip, branches = args[0], args[1], args[2:]
    touch = collections.defaultdict(list)
    for b in branches:
        for f in git("diff", "--name-only", "--no-renames", base, b).split():
            touch[f].append(b)
    integ = set(git("diff", "--name-only", "--no-renames", since, tip).split()) if since else set()
    tipfiles = set(git("diff", "--name-only", "--no-renames", base, tip).split())
    print("files touched by branches:", len(touch), f" files changed {base}..{tip}:", len(tipfiles))
    print("changed in the tip but by no branch:", sorted(tipfiles - set(touch)))
    for f, bs in sorted(touch.items()):
        mark = " (integration-touched)" if f in integ else ""
        at_tip = show(tip, f)
        if len(bs) == 1:
            same = at_tip == show(bs[0], f)
            if not same or f in integ:
                print(f"1 {bs[0]:20s} {'same' if same else 'DIFFERS'}{mark} {f}")
            continue
        tiplines = collections.Counter((at_tip or b"").decode(errors="replace").splitlines())
        print(f"M {','.join(bs)}{mark} {f}")
        for b in bs:
            d = git("diff", "-U0", "--no-renames", base, b, "--", f)
            added = [line[1:] for line in d.splitlines() if line.startswith("+") and not line.startswith("+++")]
            missing = [line for line in added if line not in tiplines]
            if missing:
                print(f"    {b}: {len(missing)}/{len(added)} added lines not in tip")
                for line in missing[:8]:
                    print("       ", line[:150])


if __name__ == "__main__":
    main()
