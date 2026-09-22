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
import unittest

from test_level_cap import ROOT

SPRITES = ROOT / "files/poketool/pokegra/pokegra"


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


if __name__ == "__main__":
    unittest.main()
