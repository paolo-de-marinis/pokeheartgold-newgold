#!/usr/bin/env python3
"""Read and write the level-up learnset archive.

pret ships files/poketool/personal/wotbl.narc as a binary, so there is no text
source to add species to. This decodes it, re-encodes it, and refuses to do
either unless the round trip reproduces the original byte for byte.

    wotbl.py verify                 check the archive round-trips
    wotbl.py extend REFERENCE       append the new species' learnsets
    wotbl.py rebuild REFERENCE      rewrite the added species' learnsets, for
                                    when a move they wanted has since arrived
    wotbl.py engine REFERENCE       rewrite HeartGold's own species with
                                    hg-engine's learnsets at d0380a487
    wotbl.py konefr REFERENCE       rewrite the learnsets konefr himself
                                    changed, and only those

Each learnset is a list of 32-bit entries, the move in the low halfword and
the level in the high one, ending with 0xFFFF. Retail packed both into a
single halfword, nine bits for the move; that holds until a move is numbered
past 511, and the reference's go to 923.
"""

import argparse
import json
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ARCHIVE = ROOT / "files/poketool/personal/wotbl.narc"

# The hg-engine commit New Gold was forked from. Everything the reference's
# learnsets say that this does not is konefr's own work.
ENGINE_BASE = "d0380a487"
# konefr's tip: what New Gold's learnsets are.
KONEFR_TIP = "ccf2c9f5"
# HeartGold's own species. The egg and the bad egg follow them, and have no
# learnset anywhere.
LAST_RETAIL_SPECIES = 493
# HeartGold's alternate forms, Deoxys Attack to Rotom Mow. The reference keeps
# them at these numbers and files their learnsets under the number
# (SPECIES_496), not under a name.
NUMBERED_FORMS = range(496, 508)

ENTRY_SIZE = 4
MOVE_BITS = 16
MOVE_MASK = (1 << MOVE_BITS) - 1
LEVEL_MAX = 0xFFFF
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
    for offset in range(0, len(raw) - ENTRY_SIZE + 1, ENTRY_SIZE):
        entry = struct.unpack_from("<I", raw, offset)[0]
        if entry == TERMINATOR:
            break
        moves.append({"level": entry >> MOVE_BITS, "move": entry & MOVE_MASK})
    return moves


def decode_retail(raw):
    """The format pret ships: one halfword, nine bits of move, seven of level.

    Only wanted for comparing against an archive from before this widened the
    entry -- the test that checks pret's own learnsets are untouched.
    """
    moves = []
    for offset in range(0, len(raw), 2):
        entry = struct.unpack_from("<H", raw, offset)[0]
        if entry == 0xFFFF:
            break
        moves.append({"level": entry >> 9, "move": entry & 0x1FF})
    return moves


def encode(moves):
    raw = b"".join(struct.pack("<I", (m["level"] << MOVE_BITS) | m["move"]) for m in moves)
    return raw + struct.pack("<I", TERMINATOR)


def build_narc(files, align=1):
    """align=4 is how the build's own archives lay members out (trtblofs.narc):
    each starts on four bytes, the gap after an odd-sized one filled with 0xFF.
    height.narc was written packed, so 1 stays the default."""
    allocation = b""
    body = b""
    for raw in files:
        allocation += struct.pack("<II", len(body), len(body) + len(raw))
        body += raw + b"\xff" * (-len(raw) % align)
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
    for name in ("extend", "rebuild", "engine", "konefr"):
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

    if args.command == "engine":
        engine(args, files)
        return

    extend(args, files, rebuild=args.command == "rebuild")


def reference_learnsets(reference, rev):
    """The reference's learnsets.json as it was at a revision."""
    import subprocess

    result = subprocess.run(["git", "-C", str(reference), "show",
                             f"{rev}:data/learnsets/learnsets.json"],
                            capture_output=True, text=True)
    if result.returncode:
        raise SystemExit(f"cannot read the learnsets at {rev}")
    return json.loads(result.stdout)


def reference_key(index, names):
    """What the reference files a species' learnset under."""
    return f"SPECIES_{index}" if index in NUMBERED_FORMS else "SPECIES_" + names[index]


def engine(args, files):
    """Rewrite HeartGold's own species with hg-engine's learnsets.

    pret's learnsets are Generation IV's. hg-engine replaced every one of them
    with the latest games' (Dunsparce learns Hyper Drill at 32 there, which is
    how Dudunsparce is had), and what the engine has at the revision New Gold
    forked from is the engine layer's. konefr's own changes go over these
    afterwards, with the konefr command.
    """
    names = species_names()
    moves = move_names()
    reference = reference_learnsets(args.reference, ENGINE_BASE)

    files = list(files)
    rewritten = 0
    for index in list(range(1, LAST_RETAIL_SPECIES + 1)) + list(NUMBERED_FORMS):
        entry = reference.get(reference_key(index, names))
        if entry is None and index in NUMBERED_FORMS:
            print(f"the reference has no learnset for {names[index]} ({index}); left as it is")
            continue
        if entry is None:
            raise SystemExit(f"the reference has no learnset for {names[index]}")
        learned = []
        for step in entry["LevelMoves"]:
            number = moves.get(step["Move"])
            if number is None:
                raise SystemExit(f"{names[index]}: this game has no {step['Move']}")
            learned.append({"level": step["Level"], "move": number})
        raw = encode(learned)
        if raw != files[index]:
            files[index] = raw
            rewritten += 1

    print(f"{rewritten} of {LAST_RETAIL_SPECIES + len(NUMBERED_FORMS)} learnsets differ from hg-engine's at {ENGINE_BASE}")
    if not args.write:
        print("nothing written; pass --write")
        return
    ARCHIVE.write_bytes(build_narc(files))
    print(f"wrote {ARCHIVE.relative_to(ROOT)}")


def konefr(args, files):
    """Rewrite the learnsets konefr changed, and only those.

    The reference's learnset file is hg-engine's whole modern dataset, most of
    which is not New Gold. What is New Gold is the difference between it and
    the revision the hack was forked from — fifteen species, at the time of
    writing — so that difference is what is taken.
    """
    names = species_names()
    moves = move_names()
    byName = {name: index for index, name in names.items()}

    before = reference_learnsets(args.reference, args.base)
    after = reference_learnsets(args.reference, KONEFR_TIP)
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
    bases = import_species.base_species_of(args.reference)

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
        if entry is None and name in bases:
            entry = reference.get("SPECIES_" + bases[name])  # a form learns what its base learns
        if entry is None:
            raise SystemExit(f"the reference has no learnset for {name}")
        learned, missing = [], []
        for step in entry["LevelMoves"]:
            number = moves.get(step["Move"])
            if number is None:
                missing.append(step["Move"])
                continue
            # The move takes the low halfword and the level the high one. The
            # terminator is a move of 0xFFFF at level 0, so no real move may be
            # numbered that high.
            if number >= MOVE_MASK or step["Level"] > LEVEL_MAX:
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
