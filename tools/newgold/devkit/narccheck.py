#!/usr/bin/env python3
"""Does a built NARC hold what its folder says? Member by member against the
files .narcorder lists, in that order.

    narccheck.py ARCHIVE.narc FOLDER

A generated archive in the source tree can be stale -- the main tree once
packed 733 old icon files -- and the build does not always notice: this
names the members that differ from the files they should be.
"""
import os
import struct
import sys


def members(path):
    d = open(path, "rb").read()
    assert d[:4] == b"NARC", f"{path} is not a NARC"
    off = struct.unpack_from("<H", d, 12)[0]
    assert d[off:off + 4] == b"BTAF", d[off:off + 4]
    size, n = struct.unpack_from("<I", d, off + 4)[0], struct.unpack_from("<H", d, off + 8)[0]
    fat = [struct.unpack_from("<II", d, off + 12 + 8 * i) for i in range(n)]
    names = off + size
    assert d[names:names + 4] == b"BTNF"
    images = names + struct.unpack_from("<I", d, names + 4)[0]
    assert d[images:images + 4] == b"GMIF"
    base = images + 8
    return [d[base + s:base + e] for s, e in fat]


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    narc, folder = sys.argv[1], sys.argv[2]
    got = members(narc)
    order = [line.strip() for line in open(os.path.join(folder, ".narcorder")) if line.strip()]
    print(narc, "members", len(got), "narcorder", len(order))
    bad = 0
    for i, (member, name) in enumerate(zip(got, order)):
        if open(os.path.join(folder, name), "rb").read() != member:
            bad += 1
            if bad < 5:
                print("mismatch", i, name)
    print("mismatches", bad)
    sys.exit(1 if bad or len(got) != len(order) else 0)


if __name__ == "__main__":
    main()
