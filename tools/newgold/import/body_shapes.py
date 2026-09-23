#!/usr/bin/env python3
"""Each species' body shape, as the games' Pokedex gives it.

The Dex's body-style search needs a shape for every species, and the
reference has none past Arceus: data/Species.c gives every added species
DEX_SEARCH_BODYTYPE_QUADRUPED as a placeholder. body_shapes.csv keeps the
shape of every National Dex number, 1 to 14 in the order the games' Pokedex
has used since Generation VI (Body01 a head only ... Body14 insectoid).

The source is Bulbapedia's "List of Pokemon by shape", kept from the games'
own Pokedex (Pokemon HOME for the newest species), at the revision named
below; --fetch reads it again. It agrees with PokeAPI's pokemon_species.csv
on 1024 of the 1025 (Sneasler: tailless here, tailed there). Pokemon
Central's infoboxes were read first and disagree with both on 36, plainly
wrong in most -- Nuzleaf a head only, Baxcalibur with two pairs of wings,
Koraidon on four legs -- so they are not used.

HeartGold's Dex orders the shapes its own way; SHAPE_TO_STYLE maps one to
the other. Retail's 493 keep retail's shapes: the later games moved nine
of them (Caterpie, Weedle, Wurmple, Burmy, Wormadam, Vespiquen, Shellos,
Gastrodon, Cresselia), and HeartGold's own Dex is not changed here.

    body_shapes.py --fetch
"""
import argparse
import csv
import re
import sys
import urllib.request
from pathlib import Path

CSV = Path(__file__).resolve().parent / "body_shapes.csv"
SOURCE = ("https://bulbapedia.bulbagarden.net/w/index.php"
          "?title=List_of_Pok%C3%A9mon_by_shape&oldid=4616890&action=raw")
LAST = 1025  # Pecharunt

# the games' shape (BodyNN) -> this Dex's DEX_SEARCH_BODYTYPE_*
SHAPE_TO_STYLE = {
    1: 12,   # head only
    2: 3,    # serpentine
    3: 11,   # fins
    4: 8,    # head and arms
    5: 7,    # head and base
    6: 2,    # bipedal with a tail
    7: 9,    # head and legs
    8: 0,    # quadruped
    9: 5,    # one pair of wings
    10: 10,  # tentacles or many legs
    11: 13,  # several bodies
    12: 1,   # bipedal without a tail
    13: 4,   # two or more pairs of wings
    14: 6,   # insectoid
}


def styles():
    """National Dex number -> this Dex's body style."""
    with CSV.open(newline="") as f:
        return {int(row["ndex"]): SHAPE_TO_STYLE[int(row["shape"])] for row in csv.DictReader(f)}


def parse(text):
    """{ndex: (name, shape)} from the list's wikitext: one section a shape,
    one {{Pokeli|NNNN|Name|form|label}} a Pokemon. A species is its entry
    with no form; one listed only by form (Wormadam, Wishiwashi, Toxtricity,
    Urshifu) is its first form, the default."""
    text = text[text.index("==List of Pokémon by shape=="):text.index("==In other languages==")]
    base, first = {}, {}
    for section in re.split(r"^===", text, flags=re.M)[1:]:
        shape = int(re.match(r"\[\[File:Body(\d\d)\.png", section).group(1))
        for m in re.finditer(r"\{\{Pokeli\|(\d+)\|([^|}]+)(?:\|([^|}]*))?", section):
            ndex, name, form = int(m.group(1)), m.group(2), m.group(3) or ""
            first.setdefault(ndex, (name, shape))
            if not form:
                if base.setdefault(ndex, (name, shape)) != (name, shape):
                    raise SystemExit(f"{ndex} {name}: two shapes")
    return {ndex: base.get(ndex, first.get(ndex)) for ndex in range(1, LAST + 1)}


def fetch():
    request = urllib.request.Request(SOURCE, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(request, timeout=60) as response:
        shapes = parse(response.read().decode("utf-8"))
    missing = [ndex for ndex, value in shapes.items() if value is None]
    if missing:
        raise SystemExit(f"no shape for {missing}")
    with CSV.open("w", newline="") as f:
        writer = csv.writer(f, lineterminator="\n")
        writer.writerow(["ndex", "name", "shape"])
        writer.writerows((ndex, name, shape) for ndex, (name, shape) in sorted(shapes.items()))
    print(f"wrote {len(shapes)} shapes to {CSV.name}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--fetch", action="store_true", help="read every shape from the list again")
    if not parser.parse_args().fetch:
        parser.print_help(sys.stderr)
        return
    fetch()


if __name__ == "__main__":
    main()
