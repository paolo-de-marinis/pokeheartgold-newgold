#!/usr/bin/env python3
"""Check native field poison behavior and the pinned NewGold zero-mask semantics.

The actual accessor is used with instrumented encryption/checksum boundaries;
this does not test DS encryption or a running field scene.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import BASELINE, REFERENCE, REFERENCE_COMMIT, ROOT, function, revision


FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "constants/battle.h"
#include "constants/field_poison.h"
#include "constants/pokemon.h"
#include "constants/std_script.h"
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define MON_MOOD_MODIFIER_SURVIVED_PSN 5

typedef struct {
    struct { int partyDecrypted, checksumFailed; u32 checksum, actualChecksum; } box;
    u32 hp, status;
    int egg, friendship, mood;
} Pokemon;
typedef struct { int count; Pokemon mons[6]; } Party;
static int trace[32], reads, checks, decrypts, encrypts, assertions, writes;
#define DECRYPT_PTY(mon) (++decrypts)
#define DECRYPT_BOX(mon) (++decrypts)
#define ENCRYPT_PTY(mon) (++encrypts)
#define ENCRYPT_BOX(mon) (++encrypts)
#define CHECKSUM(boxMon) (++checks, (boxMon)->actualChecksum)
#define GF_ASSERT(condition) ((void)((condition) ? 0 : ++assertions))
static u32 GetMonDataInternal(Pokemon *mon, int attr, void *dest) {
    assert(dest == NULL && reads < 32);
    trace[reads++] = attr;
    switch (attr) {
    case MON_DATA_HP: return mon->hp;
    case MON_DATA_IS_EGG: return mon->box.checksumFailed || mon->egg;
    case MON_DATA_STATUS: return mon->status;
    default: assert(0); return 0;
    }
}
@ACCESSOR@
static int Party_GetCount(Party *party) { return party->count; }
static Pokemon *Party_GetMonByIndex(Party *party, int i) {
    assert(i >= 0 && i < party->count && i < 6);
    return &party->mons[i];
}
static void SetMonData(Pokemon *mon, int attr, const u32 *data) {
    assert(attr == MON_DATA_HP); mon->hp = *data; writes++;
}
static void MonApplyFriendshipMod(Pokemon *mon, int event, u16 location) {
    assert(event == FRIENDSHIP_EVENT_HEAL_FIELD_PSN && location == 123);
    mon->friendship--; writes++;
}
static void ApplyMonMoodModifier(Pokemon *mon, int event) {
    assert(event == MON_MOOD_MODIFIER_SURVIVED_PSN);
    mon->mood--; writes++;
}
@ELIGIBILITY@
@NATIVE@
@REFERENCE@
@VANILLA@

typedef struct { Party party; u16 counter; } SaveData;
struct Location { int mapId; };
struct Effect { int unk20; };
typedef struct {
    SaveData *saveData;
    struct Location *location;
    struct Effect *unk4;
} FieldSystem;
static int effects, scripts, mapReads;
static Party *SaveArray_Party_Get(SaveData *save) { return &save->party; }
static SaveData *Save_LocalFieldData_Get(SaveData *save) { return save; }
static u16 *LocalFieldData_GetPoisonStepCounter(SaveData *save) { return &save->counter; }
static u16 MapHeader_GetMapSec(int map) { assert(map == 12); mapReads++; return 123; }
static void FieldSystem_DoPoisonEffect(int effect) { (void)effect; effects++; }
static void StartMapSceneScript(FieldSystem *fs, int script, void *object) {
    (void)fs; assert(script == std_survive_poisoning && object == NULL); scripts++;
}
@CALLER@

static void reset(void) {
    memset(trace, 0, sizeof(trace));
    reads = checks = decrypts = encrypts = assertions = writes = 0;
}
static void compare(Party party) {
    Party native = party, reference = party;
    int nativeTrace[32], counts[6];
    reset();
    assert(ApplyPoisonStep(&native, 123) == FIELD_POISON_NONE);
    assert(writes == 0);
    memcpy(nativeTrace, trace, sizeof(trace));
    counts[0] = reads; counts[1] = checks; counts[2] = decrypts;
    counts[3] = encrypts; counts[4] = assertions; counts[5] = writes;
    reset();
    assert(ReferenceApplyPoisonStep(&reference, 123) == FIELD_POISON_NONE);
    assert(!memcmp(&native, &reference, sizeof(native)));
    assert(!memcmp(nativeTrace, trace, sizeof(trace)));
    assert(counts[0] == reads && counts[1] == checks && counts[2] == decrypts);
    assert(counts[3] == encrypts && counts[4] == assertions && counts[5] == writes);
    for (int i = 0; i < party.count; i++) {
        assert(native.mons[i].hp == party.mons[i].hp);
        assert(native.mons[i].status == party.mons[i].status);
        assert(native.mons[i].friendship == party.mons[i].friendship);
        assert(native.mons[i].mood == party.mons[i].mood);
    }
}
int main(void) {
    const u32 hp[] = {0, 1, 2, 100, 65535};
    Party party = { .count = 1 };
    for (int status = 0; status < 256; status++)
    for (int h = 0; h < 5; h++)
    for (int egg = 0; egg < 2; egg++)
    for (int corrupt = 0; corrupt < 2; corrupt++)
    for (int unlocked = 0; unlocked < 2; unlocked++) {
        Pokemon *mon = &party.mons[0];
        mon->hp = hp[h]; mon->status = status; mon->egg = egg;
        mon->friendship = 200; mon->mood = 5;
        mon->box.partyDecrypted = unlocked; mon->box.checksumFailed = FALSE;
        mon->box.checksum = 42; mon->box.actualChecksum = corrupt ? 43 : 42;
        compare(party);
        reset();
        assert(ApplyPoisonStep(&party, 123) == FIELD_POISON_NONE);
        int eligible = hp[h] && !egg && !(corrupt && !unlocked);
        assert(reads == 1 + !!hp[h] + eligible);
        assert(checks == (unlocked ? 0 : reads));
        assert(decrypts == 2 * checks && encrypts == decrypts);
        assert(assertions == (corrupt ? checks : 0));
        assert(party.mons[0].box.checksumFailed == (corrupt && !unlocked));
    }
    memset(&party, 0, sizeof(party));
    for (int i = 0; i < 6; i++) {
        party.mons[i].hp = i; party.mons[i].status = STATUS_POISON | STATUS_BAD_POISON;
        party.mons[i].egg = i == 2; party.mons[i].friendship = 200;
        party.mons[i].box.checksumFailed = i == 3;
    }
    for (int count = 0; count <= 6; count++) { party.count = count; compare(party); }
    SaveData save = { .party = party };
    struct Location location = { .mapId = 12 };
    struct Effect effect = {0};
    FieldSystem fs = { .saveData = &save, .location = &location, .unk4 = &effect };
    for (u32 count = 0; count <= UINT16_MAX; count++) {
        save.counter = count; reset(); mapReads = effects = scripts = 0;
        assert(FieldSystem_UpdatePoison(&fs) == FALSE);
        assert(save.counter == (u16)(count + 1) % 4);
        assert(mapReads == (save.counter == 0));
        assert((reads != 0) == (save.counter == 0));
        assert(effects == 0 && scripts == 0 && writes == 0);
        assert(!memcmp(&save.party, &party, sizeof(party)));
    }
    memset(&party, 0, sizeof(party)); party.count = 1;
    party.mons[0].hp = 3; party.mons[0].status = STATUS_POISON;
    reset();
    assert(VanillaApplyPoisonStep(&party, 123) == FIELD_POISON_DAMAGE);
    assert(party.mons[0].hp == 2 && writes == 1);
    reset();
    assert(VanillaApplyPoisonStep(&party, 123) == FIELD_POISON_SURVIVE);
    assert(party.mons[0].hp == 1 && writes == 3);
    return 0;
}
"""


