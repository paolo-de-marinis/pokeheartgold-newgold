#!/usr/bin/env python3
"""Every Pokemon that can be female has a female picture.

The game reads the female member of pokegra.narc for every female Pokemon,
so the repository keeps a female picture for every species that can be
female -- the male one again where there is no difference -- and leaves a
gender's files empty only where that gender does not exist. An importer that
left the female empty when it matched the male sent 504 species' females
into a data abort on the way into battle (2026-09-22, a female Sylveon
against Falkner).
"""

import json
import re
import unittest

from test_level_cap import ROOT, function

SPRITES = ROOT / "files/poketool/pokegra/pokegra"


def species_numbers():
    text = (ROOT / "include/constants/species.h").read_text()
    return {m.group(1): int(m.group(2)) for m in re.finditer(r"#define SPECIES_(\w+)\s+(\d+)\b", text)}


class SpriteTests(unittest.TestCase):
    def test_every_gender_a_species_can_be_has_its_pictures(self):
        personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        missing = []
        for species in range(1, len(personal)):
            if 494 <= species <= 507:
                continue  # the egg, the bad egg and the retail forms live in otherpoke.narc
            ratio = personal[species]["genderRatio"]
            genders = (["male"] if ratio < 1 else []) + (["female"] if 0 < ratio <= 1 else [])
            for gender in genders:
                for name in ("front.png", "back.png"):
                    if (SPRITES / f"{species:04d}" / gender / name).stat().st_size == 0:
                        missing.append(f"{species:04d}/{gender}/{name}")
        self.assertEqual(missing, [], "a picture the game will ask for is empty:\n" + "\n".join(missing[:20]))

    def test_every_gender_the_dex_records_draws_a_picture(self):
        """The Dex draws a species' picture in the gender it saw: its own
        genders and those of its forms, which count for it
        (SpeciesToDexSpecies). A female Meowstic is MEOWSTIC_FEMALE and the
        base is male-only, so the Dex asks for Meowstic, female: the picture
        code has to send that to the female species."""
        personal = json.loads((ROOT / "files/poketool/personal/personal.json").read_text())["baseStats"]
        numbers = species_numbers()
        pokemon = (ROOT / "src/pokemon.c").read_text()
        sprite = function(pokemon, "GetMonSpriteCharAndPlttNarcIdsEx")
        own_case = {numbers.get(name) for name in re.findall(r"case SPECIES_(\w+):", sprite[:sprite.index("default:")])}
        mapping = re.search(r"^static u16 PicSpecies_FemaleForm\(.*?^\}", pokemon, re.M | re.S)
        female_form = {numbers[a]: numbers[b] for a, b in re.findall(
            r"case SPECIES_(\w+):\s*return SPECIES_(\w+);", mapping.group(0) if mapping else "")}
        bases = {numbers[form]: numbers[base] for form, base in re.findall(
            r"\[SPECIES_(\w+) - NATIONAL_DEX_COUNT - 1\] = SPECIES_(\w+),", (ROOT / "src/pokedex.c").read_text())}
        recorded = {}
        for species in range(1, len(personal)):
            if 494 <= species <= 507:
                continue
            ratio = personal[species]["genderRatio"]
            genders = (["male"] if ratio != 1 else []) + (["female"] if 0 < ratio <= 1 else [])
            recorded.setdefault(bases.get(species, species), set()).update(genders)
        missing = []
        for species, genders in sorted(recorded.items()):
            if species in own_case:
                continue  # otherpoke.narc, by form
            for gender in sorted(genders):
                drawn = female_form.get(species, species) if gender == "female" else species
                if (SPRITES / f"{drawn:04d}" / gender / "front.png").stat().st_size == 0:
                    missing.append(f"{species:04d} {gender} -> {drawn:04d}/{gender}/front.png")
        self.assertEqual(missing, [], "the Dex draws an empty picture:\n" + "\n".join(missing))


if __name__ == "__main__":
    unittest.main()
