#!/usr/bin/env python3
"""Give the added species rows in the Dex's foreign-language banks.

The Dex keeps a species' entry, name and category once per language: 805..810
the entries, 818..822 the names, 824..828 the categories. It reads them only
for a Pokemon from another language's game, and one of the added species
cannot arrive that way, but the banks are indexed by species, so each of them
has to reach the last one. 804, written here with them, is not another
language's: it is SoulSilver's own entries, as 803 is HeartGold's
(ZUKAN_FLAVOR_GMM in ov18_021E590C.c), printed for every species. hg-engine
leaves these banks as retail's; the rows past 493 are this port's own, in
English:

- an added species takes the reference's entry and category (a form, which has
  none of its own there, takes its base's), and its name as msg_0237 has it;
  an entry too wide for the Dex's window is broken again as msg_0803's is
  (import_species_text.fit_entry);
- the egg and the bad egg are blank, and the retail alternate forms 496..507
  take their base species' row from the same bank.

The English banks (237, 238, 803, 811..817, 823) are hg-engine's and are
written by import_species_text.py; run that first, since the names come from
msg_0237. Species.c is read at a revision (the engine, d0380a487, by default).
Each bank is written whole and in index order.

Usage: import_dex_text.py [--revision REV] [--write]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gmm  # noqa: E402
import import_species  # noqa: E402
import import_species_text  # noqa: E402

FIRST_ADDED = 508
LAST_ADDED = FIRST_ADDED + len(import_species.added_species()) - 1

# The egg, the bad egg, and the forms that are not Dex numbers of their own.
FORM_BASES = {
    496: 386, 497: 386, 498: 386,   # Deoxys
    499: 413, 500: 413,             # Wormadam
    501: 487,                       # Giratina
    502: 492,                       # Shaymin
    503: 479, 504: 479, 505: 479, 506: 479, 507: 479,  # Rotom
}

BANKS = {bank: "entry" for bank in range(804, 811)}
BANKS.update({bank: "name" for bank in range(818, 823)})
BANKS.update({bank: "category" for bank in range(824, 829)})


def text_data(revision):
    """SPECIES_ name -> entry and category; a form with no entry of its own
    takes its base's record (the table lists a form after its base, so a
    Gigantamax Low Key Toxtricity finds Low Key already filled)."""
    data = {name: {"entry": fields["pokedexEntry"], "category": fields["classification"]}
            for name, fields in import_species_text.text_data(revision).items()}
    for form, base in import_species_text.base_species(revision).items():
        if form in data and base in data and not data[form]["entry"]:
            data[form] = dict(data[base])
    return data


def wanted(kind, data, name):
    """A row's text; an entry broken for the Dex's window as msg_0803's is."""
    if kind == "name":
        return name
    return gmm.escape(import_species_text.fit_entry(data[kind]) if kind == "entry" else data[kind])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    data = text_data(args.revision)
    species = import_species_text.port_species()
    if max(species) != LAST_ADDED:
        raise SystemExit(f"the added species end at {LAST_ADDED}, the header at {max(species)}")
    names = {row["index"]: row["text"] for row in gmm.read(237)}

    for bank, kind in sorted(BANKS.items()):
        rows = gmm.read(bank)
        changed = 0
        for index in range(494, LAST_ADDED + 1):
            if index in FORM_BASES:
                text = rows[FORM_BASES[index]]["text"]
            elif index >= FIRST_ADDED:
                text = wanted(kind, data[species[index]], names[index])
            else:
                text = ""
            if index < len(rows):
                if rows[index]["text"] == text and rows[index]["context"] == "used":
                    continue
                rows[index] = dict(rows[index], text=text, context="used", extra="")
            else:
                rows.append(gmm.new_row(bank, index, text, f"msg_{bank:04d}_{species[index].lower()}"))
            changed += 1
        print(f"msg_{bank:04d}: {changed} rows ({kind})")
        if args.write and changed:
            gmm.write(bank, rows)
    if not args.write:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
