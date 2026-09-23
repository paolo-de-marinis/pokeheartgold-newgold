#!/usr/bin/env python3
"""Run the Battle Frontier record writers and reader natively with host sanitizers.

FrontierMon, the three set writers (ov80_02229F6C, ov80_02236734,
sub_0204B834), the player's own writer SetFrontierMon and the reader
ov80_0222A140 are extracted from the repository. Narc data, base stats and the
Pokemon they build are controlled stand-ins. A record written for an ability
past 255 must give the same ability back when the battle party is built.
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
#include "constants/abilities.h"
#include "constants/heap.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32;
typedef int BOOL; typedef int NarcId;
#define TRUE 1
#define FALSE 0
#define MSGDATA_LOAD_LAZY 1
#define NARC_msgdata_msg 0
#define NARC_msg_msg_0237_bin 237
typedef struct MsgData MsgData;
typedef struct String String;
@TYPES@
_Static_assert(sizeof(FrontierMon) == 0x38, "FrontierMon keeps its record size");
_Static_assert(offsetof(FrontierMon, ability) == 0x20, "FrontierMon keeps the ability byte");
_Static_assert(offsetof(FrontierMon, nickname) == 0x22, "FrontierMon keeps the nickname");

typedef struct { u8 towerMode; } FrontierFieldSystem; // controlled stand-in
typedef struct { u32 fields[256]; } Pokemon;

static u8 gGameLanguage = 2;
static const u16 _0223B620[4], ov80_0223C048[4], ItemReplacementList[4];
static FrontierMonNarcData narcRecord;
static int baseAbility1, baseAbility2;
static u32 createdIvs;

static void MI_CpuClear8(void *p, u32 n) { memset(p, 0, n); }
static void ov80_02229EF4(FrontierMonNarcData *d, u32 i, NarcId n) { (void)i; (void)n; *d = narcRecord; }
static void GetFrontierMonNarcData(FrontierMonNarcData *d, u32 i) { (void)i; *d = narcRecord; }
static NarcId ov80_02236AF0(u8 mode) { return mode; }
static u16 FrontierFieldSystem_0204B510(FrontierFieldSystem *f) { (void)f; return 0x1234; }
static u16 LCRandom(void) { return 0x1234; }
static u8 GetNatureFromPersonality(u32 pid) { return pid % 25; }
static u8 CalcShininessByOtIdAndPersonality(u32 otId, u32 pid) { (void)otId; (void)pid; return FALSE; }
static u32 MaskOfFlagNo(int i) { return 1u << i; }
static int GetMonBaseStat(int species, int field) {
    (void)species;
    assert(field == BASE_ABILITY_1 || field == BASE_ABILITY_2);
    return field == BASE_ABILITY_1 ? baseAbility1 : baseAbility2;
}
static void GetSpeciesNameIntoArray(u16 species, enum HeapID heapID, u16 *dest) { (void)species; (void)heapID; dest[0] = 0xFFFF; }
static void ZeroMonData(Pokemon *mon) { memset(mon, 0, sizeof(*mon)); }
static void CreateMon(Pokemon *mon, int species, int level, int ivs, int fixed, int pid, int otIdType, int otId) {
    (void)species; (void)level; (void)fixed; (void)pid; (void)otIdType; (void)otId;
    createdIvs = (u32)ivs;
    // Whatever the game derives here, the record's ability must overwrite it.
    mon->fields[MON_DATA_ABILITY] = 0xDEAD;
}
static void CalcMonLevelAndStats(Pokemon *mon) { (void)mon; }
static void SetMonData(Pokemon *mon, int attr, const void *value) {
    assert(attr >= 0 && attr < 256);
    if (attr == MON_DATA_ABILITY) {
        mon->fields[attr] = *(const u16 *)value;
    } else if (attr == MON_DATA_COMBINED_IVS) {
        mon->fields[attr] = *(const u32 *)value;
    }
}
static u32 GetMonData(Pokemon *mon, int attr, void *out) {
    assert(attr >= 0 && attr < 256);
    if (attr == MON_DATA_NICKNAME) {
        memset(out, 0xFF, 22);
    }
    return mon->fields[attr];
}
static MsgData *NewMsgDataFromNarc(int mode, int narc, int file, enum HeapID heapID) { (void)mode; (void)narc; (void)file; (void)heapID; assert(0); return NULL; }
static String *NewString_ReadMsgData(MsgData *m, int id) { (void)m; (void)id; return NULL; }
static void String_Delete(String *s) { (void)s; }
static void DestroyMsgData(MsgData *m) { (void)m; }
@NATIVE@
'''

MAIN = r'''
static u32 battleAbility(FrontierMon *record) {
    Pokemon mon;
    ov80_0222A140(record, &mon, 50);
    // The high bit never reaches the IVs.
    assert(createdIvs <= 0x3FFFFFFF && mon.fields[MON_DATA_COMBINED_IVS] <= 0x3FFFFFFF);
    return mon.fields[MON_DATA_ABILITY];
}

int main(void) {
    FrontierFieldSystem fsys = { 0 };
    FrontierMon record;
    narcRecord.species = 185;
    narcRecord.evs = 0x3F;
    narcRecord.nature = 3;
    // Abilities go to 319; 320-511 confirm nothing narrows below nine bits.
    for (int ability = 1; ability < 512; ability++) {
        for (u32 pid = 0x103; pid <= 0x104; pid++) {
            // One ability: the pid never matters.
            baseAbility1 = ability; baseAbility2 = ABILITY_NONE;
            ov80_02229F6C(&record, 0, 1, pid, 31, 0, FALSE, HEAP_ID_FIELD1, 0);
            assert(battleAbility(&record) == (u32)ability);
            ov80_02236734(&fsys, &record, 0, 1, pid, 31, 0, FALSE, HEAP_ID_FIELD1);
            assert(battleAbility(&record) == (u32)ability);
            sub_0204B834(&fsys, &record, 0, 1, pid, 31, 0, FALSE, HEAP_ID_FIELD1);
            assert(battleAbility(&record) == (u32)ability);
            // Two abilities: an odd pid takes the second, an even one the first.
            baseAbility1 = 511 - ability; baseAbility2 = ability;
            u32 expected = pid % 2 ? (u32)ability : (u32)(511 - ability);
            ov80_02229F6C(&record, 0, 1, pid, 31, 0, FALSE, HEAP_ID_FIELD1, 0);
            assert(battleAbility(&record) == expected);
            ov80_02236734(&fsys, &record, 0, 1, pid, 31, 0, FALSE, HEAP_ID_FIELD1);
            assert(battleAbility(&record) == expected);
            sub_0204B834(&fsys, &record, 0, 1, pid, 31, 0, FALSE, HEAP_ID_FIELD1);
            assert(battleAbility(&record) == expected);
            assert(!record.useSpeciesName);
        }

        // The player's own Pokemon, with every IV at 31.
        Pokemon own;
        memset(&own, 0, sizeof(own));
        own.fields[MON_DATA_ABILITY] = ability;
        own.fields[MON_DATA_COMBINED_IVS] = 0x3FFFFFFF;
        memset(&record, 0, sizeof(record));
        SetFrontierMon(&record, &own);
        assert(record.ability == (ability & 0xFF));
        Pokemon mon;
        ov80_0222A140(&record, &mon, 50);
        assert(mon.fields[MON_DATA_ABILITY] == (u32)ability);
        assert(mon.fields[MON_DATA_COMBINED_IVS] == 0x3FFFFFFF);
    }
    puts("PASS: 511 abilities through three set writers, the player's writer and the reader.");
}
'''


class FrontierAbilityTests(unittest.TestCase):
    def test_frontier_record_keeps_the_ability(self):
        header = (ROOT / "include/scrcmd_9.h").read_text()
        types = header[header.index("typedef struct FrontierMonNarcData {"):header.index("} FrontierMon;") + len("} FrontierMon;")]
        native = [function((ROOT / "src/frontier/frontier_mon.c").read_text(), "ov80_02229F6C"),
                  function((ROOT / "src/frontier/frontier_mon.c").read_text(), "ov80_0222A140"),
                  function((ROOT / "src/frontier/frontier_tower_mon.c").read_text(), "ov80_02236734"),
                  function((ROOT / "src/unk_0204B538.c").read_text(), "sub_0204B834"),
                  function((ROOT / "src/unk_0204A3F4.c").read_text(), "SetFrontierMon")]
        source = PREFIX.replace("@TYPES@", without_includes(types)).replace("@NATIVE@", "\n".join(native)) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-frontier-ability-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
