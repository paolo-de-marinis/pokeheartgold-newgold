#!/usr/bin/env python3
"""Give the added species their Pokedex text.

Every string the Dex shows is a message bank indexed by species number, and
each of them stops at 493. A species past that has no entry, no category and no
height or weight, which is why catching one records nothing rather than
crashing: the Dex simply has nothing to say about it.

The strings come from the reference's own species table, which carries them
beside the base stats. The formatting does not: heights and weights are right
aligned in a fixed field with thin spaces, and the rule is recovered from the
rows the game already has rather than guessed.

Rows 494 to 507 are the egg and the alternate forms. They are never Dex
numbers, but the banks are indexed by species, so they take their base
species' text to keep everything after them in place.

Usage: import_dex_text.py REFERENCE_CHECKOUT [--write]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MESSAGES = ROOT / "files/msgdata/msg"

sys.path.insert(0, str(Path(__file__).resolve().parent))
import import_species  # noqa: E402

FIRST_ADDED = 508
# Where the added species stop is whatever the species header says now, not a
# number written here: the expansion moved it once already.
LAST_ADDED = FIRST_ADDED + len(import_species.added_species()) - 1

# The egg, the bad egg, and the forms that are not Dex numbers of their own.
FORM_BASES = {
    496: 386, 497: 386, 498: 386,   # Deoxys
    499: 413, 500: 413,             # Wormadam
    501: 487,                       # Giratina
    502: 492,                       # Shaymin
    503: 479, 504: 479, 505: 479, 506: 479, 507: 479,  # Rotom
}

THIN = " "
WEIGHT_FIELD = 6
HEIGHT_FIELD = 7

# What each bank holds, by the field of the reference's species text. A bank
# named for a language other than this build's keeps the English string: the
# Dex reads those only for a Pokemon traded from another language, and one of
# these species cannot arrive that way, but the row has to exist all the same.
BANKS = {
    "0803": "entry", "0804": "entry",
    "0805": "entry", "0806": "entry", "0807": "entry",
    "0808": "entry", "0809": "entry", "0810": "entry",
    "0811": "blank",
    "0812": "weight", "0813": "weight",
    "0814": "height", "0815": "height",
    "0816": "category",
    "0817": "name", "0818": "name", "0819": "name",
    "0820": "name", "0821": "name", "0822": "name",
    "0823": "category", "0824": "category", "0825": "category",
    "0826": "category", "0827": "category", "0828": "category",
    "0238": "article",
}

ROW = re.compile(
    r'<row id="([^"]*)" index="(\d+)">\s*'
    r'(?:<attribute name="window_context_name">([^<]*)</attribute>\s*)?'
    r'<language name="English">(.*?)</language>\s*</row>', re.S)


def rows(bank):
    text = (MESSAGES / f"msg_{bank}.gmm").read_text()
    return {int(m.group(2)): m.group(4) for m in ROW.finditer(text)}


def pad(value, width):
    """Right align in a fixed field, the way the game's own rows are."""
    return THIN * max(0, width - len(value)) + value


def article(name):
    return f"a{'n' if name[0].upper() in 'AEIOU' else ''} {{COLOR 255}}{name.upper()}{{COLOR 0}}"


def text_data(reference):
    """The five strings the reference keeps beside each species' stats."""
    source = (reference / "data/Species.c").read_text(errors="replace")
    found = {}
    for match in re.finditer(r"\[SPECIES_([A-Z0-9_]+)\] = \{\s*\.textData = \{(.*?)\n        \},", source, re.S):
        block = match.group(2)
        def field(name):
            m = re.search(rf'\.{name} = "([^"]*)",', block)
            # The reference is C, so a line break inside an entry is written
            # with the backslash escaped; a message bank writes it plain.
            return m.group(1).replace("\\\\n", "\\n") if m else ""
        found[match.group(1)] = {
            "name": field("name"),
            "entry": field("pokedexEntry"),
            "category": field("classification"),
            "height": field("height"),
            "weight": field("weight"),
        }
    return found


def wanted(bank, kind, data, name):
    if kind == "blank":
        return ""
    if kind == "article":
        return article(name)
    if kind == "weight":
        number, _, unit = data["weight"].partition(" ")
        return pad(number, WEIGHT_FIELD) + (f" {unit}" if unit else "")
    if kind == "height":
        return pad(data["height"], HEIGHT_FIELD)
    if kind == "name":
        # The names are this repository's own, already imported into msg_0237.
        # The reference leaves some of them in the shouting case the old games
        # used, and two of them as placeholders.
        return name
    return data[kind]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    data = text_data(args.reference)
    # The reference gives a form no text of its own -- "-----" for a name and
    # nothing for an entry -- and shows its base's; here the form is a species
    # and takes the base's text outright.
    for form, base in import_species.base_species_of(args.reference).items():
        if form in data and base in data and not data[form]["entry"]:
            data[form] = dict(data[base])
    bases = import_species.base_species_of(args.reference)
    forms = set()
    added = {}
    for offset, name in enumerate(import_species.added_species()):
        if name in bases:
            forms.add(FIRST_ADDED + offset)
        if name not in data:
            raise SystemExit(f"the reference has no text for SPECIES_{name}")
        added[FIRST_ADDED + offset] = (name, data[name])
    last = int(re.search(r"#define SPECIES_" + re.search(
        r"#define NUM_SPECIES SPECIES_([A-Z0-9_]+)",
        (ROOT / "include/constants/species.h").read_text()).group(1) + r"\s+(\d+)",
        (ROOT / "include/constants/species.h").read_text()).group(1))
    if LAST_ADDED != last:
        raise SystemExit(f"the added species end at {LAST_ADDED}, the header at {last}")

    names = rows("0237")
    changed = 0
    for bank, kind in sorted(BANKS.items()):
        path = MESSAGES / f"msg_{bank}.gmm"
        have = rows(bank)
        additions = []
        for index in range(494, LAST_ADDED + 1):
            if index in have and index not in forms:
                continue
            if index in FORM_BASES:
                value, tag = have.get(FORM_BASES[index], ""), f"form_{index}"
            elif index in added:
                key, entry = added[index]
                value = wanted(bank, kind, entry, names.get(index, entry["name"]))
                tag = key.lower()
            else:
                value, tag = "", f"unused_{index}"
            additions.append((index, tag, value))
        if not additions:
            continue
        changed += len(additions)
        print(f"  msg_{bank}: {len(additions)} rows ({kind})")
        if not args.write:
            continue
        block = "".join(
            f'\t<row id="msg_{bank}_{tag}" index="{index}">\n'
            f'\t\t<attribute name="window_context_name">used</attribute>\n'
            f'\t\t<language name="English">{value}</language>\n'
            f"\t</row>\n"
            for index, tag, value in additions)
        # A row this writes replaces the one it wrote last time. Appending
        # instead left each form's rows two and three times over, and the
        # game reads the first: the two Galarian lines showed an empty entry.
        # Earlier runs also left some rows twice; the first is the one the
        # game reads, so a later copy of any row goes.
        rewritten = {index for index, _, _ in additions}
        kept = set()
        def keep(m):
            index = int(m.group(1))
            if index in rewritten or index in kept:
                return ""
            kept.add(index)
            return m.group(0)
        text = re.sub(r'\t<row id="[^"]*" index="(\d+)">.*?\t</row>\n', keep, path.read_text(), flags=re.S)
        path.write_text(text.replace("</body>", block + "</body>"))

    print(f"{changed} rows in {len(BANKS)} banks")
    if not args.write:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
