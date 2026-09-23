#!/usr/bin/env python3
"""The battle messages, bank 197: hg-engine's rows, then the port's own.

For every TAG_NICKNAME-family message the game adds one to the row when the
Pokemon is the wild one and two when it is a trainer's (battle_system.c,
BattleSystem_AdjustMessageForSide), so a line written on its own prints
whatever happens to follow it once the opponent uses the move. Twelve of the
lines the port once imported were like that: a foe's Laser Focus said it was
covered in powder.

Rows 0 to 1786 are hg-engine's data/text/197.txt (import_battle_messages.py):
retail's rows reworded in place and the engine's own after them. The engine
reused some retail rows with other tags or for other lines, so the scripts and
C print them the way the engine does; and it has no text for a few lines this
port prints, which follow its last row.
"""

import re
import sys
import unittest

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import gmm  # noqa: E402
import import_battle_messages  # noqa: E402

ENGINE_ROWS = 1787
FIRST_PORT_ROW = ENGINE_ROWS
NICKNAME_TAGS = ("TAG_NICKNAME", "TAG_MOVE_NICKNAME", "TAG_ABILITY_NICKNAME", "TAG_ITEM_NICKNAME_FLAVOR")
SCRIPTS = ROOT / "files/battledata/script"

# How far past the row a tag can move it (BattleSystem_AdjustMessageForSide):
# a side tag by one, a Pokemon by two, two Pokemon by up to six.
SIDE_TAGS = ("TAG_NONE_SIDE", "TAG_MOVE_SIDE")
TWO_POKEMON_TAGS = ("TAG_NICKNAME_NICKNAME", "TAG_NICKNAME_ABILITY_NICKNAME", "TAG_NICKNAME_ITEM_NICKNAME")


def rows():
    text = (ROOT / "files/msgdata/msg/msg_0197.gmm").read_text()
    return {int(m.group(1)): m.group(2) for m in
            re.finditer(r'<row id="msg_0197_\d+" index="(\d+)">.*?<language name="English">(.*?)</language>', text, re.S)}


def reach(tag):
    if "0x80" in tag:
        return 0
    tag = tag.split("|")[0].strip()
    if tag in SIDE_TAGS:
        return 1
    if tag.startswith(TWO_POKEMON_TAGS):
        return 6
    if tag.startswith(NICKNAME_TAGS):
        return 2
    return 0


def script_messages():
    """(file, row, tag) for every message a battle script prints or buffers.
    PrintGlobalMessage sets 0x80 on the tag, which the side never moves."""
    found = []
    for path in sorted(SCRIPTS.rglob("*.s")):
        for line in path.read_text(errors="replace").splitlines():
            m = re.search(r"(\w+Message)\b.*?msg_0197_(\d+), (TAG_[\w |x0-9]*?)(,|$)", line)
            if m:
                tag = m.group(3) + (" | 0x80" if m.group(1) == "PrintGlobalMessage" else "")
                found.append((path.name, int(m.group(2)), tag))
    return found


def script(name):
    return next(SCRIPTS.rglob(name)).read_text()


