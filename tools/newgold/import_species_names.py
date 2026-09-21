#!/usr/bin/env python3
"""Add the new species' names to the species name bank.

Names are read out of files/msgdata/msg/msg_0237.gmm by species number, so the
rows have to reach as far as the last species. The rows between the bad egg and
the first added species belong to the alternate forms, which are named by their
base species, so they are filled with the placeholder the bank already uses for
nothing.

Usage: import_species_names.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BANK = ROOT / "files/msgdata/msg/msg_0237.gmm"

import import_species  # noqa: E402

PLACEHOLDER = "-----"

ROW = """\t<row id="msg_0237_{identifier}" index="{index}">
\t\t<attribute name="window_context_name">used</attribute>
\t\t<language name="English">{text}</language>
\t</row>
"""


# A regional form has no name of its own in the reference: it is a form of
# something, and the game shows the base species' name. Here they are species
# in their own right, so the name has to be said.
FORM_NAMES = {
    "SLOWPOKE_GALARIAN": "Slowpoke",
    "SLOWBRO_GALARIAN": "Slowbro",
}


def species_names(reference):
    """The display name the reference gives each species."""
    source = (reference / "data/Species.c").read_text(errors="replace")
    blocks = re.split(r"\n    \[(SPECIES_[A-Z0-9_]+)\] = \{", source)
    names = {}
    for index in range(1, len(blocks), 2):
        match = re.search(r'\.name\s*=\s*"([^"]*)"', blocks[index + 1])
        if match:
            names[blocks[index][len("SPECIES_"):]] = match.group(1)
    return names


def species_id(name):
    header = (ROOT / "include/constants/species.h").read_text()
    return int(re.search(rf"#define SPECIES_{name}\s+(\d+)", header).group(1))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    bank = BANK.read_text()
    present = {int(m) for m in re.findall(r'<row id="[^"]*" index="(\d+)">', bank)}
    # Rewrite from the first added species rather than from the end of the
    # bank, so running this again after a species is added says the same thing
    # about the ones already there.
    first = species_id(import_species.added_species()[0])
    last = species_id(import_species.added_species()[-1])
    bank = re.sub(r'\t<row id="[^"]+" index="(\d+)">.*?\t</row>\n',
                  lambda m: "" if int(m.group(1)) >= first else m.group(0), bank, flags=re.S)
    print(f"the bank names {len(present)} rows, 0 to {max(present)}; "
          f"rewriting {first} to {last}")

    names = species_names(args.reference)
    for name, text in FORM_NAMES.items():
        names[name] = text

    missing = [name for name in import_species.added_species() if name not in names]
    if missing:
        raise SystemExit(f"the reference has no name for: {', '.join(missing)}")

    wanted = {species_id(name): (name.lower(), names[name]) for name in import_species.added_species()}
    rows = []
    for index in range(first, last + 1):
        identifier, text = wanted.get(index, (f"unused_{index}", PLACEHOLDER))
        rows.append(ROW.format(identifier=identifier, index=index, text=text))

    padded = sum(1 for index in range(first, last + 1) if index not in wanted)
    print(f"{len(rows)} rows to add: {len(wanted)} names and {padded} placeholders "
          f"for the alternate forms between them")
    print("first names:", ", ".join(names[n] for n in import_species.added_species()[:5]))

    if not args.write:
        print("nothing written; pass --write")
        return
    BANK.write_text(bank.replace("</body>", "".join(rows) + "</body>"))
    print(f"wrote {BANK.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
