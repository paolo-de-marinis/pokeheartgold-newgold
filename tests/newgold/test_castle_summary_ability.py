#!/usr/bin/env python3
"""Run the Battle Castle summary constructors and renderers natively with host sanitizers.

Ov83MonSummary and the two state prefixes come from include/overlay_83.h; the
constructors ov83_02241E18 / ov83_02245D48 and renderers ov83_022421E0 /
ov83_02246114 from src/. Drawing, text and the party are stand-ins: every
call the ability does not flow through is a macro that does nothing. The
record keeps its asserted byte, so the name must come from the Pokemon itself.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function

STUBBED = """FillWindowPixelBuffer BufferBoxMonNickname BufferBoxMonSpeciesName ov83_02241DD8 ov83_022479E4
ov83_02240C48 ov83_02244A98 ov83_02245D08 ov83_02247998 BufferNatureName BufferItemName BufferMoveName
GetWindowWidth NewString_ReadMsgData FontID_String_GetWidth String_Delete StringExpandPlaceholders
ScheduleWindowCopyToVram CopyWindowPixelsToVram_TextMode ov83_0224777C ov83_02247768 AcquireMonLock
ReleaseMonLock GetMonNature GetMonGender GetMoveMaxPP""".split()

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define MAKE_TEXT_COLOR(fg, bg, shadow) 0
#define PRINTING_MODE_LEFT_ALIGN 0
typedef struct MsgData MsgData;
typedef struct MessageFormat MessageFormat;
typedef struct String String;
typedef struct SaveData SaveData;
typedef struct BoxPokemon BoxPokemon;
typedef struct { int unused; } Window;
typedef struct { u32 fields[256]; } Pokemon;
typedef struct Party { Pokemon mon; } Party;
#define Mon_GetBoxMon(mon) ((BoxPokemon *)(mon))
@STUBS@
@MESSAGES@
@TYPES@

static u32 bufferedAbility;
static int bufferedCalls;
static Pokemon *Party_GetMonByIndex(Party *party, int i) { assert(i == 0); return &party->mon; }
static u32 GetMonData(Pokemon *mon, int attr, void *out) { (void)out; assert(attr >= 0 && attr < 256); return mon->fields[attr]; }
static void BufferAbilityName(MessageFormat *format, u32 field, u32 ability) { (void)format; assert(field == 0); bufferedAbility = ability; bufferedCalls++; }
@NATIVE@
'''

MAIN = r'''
int main(void) {
    static Ov83PlayerSummaryStatePrefix player;
    static Ov83OpponentSummaryStatePrefix opponent;
    static Party party;
    u8 visible[6] = { 1, 1, 1, 1, 1, 1 };
    player.party = opponent.party = &party;
    opponent.basicInfoVisible = opponent.statsVisible = opponent.movesVisible = visible;
    // Abilities go to 319; 320-511 confirm nothing narrows below nine bits.
    for (u32 ability = 0; ability < 512; ability++) {
        memset(&party, 0, sizeof(party));
        party.mon.fields[MON_DATA_ABILITY] = ability;
        party.mon.fields[MON_DATA_MOVE1] = MOVE_TACKLE;

        ov83_02241E18(&player);
        assert(player.summary.mon == &party.mon && player.summary.ability == (ability & 0xFF));
        bufferedCalls = 0;
        ov83_022421E0(&player, TRUE);
        assert(bufferedCalls == 1 && bufferedAbility == ability);

        ov83_02245D48(&opponent);
        assert(opponent.summary.mon == &party.mon && opponent.summary.ability == (ability & 0xFF));
        bufferedCalls = 0;
        ov83_02246114(&opponent, TRUE);
        assert(bufferedCalls == 1 && bufferedAbility == ability);
    }
    // A hidden opponent's ability is never named.
    visible[0] = 0;
    bufferedCalls = 0;
    ov83_02246114(&opponent, TRUE);
    assert(bufferedCalls == 0);
    puts("PASS: 512 abilities through both Castle summaries.");
}
'''


class CastleSummaryAbilityTests(unittest.TestCase):
    def test_castle_summary_names_the_whole_ability(self):
        header = (ROOT / "include/overlay_83.h").read_text()
        types = header[header.index("typedef struct Ov83MonSummary {"):header.index("} Ov83OpponentSummaryStatePrefix;") + len("} Ov83OpponentSummaryStatePrefix;")]
        native = [function((ROOT / "src/overlay_83_player_mon.c").read_text(), "ov83_02241E18"),
                  function((ROOT / "src/overlay_83_player_summary.c").read_text(), "ov83_022421E0"),
                  function((ROOT / "src/overlay_83_opponent_mon.c").read_text(), "ov83_02245D48"),
                  function((ROOT / "src/overlay_83_opponent_summary.c").read_text(), "ov83_02246114")]
        messages = sorted(set(re.findall(r"\bmsg_00\d\d_\d{5}\b", "\n".join(native))))
        source = (PREFIX
                  .replace("@STUBS@", "\n".join(f"#define {name}(...) 0" for name in STUBBED))
                  .replace("@MESSAGES@", "\n".join(f"#define {name} {i}" for i, name in enumerate(messages)))
                  .replace("@TYPES@", types)
                  .replace("@NATIVE@", "\n".join(native)) + MAIN)
        with tempfile.TemporaryDirectory(prefix="newgold-castle-ability-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-Wno-unused-value", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