class BattleMessageTests(unittest.TestCase):
    def test_every_port_nickname_line_has_its_wild_and_opposing_rows(self):
        table = rows()
        loose = []
        for name, row, tag in script_messages():
            if row < FIRST_PORT_ROW or not tag.startswith(NICKNAME_TAGS) or "0x80" in tag:
                continue
            if "wild" not in table.get(row + 1, "").lower() or "opposing" not in table.get(row + 2, "").lower():
                loose.append(f"{name}: row {row} {table.get(row, '')[:40]!r}")
        self.assertEqual(loose, [], "printed about a Pokemon, with no wild or opposing row after it:\n" + "\n".join(loose))

    def test_no_script_reaches_a_row_the_engine_left_unused(self):
        """The engine marks the retail rows it gave up "(Unused)": 662 to 668
        were Intimidate's, 682 to 685 the wild and foe Trace, 1124 to 1127 Bad
        Dreams. Printing one, or a row past the end, is a line nobody wrote."""
        self.assertTrue(script_messages())
        table = rows()
        wrong = []
        for name, row, tag in script_messages():
            for offset in range(reach(tag) + 1):
                text = table.get(row + offset)
                if text is None or "(unused)" in text.lower():
                    wrong.append(f"{name}: msg_0197_{row} as {tag} reaches {row + offset}: {text!r}")
        self.assertEqual(wrong, [], "\n".join(wrong))

    def test_no_c_message_is_a_row_the_engine_left_unused(self):
        table = rows()
        wrong = []
        for path in sorted((ROOT / "src").rglob("*.c")):
            for row in re.findall(r"msg_0197_(\d+)", path.read_text(errors="replace")):
                text = table.get(int(row))
                if text is None or "(unused)" in text.lower():
                    wrong.append(f"{path.name}: msg_0197_{row} {text!r}")
        self.assertEqual(wrong, [], "\n".join(wrong))

    def test_the_rows_the_engine_reused_are_printed_its_way(self):
        """The engine rewrote these retail rows and changed the scripts that
        print them, so the old tags would name the wrong Pokemon or reach the
        rows it emptied."""
        table = rows()
        cases = {
            "subscript_0183_Drizzle.s": ("00619", "TAG_NONE", "It started to rain!"),
            "subscript_0184_SandStream.s": ("00695", "TAG_NONE", "A sandstorm kicked up!"),
            "subscript_0364_SandSpit.s": ("00695", "TAG_NONE", "A sandstorm kicked up!"),
            "subscript_0185_Drought.s": ("00698", "TAG_NONE", "The sunlight turned harsh!"),
            "effect_script_0136.s": ("00619", "TAG_NONE", "It started to rain!"),
            "effect_script_0115.s": ("00695", "TAG_NONE", "A sandstorm kicked up!"),
            "effect_script_0137.s": ("00698", "TAG_NONE", "The sunlight turned harsh!"),
            "effect_script_0164.s": ("00701", "TAG_NONE", "It started to hail!"),
            "subscript_0187_Trace.s": ("00679", "TAG_NICKNAME_ABILITY, BATTLER_CATEGORY_MSG_DEFENDER,",
                                       "It traced {STRVAR_1 1, 0, 0}’s {STRVAR_1 5, 1, 0}!"),
            "subscript_0263_BadDreams.s": ("01121", "TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP",
                                           "{STRVAR_1 1, 0, 0} is tormented!"),
            "subscript_0264_SuperEffectiveBerries.s": ("01527", "TAG_NICKNAME_ITEM,",
                                                       "The {STRVAR_1 8, 1, 0} weakened\\nthe damage to {STRVAR_1 1, 0, 0}!"),
            "subscript_0300_Mummy.s": ("01306", "TAG_NICKNAME_ABILITY,", "{STRVAR_1 1, 0, 0}’s ability became Mummy!"),
        }
        for name, (row, tag, text) in cases.items():
            self.assertIn(f"msg_0197_{row}, {tag}", script(name), name)
            self.assertEqual(table[int(row)], text, name)
        self.assertIn("msg_0197_01453, TAG_NICKNAME_ABILITY,", script("subscript_0300_Mummy.s"),
                      "Lingering Aroma has its own line")
        # An ability's stat drop says only what fell, as the engine does.
        commands = (ROOT / "src/battle/battle_command.c").read_text()
        self.assertNotIn("tag = TAG_NICKNAME_ABILITY_NICKNAME_STAT", commands)
        self.assertNotIn("msg_0197_00662", commands)

    def test_the_port_rows_follow_the_engines_last(self):
        """Lines the port prints that the engine has no text for, and who
        prints them."""
        table = rows()
        self.assertEqual(max(table) + 1, FIRST_PORT_ROW + 37)
        expected = {
            "wandering spirit": (1787, "{STRVAR_1 1, 0, 0}’s Ability\\nbecame {STRVAR_1 5, 1, 0}!"),
            "belch": (1790, "{STRVAR_1 1, 0, 0} hasn’t eaten any held Berries,\\nso it can’t possibly belch!"),
            "snow continues": (1793, "The snow continues to fall."),
            "beat up": (1794, "{STRVAR_1 1, 0, 0}’s attack!"),
            "quick draw": (1797, "{STRVAR_1 1, 0, 0}\\ncan act faster than normal,\\fthanks to its {STRVAR_1 5, 1, 0}!"),
            "neutralizing gas": (1800, "Neutralizing gas filled the area!"),
            "neutralizing gas ends": (1801, "The effects of the neutralizing gas\\nwore off!"),
            "cud chew": (1802, "{STRVAR_1 1, 0, 0} ate its\\n{STRVAR_1 8, 1, 0} again!"),
            "tera shell": (1805, "{STRVAR_1 1, 0, 0} made its shell gleam!\\nIt’s distorting type matchups!"),
            "battle bond": (1808, "{STRVAR_1 1, 0, 0} became fully charged due\\nto its bond with its Trainer!"),
        }
        for name, (row, text) in expected.items():
            self.assertEqual(import_battle_messages.port_row(name), row, name)
            self.assertEqual(table[row], text, name)
        self.assertIn("msg_0197_01787, TAG_NICKNAME_ABILITY", script("subscript_0366_WanderingSpirit.s"))
        self.assertIn("msg_0197_01797, TAG_NICKNAME_ABILITY", script("subscript_0278_CheckQuickClaw.s"))
        self.assertIn("msg_0197_01800, TAG_NONE", script("subscript_*_NeutralizingGas.s"))
        self.assertIn("msg_0197_01801, TAG_NONE", script("subscript_*_NeutralizingGasEnd.s"))
        self.assertIn("msg_0197_01802, TAG_NICKNAME_ITEM", script("subscript_*_CudChew.s"))
        self.assertIn("msg_0197_01805, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP", script("subscript_*_TeraShell.s"))
        self.assertIn("msg_0197_01808, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP", script("subscript_*_BattleBond.s"))
        # Rows added since, found by name so that a merge can renumber them.
        for name, text, tag, where in (
            ("supreme overlord", "{STRVAR_1 1, 0, 0} gained strength\\nfrom the fallen!",
             "TAG_NICKNAME", "subscript_*_SupremeOverlord.s"),
            ("curious medicine", "{STRVAR_1 1, 0, 0}’s stat changes\\nwere removed!",
             "TAG_NICKNAME", "subscript_*_CuriousMedicine.s"),
            ("symbiosis", "{STRVAR_1 1, 0, 0} shared its\\n{STRVAR_1 8, 1, 0} with {STRVAR_1 1, 2, 0}!",
             "TAG_NICKNAME_ITEM_NICKNAME", "subscript_*_Symbiosis.s"),
        ):
            row = import_battle_messages.port_row(name)
            self.assertEqual(table[row], text, name)
            self.assertIn(f"msg_0197_{row:05d}, {tag}", script(where), name)
        self.assertIn("msg_0197_01790, TAG_NICKNAME", script("effect_script_0397.s"))
        battle = ROOT / "src/battle"
        self.assertIn("msg->id = msg_0197_01790;", (battle / "overlay_12_0224E4FC.c").read_text())
        self.assertEqual((battle / "battle_controller_player.c").read_text().count("msg_0197_01793"), 2)
        self.assertIn("ctx->buffMsg.id = msg_0197_01794;", (battle / "battle_command.c").read_text())

    def test_the_lines_the_port_moved_to_the_engines_rows(self):
        """A sample of the lines the port had appended before the engine's
        rows were in: each is printed from the engine's row with that text."""
        table = rows()
        for name, row, text in (
                ("subscript_0401_MoveFailThroatChop.s", 1619,
                 "The effects of Throat Chop prevent\\n{STRVAR_1 1, 0, 0} from using certain moves!"),
                ("subscript_0367_Unnerve.s", 1463, "{STRVAR_1 1, 0, 0}\\nhas two Abilities!"),
                ("subscript_0339_HandleSnowTemporary.s", 1439, "It started to snow!"),
                ("subscript_0347_CreateTerrainOverlay.s", 1388, "Grass grew to cover the battlefield!")):
            self.assertIn(f"msg_0197_{row:05d},", script(name), name)
            self.assertEqual(table[row], text, name)

    @unittest.skipUnless(gmm.REFERENCE.exists(), "the reference checkout is not here")
    def test_rows_up_to_the_engines_last_are_the_engines(self):
        engine = gmm.reference_rows(gmm.ENGINE, 197)
        self.assertEqual(len(engine), ENGINE_ROWS)
        bank = gmm.read(197)
        self.assertEqual([row["text"] for row in bank[:ENGINE_ROWS]], engine)
        self.assertEqual({row["context"] for row in bank}, {"used"})


if __name__ == "__main__":
    unittest.main()
