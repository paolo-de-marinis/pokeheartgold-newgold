#!/usr/bin/env python3
"""Every Pokemon that can be female has a female picture.

The game reads the female member of pokegra.narc for every female Pokemon,
so the repository keeps a female picture for every species that can be
female -- the male one again where there is no difference -- and leaves a
gender's files empty only where that gender does not exist. An importer that
left the female empty when it matched the male sent 504 species' females
into a data abort on the way into battle (2026-09-22, a female Sylveon
against Falkner).

A species listed in tools/newgold/import/own_art.py has pictures Paolo had
drawn (docs/newgold/DEVKIT-PROMPTS.md) where the reference has a
placeholder, written into the tree by convert_chatgpt.py. Every importer
that writes those files has to keep the tree's for it: one that copied the
reference's again would put Bulbasaur's battle pictures back on Bramblin.
"""

import json
import os
import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT, function

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_followers  # noqa: E402
import import_icons  # noqa: E402
import import_species  # noqa: E402
import import_sprites  # noqa: E402
import own_art  # noqa: E402

SPRITES = ROOT / "files/poketool/pokegra/pokegra"
REFERENCE = Path(os.environ.get("HG_ENGINE_NEWGOLD_REFERENCE", import_followers.REFERENCE))


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
        mapping = re.search(r"^u16 PicSpecies_FemaleForm\(.*?^\}", pokemon, re.M | re.S)
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

    def test_the_picture_and_its_height_ask_the_female_form(self):
        """The mapping above only counts if the two functions that draw a
        picture from a species and a gender -- the picture and palette, and
        the picture's height -- send the base's female to it."""
        pokemon = (ROOT / "src/pokemon.c").read_text()
        for name in ("GetMonSpriteCharAndPlttNarcIdsEx", "GetMonPicHeightBySpeciesGenderForm"):
            with self.subTest(function=name):
                self.assertIn("PicSpecies_FemaleForm(species, gender)", function(pokemon, name))


def palette_table():
    source = import_icons.INDEX.read_text()
    start = source.index("sPokemonPalNoBySpeciesAndForm[] = {")
    return [int(v) for v in re.findall(r"^\s*(\d+),", source[start:source.index("\n};", start)], re.M)]


def icon_of(name):
    return import_icons.ICONS / f"poke_icon_{import_icons.first_added_icon() + import_species.added_species().index(name):08d}.png"


def member_of(name):
    header = import_followers.MMODEL_H.read_text()
    return int(re.search(rf"^#define MMODEL_FOLLOWER_MON_{name}\s+(\d+)", header, re.M).group(1))


class OwnArtImportTests(unittest.TestCase):
    def test_the_list_names_species_the_tree_has(self):
        self.assertIn("BRAMBLIN", own_art.SPECIES)
        self.assertEqual(set(own_art.SPECIES) - set(import_species.added_species()), set())

    def test_the_battle_pictures_are_not_copied_again(self):
        """import_sprites.py copies every added species' battle pictures but
        Paolo's."""
        copied = import_sprites.species_to_copy()
        self.assertEqual(set(own_art.SPECIES) & set(copied), set())
        self.assertEqual(len(copied), len(import_species.added_species()) - len(own_art.SPECIES))

    def test_the_icon_and_its_palette_are_the_tree_s(self):
        """import_icons.py keeps the tree's icon, and gives it the shared
        palette that icon is drawn in, which is the table's."""
        if not REFERENCE.exists():
            self.skipTest("no reference checkout")
        plan = {name: (picture, number) for name, picture, number, _theirs in import_icons.plan(REFERENCE)}
        first = import_species.added_species().index
        header = (ROOT / "include/pokemon_icon_idx.h").read_text()
        first_palette = int(re.search(r"#define FIRST_ADDED_PALETTE\s+(\d+)", header).group(1))
        for name in own_art.SPECIES:
            picture, number = plan[name]
            self.assertEqual(picture, icon_of(name), name)
            self.assertEqual(number, import_icons.drawn_in(icon_of(name), import_icons.shared_palettes()), name)
            self.assertEqual(palette_table()[first_palette + first(name)], number, name)

    def test_the_follower_is_the_tree_s(self):
        """import_followers.py keeps the texture the tree has for the species,
        at whatever member it writes it to."""
        for name in own_art.SPECIES:
            kept = (import_followers.MMODEL_DIR / f"mmodel_{member_of(name):08d}.NSBTX").read_bytes()
            self.assertEqual(import_followers.texture(name, f"data/graphics/sprites/{name.lower()}"), kept, name)


if __name__ == "__main__":
    unittest.main()
