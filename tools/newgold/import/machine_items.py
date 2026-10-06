#!/usr/bin/env python3
"""Give the machines past HM08 their move's description and their type's disc.

TM93 to TM148 sit on item ids hg-engine gave its own TMs (TM093 to TM100,
Scarlet and Violet's TM101 to TM148), and import_items.py brings those items
over with the reference's record, text and icon: the text and disc of the
move hg-engine's machine of that number taught (TM101 was Power Gem's).
New Gold's TM101 is Smack Down, so each of these items gets, from the game's
own tables, what a TM shows in the bag:

    files/msgdata/msg/msg_0221.gmm  its description, the move's own (bank
                                    749) laid out as an item's: three lines
                                    of at most 39 characters, as HeartGold's
                                    TM01 to HM08 are, or, for the four that
                                    need it, the narrowest width up to 45
                                    (the reference's widest item line) that
                                    keeps three
    src/item.c                      its disc, sImportedItemIcons: the icon of
                                    hg-engine's own TM of the move's type
                                    (TYPE_DISC), the palette being the next
                                    member as for every imported item

The machines are read from src/item.c (sMachineRuns, sTMHMMoves) through
savedit, so a change to the list is followed by running this again.
import_items.py runs it after it writes, since it rewrites both.

Usage: machine_items.py [--write | --check]
"""

import argparse
import re
import sys
import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path[:0] = [str(ROOT / "tools/newgold/import"), str(ROOT / "tools/newgold/devkit")]
import gmm  # noqa: E402
import savedit  # noqa: E402

ITEM_C = ROOT / "src/item.c"
DESCRIPTIONS, MOVE_DESCRIPTIONS = 221, 749
LINE, WIDEST, LINES = 39, 45, 3

# The disc of each type: the icon member of hg-engine's first TM item whose
# move had that type, as this tree had them before TM93 to TM148
# (48ab75d65), except Normal's: that was TM100's (1043), but hg-engine draws
# its TM100 with Scarlet and Violet's disc, Dragon Dance's, so Normal takes
# TM103's (1511, Substitute), whose palette is retail's Normal one.
# Retail's own TM01 to HM08 draw from their rows in sItemNarcIds.
TYPE_DISC = {
    "NORMAL": 1511, "FIGHTING": 1529, "FLYING": 1037, "POISON": 1509, "GROUND": 1517, "ROCK": 1507,
    "BUG": 943, "GHOST": 1533, "STEEL": 939, "FIRE": 1519, "WATER": 1525, "GRASS": 1527,
    "ELECTRIC": 1035, "PSYCHIC": 1039, "ICE": 1553, "DRAGON": 1535, "DARK": 941, "FAIRY": 1559,
}


def machines_past_hm08():
    """(item, move) for each machine past HM08, in the table's order."""
    return [(item, move) for place, (move, item) in enumerate(savedit.machines()) if place >= 100]


def description(move):
    """The move's description, laid out as an item's."""
    text = " ".join(gmm.read(MOVE_DESCRIPTIONS)[move]["text"].replace("\\n", " ").replace("\\r", " ").split())
    for width in range(LINE, WIDEST + 1):
        lines = textwrap.wrap(text, width, break_long_words=False)
        if len(lines) <= LINES:
            return "\\n".join(lines)
    raise SystemExit(f"move {move}'s description does not fit {LINES} lines of {WIDEST}")


def first_imported():
    return savedit.constants("include/constants/items.h", "FIRST_IMPORTED_")["FIRST_IMPORTED_ITEM"]


def icon_table(source):
    start = source.index("sImportedItemIcons[ITEMS_COUNT - FIRST_IMPORTED_ITEM] = {")
    start = source.index("{", start) + 1
    return start, source.index("};", start)


def wanted_icons(source):
    """sImportedItemIcons with each machine past HM08 on its type's disc."""
    start, end = icon_table(source)
    icons = [int(n) for n in re.findall(r"\d+", source[start:end])]
    types, kind = savedit.type_names(), savedit.move_attr("MOVEATTR_TYPE")
    for item, move in machines_past_hm08():
        icons[item - first_imported()] = TYPE_DISC[types[kind[move]]]
    rows = [", ".join(f"{n:4d}" for n in icons[i:i + 12]) for i in range(0, len(icons), 12)]
    return source[:start] + "\n" + ",\n".join("    " + row for row in rows) + ",\n" + source[end:]


def apply(write):
    """What would change, written when `write`."""
    rows = gmm.read(DESCRIPTIONS)
    changed = []
    for item, move in machines_past_hm08():
        text = description(move)
        if rows[item]["text"] != text:
            changed.append(f"{item}: description")
            rows[item] = gmm.new_row(DESCRIPTIONS, item, text)
    source = ITEM_C.read_text()
    icons = wanted_icons(source)
    if icons != source:
        changed.append("src/item.c: sImportedItemIcons")
    if write and changed:
        gmm.write(DESCRIPTIONS, rows)
        ITEM_C.write_text(icons)
    return changed


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true", help="fail if anything would change")
    args = parser.parse_args()
    changed = apply(args.write)
    print(f"{len(machines_past_hm08())} machines past HM08; {len(changed)} to change" +
          (": " + ", ".join(changed[:6]) + (" ..." if len(changed) > 6 else "") if changed else ""))
    if args.check:
        sys.exit(1 if changed else 0)


if __name__ == "__main__":
    main()
