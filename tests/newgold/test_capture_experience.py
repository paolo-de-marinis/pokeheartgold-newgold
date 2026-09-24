#!/usr/bin/env python3
"""A capture pays its experience straight after "Gotcha!".

It came after the whole catch once, from the ball-throw script: after the Dex,
the nickname and the Box. A nickname's naming screen takes the battle's windows
down, and the experience messages went to a window that was no more -- an
assert in CopyWindowToVram, a crash on hardware; without a nickname they were
printed on a black screen. The catch task pays it now, between the "Gotcha!"
message and the Dex, as the games since the sixth generation do, and the
experience task hands the getter back to the catch at its end.
"""

import re
import unittest

from test_repels import ROOT, function

SOURCE = ROOT / "src/battle/battle_command.c"
SCRIPT = ROOT / "files/battledata/script/subscript/subscript_0011_ThrowBall.s"


class CaptureExperienceTests(unittest.TestCase):
    def setUp(self):
        self.source = SOURCE.read_text()

    def test_the_catch_pays_it_between_gotcha_and_the_dex(self):
        body = function(self.source, "Task_GetPokemon")
        self.assertIn("StartGetExpTask(", body, "the catch pays no experience itself")
        gotcha = body.index("msg_0197_00867")
        pays = body.index("StartGetExpTask(")
        self.assertLess(gotcha, pays)
        self.assertLess(pays, body.index("ov18_021F8974("), "before the Dex page")
        self.assertLess(pays, body.index("NamingScreen_CreateArgs("), "before the naming screen")
        self.assertIn("CountExpGainers(", body[gotcha:pays], "only when there is experience to give")

    def test_the_catching_demonstration_pays_none(self):
        body = function(self.source, "Task_GetPokemon")
        pays = body.index("StartGetExpTask(")
        condition = body[body.rindex("if (", 0, pays):pays]
        self.assertIn("!(BattleSystem_GetBattleType(data->battleSystem) & BATTLE_TYPE_TUTORIAL)", condition,
                      "Lyra's Marill gains experience from the demonstration's catch")

    def test_the_catch_waits_for_its_getter_back(self):
        self.assertIn("data->ctx->getterWork = data->caller;", function(self.source, "Task_GetExp"))
        self.assertIn("->caller = caller;", function(self.source, "StartGetExpTask"))

    def test_the_ball_throw_script_pays_nothing_after_the_catch(self):
        script = SCRIPT.read_text()
        after = script[script.index("WaitCatchMonTask"):]
        self.assertIsNone(re.search(r"^\s*(CalcExpGain|StartGetExpTask)\b", after, re.M))


if __name__ == "__main__":
    unittest.main()
