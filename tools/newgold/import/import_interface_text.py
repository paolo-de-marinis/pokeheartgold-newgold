#!/usr/bin/env python3
"""Write the interface banks from the reference's data/text at a revision.

Banks 010 (bag), 024 (PC), 040 (common field messages), 203 (blackout),
300 (party menu), 302 (summary) and 435 (shop) are hg-engine's whole: every
row is the reference's line with the same number. A line of spaces is one of
retail's unused rows and is written as a garbage row of that width (msgenc
makes it that many spaces; a used row of spaces would come out empty). A row
whose text the bank already has is kept as it is.

The rows moved with the text are read where hg-engine reads them: box names
from 024 row 95 + box, the repel prompt from 040 rows 118/119, the Ability
Capsule from 300 row 193, a Mint from 300 row 194 + nature, a TM learned into
a free slot from 300 row 219, and the EV/IV header from 302 rows 206/207.

Bank 550 is Cherrygrove's map text. hg-engine has no file for it, so at the
engine it is retail's 25 rows; konefr's data/text/550.txt keeps those 25 and
appends 41 for his developer vendor and EV presets, which nothing here reads.

Usage: import_interface_text.py [--revision REV]   (default: the engine)
"""
import argparse
import re

import gmm

BANKS = (10, 24, 40, 203, 300, 302, 435)
# Banks only New Gold writes, and how many rows retail has where it does not.
RETAIL_WHERE_ABSENT = {550: 25}


def width(row):
    """How many spaces a garbage row encodes as: msgenc blanks its Japanese
    placeholder byte for byte."""
    match = re.search(r'<language name="日本語">(.*?)</language>', row["extra"], re.S)
    return len(match.group(1).encode()) if match else 0


def build(bank, lines, old):
    # Row ids are what scripts name: msg_0550_T21_00003, not msg_0550_00003.
    prefix = gmm.path_of(bank).stem
    rows = []
    for index, line in enumerate(lines):
        name = f"{prefix}_{index:05d}"
        had = old[index] if index < len(old) else None
        if line and not line.strip(" "):
            if had and had["context"] == "garbage" and width(had) == len(line):
                rows.append(dict(had, id=name))
            else:
                rows.append(gmm.garbage_row(bank, index, len(line), name))
        elif had and had["context"] == "used" and had["text"] == line and not had["extra"]:
            rows.append(dict(had, id=name))
        else:
            rows.append(gmm.new_row(bank, index, line, name))
    return rows


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    revision = parser.parse_args().revision
    for bank in BANKS:
        lines = gmm.reference_rows(revision, bank)
        if lines is None:
            raise SystemExit(f"{revision} has no data/text/{bank:03d}.txt")
        gmm.write(bank, build(bank, lines, gmm.read(bank)))
    for bank, retail in RETAIL_WHERE_ABSENT.items():
        lines = gmm.reference_rows(revision, bank)
        old = gmm.read(bank)
        gmm.write(bank, old[:retail] if lines is None else build(bank, lines, old))


if __name__ == "__main__":
    main()
