#!/usr/bin/env python3
"""Check that nothing reads a party before the battle system has one.

ov12_02238A68 builds the battle context first and copies the parties in after,
so inside BattleContext_New every entry of trainerParty is still NULL. A call
there to BattleSystem_GetPartySize ends in Party_GetCount(NULL): on hardware,
and in a melonDS that raises data aborts, that is a black screen with the music
still playing. The libretro core the harness runs on reads address 4 as zero
and carries on, which is how nine battles in a row passed with the bug in.

The held items are written down from the first controller command instead,
which runs once the parties are in place.
"""

import re
import unittest

from test_level_cap import ROOT

CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
PARTY_READERS = ("BattleSystem_GetPartySize", "BattleSystem_GetPartyMon",
                 "RememberHeldItems", "Party_GetCount")


def body(name):
    text = CONTROLLER.read_text()
    match = re.search(r"\n[A-Za-z_][A-Za-z_0-9 *]*\b" + name + r"\([^)]*\) \{\n(.*?)\n\}\n",
                      text, re.S)
    assert match, f"{name} is not in {CONTROLLER}"
    return match.group(1)


class BattleContextTests(unittest.TestCase):
    def test_the_context_is_built_without_a_party(self):
        new = body("BattleContext_New")
        for reader in PARTY_READERS:
            self.assertNotIn(reader, new,
                             f"BattleContext_New calls {reader} before the parties are set")

    def test_held_items_are_remembered_once_the_parties_are_in(self):
        self.assertIn("RememberHeldItems(battleSystem, ctx);",
                      body("BattleControllerPlayer_GetBattleMon"))

    def test_held_items_are_given_back(self):
        self.assertIn("GiveBackHeldItems(battleSystem, ctx);", body("BattleContext_Main"))


if __name__ == "__main__":
    unittest.main()
