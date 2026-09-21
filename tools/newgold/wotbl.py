#!/usr/bin/env python3
"""Read and write the level-up learnset archive.

pret ships files/poketool/personal/wotbl.narc as a binary, so there is no text
source to add species to. This decodes it, re-encodes it, and refuses to do
either unless the round trip reproduces the original byte for byte.

    wotbl.py verify                 check the archive round-trips
    wotbl.py extend REFERENCE       append the new species' learnsets
    wotbl.py rebuild REFERENCE      rewrite the added species' learnsets, for
                                    when a move they wanted has since arrived
    wotbl.py konefr REFERENCE       rewrite the learnsets konefr himself
                                    changed, and only those

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

# The hg-engine commit New Gold was forked from. Everything the reference's
# learnsets say that this does not is konefr's own work.
ENGINE_BASE = "d0380a487"

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


# Names the reference spells differently from this game.
MOVE_ALIASES = {
    "MOVE_SMOKESCREEN": "MOVE_SMOKE_SCREEN",
    "MOVE_SELF_DESTRUCT": "MOVE_SELFDESTRUCT",
    "MOVE_SOFT_BOILED": "MOVE_SOFTBOILED",
    "MOVE_FEINT_ATTACK": "MOVE_FAINT_ATTACK",
    "MOVE_HIGH_JUMP_KICK": "MOVE_HI_JUMP_KICK",
}


def move_names():
    """Map every move HGSS knows to its number, under either spelling."""
    header = (ROOT / "include/constants/moves.h").read_text()
    known = {m[1]: int(m[2]) for m in re.finditer(r"#define (MOVE_[A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}
    for theirs, ours in MOVE_ALIASES.items():
        if ours in known:
            known[theirs] = known[ours]
    return known


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
    for name in ("extend", "rebuild", "konefr"):
        command = sub.add_parser(name)
        command.add_argument("reference", type=Path)
        command.add_argument("--write", action="store_true")
        if name == "konefr":
            command.add_argument("--base", default=ENGINE_BASE,
                                 help="the hg-engine revision New Gold forked from")
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

    if args.command == "konefr":
        konefr(args, files)
        return

    extend(args, files, rebuild=args.command == "rebuild")


def konefr(args, files):
    """Rewrite the learnsets konefr changed, and only those.

    The reference's learnset file is hg-engine's whole modern dataset, most of
    which is not New Gold. What is New Gold is the difference between it and
    the revision the hack was forked from — fifteen species, at the time of
    writing — so that difference is what is taken.
    """
    import subprocess

    names = species_names()
    moves = move_names()
    byName = {name: index for index, name in names.items()}

    def revision(rev):
        result = subprocess.run(["git", "-C", str(args.reference), "show",
                                 f"{rev}:data/learnsets/learnsets.json"],
                                capture_output=True, text=True)
        if result.returncode:
            raise SystemExit(f"cannot read the learnsets at {rev}")
        return json.loads(result.stdout)

    before, after = revision(args.base), revision("HEAD")
    changed = [key for key in after if before.get(key) != after[key]]

    files = list(files)
    rewritten, dropped, unreachable = 0, {}, []
    for key in changed:
        name = key.replace("SPECIES_", "")
        index = byName.get(name)
        if index is None or index >= len(files):
            unreachable.append(name)
            continue
        learned, missing = [], []
        for step in after[key]["LevelMoves"]:
            number = moves.get(step["Move"])
            if number is None:
                missing.append(step["Move"])
                continue
            learned.append({"level": step["Level"], "move": number})
        raw = encode(learned)
        if raw != files[index]:
            files[index] = raw
            rewritten += 1
        if missing:
            dropped[name] = missing

    print(f"konefr changed {len(changed)} learnsets; {rewritten} of them differ here")
    for name in sorted(dropped):
        print(f"  {name}: left out {', '.join(sorted(dropped[name]))}")
    for name in sorted(unreachable):
        print(f"  {name}: this game has no such species")
    if not args.write:
        print("nothing written; pass --write")
        return
    ARCHIVE.write_bytes(build_narc(files))
    print(f"wrote {ARCHIVE.relative_to(ROOT)}")


def extend(args, files, rebuild=False):
    """Append a learnset for every species the archive does not cover yet.

    With rebuild, the species already added are written again as well, which is
    what to do once a move one of them wanted has since been added: the first
    import had to leave it out.
    """
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import import_species

    names = species_names()
    moves = move_names()
    reference = json.loads((args.reference / "data/learnsets/learnsets.json").read_text())

    added, dropped, lowered = [], {}, {}
    # The added species start where the egg and form block ends.
    firstAdded = min(index for index, name in names.items()
                     if name in import_species.added_species())
    first = firstAdded if rebuild else len(files)
    for index in range(first, max(names) + 1):
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
        # A species whose level-one moves are all still missing would be
        # obtained with nothing it could use -- Indeedee knows Stored Power
        # and Play Nice at one, and neither exists here yet. The earliest move
        # that did survive is taught at level one instead, so it can fight.
        # Rebuilding once the real moves arrive puts the learnset right.
        if learned and min(step["level"] for step in learned) > 1:
            earliest = min(learned, key=lambda step: step["level"])
            earliest["level"] = 1
            lowered[name] = earliest["move"]
        added.append(encode(learned))
        if missing:
            dropped[name] = missing

    print(f"{len(added)} learnsets, identifiers {first} to {first + len(added) - 1}")
    if dropped:
        total = sum(len(v) for v in dropped.values())
        print(f"{total} level-up moves HGSS does not have yet, across {len(dropped)} species, left out:")
        for name in sorted(dropped)[:6]:
            print(f"  {name}: {', '.join(sorted(dropped[name]))}")
        if len(dropped) > 6:
            print(f"  ... and {len(dropped) - 6} more")
    if lowered:
        byNumber = {number: name for name, number in moves.items()}
        print(f"{len(lowered)} species had no level-one move left and were given "
              f"their earliest surviving one at level one:")
        for name, move in sorted(lowered.items()):
            print(f"  {name}: {byNumber.get(move, move)}")
    if not args.write:
        return
    ARCHIVE.write_bytes(build_narc(files[:first] + added))
    print(f"wrote {ARCHIVE.relative_to(ROOT)} with {first + len(added)} learnsets")


if __name__ == "__main__":
    main()
