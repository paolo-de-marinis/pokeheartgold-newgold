#!/usr/bin/env python3
"""The catching demonstration's first turn cannot knock the Rattata out.

BattleSetup_New_Tutorial gives the player a Lv. 5 Marill against a Lv. 2
Rattata, and the demonstration's first turn is Marill's first move
(BattleInput_CatchingTutorialCB_Move touches move 1), always hitting and never
a critical hit. Should that knock the Rattata out, the demonstration would
end before its throw, and retail's CalcExpGain would pay experience for a
battle the player does not keep.

Marill's moves are its learnset up to its level as InitBoxMonMoveset fills
them: each new one appended, the oldest dropped when four are known. With
this tree's learnset, six moves at level 1, the first left is Tail Whip, a
status move. A learnset change that puts a damaging move first fails here, to
be checked against the Rattata's HP.
"""

import re
import sys
import unittest

from test_level_cap import ROOT
from test_move_effects import moves, records

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import wotbl  # noqa: E402


def moveset(species, level):
    known = []
    for entry in wotbl.decode(wotbl.read_narc(wotbl.ARCHIVE.read_bytes())[0][species]):
        if entry["level"] > level:
            break
        if entry["move"] in known:
            continue
        if len(known) == 4:
            known.pop(0)
        known.append(entry["move"])
    return known


class CatchingDemonstrationTests(unittest.TestCase):
    def test_marill_opens_with_a_move_that_does_no_damage(self):
        setup = (ROOT / "src/battle/battle_setup.c").read_text()
        tutorial = setup[setup.index("BattleSetup *BattleSetup_New_Tutorial("):]
        (player, level), _ = re.findall(r"CreateMon\(pokemon, SPECIES_(\w+), (\d+),", tutorial)[:2]
        species = int(re.search(rf"#define SPECIES_{player}\s+(\d+)", (ROOT / "include/constants/species.h").read_text()).group(1))
        first = moveset(species, int(level))[0]
        name = {number: name for name, number in moves().items()}[first]
        power = records()[first][2]
        self.assertEqual((player, name, power), ("MARILL", "TAIL_WHIP", 0))


if __name__ == "__main__":
    unittest.main()
