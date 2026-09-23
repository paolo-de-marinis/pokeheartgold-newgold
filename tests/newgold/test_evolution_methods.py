#!/usr/bin/env python3
"""Run GetMonEvolution on the host for the evolution methods hg-engine added.

The whole function is taken from src/pokemon.c and compiled against stubs:
the evolution table is one row, the clock is an hour, the field is a map and
a weather, the party is an array. Each method is checked against what
hg-engine's GetMonEvolutionInternal does at d0380a487, and where the port
departs from it to the games' behaviour the check says so.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function, read

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
typedef struct { int hour, minute, second; } RTCTime;

typedef struct {
    u16 species, heldItem, friendship;
    u8 level, form, type1, type2;
    u32 pid;
} Pokemon;
typedef struct { int count; Pokemon mons[6]; } Party;
typedef struct { int mapId; } Location;
typedef struct SaveData SaveData;
typedef struct LocalFieldData LocalFieldData;

static struct Evolution table[MAX_EVOS_PER_POKE];
static int hour, allocations;
static u16 weather;
static Location location;

static u32 GetMonData(Pokemon *mon, int field, void *dest) {
    assert(dest == NULL);
    switch (field) {
    case MON_DATA_SPECIES: return mon->species;
    case MON_DATA_HELD_ITEM: return mon->heldItem;
    case MON_DATA_FRIENDSHIP: return mon->friendship;
    case MON_DATA_LEVEL: return mon->level;
    case MON_DATA_FORM: return mon->form;
    case MON_DATA_BEAUTY: return 0;
    case MON_DATA_PERSONALITY: return mon->pid;
    case MON_DATA_TYPE_1: return mon->type1;
    case MON_DATA_TYPE_2: return mon->type2;
    default: assert(0 && "Unexpected field"); return 0;
    }
}
static u32 GetItemAttr(u16 item, int field, enum HeapID heap) {
    assert(field == ITEMATTR_HOLD_EFFECT && heap == HEAP_ID_DEFAULT);
    return item == ITEM_EVERSTONE ? HOLD_EFFECT_NO_EVOLVE : 0;
}
static void *Heap_Alloc(enum HeapID heap, size_t size) {
    assert(heap == HEAP_ID_DEFAULT && size == sizeof(table));
    allocations++;
    return malloc(size);
}
static void Heap_Free(void *memory) { allocations--; free(memory); }
static void LoadMonEvolutionTable(u16 species, struct Evolution *dest) {
    assert(species != SPECIES_NONE);
    memcpy(dest, table, sizeof(table));
}
static inline BOOL MonHasMove(Pokemon *mon, u16 move) { (void)mon; (void)move; return FALSE; }
static inline BOOL MonHasMoveOfType(Pokemon *mon, u8 type) { (void)mon; (void)type; return FALSE; }
static inline BOOL Party_HasMon(Party *party, u16 species) { (void)party; (void)species; return FALSE; }
static inline int Party_GetCount(Party *party) { return party->count; }
static inline Pokemon *Party_GetMonByIndex(Party *party, int slot) { assert(slot < party->count); return &party->mons[slot]; }
static inline SaveData *SaveData_Get(void) { return (SaveData *)&location; }
static inline LocalFieldData *Save_LocalFieldData_Get(SaveData *save) { return (LocalFieldData *)save; }
static inline Location *LocalFieldData_GetCurrentPosition(LocalFieldData *field) { return (Location *)field; }
static inline u16 LocalFieldData_GetWeatherType(LocalFieldData *field) { (void)field; return weather; }
static inline void GF_RTC_CopyTime(RTCTime *time) { time->hour = hour; time->minute = 30; time->second = 0; }
@HOUR_FUNCTION@
static TIMEOFDAY GF_RTC_GetTimeOfDay(void) { return GF_RTC_GetTimeOfDayByHour(hour); }
@NIGHT_FUNCTION@
@FUNCTIONS@

static void one_row(int method, u16 parameter, u16 target) {
    memset(table, 0, sizeof(table));
    table[0] = (struct Evolution){ method, parameter, target };
}

static u16 evolve(Pokemon *mon, Party *party, int expectedMethod) {
    int method = -1;
    u16 target = GetMonEvolution(party, mon, EVOCTX_LEVELUP, ITEM_NONE, &method);
    assert(method == (target ? expectedMethod : -1));
    assert(allocations == 0);
    return target;
}

static void check_magnetic_field(void) {
    // hg-engine: Route 43 and Route 10, by the Power Plant, at any level.
    Pokemon mon = { .species = SPECIES_CHARJABUG, .level = 1 };
    one_row(EVO_MAGNETIC_FIELD, 0, SPECIES_VIKAVOLT);
    for (int map = 0; map < MAP_ID_MAX; map++) {
        location.mapId = map;
        u16 expected = map == MAP_ROUTE_43 || map == MAP_ROUTE_10 ? SPECIES_VIKAVOLT : SPECIES_NONE;
        assert(evolve(&mon, NULL, EVO_MAGNETIC_FIELD) == expected);
    }
    // Not by trade, nor by an item.
    location.mapId = MAP_ROUTE_43;
    for (int context = EVOCTX_TRADE; context <= EVOCTX_ITEM_USE; context++) {
        assert(GetMonEvolution(NULL, &mon, context, ITEM_THUNDERSTONE, NULL) == SPECIES_NONE);
    }
}

static void check_time_of_day(void) {
    // hg-engine: this game's day and night, and dusk as the hour from five.
    // Night is from eight in the evening to four in the morning.
    Pokemon mon = { .species = SPECIES_ROCKRUFF };
    location.mapId = MAP_NEW_BARK;
    for (int method = EVO_LEVEL_DAY; method <= EVO_LEVEL_DUSK; method++) {
        one_row(method, 25, SPECIES_LYCANROC);
        for (hour = 0; hour < 24; hour++) {
            int night = hour < 4 || hour >= 20;
            int rightTime = method == EVO_LEVEL_DAY ? !night : method == EVO_LEVEL_NIGHT ? night : hour == 17;
            for (mon.level = 24; mon.level <= 26; mon.level++) {
                u16 expected = rightTime && mon.level >= 25 ? SPECIES_LYCANROC : SPECIES_NONE;
                assert(evolve(&mon, NULL, method) == expected);
            }
        }
    }
    // Rockruff's two rows: day first, so the hour decides between them.
    one_row(EVO_LEVEL_DAY, 25, SPECIES_LYCANROC);
    table[1] = (struct Evolution){ EVO_LEVEL_NIGHT, 25, SPECIES_LYCANROC_MIDNIGHT };
    mon.level = 25;
    hour = 12;
    assert(evolve(&mon, NULL, EVO_LEVEL_DAY) == SPECIES_LYCANROC);
    hour = 22;
    assert(evolve(&mon, NULL, EVO_LEVEL_NIGHT) == SPECIES_LYCANROC_MIDNIGHT);
}

static void check_rain(void) {
    // hg-engine: rain, heavy rain and thunderstorms, the weather the field
    // shows -- Route 33's and the Lake of Rage's here. The games also count
    // fog, which this game has none of.
    Pokemon mon = { .species = SPECIES_SLIGGOO };
    hour = 12;
    one_row(EVO_LEVEL_RAIN, 50, SPECIES_GOODRA);
    for (weather = WEATHER_SUNNY; weather <= WEATHER_LOW_LIGHT; weather++) {
        int rain = weather == WEATHER_RAIN || weather == WEATHER_HEAVY_RAIN || weather == WEATHER_THUNDERSTORM;
        for (mon.level = 49; mon.level <= 51; mon.level++) {
            u16 expected = rain && mon.level >= 50 ? SPECIES_GOODRA : SPECIES_NONE;
            assert(evolve(&mon, NULL, EVO_LEVEL_RAIN) == expected);
        }
    }
    weather = WEATHER_SUNNY;
}

static void check_dark_type_in_party(void) {
    // hg-engine: the level, and a Dark type anywhere else in the party --
    // either of its types. No party (a trade, say), no evolution.
    Party party = { .count = 3 };
    party.mons[0] = (Pokemon){ .species = SPECIES_PANCHAM, .type1 = TYPE_FIGHTING, .type2 = TYPE_FIGHTING };
    party.mons[1] = (Pokemon){ .species = SPECIES_PIKACHU, .type1 = TYPE_ELECTRIC, .type2 = TYPE_ELECTRIC };
    Pokemon *pancham = &party.mons[0];
    one_row(EVO_LEVEL_DARK_TYPE_MON_IN_PARTY, 32, SPECIES_PANGORO);
    const u8 types[][2] = { { TYPE_NORMAL, TYPE_NORMAL }, { TYPE_DARK, TYPE_DARK }, { TYPE_POISON, TYPE_DARK }, { TYPE_DARK, TYPE_FLYING } };
    for (unsigned t = 0; t < sizeof(types) / sizeof(types[0]); t++) {
        party.mons[2] = (Pokemon){ .species = SPECIES_SNEASEL, .type1 = types[t][0], .type2 = types[t][1] };
        for (pancham->level = 31; pancham->level <= 33; pancham->level++) {
            u16 expected = t != 0 && pancham->level >= 32 ? SPECIES_PANGORO : SPECIES_NONE;
            assert(evolve(pancham, &party, EVO_LEVEL_DARK_TYPE_MON_IN_PARTY) == expected);
            assert(evolve(pancham, NULL, EVO_LEVEL_DARK_TYPE_MON_IN_PARTY) == SPECIES_NONE);
        }
    }
    // Only the Pokemon in the party: a Dark type past its count is not there.
    party.count = 2;
    assert(evolve(pancham, &party, EVO_LEVEL_DARK_TYPE_MON_IN_PARTY) == SPECIES_NONE);
    // And not the evolving Pokemon itself, were it Dark.
    party.count = 1;
    pancham->type2 = TYPE_DARK;
    assert(evolve(pancham, &party, EVO_LEVEL_DARK_TYPE_MON_IN_PARTY) == SPECIES_NONE);
}

int main(void) {
    check_magnetic_field();
    check_time_of_day();
    check_rain();
    check_dark_type_in_party();
    return 0;
}
"""


