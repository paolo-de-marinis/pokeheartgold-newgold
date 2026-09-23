#!/usr/bin/env python3
"""Check native friendship evolution methods using the complete actual C function.

Native/pinned-vanilla checks always run. When HG_ENGINE_NEWGOLD_REFERENCE or the
sibling reference checkout is available, compare the three actual NewGold case
bodies too. This does not port new evolution methods/Fairy species or validate
DS ABI, NARC contents, level-up callers, or the evolution presentation.
"""

from pathlib import Path
import os
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import BASELINE, REFERENCE, REFERENCE_COMMIT, ROOT, function, read, revision

SOURCE = "src/pokemon.c"

FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "constants/heap.h"
#include "constants/items.h"
#include "constants/maps.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"
#include "constants/weather.h"

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT assert
@THRESHOLD@
@EVOLUTION_TYPE@
@RTC_TYPE@

typedef struct {
    u16 species, heldItem, friendship, move, moveType, attack, defense;
    u8 level, form, beauty, gender;
    u32 pid;
} Pokemon;
typedef struct { u16 species; } Party;
typedef struct { int mapId; } Location;
typedef struct SaveData SaveData;
typedef struct LocalFieldData LocalFieldData;
// Nowhere magnetic: the magnetic field has its own test.
static Location location = { MAP_NEW_BARK };
// The baseline's name for what hg-engine made the magnetic field.
#define EVO_CORONET EVO_MAGNETIC_FIELD
static struct Evolution table[MAX_EVOS_PER_POKE];
static int hour, allocations;

static u32 GetMonData(Pokemon *mon, int field, void *dest) {
    assert(dest == NULL);
    switch (field) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_HELD_ITEM: return mon->heldItem;
    case MON_DATA_FRIENDSHIP: return mon->friendship;
    case MON_DATA_ATK: return mon->attack;
    case MON_DATA_DEF: return mon->defense;
    case MON_DATA_LEVEL: return mon->level;
    case MON_DATA_FORM: return mon->form;
    case MON_DATA_BEAUTY: return mon->beauty;
    case MON_DATA_GENDER: return mon->gender;
    case MON_DATA_PERSONALITY: return mon->pid;
    default: assert(0 && "Unexpected field"); return 0;
    }
}
static u32 GetItemAttr(u16 item, int field, enum HeapID heap) {
    assert(field == ITEMATTR_HOLD_EFFECT && heap == HEAP_ID_DEFAULT);
    return item == ITEM_EVERSTONE ? HOLD_EFFECT_NO_EVOLVE : 0;
}
static void *Heap_Alloc(enum HeapID heap, size_t size) {
    assert(heap == HEAP_ID_DEFAULT && size == sizeof(table));
    void *result = malloc(size);
    assert(result != NULL);
    allocations++;
    return result;
}
static void Heap_Free(void *memory) { assert(allocations > 0); allocations--; free(memory); }
static void LoadMonEvolutionTable(u16 species, struct Evolution *dest) {
    assert(species != SPECIES_NONE);
    memcpy(dest, table, sizeof(table));
}
static BOOL MonHasMove(Pokemon *mon, u16 move) { return mon->move == move; }
static inline BOOL MonHasMoveOfType(Pokemon *mon, u8 type) { return mon->moveType == type; }
static BOOL Party_HasMon(Party *party, u16 species) { return party->species == species; }
static inline u8 GetNatureFromPersonality(u32 pid) { return (u8)(pid % 25); }
// No Dark type in this party: the one Pokemon it has is not asked its type.
static inline int Party_GetCount(Party *party) { (void)party; return 0; }
static inline Pokemon *Party_GetMonByIndex(Party *party, int slot) { (void)party; (void)slot; return NULL; }
static inline SaveData *SaveData_Get(void) { return (SaveData *)&location; }
static inline LocalFieldData *Save_LocalFieldData_Get(SaveData *save) { return (LocalFieldData *)save; }
static inline Location *LocalFieldData_GetCurrentPosition(LocalFieldData *field) { return (Location *)field; }
static inline u16 LocalFieldData_GetWeatherType(LocalFieldData *field) { (void)field; return 0; }
@HOUR_FUNCTION@
static TIMEOFDAY GF_RTC_GetTimeOfDay(void) { return GF_RTC_GetTimeOfDayByHour(hour); }
typedef struct { int hour, minute, second; } RTCTime;
static inline void GF_RTC_CopyTime(RTCTime *time) { time->hour = hour; time->minute = 0; time->second = 0; }
@NIGHT_FUNCTION@
@VANILLA_FUNCTION@
@NATIVE_FUNCTION@
@REFERENCE@

