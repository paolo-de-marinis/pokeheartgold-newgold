#!/usr/bin/env python3
"""The species' text, as hg-engine generates it, at a revision.

hg-engine keeps each species' name, Dex entry, classification, height and
weight beside its stats in data/Species.c. tools/source/speciesdatagen writes
one field to each of ten banks, row = species -- name to 237, 238 and 817,
pokedexEntry to 803, classification to 816 and 823, height to 814 and 815,
weight to 812 and 813 -- and scripts/msg_cat.py finishes them: " becomes ”,
' and ` become ’, 817 is upper case, 238 takes "an " before a vowel and "a "
otherwise, and a non-empty height is padded on the left with spaces to 7
characters, a weight to 11. Bank 811 is a static data/text/811.txt.

This does the same at a revision (the engine, d0380a487, by default), with two
differences that come from this port's numbering, not from the text:

- A row is a port species, found in the reference by its SPECIES_ name: the
  two number the same species alike only up to 495. The retail alternate-form
  slots 496..507 have no name there; hg-engine keeps retail's form data at the
  same numbers as SPECIES_496..507, so those rows are the engine's rows at the
  same number.
- Forms are species here (1042..1437, and the Galarian Slowpoke and Slowbro at
  573/574), read by their own number. hg-engine names and describes a form
  through its base species, so its own rows for them are placeholders; where a
  form's field is one, the row takes the base species' field, which is what
  hg-engine shows. A form with a real value of its own keeps it.

811 is copied row for row: nothing reads it, and a row of spaces is written as
a garbage row, because msgenc encodes a used row of spaces as nothing.

Every bank is written whole and in index order (gmm.write), keeping each row's
id; a row that already encodes to the wanted text is left as it is.

Usage: import_species_text.py [--revision REV] [--write]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gmm  # noqa: E402

FIELDS = {237: "name", 238: "name", 817: "name", 803: "pokedexEntry",
          816: "classification", 823: "classification",
          814: "height", 815: "height", 812: "weight", 813: "weight"}
BLANK = 811
BANKS = sorted(FIELDS) + [BLANK]
UPPER = {817}              # msg_cat caps_list
ARTICLE = {238}            # msg_cat article_list
PAD = {812: 11, 813: 11, 814: 7, 815: 7}    # msg_cat force_lengths

# What hg-engine writes for a form that has nothing of its own to say.
PLACEHOLDERS = {"name": {"-----"}, "pokedexEntry": {"", "-----"},
                "classification": {"????? Pokémon"},
                "height": {"???’??”"}, "weight": {"????.? lbs."}}
RETAIL_FORM_SLOTS = range(496, 508)
TEXT_FIELD = re.compile(r'^\s*\.(name|pokedexEntry|classification|height|weight) = "((?:[^"\\]|\\.)*)",\s*$')


def unescape(literal):
    """A C string literal's body; Species.c escapes only \\ and "."""
    def one(m):
        if m.group(1) not in '\\"':
            raise SystemExit(f"an escape this does not read: \\{m.group(1)}")
        return m.group(1)
    return re.sub(r"\\(.)", one, literal)


def text_data(revision):
    """SPECIES_ name -> the five textData strings, from Species.c."""
    found, current = {}, None
    for line in gmm.git_show(revision, "data/Species.c").splitlines():
        m = re.match(r"^    \[SPECIES_(\w+)\] = \{", line)
        if m:
            current = found.setdefault(m.group(1), {})
            continue
        m = TEXT_FIELD.match(line)
        if m and current is not None and m.group(1) not in current:
            current[m.group(1)] = unescape(m.group(2))
    return found


def numbers(header, names):
    """SPECIES_ name -> number for these names, evaluating the reference's
    macro arithmetic."""
    defines = dict(re.findall(r"^#define (\w+)[ \t]+([^/\n]+)", header, re.M))
    cache = {}

    def value(name):
        if name not in cache:
            expression = re.sub(r"[A-Za-z_]\w*", lambda m: str(value(m.group(0))), defines[name].strip())
            if not re.fullmatch(r"[\d\s()+*-]+", expression):
                raise SystemExit(f"{name}: {expression}")
            cache[name] = eval(expression)  # digits and arithmetic only
        return cache[name]
    return {name: value(f"SPECIES_{name}") for name in names if f"SPECIES_{name}" in defines}