def program():
    evolution = re.search(r"struct Evolution \{.*?\};\n#define MAX_EVOS_PER_POKE \d+", read("include/pokemon_types_def.h"), re.S)
    rtc = re.search(r"typedef enum RTC_TimeOfDay \{.*?\} TIMEOFDAY;", read("include/gf_rtc.h"), re.S)
    threshold = re.search(r"^#define FRIENDSHIP_EVOLUTION_THRESHOLD\s+\d+", read("src/pokemon.c"), re.M)
    source = read("src/pokemon.c")
    replacements = {
        "@THRESHOLD@": threshold.group(),
        "@EVOLUTION_TYPE@": evolution.group(),
        "@RTC_TYPE@": rtc.group(),
        "@HOUR_FUNCTION@": function(read("src/gf_rtc.c"), "GF_RTC_GetTimeOfDayByHour"),
        "@NIGHT_FUNCTION@": function(read("src/gf_rtc.c"), "IsNighttime"),
        "@FUNCTIONS@": "\n".join(function(source, name) for name in ("EvolvedPassiveForm", "GetMonEvolution")),
    }
    text = FIXTURE
    for placeholder, replacement in replacements.items():
        text = text.replace(placeholder, replacement)
    return text


class EvolutionMethods(unittest.TestCase):
    def test_methods_on_the_host(self):
        with tempfile.TemporaryDirectory(prefix="newgold-evolution-methods-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program())
            build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test"),
            ], capture_output=True, text=True)
            self.assertEqual(build.returncode, 0, build.stderr)
            run = subprocess.run([str(path / "test")], capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stderr)


if __name__ == "__main__":
    unittest.main()
