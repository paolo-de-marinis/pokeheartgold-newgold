#!/usr/bin/env python3
"""Did every branch of a round survive its integration?

    survive.py [--blocks] BASE INTEGRATED BRANCH...      (in the repository)

For each BRANCH -- the branch as it was picked, e.g. r9-battle-shifted --
every file it changed since BASE is compared with INTEGRATED, as multisets
of stripped lines: a line the branch added that INTEGRATED has fewer of
(added-not-kept), a line the branch removed that came back (removed-but-back),
a file missing, a file deleted but still there, a binary that differs.

--blocks looks instead for each run of lines the branch added, whole and in
order, in INTEGRATED's file, and names the runs that were broken up.

A finding is a place to read, not a defect: another branch may have changed
the same line on purpose.
"""
import collections
import subprocess
import sys


def git(*args):
    p = subprocess.run(["git", *args], capture_output=True)
    return p.stdout if p.returncode == 0 else None


def lines(rev, path):
    blob = git("show", f"{rev}:{path}")
    if blob is None:
        return None
    try:
        return [line.strip() for line in blob.decode().split("\n")]
    except UnicodeDecodeError:
        return blob


def by_lines(base, integrated, branch):
    for row in git("diff", "--name-status", "-M", base, branch).decode().splitlines():
        parts = row.split("\t")
        status, old, path = parts[0], parts[1], parts[-1]
        if status.startswith("D"):
            if lines(integrated, old) is not None:
                print(f"  DELETED-BUT-PRESENT {old}")
            continue
        mine, theirs, before = lines(branch, path), lines(integrated, path), lines(base, old)
        if theirs is None:
            print(f"  MISSING {path}")
            continue
        if isinstance(mine, bytes) or isinstance(theirs, bytes):
            if git("rev-parse", f"{branch}:{path}") != git("rev-parse", f"{integrated}:{path}"):
                print(f"  BINARY-DIFFERS {path}")
            continue
        cb, ci, co = collections.Counter(mine), collections.Counter(theirs), collections.Counter(before or [])
        missing = [line for line in cb if line and cb[line] > co[line] and ci[line] < cb[line]]
        back = [line for line in co if line and co[line] > cb[line] and ci[line] > cb[line]]
        if missing or back:
            print(f"  {path}")
            for line in missing:
                print(f"     - added-not-kept ({cb[line]} vs {ci[line]}): {line[:150]}")
            for line in back:
                print(f"     - removed-but-back ({cb[line]} vs {ci[line]}): {line[:150]}")


def by_blocks(base, integrated, branch):
    blocks, path, context, run = [], None, None, []

    def flush():
        if run:
            blocks.append((path, context, list(run)))
            run.clear()

    for line in git("diff", "-U0", "-M", base, branch).decode(errors="replace").split("\n"):
        if line.startswith("+++ "):
            flush()
            path = None if line == "+++ /dev/null" else line[6:]
        elif line.startswith("@@"):
            flush()
            context = line
        elif line.startswith("+"):
            run.append(line[1:].strip())
        elif line.startswith("-"):
            flush()
    flush()
    texts = {}
    for path, context, run in blocks:
        if path is None:
            continue
        if path not in texts:
            blob = git("show", f"{integrated}:{path}") or b""
            texts[path] = "\n".join(line.strip() for line in blob.decode(errors="replace").split("\n"))
        if "\n".join(run) not in texts[path]:
            print(f"  {path} {context[:60]} ({len(run)} lines) block not contiguous")


def main():
    args = sys.argv[1:]
    check = by_lines
    if args[:1] == ["--blocks"]:
        check, args = by_blocks, args[1:]
    if len(args) < 3:
        sys.exit(__doc__)
    base, integrated, branches = args[0], args[1], args[2:]
    for branch in branches:
        print(f"######## {branch}")
        check(base, integrated, branch)


if __name__ == "__main__":
    main()
