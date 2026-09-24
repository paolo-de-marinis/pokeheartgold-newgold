#!/usr/bin/env python3
"""offsetof, as mwcc lays the struct out.

    offsets.py TYPE FIELD... [--header battle/battle.h ...] [VARIABLE=VALUE...]

Each FIELD (a member, or a path: ctx.battleMons[1].hp) is compiled with
cc.sh as `const int probe_N = (int)&((TYPE *)0)->FIELD;` against the headers
named (battle/battle.h and battle/battle_system.h by default), and its value
read back out of the object. In the repository, after env.sh (cc.sh's
compiler, arm-none-eabi-readelf on PATH). VARIABLE=VALUE go to make, as
NEWGOLD_DIAG=1, which changes some layouts.
"""
import argparse
import os
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def readelf(*args):
    return subprocess.run(["arm-none-eabi-readelf", *args], capture_output=True, text=True, check=True).stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("type")
    parser.add_argument("fields", nargs="+")
    parser.add_argument("--header", action="append")
    args = parser.parse_args()
    make = [f for f in args.fields if "=" in f]
    fields = [f for f in args.fields if "=" not in f]
    root = Path(subprocess.run(["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True).stdout.strip())
    scratch = root / "build/offsets"
    scratch.mkdir(parents=True, exist_ok=True)
    source, obj = scratch / f"probe_{os.getpid()}.c", scratch / f"probe_{os.getpid()}.o"
    lines = [f'#include "{h}"' for h in args.header or ("battle/battle.h", "battle/battle_system.h")]
    lines += [f"const int probe_{i} = (int)&((({args.type} *)0)->{f});" for i, f in enumerate(fields)]
    source.write_text("\n".join(lines) + "\n")
    try:
        run = subprocess.run([str(HERE / "cc.sh"), str(source), str(obj), *make], capture_output=True, text=True)
        if run.returncode:
            sys.exit((run.stdout + run.stderr)[-3000:])
        symbols = {}
        for line in readelf("-sW", str(obj)).splitlines():
            p = line.split()
            if len(p) >= 8 and p[7].startswith("probe_"):
                symbols[int(p[7][6:])] = (int(p[1], 16), p[6])
        offsets = {}
        for line in readelf("-SW", str(obj)).splitlines():
            q = line.replace("[ ", "[").split()
            if q and q[0].startswith("[") and q[0].endswith("]") and q[0][1:-1].isdigit():
                offsets[q[0][1:-1]] = int(q[4], 16)
        data = obj.read_bytes()
        for i, f in enumerate(fields):
            value, section = symbols[i]
            at = offsets[section] + value
            print(f"{f} {int.from_bytes(data[at:at + 4], 'little'):#x}")
    finally:
        source.unlink(missing_ok=True)
        obj.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
