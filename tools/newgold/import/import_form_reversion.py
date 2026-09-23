#!/usr/bin/env python3
"""Write src/data/form_reversion.h, the species each battle form goes back to.

hg-engine marks the forms that last only as long as a battle NEEDS_REVERSION
in data/PokeFormDataTbl.c -- a Mega, Zen Mode, Xerneas' Active Mode, a crowned
Zacian -- and RevertFormChange (src/pokemon.c:1455) sends such a form back to
form 0 of its species, or to the form data/FormReversionMapping.c names for it
(a Minior core to its meteor of the same colour). Here a form is a species of
its own, so the table gives the species it goes back to: the base for form 0,
and otherwise the base's form of that number in the same table.

Both files are read at the engine's revision with git. Their only conditionals
are settings the engine turns on (MEGA_EVOLUTIONS, PRIMAL_REVERSION and
IMPLEMENT_DEXIT_FORMS_MECHANICS in include/config.h), so every entry counts. A
form this game has not got is left out.

Minior's cores are left out too: a Minior is in its Core Form whenever it is
out of a battle (Pokemon Central, Scudosoglia), so it is the meteor that goes
back, and to the core of its colour. Species_GetBattleFormReversion says so in
C, because the red meteor is SPECIES_MINIOR itself and has no row here.

Usage: import_form_reversion.py [--write]
"""

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gmm  # noqa: E402

ROOT = gmm.ROOT
TABLE = ROOT / "src/data/form_reversion.h"


def form_table():
    """{base: [(form, needs reversion)]}, in the engine's form order."""
    source = gmm.git_show(gmm.ENGINE, "data/PokeFormDataTbl.c")
    table = {}
    for base, body in re.findall(r"\[SPECIES_([A-Z0-9_]+)\]\s*=\s*\{(.*?)\}", source, re.S):
        table[base] = [(name, bool(flag)) for flag, name in
                       re.findall(r"(NEEDS_REVERSION\s*\|\s*)?SPECIES_([A-Z0-9_]+)", body)]
    return table


def reversion_forms():
    """{form: form number it goes back to}; a form not named goes back to 0."""
    source = gmm.git_show(gmm.ENGINE, "data/FormReversionMapping.c")
    return {name: int(number) for name, number in
            re.findall(r"\[SPECIES_([A-Z0-9_]+) - SPECIES_MEGA_START\]\s*=\s*(\d+)", source)}


def table():
    """[(form, species it goes back to)] for every form here that has one."""
    header = (ROOT / "include/constants/species.h").read_text()
    ours = set(re.findall(r"^#define SPECIES_([A-Z0-9_]+)\s+\d+", header, re.M))
    mapping = reversion_forms()
    rows = []
    for base, forms in form_table().items():
        for form, reverts in forms:
            if not reverts or form not in ours or form.startswith("MINIOR_CORE_"):
                continue
            number = mapping.get(form, 0)
            target = base if number == 0 else forms[number - 1][0]
            if target not in ours:
                raise SystemExit(f"{form} goes back to {target}, which is not a species here")
            rows.append((form, target))
    return rows


def render(rows):
    lines = ["// The species a form that lasts only as long as a battle goes back to, from",
             "// hg-engine's PokeFormDataTbl and FormReversionMapping; the rest are 0.",
             "// Written by tools/newgold/import/import_form_reversion.py; do not edit it.",
             "static const u16 sFormReversion[NUM_SPECIES - NATIONAL_DEX_COUNT] = {"]
    lines += [f"    [SPECIES_{form} - NATIONAL_DEX_COUNT - 1] = SPECIES_{target}," for form, target in rows]
    return "\n".join(lines + ["};", ""])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = table()
    print(f"{len(rows)} forms go back after a battle")
    if not args.write:
        print("nothing written; pass --write")
        return
    TABLE.write_text(render(rows))
    print(f"wrote {TABLE.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