def port_species():
    """Port species number -> name, for every row the banks have."""
    header = (gmm.ROOT / "include/constants/species.h").read_text()
    by_number = {int(n): name for name, n in re.findall(r"#define SPECIES_([A-Z0-9_]+)\s+(\d+)\b", header)}
    assert sorted(by_number) == list(range(len(by_number))), "the port's species are not dense"
    return by_number


def base_species(revision):
    table = gmm.git_show(revision, "data/FormToSpeciesMapping.c")
    return dict(re.findall(r"\[SPECIES_(\w+) - SPECIES_MEGA_START\]\s*=\s*SPECIES_(\w+)", table))


def fields_by_port_row(revision):
    """Port row -> the five raw fields hg-engine gives that species."""
    data = text_data(revision)
    theirs = numbers(gmm.git_show(revision, "include/constants/species.h"), data)
    by_number = {}
    for name, number in theirs.items():
        by_number.setdefault(number, data[name])
    bases = base_species(revision)
    rows = {}
    for row, name in port_species().items():
        if name in data:
            fields = dict(data[name])
        elif row in RETAIL_FORM_SLOTS:
            fields = dict(by_number[row])
        else:
            raise SystemExit(f"SPECIES_{name} ({row}) has no text at {revision}")
        for field, blank in PLACEHOLDERS.items():
            # A Gigantamax Toxtricity Low Key's base is Low Key, itself a form.
            base = name
            while fields[field] in blank and base in bases:
                base = bases[base]
                fields[field] = data[base][field]
        rows[row] = fields
    return rows


def finish(bank, text):
    """scripts/msg_cat.py, then escaped for a gmm."""
    text = text.replace('"', "”").replace("'", "’").replace("`", "’")
    if bank in UPPER:
        text = text.upper()
    if bank in ARTICLE:
        text = ("an " if text.upper()[:1] in ("A", "E", "I", "O", "U") else "a ") + text
    if text and bank in PAD:
        text = text.rjust(PAD[bank])
    return gmm.escape(text)


def wanted(revision):
    """Bank -> the English text of every row, in index order."""
    rows = fields_by_port_row(revision)
    out = {bank: [finish(bank, rows[row][field]) for row in sorted(rows)] for bank, field in FIELDS.items()}
    out[BLANK] = gmm.reference_rows(revision, BLANK)
    return out


def encodes_as(row):
    """What msgenc makes of a row: a garbage row is that many spaces."""
    if row["context"] == "garbage":
        placeholder = re.search(r">(.*)</language>", row["extra"]).group(1)
        return " " * len(placeholder.encode("utf-8"))
    return row["text"] if row["text"].strip() else ""   # pugixml drops blank text


def rewrite(bank, texts):
    """The bank's rows with these texts, ids kept; returns (rows, changed)."""
    have = gmm.read(bank)
    rows, changed = [], 0
    for index, text in enumerate(texts):
        old = have[index] if index < len(have) else None
        if old is not None and encodes_as(old) == text:
            rows.append(old)
            continue
        changed += 1
        name = old["id"] if old else None
        if text and not text.strip(" "):
            rows.append(gmm.garbage_row(bank, index, len(text), name))
        else:
            rows.append(gmm.new_row(bank, index, text, name))
    return rows, changed + max(0, len(have) - len(texts))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    for bank, texts in wanted(args.revision).items():
        rows, changed = rewrite(bank, texts)
        print(f"msg_{bank:04d}: {len(rows)} rows, {changed} changed")
        if args.write and changed:
            gmm.write(bank, rows)
    if not args.write:
        print("nothing written; pass --write")


if __name__ == "__main__":
    main()
