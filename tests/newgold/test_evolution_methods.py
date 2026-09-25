#!/usr/bin/env python3
"""Run GetMonEvolution on the host for the evolution methods hg-engine added.

The whole function is taken from src/pokemon.c and compiled against stubs:
the evolution table is one row, the clock is an hour, the field is a map and
a weather, the party is an array. Each method is checked against what
hg-engine's GetMonEvolutionInternal does at d0380a487, and where the port
departs from it to the games' behaviour the check says so.
"""

import json
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
    u16 species, heldItem, friendship, move;
    u8 level, form, type1, type2, bits113, evolutionCounter;
    u32 pid, hp, maxHp;
} Pokemon;
typedef struct { int count; Pokemon mons[6]; } Party;
typedef struct { int mapId; } Location;
typedef struct SaveData SaveData;
typedef struct LocalFieldData LocalFieldData;
typedef struct Bag Bag;

static struct Evolution table[MAX_EVOS_PER_POKE];
static int hour, allocations;
static u16 weather, coins;
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
    case MON_DATA_UNUSED_113: return mon->bits113;
    case MON_DATA_EVOLUTION_COUNTER: return mon->evolutionCounter;
    case MON_DATA_HP: return mon->hp;
    case MON_DATA_MAX_HP: return mon->maxHp;
    default: assert(0 && "Unexpected field"); return 0;
    }
}
static inline void SetMonData(Pokemon *mon, int field, void *value) {
    assert(field == MON_DATA_EVOLUTION_COUNTER);
    mon->evolutionCounter = *(u8 *)value;
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
static inline BOOL MonHasMove(Pokemon *mon, u16 move) { return mon->move == move; }
static inline BOOL MonHasMoveOfType(Pokemon *mon, u8 type) { (void)mon; (void)type; return FALSE; }
static inline BOOL Party_HasMon(Party *party, u16 species) {
    for (int i = 0; i < party->count; i++) {
        if (party->mons[i].species == species) {
            return TRUE;
        }
    }
    return FALSE;
}
static inline int Party_GetCount(Party *party) { return party->count; }
static inline Pokemon *Party_GetMonByIndex(Party *party, int slot) { assert(slot < party->count); return &party->mons[slot]; }
static inline SaveData *SaveData_Get(void) { return (SaveData *)&location; }
static inline LocalFieldData *Save_LocalFieldData_Get(SaveData *save) { return (LocalFieldData *)save; }
static inline Location *LocalFieldData_GetCurrentPosition(LocalFieldData *field) { return (Location *)field; }
static inline Bag *Save_Bag_Get(SaveData *save) { return (Bag *)save; }
static inline u16 Bag_GetQuantity(Bag *bag, u16 item, enum HeapID heap) {
    (void)bag;
    assert(item == ITEM_GIMMIGHOUL_COIN && heap == HEAP_ID_DEFAULT);
    return coins;
}
static inline u16 LocalFieldData_GetWeatherType(LocalFieldData *field) { (void)field; return weather; }
static inline void GF_RTC_CopyTime(RTCTime *time) { time->hour = hour; time->minute = 30; time->second = 0; }
@HOUR_FUNCTION@
static TIMEOFDAY GF_RTC_GetTimeOfDay(void) { return GF_RTC_GetTimeOfDayByHour(hour); }
@NIGHT_FUNCTION@
@FUNCTIONS@
@DESIGNED_ROWS@

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

static void check_rocks(void) {
    // hg-engine: the Moss Rock in Ilex Forest and Viridian Forest, the Ice
    // Rock on Ice Path B3F and Seafoam Islands B4F, at any level. Retail's
    // Eterna and Route 217 compared the map's evolution method, which no map
    // has; the rocks read the map, so that number evolves nothing now.
    static const struct { int method; int maps[2]; u16 target; } rocks[] = {
        { EVO_MOSSY_ROCK, { MAP_ILEX_FOREST, MAP_VIRIDIAN_FOREST }, SPECIES_LEAFEON },
        { EVO_ICY_ROCK, { MAP_ICE_PATH_B3F, MAP_SEAFOAM_ISLANDS_B4F }, SPECIES_GLACEON },
    };
    Pokemon mon = { .species = SPECIES_EEVEE, .level = 1 };
    for (int r = 0; r < 2; r++) {
        one_row(rocks[r].method, 0, rocks[r].target);
        for (int map = 0; map < MAP_ID_MAX; map++) {
            location.mapId = map;
            u16 expected = map == rocks[r].maps[0] || map == rocks[r].maps[1] ? rocks[r].target : SPECIES_NONE;
            assert(evolve(&mon, NULL, rocks[r].method) == expected);
            int method = -1;
            assert(GetMonEvolution(NULL, &mon, EVOCTX_LEVELUP, rocks[r].method, &method) == expected);
        }
        location.mapId = rocks[r].maps[0];
        for (int context = EVOCTX_TRADE; context <= EVOCTX_ITEM_USE; context++) {
            assert(GetMonEvolution(NULL, &mon, context, ITEM_LEAF_STONE, NULL) == SPECIES_NONE);
        }
    }
    location.mapId = MAP_NEW_BARK;
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

static void check_nature(void) {
    // hg-engine and the games: thirteen natures make the Amped Form, the
    // other twelve the Low Key Form. The nature is the personality's.
    static const u8 amped[] = {
        NATURE_HARDY, NATURE_BRAVE, NATURE_ADAMANT, NATURE_NAUGHTY, NATURE_DOCILE, NATURE_IMPISH, NATURE_LAX,
        NATURE_HASTY, NATURE_JOLLY, NATURE_NAIVE, NATURE_RASH, NATURE_SASSY, NATURE_QUIRKY,
    };
    Pokemon mon = { .species = SPECIES_TOXEL };
    one_row(EVO_LEVEL_NATURE_AMPED, 30, SPECIES_TOXTRICITY);
    table[1] = (struct Evolution){ EVO_LEVEL_NATURE_LOW_KEY, 30, SPECIES_TOXTRICITY_LOW_KEY };
    for (u32 nature = 0; nature < 25; nature++) {
        int isAmped = memchr(amped, nature, sizeof(amped)) != NULL;
        for (mon.level = 29; mon.level <= 31; mon.level++) {
            mon.pid = 25 * 1000 + nature;
            u16 expected = mon.level < 30 ? SPECIES_NONE : isAmped ? SPECIES_TOXTRICITY : SPECIES_TOXTRICITY_LOW_KEY;
            assert(evolve(&mon, NULL, isAmped ? EVO_LEVEL_NATURE_AMPED : EVO_LEVEL_NATURE_LOW_KEY) == expected);
        }
    }
}

static void check_hurt(void) {
    // hg-engine: at a level-up, 49 HP or more below its maximum and not
    // fainted. At any level.
    Pokemon mon = { .species = SPECIES_YAMASK_GALARIAN, .level = 1, .maxHp = 100 };
    one_row(EVO_HURT_IN_BATTLE_AMOUNT, 49, SPECIES_RUNERIGUS);
    for (mon.hp = 0; mon.hp <= mon.maxHp; mon.hp++) {
        u16 expected = mon.hp != 0 && mon.maxHp - mon.hp >= 49 ? SPECIES_RUNERIGUS : SPECIES_NONE;
        assert(evolve(&mon, NULL, EVO_HURT_IN_BATTLE_AMOUNT) == expected);
    }
    // With less than 49 HP to lose, it never can.
    mon.maxHp = 49;
    for (mon.hp = 0; mon.hp <= mon.maxHp; mon.hp++) {
        assert(evolve(&mon, NULL, EVO_HURT_IN_BATTLE_AMOUNT) == SPECIES_NONE);
    }
}

static void check_critical_hits(void) {
    // hg-engine: the mark the battle leaves at the third critical hit, at any
    // level. The games also want it standing at the end of that battle.
    Pokemon mon = { .species = SPECIES_FARFETCHD_GALARIAN, .level = 1, .maxHp = 50 };
    one_row(EVO_AMOUNT_OF_CRITICAL_HITS, 3, SPECIES_SIRFETCHD);
    for (int bits = 0; bits < 4; bits++) {
        for (mon.hp = 0; mon.hp <= 1; mon.hp++) {
            mon.bits113 = bits;
            u16 expected = (bits & MON_CRITICAL_HITS_EVOLUTION_BIT) && mon.hp != 0 ? SPECIES_SIRFETCHD : SPECIES_NONE;
            assert(evolve(&mon, NULL, EVO_AMOUNT_OF_CRITICAL_HITS) == expected);
        }
    }
}

static void check_form_argument(void) {
    // The games' count on the Pokemon, at least the row's number, at any
    // level: Primeape's twenty Rage Fists, Bisharp's three Bisharp.
    Pokemon mon = { .species = SPECIES_PRIMEAPE, .level = 1 };
    one_row(EVO_FORM_ARGUMENT, 20, SPECIES_ANNIHILAPE);
    for (int count = 0; count <= 255; count++) {
        mon.evolutionCounter = count;
        assert(evolve(&mon, NULL, EVO_FORM_ARGUMENT) == (count >= 20 ? SPECIES_ANNIHILAPE : SPECIES_NONE));
    }
}

static void check_gimmighoul_coins(void) {
    // Gimmighoul's count is the Gimmighoul Coins in the Bag, not its own.
    Pokemon mon = { .species = SPECIES_GIMMIGHOUL, .level = 1, .evolutionCounter = 255 };
    one_row(EVO_FORM_ARGUMENT, GIMMIGHOUL_EVOLUTION_COINS, SPECIES_GHOLDENGO);
    for (coins = 990; coins <= 999; coins++) {
        assert(evolve(&mon, NULL, EVO_FORM_ARGUMENT) == (coins >= 999 ? SPECIES_GHOLDENGO : SPECIES_NONE));
    }
    // And no one else's is.
    mon.species = SPECIES_BISHARP;
    mon.evolutionCounter = 0;
    one_row(EVO_FORM_ARGUMENT, 3, SPECIES_KINGAMBIT);
    assert(evolve(&mon, NULL, EVO_FORM_ARGUMENT) == SPECIES_NONE);
    coins = 0;
}

static void check_defeated_bisharp(void) {
    // A Bisharp counts the Bisharp holding a Leader's Crest it defeats; no
    // other Pokemon, no other Bisharp and no other item.
    static const u16 species[] = { SPECIES_BISHARP, SPECIES_PAWNIARD };
    static const u16 items[] = { ITEM_LEADERS_CREST, ITEM_NONE, ITEM_EVERSTONE };
    for (unsigned own = 0; own < 2; own++) {
        for (unsigned foe = 0; foe < 2; foe++) {
            for (unsigned it = 0; it < 3; it++) {
                Pokemon mon = { .species = species[own] };
                Mon_CountDefeatedMon(&mon, species[foe], items[it]);
                assert(mon.evolutionCounter == (own == 0 && foe == 0 && it == 0));
            }
        }
    }
    Pokemon bisharp = { .species = SPECIES_BISHARP, .level = 1 };
    one_row(EVO_FORM_ARGUMENT, 3, SPECIES_KINGAMBIT);
    for (int defeated = 1; defeated <= 3; defeated++) {
        Mon_CountDefeatedMon(&bisharp, SPECIES_BISHARP, ITEM_LEADERS_CREST);
        assert(evolve(&bisharp, NULL, EVO_FORM_ARGUMENT) == (defeated == 3 ? SPECIES_KINGAMBIT : SPECIES_NONE));
    }
}

static void check_trade_specific_mon(void) {
    // Traded for the row's species, which the trade passes as the party; with
    // no party (the GTS's call), nothing. Not at a level-up or by an item.
    Pokemon karrablast = { .species = SPECIES_KARRABLAST, .level = 1 };
    Party partner = { .count = 1, .mons = { { .species = SPECIES_SHELMET } } };
    Party other = { .count = 1, .mons = { { .species = SPECIES_KARRABLAST } } };
    int method = -1;
    one_row(EVO_TRADE_SPECIFIC_MON, SPECIES_SHELMET, SPECIES_ESCAVALIER);
    assert(GetMonEvolution(&partner, &karrablast, EVOCTX_TRADE, ITEM_NONE, &method) == SPECIES_ESCAVALIER && method == EVO_TRADE_SPECIFIC_MON);
    assert(GetMonEvolution(&other, &karrablast, EVOCTX_TRADE, ITEM_NONE, NULL) == SPECIES_NONE);
    assert(GetMonEvolution(NULL, &karrablast, EVOCTX_TRADE, ITEM_NONE, NULL) == SPECIES_NONE);
    assert(GetMonEvolution(&partner, &karrablast, EVOCTX_LEVELUP, ITEM_NONE, NULL) == SPECIES_NONE);
    assert(GetMonEvolution(&partner, &karrablast, EVOCTX_ITEM_USE, ITEM_LINKING_CORD, NULL) == SPECIES_NONE);
    // An Everstone holds it back, as for any trade.
    karrablast.heldItem = ITEM_EVERSTONE;
    assert(GetMonEvolution(&partner, &karrablast, EVOCTX_TRADE, ITEM_EVERSTONE, NULL) == SPECIES_NONE);
    assert(allocations == 0);
}

static void check_swords_dance(void) {
    // Paolo's design (2026-09-23), Bisharp's rows as evo.json has them: a
    // level-up knowing Swords Dance, at any level; knowing another move, or
    // by trade or item, nothing.
    static const u16 moves[] = { MOVE_NONE, MOVE_SLASH, MOVE_SWORDS_DANCE };
    Pokemon mon = { .species = SPECIES_BISHARP, .level = 1 };
    memcpy(table, rows_SPECIES_BISHARP, sizeof(table));
    for (unsigned m = 0; m < 3; m++) {
        mon.move = moves[m];
        assert(evolve(&mon, NULL, EVO_HAS_MOVE) == (mon.move == MOVE_SWORDS_DANCE ? SPECIES_KINGAMBIT : SPECIES_NONE));
    }
    for (int context = EVOCTX_TRADE; context <= EVOCTX_ITEM_USE; context++) {
        assert(GetMonEvolution(NULL, &mon, context, ITEM_LINKING_CORD, NULL) == SPECIES_NONE);
    }
}

static void check_pay_day(void) {
    // Paolo's design (2026-09-23), both forms' rows as evo.json has them: a
    // level-up knowing Pay Day, with no coin in the Bag; the Chest Form's
    // 999 coins are still its other way, and are the method when both hold.
    static const u16 moves[] = { MOVE_NONE, MOVE_ASTONISH, MOVE_PAY_DAY };
    const struct Evolution *rows[] = { rows_SPECIES_GIMMIGHOUL, rows_SPECIES_GIMMIGHOUL_ROAMING };
    const u16 species[] = { SPECIES_GIMMIGHOUL, SPECIES_GIMMIGHOUL_ROAMING };
    for (unsigned f = 0; f < 2; f++) {
        Pokemon mon = { .species = species[f], .level = 55 };
        memcpy(table, rows[f], sizeof(table));
        for (unsigned m = 0; m < 3; m++) {
            mon.move = moves[m];
            assert(evolve(&mon, NULL, EVO_HAS_MOVE) == (mon.move == MOVE_PAY_DAY ? SPECIES_GHOLDENGO : SPECIES_NONE));
        }
    }
    Pokemon chest = { .species = SPECIES_GIMMIGHOUL, .level = 55, .move = MOVE_PAY_DAY };
    memcpy(table, rows_SPECIES_GIMMIGHOUL, sizeof(table));
    coins = GIMMIGHOUL_EVOLUTION_COINS;
    assert(evolve(&chest, NULL, EVO_FORM_ARGUMENT) == SPECIES_GHOLDENGO);
    coins = 0;
}

static void check_ice_path(void) {
    // Paolo's design (2026-09-23), Milcery's rows as evo.json has them: a
    // level-up on any of the Ice Path's four floors, at any level, holding
    // one of seven Berries, which picks the Sweet. Anywhere else, holding
    // another Berry or nothing, or by trade or item, nothing.
    static const struct { u16 berry, sweet; } berries[] = {
        { ITEM_CHERI_BERRY, SPECIES_ALCREMIE },
        { ITEM_ORAN_BERRY, SPECIES_ALCREMIE_BERRY_SWEET },
        { ITEM_PECHA_BERRY, SPECIES_ALCREMIE_LOVE_SWEET },
        { ITEM_SITRUS_BERRY, SPECIES_ALCREMIE_STAR_SWEET },
        { ITEM_LUM_BERRY, SPECIES_ALCREMIE_CLOVER_SWEET },
        { ITEM_ASPEAR_BERRY, SPECIES_ALCREMIE_FLOWER_SWEET },
        { ITEM_NANAB_BERRY, SPECIES_ALCREMIE_RIBBON_SWEET },
        { ITEM_RAWST_BERRY, SPECIES_NONE },
        { ITEM_NONE, SPECIES_NONE },
    };
    Pokemon mon = { .species = SPECIES_MILCERY, .level = 1 };
    memcpy(table, rows_SPECIES_MILCERY, sizeof(table));
    for (unsigned b = 0; b < sizeof(berries) / sizeof(berries[0]); b++) {
        mon.heldItem = berries[b].berry;
        for (int map = 0; map < MAP_ID_MAX; map++) {
            location.mapId = map;
            int icePath = map == MAP_ICE_PATH_1F || map == MAP_ICE_PATH_B1F || map == MAP_ICE_PATH_B2F || map == MAP_ICE_PATH_B3F;
            assert(evolve(&mon, NULL, EVO_ITEM_ICE_PATH) == (icePath ? berries[b].sweet : SPECIES_NONE));
        }
        location.mapId = MAP_ICE_PATH_B1F;
        for (int context = EVOCTX_TRADE; context <= EVOCTX_ITEM_USE; context++) {
            assert(GetMonEvolution(NULL, &mon, context, berries[b].berry, NULL) == SPECIES_NONE);
        }
    }
    location.mapId = MAP_NEW_BARK;
}

static void check_counted_moves(void) {
    // Primeape counts Rage Fist and Stantler Psyshield Bash, nothing else and
    // no one else; the count stops at 255.
    static const u16 species[] = { SPECIES_PRIMEAPE, SPECIES_STANTLER, SPECIES_MANKEY, SPECIES_ANNIHILAPE };
    static const u16 moves[] = { MOVE_RAGE_FIST, MOVE_PSYSHIELD_BASH, MOVE_TACKLE };
    for (unsigned s = 0; s < 4; s++) {
        for (unsigned m = 0; m < 3; m++) {
            Pokemon mon = { .species = species[s] };
            int counts = (species[s] == SPECIES_PRIMEAPE && moves[m] == MOVE_RAGE_FIST) || (species[s] == SPECIES_STANTLER && moves[m] == MOVE_PSYSHIELD_BASH);
            for (int use = 1; use <= 300; use++) {
                Mon_CountEvolutionMove(&mon, moves[m]);
                assert(mon.evolutionCounter == (counts ? (use < 255 ? use : 255) : 0));
            }
        }
    }
}

static void check_lets_go(void) {
    // A thousand steps, one in four counted: 250 on the byte.
    Pokemon mon = { .species = SPECIES_PAWMO, .level = 1 };
    one_row(EVO_LETS_GO, 0, SPECIES_PAWMOT);
    for (int count = 0; count <= 255; count++) {
        mon.evolutionCounter = count;
        assert(evolve(&mon, NULL, EVO_LETS_GO) == (count >= 250 ? SPECIES_PAWMOT : SPECIES_NONE));
    }
    // The follower's steps count only for a species that evolves so, and stop
    // at 255.
    mon.evolutionCounter = 0;
    table[0].method = EVO_LEVEL;
    Mon_CountLetsGoStep(&mon);
    assert(mon.evolutionCounter == 0);
    table[1] = (struct Evolution){ EVO_LETS_GO, 0, SPECIES_PAWMOT };
    for (int step = 1; step <= 300; step++) {
        Mon_CountLetsGoStep(&mon);
        assert(mon.evolutionCounter == (step < 255 ? step : 255));
    }
}

int main(void) {
    check_magnetic_field();
    check_rocks();
    check_time_of_day();
    check_rain();
    check_dark_type_in_party();
    check_nature();
    check_hurt();
    check_critical_hits();
    check_form_argument();
    check_gimmighoul_coins();
    check_defeated_bisharp();
    check_trade_specific_mon();
    check_swords_dance();
    check_pay_day();
    check_ice_path();
    check_counted_moves();
    check_lets_go();
    return 0;
}
"""


SCENE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include "constants/game_stats.h"
#include "constants/heap.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u8 bytes[16]; } Window;
typedef struct { u16 heldItem; } Pokemon;
typedef struct Bag Bag;
typedef struct Mail Mail;
typedef struct BgConfig BgConfig; typedef struct MsgData MsgData; typedef struct MessageFormat MessageFormat;
typedef struct String String; typedef struct PaletteData PaletteData; typedef struct PokepicManager PokepicManager;
typedef struct Pokepic Pokepic; typedef struct Party Party; typedef struct Options Options;
typedef struct GF3DVramMan GF3DVramMan; typedef struct OverlayManager OverlayManager;
typedef struct PokemonSummaryArgs PokemonSummaryArgs; typedef struct Pokedex Pokedex; typedef struct GameStats GameStats;
typedef struct NARC NARC; typedef struct SpriteSystem SpriteSystem; typedef struct SpriteManager SpriteManager;
typedef struct ManagedSprite ManagedSprite;
@STRUCT@
typedef struct EvolutionTaskData EvolutionTaskData;
static int taken, takenItem;
static BOOL Bag_TakeItem(Bag *bag, u16 item, u16 quantity, enum HeapID heap) { (void)bag; (void)heap; takenItem = item; taken += quantity; return TRUE; }
static void SetMonData(Pokemon *mon, int field, void *value) { assert(field == MON_DATA_HELD_ITEM); mon->heldItem = *(int *)value; }
// The Shedinja half is the retail code, moved to C matching; it is not run here.
static u16 Bag_GetQuantity(Bag *bag, u16 item, enum HeapID heap) { (void)bag; (void)item; (void)heap; return 0; }
static int Party_GetCount(Party *party) { (void)party; return 6; }
static int Party_GetMaxCount(Party *party) { (void)party; return 6; }
static Pokemon *AllocMonZeroed(enum HeapID heap) { (void)heap; assert(0); return NULL; }
static void CopyPokemonToPokemon(Pokemon *a, Pokemon *b) { (void)a; (void)b; }
static Mail *Mail_New(enum HeapID heap) { (void)heap; return NULL; }
static void Heap_Free(void *p) { (void)p; }
#define MI_CpuClearFast(dest, size) memset(dest, 0, size)
static void UpdateMonAbility(Pokemon *mon) { (void)mon; }
static void CalcMonLevelAndStats(Pokemon *mon) { (void)mon; }
static BOOL Party_AddMon(Party *party, Pokemon *mon) { (void)party; (void)mon; return TRUE; }
static void Pokedex_SetMonCaughtFlag(Pokedex *dex, Pokemon *mon) { (void)dex; (void)mon; }
static void GameStats_Inc(GameStats *stats, int stat) { (void)stats; (void)stat; }
static void GameStats_AddScore(GameStats *stats, int score) { (void)stats; (void)score; }
@FUNCTION@

int main(void) {
    Pokemon mon = { ITEM_EVERSTONE };
    EvolutionTaskData data = { .mon = &mon };
    // Gimmighoul spends its 999 coins; any other species by the same method
    // spends nothing.
    data.evolutionCondition = EVO_FORM_ARGUMENT;
    data.species = SPECIES_GIMMIGHOUL;
    sub_02076C90(&data);
    assert(taken == 999 && takenItem == ITEM_GIMMIGHOUL_COIN);
    data.species = SPECIES_PRIMEAPE;
    sub_02076C90(&data);
    assert(taken == 999 && mon.heldItem == ITEM_EVERSTONE);
    // Retail's: an item held to evolve is taken.
    data.evolutionCondition = EVO_ITEM_DAY;
    sub_02076C90(&data);
    assert(mon.heldItem == ITEM_NONE && taken == 999);
    // And Milcery's Berry in the Ice Path.
    mon.heldItem = ITEM_CHERI_BERRY;
    data.evolutionCondition = EVO_ITEM_ICE_PATH;
    sub_02076C90(&data);
    assert(mon.heldItem == ITEM_NONE && taken == 999);
    return 0;
}
"""


def scene():
    source = read("src/unk_02075E14.c")
    struct = re.search(r"struct EvolutionTaskData \{.*?\}; // size: 0x[0-9A-F]+", source, re.S).group()
    return SCENE.replace("@STRUCT@", struct).replace("@FUNCTION@", function(source, "sub_02076C90"))


# The species whose rows, as the table has them, the program runs.
DESIGNED_SPECIES = ("SPECIES_BISHARP", "SPECIES_GIMMIGHOUL", "SPECIES_GIMMIGHOUL_ROAMING", "SPECIES_MILCERY")


def designed_rows():
    """Each of DESIGNED_SPECIES' rows in evo.json, as rows_<species>."""
    table = {entry["baseSpecies"]: entry["evos"] for entry in json.loads(read("files/poketool/personal/evo.json"))["evoTable"]}
    return "\n".join(f"static const struct Evolution rows_{base}[MAX_EVOS_PER_POKE] = {{ "
                     + (", ".join(f"{{ {e['method']}, {e['param']}, {e['target']} }}" for e in table.get(base, []))
                        or "{ EVO_NONE, 0, SPECIES_NONE }") + " };"
                     for base in DESIGNED_SPECIES)


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
        "@DESIGNED_ROWS@": designed_rows(),
        "@FUNCTIONS@": "\n".join(function(source, name) for name in ("GetNatureFromPersonality", "EvolvedPassiveForm", "GetMonEvolution", "Mon_IncrementEvolutionCounter", "Mon_CountEvolutionMove", "Mon_CountDefeatedMon", "Mon_CountLetsGoStep")),
    }
    text = FIXTURE
    for placeholder, replacement in replacements.items():
        text = text.replace(placeholder, replacement)
    return text


def run_program(test, text):
    with tempfile.TemporaryDirectory(prefix="newgold-evolution-methods-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(text)
        build = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Wextra", "-Werror", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test"),
        ], capture_output=True, text=True)
        test.assertEqual(build.returncode, 0, build.stderr)
        run = subprocess.run([str(path / "test")], capture_output=True, text=True)
        test.assertEqual(run.returncode, 0, run.stderr)


