#!/usr/bin/env python3
"""Which files of two ROMs differ: every file by its path in the ROM's file
system (FNT/FAT), with arm9, arm7 and the overlays, hashed.

    ndsfiles.py A B          A and B each a .nds or a dump of one
    ndsfiles.py dump ROM     the hashes as JSON, to compare later

A build that should change one archive changes one line here; a ROM that
differs by a byte says where.
"""
import hashlib
import json
import struct
import sys


def files(path):
    rom = open(path, "rb").read()
    u32 = lambda o: struct.unpack_from("<I", rom, o)[0]  # noqa: E731
    fnt, fat = u32(0x40), u32(0x48)
    out = {"arm9": rom[u32(0x20):u32(0x20) + u32(0x2C)], "arm7": rom[u32(0x30):u32(0x30) + u32(0x3C)]}

    def data(i):
        a, b = struct.unpack_from("<II", rom, fat + 8 * i)
        return rom[a:b]
    for tab, size in ((u32(0x50), u32(0x54)), (u32(0x58), u32(0x5C))):
        for k in range(size // 32):
            out[f"overlay_{tab:x}_{k}"] = data(struct.unpack_from("<I", rom, tab + 32 * k + 0x18)[0])

    def walk(dir_id, prefix):
        sub, first = struct.unpack_from("<IH", rom, fnt + 8 * (dir_id & 0xFFF))
        p, fid = fnt + sub, first
        while rom[p]:
            n = rom[p]
            name = rom[p + 1:p + 1 + (n & 0x7F)].decode("latin1")
            p += 1 + (n & 0x7F)
            if n & 0x80:
                walk(struct.unpack_from("<H", rom, p)[0], prefix + name + "/")
                p += 2
            else:
                out[prefix + name] = data(fid)
                fid += 1
    walk(0xF000, "")
    return {k: hashlib.md5(v).hexdigest() for k, v in out.items()}


def load(path):
    return files(path) if path.endswith(".nds") else json.load(open(path))


def main():
    if len(sys.argv) == 3 and sys.argv[1] == "dump":
        print(json.dumps(files(sys.argv[2]), indent=0, sort_keys=True))
    elif len(sys.argv) == 3:
        a, b = load(sys.argv[1]), load(sys.argv[2])
        for k in sorted(set(a) | set(b)):
            if a.get(k) != b.get(k):
                print("differs:", k)
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main()
