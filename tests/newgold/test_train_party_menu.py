#!/usr/bin/env python3
"""The party menu the EV/IV trainer opens: "Train which Pokemon?", one
Pokemon chosen at once, and no Egg -- context 20's rules with its own line.

Read in the source: the context's prompt, the egg check its choice goes
through, and the choice handing the slot back as context 20's does.
"""

import re
import unittest

from test_repels import ROOT, function, read


class TrainPartyMenuTests(unittest.TestCase):
    def setUp(self):
        self.source = read("src/party_menu.c")

    def test_it_asks_which_pokemon_to_train(self):
        self.assertRegex(self.source, r"context == PARTY_MENU_CONTEXT_TRAIN_MON\) \{\s*"
                                      r"PartyMenu_PrintMessageOnWindow32\(partyMenu, msg_0300_00227, TRUE\);")
        bank = (ROOT / "files/msgdata/msg/msg_0300.gmm").read_text(encoding="utf-8")
        self.assertIn('index="227">\n\t\t<attribute name="window_context_name">used</attribute>\n'
                      '\t\t<language name="English">Train which Pokémon?</language>', bank)

    def test_an_egg_is_refused(self):
        choose = function(self.source, "sub_0207AC70")
        branch = re.search(r"else if \(([^{]*PARTY_MENU_CONTEXT_TRAIN_MON[^{]*)\) \{(.*?)\} else if", choose, re.S)
        self.assertIsNotNone(branch, "the context's choice is not in the egg-checking branch")
        self.assertIn("PARTY_MENU_CONTEXT_20", branch.group(1))
        self.assertIn("isEgg", branch.group(2))
        self.assertIn("SEQ_SE_DP_CUSTOM06", branch.group(2))

    def test_the_choice_returns_at_once(self):
        main = function(self.source, "PartyMenu_Subtask_MainNormal")
        cases = main[:main.index("PARTY_MENU_ACTION_RETURN_0")]
        self.assertIn("case PARTY_MENU_CONTEXT_TRAIN_MON:", cases)


if __name__ == "__main__":
    unittest.main()