static void one_row(int method, u16 parameter) {
    memset(table, 0, sizeof(table));
    table[0] = (struct Evolution){ method, parameter, SPECIES_PIKACHU };
}

static void check_expected(Pokemon *mon, int context, u16 expected, int expectedMethod) {
    Pokemon original;
    memcpy(&original, mon, sizeof(original));
    int method = -1;
    assert(GetMonEvolution(NULL, mon, context, ITEM_FIRE_STONE, &method) == expected);
    assert(method == expectedMethod);
    assert(GetMonEvolution(NULL, mon, context, ITEM_FIRE_STONE, NULL) == expected);
    assert(memcmp(mon, &original, sizeof(original)) == 0);
    assert(allocations == 0);
}

static void check_friendship(void) {
    Pokemon mon = { .species = SPECIES_EEVEE, .level = 30 };
    for (int method = EVO_FRIENDSHIP; method <= EVO_FRIENDSHIP_NIGHT; method++) {
        one_row(method, 0);
        for (hour = 0; hour < 24; hour++) {
            int night = hour < 4 || hour >= 20;
            int rightTime = method == EVO_FRIENDSHIP
                || (method == EVO_FRIENDSHIP_DAY && !night)
                || (method == EVO_FRIENDSHIP_NIGHT && night);
            for (int friendship = 0; friendship <= FRIENDSHIP_MAX; friendship++) {
                mon.friendship = friendship;
                int eligible = friendship >= 160 && rightTime;
                check_expected(&mon, EVOCTX_LEVELUP, eligible ? SPECIES_PIKACHU : SPECIES_NONE, eligible ? method : -1);
#ifdef HAVE_REFERENCE
                int referenceMethod = -1;
                u16 target = ReferenceFriendship(friendship, method, &referenceMethod);
                assert(target == (eligible ? SPECIES_PIKACHU : SPECIES_NONE));
                assert(referenceMethod == (eligible ? method : -1));
#endif
            }
        }
    }
}