class EvolutionMethods(unittest.TestCase):
    def test_the_evolution_spends_gimmighouls_coins(self):
        run_program(self, scene())

    def test_the_wireless_trade_passes_what_it_was_traded_for(self):
        """The Pokemon sent, as a party of one, is the party the trade's
        evolution check is given, and is freed after it."""
        body = function(read("src/launch_application.c"), "Task_WirelessTrade")
        state = body[body.index("case WIRELESS_TRADE_STATE_5:"):body.index("case WIRELESS_TRADE_STATE_6:")]
        self.assertRegex(state, r"Party \*partner = SaveArray_Party_Alloc\(HEAP_ID_FIELD3\);\s*"
                                r"Party_AddMon\(partner, data->wirelessTradeSelectMon\.unk38\);\s*"
                                r"int species = GetMonEvolution\(partner, data->wirelessTradeSelectMon\.unk3C, EVOCTX_TRADE, [^;]*;\s*"
                                r"Heap_Free\(partner\);")
        # unk38 is the Pokemon sent and unk3C the one received.
        self.assertIn("data->tradeSequence.unk0 = Mon_GetBoxMon(data->wirelessTradeSelectMon.unk38);", body)

    def test_the_gts_passes_what_it_was_traded_for(self):
        """The station's evolution check after a trade is given the Pokemon
        the player gave, as a party of one: the one the trade animation sent
        for an offer found, the deposit read back from the save for a
        deposit collected."""
        source = read("src/overlay_70_02241648.c")
        self.assertRegex(function(source, "GetTradeEvolution"),
                         r"Party \*partner = SaveArray_Party_Alloc\(HEAP_ID_61\);\s*int species;\s*"
                         r"Party_AddMon\(partner, given\);\s*"
                         r"species = GetMonEvolution\(partner, mon, EVOCTX_TRADE, [^;]*;\s*"
                         r"Heap_Free\(partner\);")
        body = function(source, "ov70_02241648")
        self.assertNotIn("GetMonEvolution", body)
        self.assertIn("GetTradeEvolution(mon, work->given, &evolutionCondition)", body)
        self.assertIn("GetTradeEvolution(mon, deposit, &depositCondition)", body)
        # The animation sends the station's copy of the save's deposit, at
        # 0x11F0 of its work, which the next step frees.
        self.assertIn("u8 unkBB4[0x11F0 - 0xBB4];\n    Pokemon *given;", read("include/overlay_70.h"))

    def test_the_battle_counts_an_opponent_the_player_defeats(self):
        """Where a Pokemon faints, an opponent's faint counts for the
        player's own Pokemon whose move it was."""
        body = function(read("src/battle/battle_command.c"), "BtlCmd_TryFaintMon")
        self.assertRegex(body, r"BattleSystem_GetFieldSide\(battleSystem, battlerId\) != 0 && ctx->battlerIdAttacker < BattleSystem_GetMaxBattlers\(battleSystem\)\s*"
                               r"&& !\(ctx->switchInFlag & MaskOfFlagNo\(ctx->battlerIdAttacker\)\)\s*"
                               r"&& BattleSystem_GetParty\(battleSystem, ctx->battlerIdAttacker\) == BattleSystem_GetParty\(battleSystem, BATTLER_PLAYER\)\) \{\s*"
                               r"Mon_CountDefeatedMon\(BattleSystem_GetPartyMon\(battleSystem, ctx->battlerIdAttacker, ctx->selectedMonIndex\[ctx->battlerIdAttacker\]\), "
                               r"ctx->battleMons\[battlerId\]\.species, ctx->battleMons\[battlerId\]\.item\);")

    def test_the_field_counts_the_follower_one_step_in_four(self):
        """Each step with the Pokemon walking behind the player visible, one
        in four by the steps walked, for the first Pokemon able to battle --
        the one FollowMon_ChangeMon puts behind the player."""
        body = function(read("src/field/field_control.c"), "FieldSystem_ProcessStep")
        visible = body[body.index("if (FollowMon_IsVisible(fieldSystem)) {"):body.index("return FALSE;", body.index("FollowMon_IsVisible"))]
        self.assertRegex(visible, r"GameStats_GetCapped\(Save_GameStats_Get\(fieldSystem->saveData\), GAME_STAT_STEPS_WALKED\) % LETS_GO_STEPS_PER_COUNT == 0\) \{\s*"
                                  r"Mon_CountLetsGoStep\(GetFirstAliveMonInParty_CrashIfNone\(SaveArray_Party_Get\(fieldSystem->saveData\)\)\);")
        self.assertIn("GetFirstAliveMonInParty_CrashIfNone(party)", function(read("src/follow_mon.c"), "FollowMon_ChangeMon"))

    def test_the_battle_counts_a_move_when_its_pp_goes(self):
        """A move is counted where the battle takes its PP for it, for the
        player's own Pokemon, by its party record."""
        body = function(read("src/battle/battle_controller_player.c"), "ov12_0224B1FC")
        taken = body[body.index("movePPCur[index] -= decreasePP;"):body.index("ctx->moveStatusFlag |= MOVE_STATUS_NO_PP;")]
        self.assertRegex(taken, r"BattleSystem_GetParty\(battleSystem, ctx->battlerIdAttacker\) == BattleSystem_GetParty\(battleSystem, BATTLER_PLAYER\)\) \{\s*"
                                r"Mon_CountEvolutionMove\(BattleSystem_GetPartyMon\(battleSystem, ctx->battlerIdAttacker, ctx->selectedMonIndex\[ctx->battlerIdAttacker\]\), ctx->moveNoTemp\);")

    def test_methods_on_the_host(self):
        run_program(self, program())


if __name__ == "__main__":
    unittest.main()
