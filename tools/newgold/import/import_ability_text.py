#!/usr/bin/env python3
"""Write the ability banks as the reference has them at a revision.

Bank 720 is the names, 721 the names in capitals, 722 the descriptions; each
is the reference's data/text/72N.txt, a row per ability. A row is matched to
the port's ability by constant name, not by position. An ability the port has
and the revision has not -- at d0380a487, Irrigation (the engine's slot 314 is
ABILITY_TEMP2) and Evaporate (319, past the engine's last row) -- gets the text
the engine gives an unused slot, so a read of it stays inside the bank.

    import_ability_text.py [--revision REV] [--write]

REV defaults to the engine (d0380a487); ccf2c9f5 is New Gold.
"""
import argparse
import re

import gmm

BANKS = {720: "Placeholder", 721: "PLACEHOLDER", 722: "Placeholder"}   # bank: unused slot
ALIASES = {"ABILITY_COMPOUND_EYES": "ABILITY_COMPOUNDEYES", "ABILITY_LIGHTNING_ROD": "ABILITY_LIGHTNINGROD"}


def abilities(text):
    return {int(m[2]): ALIASES.get(m[1], m[1]) for m in re.finditer(r"#define (ABILITY_\w+)\s+(\d+)", text)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    port = abilities((gmm.ROOT / "include/constants/abilities.h").read_text())
    theirs = {name: number for number, name in
              abilities(gmm.git_show(args.revision, "include/constants/ability.h")).items()}
    if sorted(port) != list(range(len(port))):
        raise SystemExit("the port's abilities are not numbered 0..N")
    for bank, unused in BANKS.items():
        reference = gmm.reference_rows(args.revision, bank)
        rows = gmm.read(bank)
        for number in range(len(port)):
            row = theirs.get(port[number])
            text = reference[row] if row is not None and row < len(reference) else unused
            if number == len(rows):
                rows.append(gmm.new_row(bank, number, text))
                print(f"{bank} row {number} {port[number]}: new {text!r}")
            elif rows[number]["text"] != text:
                print(f"{bank} row {number} {port[number]}: {rows[number]['text']!r} -> {text!r}")
                rows[number]["text"] = text
        if len(rows) > len(port):
            print(f"{bank}: rows {len(port)}..{len(rows) - 1} name no ability and go")
        if args.write:
            gmm.write(bank, rows[:len(port)])
    if not args.write:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
