#!/usr/bin/env python3
"""Run Revival Blessing's party menu drawing on the host.

Revival Blessing opens the battle party menu in BATTLE_PARTY_MODE_REVIVE,
where Cancel does nothing (ov08_0221C14C). ov08_022221CC draws the list's
Cancel greyed (state 3) in that mode, as for a forced switch, and
ov08_0221F5D0 labels the submenu's first button REVIVE instead of SHIFT.
Both are extracted and run with a stand-in menu that records what they draw;
the label is looked up in msg_0006 by its text.
"""

import re
import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

PROGRAM = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/battle.h"
typedef uint8_t u8; typedef uint16_t u16;
#define FALSE 0
@ROWS@
typedef struct Window { int unused; } Window;
typedef struct { u8 selectedPos, unk34, mode; } BattlePartyMenuArgs;
typedef struct { u8 isEgg; struct { u16 move; } moves[4]; } BattlePartyMenuMon;
typedef struct { BattlePartyMenuArgs *args; BattlePartyMenuMon mons[6]; Window *windows; u8 unk2077_4; } BattlePartyMenu;
static int cancelState = -1, label = -1;
int ov08_0221D5DC(BattlePartyMenu *menu, int pos) { return 1; }
u8 ov08_02222564(BattlePartyMenu *menu) { return 1; }
void ov08_02221E6C(BattlePartyMenu *menu, u8 button, u8 state, u8 a3) { if (button == 6) cancelState = state; }
void FillWindowPixelBuffer(Window *window, u8 fill) {}
void ScheduleWindowCopyToVram(Window *window) {}
void ov08_0221F658(BattlePartyMenu *menu, u8 pos) {}
void ov08_0221E3A4(BattlePartyMenu *menu, int window, int msgId) { if (window == 1) label = msgId; }
@FUNCTIONS@
int main(void) {
    Window windows[4];
    BattlePartyMenuArgs args = {0};
    BattlePartyMenu menu = {&args};
    menu.windows = windows;
    for (int mode = 0; mode < 6; mode++) {
        args.mode = mode;
        ov08_022221CC(&menu, 0);
        ov08_0221F5D0(&menu);
        printf("%d %d %d\n", mode, cancelState, label);
    }
    return 0;
}
'''


def rows():
    gmm = (ROOT / "files/msgdata/msg/msg_0006.gmm").read_text(encoding="utf-8")
    return {text: int(index) for index, text in re.findall(r'<row id="msg_0006_\d+" index="(\d+)">\s*<attribute[^>]*>[^<]*</attribute>\s*<language name="English">([^<]*)</language>', gmm)}


class RevivalBlessingMenuTests(unittest.TestCase):
    def test_cancel_is_greyed_and_the_button_says_revive(self):
        text = rows()
        defines = "\n".join(f"#define msg_0006_{index:05d} {index}" for index in text.values())
        functions = function((ROOT / "src/overlay_08_022221CC.c").read_text(), "ov08_022221CC") + "\n" + \
            function((ROOT / "src/overlay_08_0221F5D0.c").read_text(), "ov08_0221F5D0")
        out = run(PROGRAM.replace("@ROWS@", defines).replace("@FUNCTIONS@", functions), "revival_menu_")
        drawn = {int(mode): (int(cancel), int(label)) for mode, cancel, label in (line.split() for line in out.splitlines())}
        self.assertEqual(drawn[5], (3, text["REVIVE"]))    # BATTLE_PARTY_MODE_REVIVE
        self.assertEqual(drawn[1], (3, text["SHIFT"]))     # a forced switch
        self.assertEqual(drawn[0], (0, text["SHIFT"]))     # a switch that may be declined


if __name__ == "__main__":
    unittest.main()
