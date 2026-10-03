"""The lines a move that does not land prints are the latest games' (Paolo,
2026-10-02): from the fifth generation every miss names the Pokemon that
avoided it -- Scarlet and Violet's English text has no "attack missed" line
(common_eng.txt 6341 to 6344), and Showdown's gen-9 code sends every miss as
'-miss' with the target -- and a move with no one left to hit fails, '-fail'
where the fourth generation sent '-notarget'."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"


def read(name):
    return (SUBSCRIPTS / name).read_text()


class MissLines(unittest.TestCase):
    def test_every_miss_names_the_pokemon_that_avoided_it(self):
        """Subscript 7's plain miss, a single-target move's as a spread
        move's: "{0} avoided the attack!" for the target, never HeartGold's
        "{0}'s attack missed!" (msg_0197_00012) for the attacker."""
        miss = read("subscript_0007_Miss.s")
        self.assertNotIn("msg_0197_00012", miss)
        plain = miss[miss.index("_CHECK_RANGE:"):miss.index("_PRINT_MSG:")]
        self.assertEqual(plain.count("PrintMessage"), 1, plain)
        self.assertIn("PrintMessage msg_0197_00024, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER", plain)

    def test_a_move_with_no_target_fails(self):
        """Subscripts 281 (any move) and 282 (Bide's stored energy) print
        "But it failed!" (msg_0197_00796), not HeartGold's "But there was no
        target..." (msg_0197_01234)."""
        for name in ("subscript_0281_NoTarget.s", "subscript_0282_BideNoTarget.s"):
            with self.subTest(name):
                script = read(name)
                self.assertNotIn("msg_0197_01234", script)
                self.assertIn("PrintMessage msg_0197_00796, TAG_NONE", script)


if __name__ == "__main__":
    unittest.main()
