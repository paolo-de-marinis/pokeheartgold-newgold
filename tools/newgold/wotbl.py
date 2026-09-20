#!/usr/bin/env python3
"""Read and write the level-up learnset archive.

pret ships files/poketool/personal/wotbl.narc as a binary, so there is no text
source to add species to. This decodes it, re-encodes it, and refuses to do
either unless the round trip reproduces the original byte for byte.

    wotbl.py verify                 check the archive round-trips
    wotbl.py extend REFERENCE       append the new species' learnsets

Each learnset is a list of 16-bit entries, the move in the low nine bits and
the level in the top seven, ending with 0xFFFF.
"""

import argparse
import json
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ARCHIVE = ROOT / "files/poketool/personal/wotbl.narc"

MOVE_BITS = 9
MOVE_MASK = (1 << MOVE_BITS) - 1
TERMINATOR = 0xFFFF


def read_narc(data):
    """Return the archive's files, in order."""
    if data[:4] != b"NARC":
        raise ValueError("not a NARC")
    position = struct.unpack_from("<H", data, 12)[0]
    if data[position:position + 4] != b"BTAF":
        raise ValueError("expected a file allocation table")
    count = struct.unpack_from("<H", data, position + 8)[0]
    ranges = [struct.unpack_from("<II", data, position + 12 + i * 8) for i in range(count)]

    chunk = position
    while data[chunk:chunk + 4] != b"GMIF":
        size = struct.unpack_from("<I", data, chunk + 4)[0]
        if size == 0:
            raise ValueError("malformed archive")
        chunk += size
    body = chunk + 8
    return [data[body + start:body + end] for start, end in ranges], data[:position], data[position:body]


def decode(raw):
    moves = []
    for offset in range(0, len(raw), 2):
        entry = struct.unpack_from("<H", raw, offset)[0]
        if entry == TERMINATOR:
            break
        moves.append({"level": entry >> MOVE_BITS, "move": entry & MOVE_MASK})
    return moves


def encode(moves):
    raw = b"".join(struct.pack("<H", (m["level"] << MOVE_BITS) | m["move"]) for m in moves)
    raw += struct.pack("<H", TERMINATOR)
    # Each file is padded with zeroes to a multiple of four bytes.
    if len(raw) % 4:
        raw += struct.pack("<H", 0)
    return raw


def build_narc(files):
    allocation = b""
    body = b""
    for raw in files:
        allocation += struct.pack("<II", len(body), len(body) + len(raw))
        body += raw
    btaf = b"BTAF" + struct.pack("<IHH", 12 + len(allocation), len(files), 0) + allocation
    btnf = b"BTNF" + struct.pack("<IIHH", 16, 4, 0, 1)
    gmif = b"GMIF" + struct.pack("<I", 8 + len(body)) + body
    total = 16 + len(btaf) + len(btnf) + len(gmif)
    header = b"NARC" + struct.pack("<HHIHH", 0xFFFE, 0x0100, total, 16, 3)
    return header + btaf + btnf + gmif


def move_names():
    """Map every move HGSS knows to its number."""
    header = (ROOT / "include/constants/moves.h").read_text()
    return {m[1]: int(m[2]) for m in re.finditer(r"#define (MOVE_[A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


def species_names():
    header = (ROOT / "include/constants/species.h").read_text()
    byId = {}
    for match in re.finditer(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\s*$", header, re.M):
        byId.setdefault(int(match.group(2)), match.group(1))
    return byId


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("verify")
    extendArgs = sub.add_parser("extend")
    extendArgs.add_argument("reference", type=Path)
    extendArgs.add_argument("--write", action="store_true")
    args = parser.parse_args()

    data = ARCHIVE.read_bytes()
    files, _, _ = read_narc(data)
    rebuilt = build_narc(files)
    if rebuilt != data:
        print(f"round trip differs: {len(rebuilt)} bytes against {len(data)}", file=sys.stderr)
        raise SystemExit(1)

    names = species_names()
    learnsets = [{"species": names.get(i, f"UNKNOWN_{i}"), "moves": decode(raw)}
                 for i, raw in enumerate(files)]
    if any(encode(entry["moves"]) != raw for entry, raw in zip(learnsets, files)):
        print("a learnset does not re-encode to its original bytes", file=sys.stderr)
        raise SystemExit(1)

    if args.command == "verify":
        print(f"{len(files)} learnsets round-trip byte for byte")
        return

    extend(args, files)


def extend(args, files):
    """Append a learnset for every species the archive does not cover yet."""
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import import_species

    names = species_names()
    moves = move_names()
    reference = json.loads((args.reference / "data/learnsets/learnsets.json").read_text())

    added, dropped = [], {}
    for index in range(len(files), max(names) + 1):
        name = names.get(index)
        if name is None:
            raise SystemExit(f"no species is defined at identifier {index}")
        entry = reference.get("SPECIES_" + name)
        if entry is None:
            raise SystemExit(f"the reference has no learnset for {name}")
        learned, missing = [], []
        for step in entry["LevelMoves"]:
            number = moves.get(step["Move"])
            if number is None:
                missing.append(step["Move"])
                continue
            # The archive packs the move into nine bits and the level into seven.
            if number > MOVE_MASK or step["Level"] > (TERMINATOR >> MOVE_BITS):
                raise SystemExit(f"{name}: {step['Move']} at level {step['Level']} does not fit an entry")
            learned.append({"level": step["Level"], "move": number})
        added.append(encode(learned))
        if missing:
            dropped[name] = missing

    print(f"{len(added)} learnsets to append, identifiers {len(files)} to {len(files) + len(added) - 1}")
    if dropped:
        total = sum(len(v) for v in dropped.values())
        print(f"{total} level-up moves HGSS does not have yet, across {len(dropped)} species, left out:")
        for name in sorted(dropped)[:6]:
            print(f"  {name}: {', '.join(sorted(dropped[name]))}")
        if len(dropped) > 6:
            print(f"  ... and {len(dropped) - 6} more")
    if not args.write:
        return
    ARCHIVE.write_bytes(build_narc(files + added))
    print(f"wrote {ARCHIVE.relative_to(ROOT)} with {len(files) + len(added)} learnsets")


if __name__ == "__main__":
    main()
