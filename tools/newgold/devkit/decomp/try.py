#!/usr/bin/env python3
"""Try versions of one function until one matches.

    try.py SRC FUNC ORIG.o < VARIANTS     (in the repository, after env.sh)

VARIANTS on stdin are whole texts of FUNC, separated by lines '====='. Each
is put in place of FUNC's body in SRC (a copy beside it, so its includes
resolve the same), compiled with cc.sh, and compared with FUNC in ORIG.o --
the assembly's object, or a build that matched -- by fncmp.py; one line each:
the variant's number and MATCH, the number of instructions that differ, or
the compiler's error. SHOW=N prints variant N's comparison in full.
"""
import os
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main():
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    src, func, orig = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
    text = src.read_text()
    m = re.search(r"\n[^\n]*\b" + re.escape(func) + r"\([^)]*\) \{\n", text)
    if not m:
        sys.exit(f"no definition of {func} in {src}")
    start = m.start() + 1
    end = text.index("\n}\n", start) + 3
    tmp = src.with_name(f"_try_{os.getpid()}.c")
    obj = Path("build") / f"_try_{os.getpid()}.o"
    obj.parent.mkdir(exist_ok=True)
    try:
        for k, variant in enumerate(sys.stdin.read().split("=====\n")):
            tmp.write_text(text[:start] + variant.strip("\n") + "\n" + text[end:])
            run = subprocess.run([str(HERE / "cc.sh"), str(tmp), str(obj)], capture_output=True, text=True)
            if run.returncode:
                print(k, "COMPILE ERROR", (run.stdout + run.stderr)[-800:], flush=True)
                continue
            cmp = subprocess.run([sys.executable, str(HERE / "fncmp.py"), orig, str(obj), func], capture_output=True, text=True)
            differ = sum(1 for line in cmp.stdout.splitlines() if line.startswith(">>"))
            print(k, "MATCH" if cmp.returncode == 0 else differ, flush=True)
            if os.environ.get("SHOW") == str(k):
                print(cmp.stdout)
    finally:
        tmp.unlink(missing_ok=True)
        obj.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
