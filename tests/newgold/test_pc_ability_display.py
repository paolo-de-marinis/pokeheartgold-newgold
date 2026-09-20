#!/usr/bin/env python3
"""Run the native PC box display record and ability renderer with host sanitizers.

The actual PCBoxDisplayMon declaration, ov14_021E7358 and ov14_021F528C are
extracted from the repository. Box data, heap, message format and windows are
controlled stand-ins, and host pointer width moves every field, so DS record
offsets are asserted by the ROM build's compile-time checks in
src/pc_box_display.c rather than here. This checks value flow, not rendering.
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest
import xml.etree.ElementTree as ET

from test_repels import ROOT, function, without_includes

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "constants/heap.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define MAKE_TEXT_COLOR(fg, bg, shadow) ((u32)(((fg) << 0) | ((bg) << 8) | ((shadow) << 16)))
// Row indices of files/msgdata/msg/msg_0024.gmm, as the generated header defines them.
#define msg_0024_00084 @ABILITY_MSG@
#define msg_0024_00093 @EGG_MSG@

typedef struct BoxPokemon BoxPokemon;
typedef struct MessageFormat MessageFormat;
typedef struct MsgData MsgData;
typedef struct { int filled, scheduled; } Window;
@RECORD@

// Controlled stand-in. The ROM build asserts the shared graphics-state offsets.
typedef struct PCBoxGraphicsStatePrefix {
    MsgData *msgData;
    MessageFormat *messageFormat;
    Window windows[44];
} PCBoxGraphicsStatePrefix;

static u32 boxData[400];
static u32 bufferedAbility;
static int bufferedCalls, abilityMessages, eggMessages, lastWindow;

static u32 GetBoxMonData(BoxPokemon *mon, int attribute, void *out) {
    (void)mon; (void)out;
    assert(attribute >= 0 && attribute < (int)(sizeof(boxData) / sizeof(*boxData)));
    return boxData[attribute];
}
static u8 GetBoxMonNature(BoxPokemon *mon) { (void)mon; return NATURE_ADAMANT; }
static u8 GetBoxMonGender(BoxPokemon *mon) { (void)mon; return MON_MALE; }
static void *Heap_Alloc(u32 heapID, u32 size) {
    assert(heapID == HEAP_ID_10);
    void *block = malloc(size);
    assert(block != NULL);
    // Every byte the record does not write stays recognizable.
    memset(block, 0x5A, size);
    return block;
}
static void BufferAbilityName(MessageFormat *messageFormat, u32 fieldno, u32 abilityId) {
    (void)messageFormat;
    assert(fieldno == 0);
    bufferedAbility = abilityId;
    bufferedCalls++;
}
static void FillWindowPixelBuffer(Window *window, u32 fill) { (void)fill; window->filled++; }
static void ScheduleWindowCopyToVram(Window *window) { window->scheduled++; }
static void ov14_021F4F84(PCBoxGraphicsStatePrefix *state, MsgData *msgData, int windowID, int msgID, int x, int y, int fontID, u32 color, int alignment) {
    (void)state; (void)msgData; (void)x; (void)y; (void)fontID; (void)color; (void)alignment;
    assert(msgID == msg_0024_00093);
    eggMessages++;
    lastWindow = windowID;
}
static void ov14_021F4FBC(PCBoxGraphicsStatePrefix *state, MsgData *msgData, int windowID, int msgID, int x, int y, int fontID, u32 color, int alignment) {
    (void)state; (void)msgData; (void)x; (void)y; (void)fontID; (void)color; (void)alignment;
    assert(msgID == msg_0024_00084);
    abilityMessages++;
    lastWindow = windowID;
}
@NATIVE@
'''

MAIN = r'''
_Static_assert(sizeof(((PCBoxDisplayMon *)0)->ability) == 2, "PC record must keep full ability IDs");
_Static_assert(sizeof(((PCBoxDisplayMon *)0)->unusedAbility) == 1, "Original truncated field stays a byte");

int main(void) {
    PCBoxGraphicsStatePrefix state;

    // The source defines abilities 0-319; 320-511 confirm nothing narrows earlier.
    for (u32 ability = 0; ability < 512; ability++) {
        memset(boxData, 0, sizeof(boxData));
        memset(&state, 0, sizeof(state));
        boxData[MON_DATA_SPECIES_EXISTS] = TRUE;
        boxData[MON_DATA_SPECIES] = SPECIES_BULBASAUR;
        boxData[MON_DATA_HELD_ITEM] = ITEM_ORAN_BERRY;
        boxData[MON_DATA_PERSONALITY] = 0x12345678;
        boxData[MON_DATA_TYPE_1] = TYPE_GRASS;
        boxData[MON_DATA_TYPE_2] = TYPE_POISON;
        boxData[MON_DATA_ABILITY] = ability;
        boxData[MON_DATA_MARKINGS] = 0x3F;
        boxData[MON_DATA_LEVEL] = MAX_LEVEL;
        for (int i = 0; i < MAX_MON_MOVES; i++) {
            boxData[MON_DATA_MOVE1 + i] = 400 + i;
        }

        PCBoxDisplayMon *record = ov14_021E7358((BoxPokemon *)boxData);
        assert(record != NULL);
        assert(record->ability == ability);
        // The constructor no longer writes the original truncated byte.
        assert(record->unusedAbility == 0x5A);
        // Every neighbouring field the remaining assembly reads is unchanged.
        assert(record->species == SPECIES_BULBASAUR && record->heldItem == ITEM_ORAN_BERRY);
        assert(record->personality == 0x12345678);
        assert(record->type1 == TYPE_GRASS && record->type2 == TYPE_POISON);
        assert(record->nature == NATURE_ADAMANT && record->markings == 0x3F);
        assert(record->level == MAX_LEVEL && !record->isEgg);
        assert(record->gender == MON_MALE && record->showGender);
        for (int i = 0; i < MAX_MON_MOVES; i++) {
            assert(record->moves[i] == 400 + i);
        }

        bufferedCalls = abilityMessages = eggMessages = 0;
        bufferedAbility = 0xFFFF;
        ov14_021F528C(&state, record, 7);
        assert(bufferedCalls == 1 && bufferedAbility == ability);
        assert(abilityMessages == 1 && eggMessages == 0 && lastWindow == 7);
        assert(state.windows[7].filled == 1 && state.windows[7].scheduled == 1);

        // Eggs still print the placeholder string and never read an ability.
        record->isEgg = TRUE;
        bufferedCalls = abilityMessages = 0;
        ov14_021F528C(&state, record, 7);
        assert(bufferedCalls == 0 && abilityMessages == 0 && eggMessages == 1);
        assert(state.windows[7].filled == 2 && state.windows[7].scheduled == 2);

        free(record);
    }

    // An empty box slot still produces no record.
    memset(boxData, 0, sizeof(boxData));
    assert(ov14_021E7358((BoxPokemon *)boxData) == NULL);

    // Nidoran keeps its hidden gender marker regardless of ability width.
    const u32 hiddenGender[] = { SPECIES_NIDORAN_F, SPECIES_NIDORAN_M };
    for (unsigned i = 0; i < sizeof(hiddenGender) / sizeof(*hiddenGender); i++) {
        u32 species = hiddenGender[i];
        memset(boxData, 0, sizeof(boxData));
        boxData[MON_DATA_SPECIES_EXISTS] = TRUE;
        boxData[MON_DATA_SPECIES] = species;
        boxData[MON_DATA_ABILITY] = 319;
        PCBoxDisplayMon *record = ov14_021E7358((BoxPokemon *)boxData);
        assert(record != NULL && record->ability == 319 && !record->showGender);
        free(record);
    }

    puts("PASS: 512 PC record/renderer ability cases, egg and empty slots, Nidoran gender.");
}
'''


class PCAbilityDisplayTests(unittest.TestCase):
    def test_native_pc_ability_path(self):
        header = (ROOT / "include/pc_box_display.h").read_text()
        record = header[header.index("typedef struct PCBoxDisplayMon {"):header.index("} PCBoxDisplayMon;") + len("} PCBoxDisplayMon;")]
        native = [function((ROOT / "src/pc_box_display.c").read_text(), "ov14_021E7358"),
                  function((ROOT / "src/pc_box_display_ability.c").read_text(), "ov14_021F528C")]
        rows = {row.get("id"): int(row.get("index")) for row in ET.parse(ROOT / "files/msgdata/msg/msg_0024.gmm").getroot().findall("row")}
        source = (PREFIX
                  .replace("@RECORD@", without_includes(record))
                  .replace("@ABILITY_MSG@", str(rows["msg_0024_00084"]))
                  .replace("@EGG_MSG@", str(rows["msg_0024_00093"]))
                  .replace("@NATIVE@", "\n".join(native)) + MAIN)
        with tempfile.TemporaryDirectory(prefix="newgold-pc-ability-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