static void check_guards(void) {
    const u16 friendships[] = {0, 159, 160, 161, 219, 220, 255};
    const u8 levels[] = {1, 50, MAX_LEVEL};
    const int hours[] = {3, 4, 19, 20};
    const u16 species[] = {SPECIES_EEVEE, SPECIES_PICHU, SPECIES_KADABRA};
    Pokemon mon = {0};
    for (int method = EVO_FRIENDSHIP; method <= EVO_FRIENDSHIP_NIGHT; method++) {
        one_row(method, 0);
        for (int context = EVOCTX_LEVELUP; context <= EVOCTX_ITEM_USE; context++) {
            for (unsigned f = 0; f < sizeof(friendships) / sizeof(friendships[0]); f++) {
                mon.friendship = friendships[f];
                for (unsigned l = 0; l < sizeof(levels) / sizeof(levels[0]); l++) {
                    mon.level = levels[l];
                    for (unsigned h = 0; h < sizeof(hours) / sizeof(hours[0]); h++) {
                        hour = hours[h];
                        int night = hour < 4 || hour >= 20;
                        int rightTime = method == EVO_FRIENDSHIP
                            || (method == EVO_FRIENDSHIP_DAY && !night)
                            || (method == EVO_FRIENDSHIP_NIGHT && night);
                        for (unsigned s = 0; s < sizeof(species) / sizeof(species[0]); s++) {
                            mon.species = species[s];
                            for (int form = 0; form <= 1; form++) {
                                mon.form = form;
                                for (int everstone = 0; everstone <= 1; everstone++) {
                                    mon.heldItem = everstone ? ITEM_EVERSTONE : ITEM_NONE;
                                    int eligible = context == EVOCTX_LEVELUP && mon.friendship >= 160 && rightTime
                                        && !(mon.species == SPECIES_PICHU && form == 1)
                                        && (!everstone || mon.species == SPECIES_KADABRA);
                                    check_expected(&mon, context, eligible ? SPECIES_PIKACHU : SPECIES_NONE, eligible ? method : -1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

static void check_unrelated_methods(void) {
    const u16 parameters[] = {0, 25, ITEM_METAL_COAT, MOVE_POUND, EVO_CORONET, EVO_ETERNA, EVO_ROUTE217};
    const u16 items[] = {ITEM_NONE, ITEM_EVERSTONE, ITEM_METAL_COAT};
    const u16 species[] = {SPECIES_EEVEE, SPECIES_PICHU, SPECIES_KADABRA};
    const u8 levels[] = {24, 25, 26};
    const u32 pids[] = {0, 4u << 16, 5u << 16, 9u << 16};
    Pokemon mon = { .move = MOVE_POUND, .friendship = 160 };
    Party party = { .species = SPECIES_PIKACHU };
    for (int method = EVO_NONE; method <= EVO_ROUTE217; method++) {
        if (method >= EVO_FRIENDSHIP && method <= EVO_FRIENDSHIP_NIGHT) continue;
        // HeartGold's Mt. Coronet matched a map evolution method no map has;
        // hg-engine's magnetic field reads the map (test_evolution_methods.py).
        if (method == EVO_MAGNETIC_FIELD) continue;
        for (unsigned p = 0; p < sizeof(parameters) / sizeof(parameters[0]); p++) {
            one_row(method, parameters[p]);
            for (int context = EVOCTX_LEVELUP; context <= EVOCTX_ITEM_USE; context++) {
                for (unsigned i = 0; i < sizeof(items) / sizeof(items[0]); i++) {
                    mon.heldItem = items[i];
                    for (unsigned s = 0; s < sizeof(species) / sizeof(species[0]); s++) {
                        mon.species = species[s];
                        for (unsigned l = 0; l < sizeof(levels) / sizeof(levels[0]); l++) {
                            mon.level = levels[l]; mon.beauty = levels[l];
                            mon.attack = levels[l]; mon.defense = 25;
                            for (unsigned state = 0; state < 4; state++) {
                                mon.gender = state & 1; mon.form = state & 1;
                                mon.pid = pids[state]; hour = state & 1 ? 20 : 4;
                                Party *partyPtr = state & 1 ? &party : NULL;
                                Pokemon original;
                                memcpy(&original, &mon, sizeof(original));
                                int actualMethod = -1, vanillaMethod = -1;
                                u16 usedItem = parameters[p] + (state >> 1);
                                u16 actual = GetMonEvolution(partyPtr, &mon, context, usedItem, &actualMethod);
                                u16 vanilla = VanillaGetMonEvolution(partyPtr, &mon, context, usedItem, &vanillaMethod);
                                assert(actual == vanilla && actualMethod == vanillaMethod);
                                assert(memcmp(&mon, &original, sizeof(mon)) == 0);
                                assert(allocations == 0);
                            }
                        }
                    }
                }
            }
        }
    }
}

static void check_table_order(void) {
    Pokemon mon = { .species = SPECIES_EEVEE, .friendship = 160, .level = 30 };
    one_row(EVO_FRIENDSHIP_DAY, 0);
    table[0].target = SPECIES_ESPEON;
    table[1] = (struct Evolution){ EVO_FRIENDSHIP, 0, SPECIES_PIKACHU };
    table[2] = (struct Evolution){ EVO_FRIENDSHIP_NIGHT, 0, SPECIES_UMBREON };
    hour = 4;
    check_expected(&mon, EVOCTX_LEVELUP, SPECIES_ESPEON, EVO_FRIENDSHIP_DAY);
    hour = 20;
    check_expected(&mon, EVOCTX_LEVELUP, SPECIES_PIKACHU, EVO_FRIENDSHIP);
}

int main(void) {
    check_friendship();
    check_guards();
    check_unrelated_methods();
    check_table_order();
    return 0;
}
"""


def reference_cases():
    config = revision(REFERENCE, REFERENCE_COMMIT, "include/config.h")
    threshold = re.search(r"^#define FRIENDSHIP_EVOLUTION_THRESHOLD\s+\d+", config, re.M)
    source = revision(REFERENCE, REFERENCE_COMMIT, "src/individual/GetMonEvolutionInternal.c")
    cases = source[source.index("            case EVO_FRIENDSHIP:"):source.index("            case EVO_LEVEL:")]
    return ("#define HAVE_REFERENCE\n" + threshold.group().replace("FRIENDSHIP_EVOLUTION_THRESHOLD", "REFERENCE_FRIENDSHIP_THRESHOLD")
            + "\nstatic u16 ReferenceFriendship(u16 friendship, int method, int *method_ret) {\n"
            + "    struct Evolution evoTable[1] = {{method, 0, SPECIES_PIKACHU}};\n"
            + "    int i = 0;\n    u16 target = SPECIES_NONE;\n    switch (method) {\n"
            + cases.replace("FRIENDSHIP_EVOLUTION_THRESHOLD", "REFERENCE_FRIENDSHIP_THRESHOLD")
            + "    }\n    return target;\n}\n")


def run_check(source, vanilla, reference=""):
    evolution = re.search(r"struct Evolution \{.*?\};\n#define MAX_EVOS_PER_POKE \d+", read("include/pokemon_types_def.h"), re.S)
    rtc = re.search(r"typedef enum RTC_TimeOfDay \{.*?\} TIMEOFDAY;", read("include/gf_rtc.h"), re.S)
    threshold = re.search(r"^#define FRIENDSHIP_EVOLUTION_THRESHOLD\s+\d+", read(SOURCE), re.M)
    replacements = {
        "@THRESHOLD@": threshold.group(),
        "@EVOLUTION_TYPE@": evolution.group(),
        "@RTC_TYPE@": rtc.group(),
        "@HOUR_FUNCTION@": function(read("src/gf_rtc.c"), "GF_RTC_GetTimeOfDayByHour"),
        "@NIGHT_FUNCTION@": function(read("src/gf_rtc.c"), "IsNighttime"),
        "@VANILLA_FUNCTION@": function(vanilla, "GetMonEvolution").replace("GetMonEvolution(", "VanillaGetMonEvolution("),
        # GetMonEvolution hands its result to EvolvedPassiveForm, which only
        # changes a target none of these cases reaches.
        "@NATIVE_FUNCTION@": (function(source, "EvolvedPassiveForm") + "\n" if "EvolvedPassiveForm(" in source else "")
        + function(source, "GetMonEvolution"),
        "@REFERENCE@": reference,
    }
    program = FIXTURE
    for placeholder, replacement in replacements.items():
        program = program.replace(placeholder, replacement)
    with tempfile.TemporaryDirectory(prefix="newgold-friendship-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test"),
        ], check=True)
        return subprocess.run([str(path / "test")], cwd=directory, capture_output=True, text=True)


class FriendshipEvolution(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.vanilla = revision(ROOT, BASELINE, SOURCE)

    def test_full_native_function_boundaries_guards_and_unrelated_methods(self):
        result = run_check(read(SOURCE), self.vanilla)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_vanilla_threshold_fails_newgold_boundary(self):
        result = run_check(self.vanilla, self.vanilla)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("GetMonEvolution", result.stderr)

    @unittest.skipIf(REFERENCE is None, "Pinned NewGold reference checkout not configured")
    def test_pinned_newgold_friendship_cases(self):
        result = run_check(read(SOURCE), self.vanilla, reference_cases())
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
