"""The catching demonstration's Marill uses Tackle (Paolo, 2026-10-02): the
demonstration always picks the first move (BattleInput_CatchingTutorialCB_Move,
CURSOR_INPUT_MOVE_1) and then says "I got its HP down!", and this game's
learnset gives a level-5 Marill Tail Whip there, where retail's gave Tackle."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


class CatchingDemo(unittest.TestCase):
    def test_the_marill_s_first_move_is_tackle(self):
        source = (ROOT / "src/battle/battle_setup.c").read_text()
        body = source[source.index("BattleSetup *BattleSetup_New_Tutorial("):]
        body = body[:body.index("\n}\n")]
        marill = body[body.index("SPECIES_MARILL"):body.index("SPECIES_RATTATA")]
        self.assertIn("MonSetMoveInSlot(pokemon, MOVE_TACKLE, 0);", marill)
        self.assertLess(marill.index("MOVE_TACKLE"), marill.index("Party_AddMon"))


if __name__ == "__main__":
    unittest.main()