class FieldPoison(unittest.TestCase):
    def test_no_damage_preserves_accessor_checks_and_step_counter(self):
        mask = 0
        if REFERENCE:
            config = revision(REFERENCE, REFERENCE_COMMIT, "include/config.h")
            self.assertRegex(config, r"(?m)^#define UPDATE_OVERWORLD_POISON\s*$")
            patches = revision(REFERENCE, REFERENCE_COMMIT, "bytereplacement")
            match = re.search(r"#ifdef UPDATE_OVERWORLD_POISON\s+arm9 02054474 ([0-9A-Fa-f]{2})", patches)
            self.assertIsNotNone(match)
            mask = int(match[1], 16)
            self.assertEqual(mask, 0)
        source = (ROOT / "src/script_pokemon_util.c").read_text()
        vanilla = function(revision(ROOT, BASELINE, "src/script_pokemon_util.c"), "ApplyPoisonStep")
        # 02054474 is the immediate status mask after GetMonData; only the mask
        # changes in NewGold. This test-only oracle retains the vanilla branches.
        reference = vanilla.replace("ApplyPoisonStep(", "ReferenceApplyPoisonStep(", 1)
        self.assertEqual(reference.count("(STATUS_POISON | STATUS_BAD_POISON)"), 1)
        reference = reference.replace("(STATUS_POISON | STATUS_BAD_POISON)", str(mask))
        native = function(source, "ApplyPoisonStep").replace("#pragma unused(location)", "(void)location;")
        program = FIXTURE.replace("@ACCESSOR@", function((ROOT / "src/pokemon.c").read_text(), "GetMonData"))
        program = program.replace("@ELIGIBILITY@", function(source, "MonNotFaintedOrEgg"))
        program = program.replace("@NATIVE@", native).replace("@REFERENCE@", reference)
        program = program.replace("@VANILLA@", vanilla.replace("ApplyPoisonStep(", "VanillaApplyPoisonStep(", 1))
        program = program.replace("@CALLER@", function((ROOT / "src/field/field_control.c").read_text(), "FieldSystem_UpdatePoison"))
        with tempfile.TemporaryDirectory(prefix="newgold-poison-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], check=True)
            subprocess.run([str(path / "test")], check=True, cwd=directory)


if __name__ == "__main__":
    unittest.main()
