#!/usr/bin/env python3
"""A battle line about a Pokemon comes in threes.

For every TAG_NICKNAME-family message the game adds one to the row when the
Pokemon is the wild one and two when it is a trainer's (battle_system.c,
BattleMessage tag handling), so a line imported on its own prints whatever
happens to follow it once the opponent uses the move. Twelve of the imported
lines were like that: a foe's Laser Focus said it was covered in powder.
"""

import re
import unittest

from test_level_cap import ROOT

FIRST_IMPORTED_ROW = 1322
NICKNAME_TAGS = ("TAG_NICKNAME", "TAG_MOVE_NICKNAME", "TAG_ABILITY_NICKNAME", "TAG_ITEM_NICKNAME_FLAVOR")


def rows():
    text = (ROOT / "files/msgdata/msg/msg_0197.gmm").read_text()
    return {int(m.group(1)): m.group(2) for m in
            re.finditer(r'<row id="msg_0197_\d+" index="(\d+)">.*?<language name="English">(.*?)</language>', text, re.S)}


class BattleMessageTests(unittest.TestCase):
    def test_every_imported_nickname_line_has_its_wild_and_opposing_rows(self):
        table = rows()
        loose = []
        for path in sorted((ROOT / "files/battledata/script").rglob("*.s")):
            for m in re.finditer(r"PrintMessage msg_0197_(\d+), (TAG_\w+)", path.read_text(errors="replace")):
                row, tag = int(m.group(1)), m.group(2)
                if row < FIRST_IMPORTED_ROW or not tag.startswith(NICKNAME_TAGS):
                    continue
                if "wild" not in table.get(row + 1, "").lower() or "opposing" not in table.get(row + 2, "").lower():
                    loose.append(f"{path.name}: row {row} {table.get(row, '')[:40]!r}")
        self.assertEqual(loose, [], "printed about a Pokemon, with no wild or opposing row after it:\n" + "\n".join(loose))


if __name__ == "__main__":
    unittest.main()
