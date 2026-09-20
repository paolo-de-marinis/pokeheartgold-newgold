#!/usr/bin/env python3
"""Run the native summary record loader and stat page with host sanitizers.

The actual PokemonSummaryMon declaration, sub_0208981C and sub_0208D178 are
extracted from the repository. Pokemon data, messages, ribbons and windows are
controlled stand-ins, and host pointer width moves every field, so the DS record
offsets are asserted by the ROM build's compile-time layout check in
src/pokemon_summary_mon.c rather than here. This checks value flow, not
rendering.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, without_includes

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/ribbon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define MAKE_TEXT_COLOR(fg, bg, shadow) ((u32)(((fg) << 0) | ((bg) << 8) | ((shadow) << 16)))
#define NELEMS(a) (sizeof(a) / sizeof((a)[0]))
#define TEXT_SPEED_NOTRANSFER 0
#define HEAP_ID_19 19
#define MSGDATA_LOAD_LAZY 0
#define NARC_msgdata_msg 0
#define NARC_msg_msg_0722_bin 722
// Row indices used by the stat page; the generated header defines the same values.
#define msg_0302_00000 0
#define msg_0302_00011 11
#define msg_0302_00014 14
#define msg_0302_00111 111
#define msg_0302_00112 112
#define msg_0302_00113 113
#define msg_0302_00114 114
#define msg_0302_00115 115
#define msg_0302_00117 117
#define msg_0302_00118 118
#define msg_0302_00119 119
#define msg_0302_00120 120
#define msg_0302_00121 121
#define msg_0302_00122 122
#define msg_0302_00123 123
#define msg_0302_00124 124
#define msg_0302_00125 125

typedef struct Pokemon Pokemon;
typedef struct BoxPokemon BoxPokemon;
typedef struct MessageFormat MessageFormat;
typedef struct MsgData MsgData;
typedef struct String String;
typedef struct { int filled, scheduled, width; } Window;
typedef struct PokemonSummaryArgs PokemonSummaryArgs;
@ENUMS@
@RECORD@

// Controlled stand-in. The ROM build asserts the shared application offsets.
typedef struct PokemonSummaryAppPrefix {
    Window windows[34];
    Window *pageWindows;
    u32 pageWindowCount;
    PokemonSummaryArgs *args;
    PokemonSummaryMon mon;
    u8 shinyLeaves[MON_DATA_SHINY_LEAF_CROWN - MON_DATA_SHINY_LEAF_A + 1];
    MsgData *msgData;
    MsgData *ribbonMsgData;
    MessageFormat *messageFormat;
    String *stringBuffer;
    u8 ribbonCount;
} PokemonSummaryAppPrefix;

static u32 monData[400];
static u32 bufferedAbility, descriptionIndex;
static int bufferedCalls, descriptionReads, lockDepth;

static BOOL AcquireMonLock(Pokemon *mon) { (void)mon; lockDepth++; return TRUE; }
static void ReleaseMonLock(Pokemon *mon, BOOL locked) { (void)mon; assert(locked); lockDepth--; }
static BoxPokemon *Mon_GetBoxMon(Pokemon *mon) { return (BoxPokemon *)mon; }
static u32 GetMonData(Pokemon *mon, int attribute, void *out) {
    (void)mon; (void)out;
    assert(attribute >= 0 && attribute < (int)NELEMS(monData));
    return monData[attribute];
}
static u8 GetMonNature(Pokemon *mon) { (void)mon; return NATURE_ADAMANT; }
static u8 GetMonGender(Pokemon *mon) { (void)mon; return MON_MALE; }
static u32 GetMonExpBySpeciesAndLevel(int species, int level) { (void)species; return (u32)level * 100; }
static u16 GetMoveMaxPP(u16 move, u8 ppUps) { return (u16)(move % 16 + ppUps); }
static u8 MonGetFlavorPreference(Pokemon *mon, int flavor) { (void)mon; return flavor == FLAVOR_SPICY; }
static u8 Pokemon_GetStatusIconId(Pokemon *mon) { (void)mon; return PARTY_MON_STATUS_ICON_OK; }
static BOOL Pokemon_IsImmuneToPokerus(Pokemon *mon) { (void)mon; return FALSE; }
static BOOL Pokemon_HasPokerus(Pokemon *mon) { (void)mon; return FALSE; }
static BOOL MonIsShiny(Pokemon *mon) { (void)mon; return FALSE; }
static int GetRibbonAttr(int ribbon, int field) { (void)field; return MON_DATA_COOL_RIBBON + ribbon; }
static void ReadMsgDataIntoString(MsgData *msgData, u32 index, String *out) {
    (void)out;
    if ((intptr_t)msgData == 722) { descriptionIndex = index; descriptionReads++; }
}
static String *NewString_ReadMsgData(MsgData *msgData, u32 index) { (void)msgData; (void)index; return (String *)1; }
static void String_Delete(String *string) { assert(string != NULL); }
static MsgData *NewMsgDataFromNarc(int lazy, int narc, int file, int heap) { (void)lazy; (void)narc; (void)heap; return (MsgData *)(intptr_t)file; }
static void DestroyMsgData(MsgData *msgData) { assert(msgData != NULL); }
static void BufferBoxMonSpeciesName(MessageFormat *f, u32 n, BoxPokemon *mon) { (void)f; (void)n; (void)mon; }
static void BufferBoxMonNickname(MessageFormat *f, u32 n, BoxPokemon *mon) { (void)f; (void)n; (void)mon; }
static void BufferBoxMonOTName(MessageFormat *f, u32 n, BoxPokemon *mon) { (void)f; (void)n; (void)mon; }
static void StringExpandPlaceholders(MessageFormat *f, String *dest, String *src) { (void)f; (void)dest; (void)src; }
static void BufferAbilityName(MessageFormat *f, u32 fieldno, u32 abilityId) {
    (void)f;
    assert(fieldno == 0);
    bufferedAbility = abilityId;
    bufferedCalls++;
}
static void FillWindowPixelBuffer(Window *window, u32 fill) { (void)fill; window->filled++; }
static void ScheduleWindowCopyToVram(Window *window) { window->scheduled++; }
static u8 GetWindowWidth(Window *window) { return (u8)window->width; }
static void AddTextPrinterParameterizedWithColor(Window *w, int font, String *s, int x, int y, int speed, u32 color, void *cb) {
    (void)font; (void)s; (void)x; (void)y; (void)speed; (void)color; (void)cb;
    w->filled++;
}
static void sub_0208C778(PokemonSummaryAppPrefix *s, Window *w, u32 color, int align) { (void)s; (void)color; (void)align; w->filled++; }
static void sub_0208C7F8(PokemonSummaryAppPrefix *s, int windowID, int msgID, int stat, int align) {
    (void)msgID; (void)align;
    assert(stat >= 0 && stat < 5);
    s->windows[windowID].filled++;
}
static void sub_0208C87C(PokemonSummaryAppPrefix *s, int msgID, s32 number, u32 digits, u8 mode) { (void)s; (void)msgID; (void)number; (void)digits; (void)mode; }
static void sub_0208C8C8(PokemonSummaryAppPrefix *s, int windowID, int sep, int first, int second, u16 a, u16 b, u8 digits, u8 centerX, u8 y) {
    (void)s; (void)windowID; (void)sep; (void)first; (void)second; (void)a; (void)b; (void)digits; (void)centerX; (void)y;
}
@NATIVE@
'''

MAIN = r'''
_Static_assert(sizeof(((PokemonSummaryMon *)0)->ability) == 2, "Summary record must keep full ability IDs");
_Static_assert(sizeof(((PokemonSummaryMon *)0)->form) == 1, "Form is a five-bit saved field");

int main(void) {
    static PokemonSummaryAppPrefix summary;
    static Window pageWindows[8];

    // The source defines abilities 0-319; 320-511 confirm nothing narrows earlier.
    for (u32 ability = 0; ability < 512; ability++) {
        memset(&summary, 0, sizeof(summary));
        memset(pageWindows, 0, sizeof(pageWindows));
        memset(monData, 0, sizeof(monData));
        summary.pageWindows = pageWindows;
        summary.msgData = (MsgData *)302;
        for (unsigned i = 0; i < NELEMS(pageWindows); i++) {
            pageWindows[i].width = 8;
        }

        monData[MON_DATA_SPECIES] = SPECIES_BULBASAUR;
        monData[MON_DATA_HELD_ITEM] = ITEM_ORAN_BERRY;
        monData[MON_DATA_LEVEL] = 50;
        monData[MON_DATA_ABILITY] = ability;
        // MON_DATA_FORM cannot exceed 31; the byte at 0x32 is wide enough.
        monData[MON_DATA_FORM] = ability % 32;
        monData[MON_DATA_TYPE_1] = TYPE_GRASS;
        monData[MON_DATA_TYPE_2] = TYPE_POISON;
        monData[MON_DATA_MARKINGS] = 0x3F;
        monData[MON_DATA_SPEED] = 123;

        sub_0208981C(&summary, (Pokemon *)monData, &summary.mon);
        assert(lockDepth == 0);
        assert(summary.mon.ability == ability);
        assert(summary.mon.form == ability % 32);
        // Neighbouring fields the remaining assembly reads keep their values.
        assert(summary.mon.nature == NATURE_ADAMANT);
        assert(summary.mon.markings == 0x3F);
        assert(summary.mon.speed == 123);
        assert(summary.mon.type1 == TYPE_GRASS && summary.mon.type2 == TYPE_POISON);
        assert(summary.mon.heldItem == ITEM_ORAN_BERRY);
        assert(summary.mon.level == 50 && !summary.mon.isEgg);
        // unk_0208B1AC.s compares the complete 28-bit status value.
        assert(summary.mon.statusIcon == PARTY_MON_STATUS_ICON_OK);
        assert(summary.mon.pokerus == 0 && !summary.mon.isShiny);

        bufferedCalls = descriptionReads = 0;
        bufferedAbility = descriptionIndex = 0xFFFF;
        sub_0208D178(&summary);
        assert(bufferedCalls == 1 && bufferedAbility == ability);
        // The description bank is indexed by the complete ID, not a truncation.
        assert(descriptionReads == 1 && descriptionIndex == ability);
    }

    // Eggs still load without touching the ability path differently.
    memset(&summary, 0, sizeof(summary));
    memset(monData, 0, sizeof(monData));
    summary.msgData = (MsgData *)302;
    monData[MON_DATA_SPECIES] = SPECIES_BULBASAUR;
    monData[MON_DATA_IS_EGG] = TRUE;
    monData[MON_DATA_ABILITY] = 319;
    sub_0208981C(&summary, (Pokemon *)monData, &summary.mon);
    assert(summary.mon.isEgg && summary.mon.ability == 319 && summary.mon.showGender);

    puts("PASS: 512 summary record/stat-page ability cases, form byte, neighbours and egg load.");
}
'''


class SummaryAbilityTests(unittest.TestCase):
    def test_native_summary_ability_path(self):
        header = (ROOT / "include/pokemon_summary_app.h").read_text()
        record = header[header.index("typedef struct PokemonSummaryMon {"):header.index("} PokemonSummaryMon;") + len("} PokemonSummaryMon;")]
        # Keep the status-icon and ribbon-attribute values in step with the headers.
        party = (ROOT / "include/party_menu.h").read_text()
        ribbon = (ROOT / "include/ribbon.h").read_text()
        enums = party[party.index("typedef enum PartyMonStatusIconId {"):party.index("} PartyMonStatusIconId;") + len("} PartyMonStatusIconId;")]
        enums += "\n" + ribbon[ribbon.index("typedef enum {"):ribbon.index("} RibbonAttr;") + len("} RibbonAttr;")]
        native = [function((ROOT / "src/pokemon_summary_mon.c").read_text(), "sub_0208981C"),
                  function((ROOT / "src/pokemon_summary_stats.c").read_text(), "sub_0208D178")]
        source = (PREFIX
                  .replace("@ENUMS@", enums)
                  .replace("@RECORD@", without_includes(record))
                  .replace("@NATIVE@", "\n".join(native)) + MAIN)
        with tempfile.TemporaryDirectory(prefix="newgold-summary-ability-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
