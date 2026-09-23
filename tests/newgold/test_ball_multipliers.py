#!/usr/bin/env python3
"""Run the native capture formula with host sanitizers.

BattleSystem_CalculateBallShakes and the helpers above it are extracted from
src/battle/battle_command.c and compiled against the repository's own
constants. The battle, the save and the clock are stand-ins set per throw,
and the random stand-in lets the harness find each throw's shake chance
exactly: the function shakes four times when every roll is below it and not
at all otherwise. Those chances are compared with reference() below, a
transcription of hg-engine's CalculateBallShakes.c (d0380a487, unchanged at
ccf2c9f5) with the ball generations its config.h sets, except for the two
places the port does not copy: the badges are counted, and a Heavy Ball
penalty larger than the catch rate leaves a rate of 1.
"""

import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_level_cap import ROOT
from test_repels import REFERENCE, revision

# The species a Moon Stone evolves, which is what the Moon Ball has meant since
# Generation VIII. HGSS listed whole families instead; the reference builds this
# list with MOON_BALL_GENERATION at GEN_LATEST, so the families are compiled out.
MOON_BALL_SPECIES = [
    "SPECIES_NIDORINA",
    "SPECIES_NIDORINO",
    "SPECIES_CLEFAIRY",
    "SPECIES_JIGGLYPUFF",
    "SPECIES_SKITTY",
    "SPECIES_MUNNA",
]

SOURCE = ROOT / "src/battle/battle_command.c"


def native_code():
    source = SOURCE.read_text()
    return source[source.index("static u32 CriticalCaptureRate("):source.index("static s32 GetMonWeight(u16 species) {")]


def shake_table():
    table = native_code()
    table = table[table.index("sShakeChances[255] = {"):]
    return [int(v) for v in re.findall(r"\d+", table[table.index("{"):table.index("}")])]


PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/balls.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int32_t s32; typedef uint64_t u64;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))

typedef struct { u16 species; u8 level; s32 hp; u32 maxHp; u32 status; u8 gender; } BattleMon;
typedef struct { BattleMon battleMons[4]; int battlerIdAttacker, battlerIdTarget; u16 itemTemp; int totalTurns, safariCatchRateStage; u8 criticalCapture; } BattleContext;
typedef struct BattleSystem BattleSystem;
typedef struct PlayerProfile PlayerProfile;
typedef struct Pokemon Pokemon;

typedef struct {
    u16 ball, species, attackerSpecies;
    u32 rate, speed, weight, level, attackerLevel, hp, maxHp, status, gender, attackerGender;
    u32 badges, caught, type1, type2, terrain, timezone, turns, fishing, battleType, ability, safariStage;
} Throw;

static const Throw *now;
static u32 rolls, shakeRoll, friendship;

static u32 BattleSystem_GetBattleType(BattleSystem *b) { (void)b; return now->battleType; }
static u32 GetMonBaseStat(u16 species, int attr) {
    assert(species == now->species);
    if (attr == BASE_CATCH_RATE) return now->rate;
    assert(attr == BASE_SPEED);
    return now->speed;
}
static const u8 sSafariCatchRateStages[13][2] = { { 10, 40 }, { 10, 35 }, { 10, 30 }, { 10, 25 }, { 10, 20 }, { 10, 15 }, { 10, 10 }, { 15, 10 }, { 20, 10 }, { 25, 10 }, { 30, 10 }, { 35, 10 }, { 40, 10 } };
static const u16 sMoonBallPokemon[6] = { SPECIES_NIDORINA, SPECIES_NIDORINO, SPECIES_CLEFAIRY, SPECIES_JIGGLYPUFF, SPECIES_SKITTY, SPECIES_MUNNA };
static BOOL BattleSystem_CheckMonCaught(BattleSystem *b, u16 species) { (void)b; assert(species == now->species); return now->caught; }
static u32 GetBattlerVar(BattleContext *c, int battler, int var, void *out) { (void)c; (void)out; assert(battler == 1); return var == BMON_DATA_TYPE_1 ? now->type1 : now->type2; }
static int BattleSystem_GetTerrainId(BattleSystem *b) { (void)b; return now->terrain; }
static int BattleSystem_GetTimezone(BattleSystem *b) { (void)b; return now->timezone; }
static BOOL BattleSystem_IsFishing(BattleSystem *b) { (void)b; return now->fishing; }
static s32 GetMonWeight(u16 species) { assert(species == now->species); return now->weight; }
static u16 GetBattlerAbility(BattleContext *c, int battler) { (void)c; assert(battler == 1); return now->ability; }
static PlayerProfile *BattleSystem_GetPlayerProfile(BattleSystem *b, int i) { (void)b; assert(i == 0); return (PlayerProfile *)1; }
static s32 PlayerProfile_CountBadges(PlayerProfile *p) { assert(p); return now->badges; }
static u16 BattleSystem_CountRegionalDexOwned(BattleSystem *b) { (void)b; return 0; }  // no critical roll
static u16 BattleSystem_Random(BattleSystem *b) { (void)b; return rolls++ == 0 ? 0 : shakeRoll; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *b, int battler, int slot) { (void)b; assert(battler == 1 && slot == 0); return (Pokemon *)1; }
static void SetMonData(Pokemon *mon, int attr, const void *value) { assert(mon && attr == MON_DATA_FRIENDSHIP); friendship = *(const u8 *)value; }
@NATIVE@
static const Throw throws[] = {
@THROWS@
};

static u32 shakes(const Throw *t, u32 roll, u8 *critical) {
    BattleContext ctx = { 0 };
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdTarget = 1;
    ctx.itemTemp = t->ball;
    ctx.totalTurns = t->turns;
    ctx.safariCatchRateStage = t->safariStage;
    ctx.battleMons[0] = (BattleMon){ t->attackerSpecies, t->attackerLevel, 1, 1, 0, t->attackerGender };
    ctx.battleMons[1] = (BattleMon){ t->species, t->level, t->hp, t->maxHp, t->status, t->gender };
    now = t;
    rolls = 0;
    shakeRoll = roll;
    u32 n = BattleSystem_CalculateBallShakes(NULL, &ctx);
    *critical = ctx.criticalCapture;
    return n;
}

int main(void) {
    for (unsigned i = 0; i < NELEMS(throws); i++) {
        // The least roll that breaks the first shake is the shake chance;
        // a throw every roll passes has 65536.
        u32 lo = 0, hi = 65536;
        u8 critical;
        while (lo < hi) {
            u32 mid = (lo + hi) / 2;
            u32 n = shakes(&throws[i], mid, &critical);
            assert(n == 0 || n == BALL_SHAKE_MAX);
            if (n == 0) hi = mid; else lo = mid + 1;
        }
        friendship = 0;
        u32 n = shakes(&throws[i], 0, &critical);
        printf("%u %u %u %u\n", lo, n, critical, friendship);
    }
}
'''

FIELDS = ("ball", "species", "attackerSpecies", "rate", "speed", "weight", "level", "attackerLevel", "hp", "maxHp", "status",
          "gender", "attackerGender", "badges", "caught", "type1", "type2", "terrain", "timezone", "turns", "fishing",
          "battleType", "ability", "safariStage")
DEFAULT = dict(ball="ITEM_POKE_BALL", species="SPECIES_RATTATA", attackerSpecies="SPECIES_CYNDAQUIL", rate=255, speed=72,
               weight=35, level=5, attackerLevel=5, hp=20, maxHp=20, status=0, gender="MON_MALE", attackerGender="MON_MALE",
               badges=0, caught=0, type1="TYPE_NORMAL", type2="TYPE_NORMAL", terrain="TERRAIN_GRASS", timezone=1, turns=0,
               fishing=0, battleType=0, ability="ABILITY_RUN_AWAY", safariStage=6)


def throws():
    cases = []

    def add(**kw):
        cases.append({**DEFAULT, **kw})

    # The formula itself: rates, levels either side of 13, HP left, status and badges.
    for rate in (3, 45, 190, 255):
        for level in (2, 5, 13, 14, 25, 36, 60):
            for hp in (20, 9, 1):
                for status in (0, "STATUS_SLEEP_0", "STATUS_BURN", "STATUS_FREEZE"):
                    for badges in (0, 3, 8):
                        add(rate=rate, level=level, hp=hp, status=status, badges=badges)
    for maxHp in (11, 150, 714):
        for hp in (maxHp, maxHp // 2, 1):
            add(rate=45, level=30, maxHp=maxHp, hp=hp)
    # Every ball, with and without what it asks for.
    for ball in ("ITEM_ULTRA_BALL", "ITEM_GREAT_BALL", "ITEM_PREMIER_BALL", "ITEM_LUXURY_BALL", "ITEM_HEAL_BALL", "ITEM_CHERISH_BALL"):
        add(ball=ball, rate=45, level=20)
    for battleType in (0, "BATTLE_TYPE_SAFARI"):
        for stage in (0, 6, 12):
            add(ball="ITEM_SAFARI_BALL", rate=45, level=20, battleType=battleType, safariStage=stage)
    # Doubled by a calm Pokemon, 128 is 256: past 255 the throw is sure.
    add(ball="ITEM_SAFARI_BALL", rate=128, level=20, battleType="BATTLE_TYPE_SAFARI", safariStage=8)
    add(ball="ITEM_SAFARI_BALL", rate=127, level=20, battleType="BATTLE_TYPE_SAFARI", safariStage=8)
    for types in (("TYPE_WATER", "TYPE_WATER"), ("TYPE_GRASS", "TYPE_BUG"), ("TYPE_FIRE", "TYPE_FIRE")):
        add(ball="ITEM_NET_BALL", rate=45, level=20, type1=types[0], type2=types[1])
    for terrain in ("TERRAIN_WATER", "TERRAIN_GRASS", "TERRAIN_CAVE"):
        add(ball="ITEM_DIVE_BALL", rate=45, level=20, terrain=terrain)
        for timezone in (1, 3, 4):
            add(ball="ITEM_DUSK_BALL", rate=45, level=20, terrain=terrain, timezone=timezone)
    for level in (1, 13, 20, 30, 31):
        add(ball="ITEM_NEST_BALL", rate=45, level=level)
    for caught in (0, 1):
        add(ball="ITEM_REPEAT_BALL", rate=45, level=20, caught=caught)
    for turns in (0, 1, 5, 9, 10, 30):
        add(ball="ITEM_TIMER_BALL", rate=45, level=20, turns=turns)
        add(ball="ITEM_QUICK_BALL", rate=45, level=20, turns=turns)
    for speed in (99, 100):
        add(ball="ITEM_FAST_BALL", rate=45, level=20, speed=speed)
    for attackerLevel in (10, 20, 21, 39, 40, 79, 80):
        add(ball="ITEM_LEVEL_BALL", rate=45, level=20, attackerLevel=attackerLevel)
    for fishing in (0, 1):
        add(ball="ITEM_LURE_BALL", rate=45, level=20, fishing=fishing)
    for rate in (3, 20, 45):
        for weight in (500, 998, 999, 1998, 1999, 2998, 2999):
            add(ball="ITEM_HEAVY_BALL", rate=rate, level=20, weight=weight)
    for attacker, attackerGender, gender in (("SPECIES_RATTATA", "MON_MALE", "MON_FEMALE"), ("SPECIES_RATTATA", "MON_MALE", "MON_MALE"),
                                             ("SPECIES_CYNDAQUIL", "MON_MALE", "MON_FEMALE"), ("SPECIES_RATTATA", "MON_GENDERLESS", "MON_FEMALE")):
        add(ball="ITEM_LOVE_BALL", rate=45, level=20, attackerSpecies=attacker, attackerGender=attackerGender, gender=gender)
    for species in ("SPECIES_CLEFAIRY", "SPECIES_CLEFFA", "SPECIES_MUNNA"):
        add(ball="ITEM_MOON_BALL", species=species, rate=45, level=20)
    for battleType in (0, "BATTLE_TYPE_BUG_CONTEST"):
        add(ball="ITEM_SPORT_BALL", rate=45, level=20, battleType=battleType)
    for status, ability in ((0, "ABILITY_RUN_AWAY"), ("STATUS_SLEEP_1", "ABILITY_RUN_AWAY"), (0, "ABILITY_COMATOSE")):
        add(ball="ITEM_DREAM_BALL", rate=45, level=20, status=status, ability=ability)
    for species in ("SPECIES_NIHILEGO", "SPECIES_BLACEPHALON", "SPECIES_RATTATA"):
        for ball in ("ITEM_BEAST_BALL", "ITEM_ULTRA_BALL"):
            add(ball=ball, species=species, rate=45, level=20)
    for caught in (0, 1):
        add(ball="ITEM_FRIEND_BALL", rate=255, level=5, caught=caught)
        add(ball="ITEM_MASTER_BALL", rate=3, level=70, caught=caught)
    return cases


BADGE_LEVELS = (20, 25, 30, 35, 40, 45, 50, 55, 100)
BADGE_PENALTIES = (4096, 3277, 2621, 2097, 1678, 1342, 1074, 859, 687)
MOON = ("SPECIES_NIDORINA", "SPECIES_NIDORINO", "SPECIES_CLEFAIRY", "SPECIES_JIGGLYPUFF", "SPECIES_SKITTY", "SPECIES_MUNNA")
ULTRA_BEASTS = ("SPECIES_NIHILEGO", "SPECIES_BUZZWOLE", "SPECIES_PHEROMOSA", "SPECIES_XURKITREE", "SPECIES_CELESTEELA", "SPECIES_KARTANA",
                "SPECIES_GUZZLORD", "SPECIES_POIPOLE", "SPECIES_NAGANADEL", "SPECIES_STAKATAKA", "SPECIES_BLACEPHALON")
SAFARI = ((10, 40), (10, 35), (10, 30), (10, 25), (10, 20), (10, 15), (10, 10), (15, 10), (20, 10), (25, 10), (30, 10), (35, 10), (40, 10))


def qmul_down(i, q):
    return i if q == 4096 else ((i * q + 2047) >> 12) & 0xFFFFFFFF


def qmul64_up(i, q):
    return (i * q + 2048) >> 12


def reference(t, table):
    """hg-engine's CalculateBallShakes, steps 1 to 11, for a throw that rolls no critical."""
    if t["ball"] == "ITEM_MASTER_BALL":
        return 65536
    rate = t["rate"]
    if t["ball"] == "ITEM_SAFARI_BALL":
        num, den = SAFARI[t["safariStage"]]
        rate = rate * num // den
    ball, level, ratio, heavy = t["ball"], t["level"], 0x1000, 0
    if ball == "ITEM_ULTRA_BALL":
        ratio = 0x2000
    elif ball == "ITEM_GREAT_BALL":
        ratio = 0x1800
    elif ball == "ITEM_SAFARI_BALL":  # SAFARI_BALL_GENERATION 4
        ratio = 0x1800 if t["battleType"] == "BATTLE_TYPE_SAFARI" else 0x1000
    elif ball == "ITEM_NET_BALL":  # NET_BALL_GENERATION 8 and up
        ratio = 0x3800 if {t["type1"], t["type2"]} & {"TYPE_WATER", "TYPE_BUG"} else 0x1000
    elif ball == "ITEM_DIVE_BALL":
        ratio = 0x3800 if t["terrain"] == "TERRAIN_WATER" else 0x1000
    elif ball == "ITEM_NEST_BALL":  # NEST_BALL_GENERATION 5 and up
        ratio = qmul_down((41 - level) * 0x1000 + 2048, 409) if level <= 30 else 0x1000
    elif ball == "ITEM_REPEAT_BALL":  # 8 and up
        ratio = 0x3800 if t["caught"] else 0x1000
    elif ball == "ITEM_TIMER_BALL":  # 5 and up
        ratio = min(1229 * t["turns"] + 0x1000, 0x4000)
    elif ball == "ITEM_DUSK_BALL":  # 7 and up
        ratio = 0x3000 if t["timezone"] in (3, 4) or t["terrain"] == "TERRAIN_CAVE" else 0x1000
    elif ball == "ITEM_QUICK_BALL":  # 5 and up
        ratio = 0x5000 if t["turns"] < 1 else 0x1000
    elif ball == "ITEM_FAST_BALL":
        ratio = 0x4000 if t["speed"] >= 100 else 0x1000
    elif ball == "ITEM_LEVEL_BALL":
        attacker = t["attackerLevel"]
        ratio = 0x8000 if attacker >= 4 * level else 0x4000 if attacker >= 2 * level else 0x2000 if attacker > level else 0x1000
    elif ball == "ITEM_LURE_BALL":  # LURE_BALL_GENERATION 4
        ratio = 0x3000 if t["fishing"] else 0x1000
    elif ball == "ITEM_HEAVY_BALL":
        w = t["weight"]
        heavy = -20 if w < 999 else 0 if w < 1999 else 20 if w < 2999 else 30
    elif ball == "ITEM_LOVE_BALL":
        genders = (t["attackerGender"], t["gender"])
        if t["attackerSpecies"] == t["species"] and genders[0] != genders[1] and "MON_GENDERLESS" not in genders:
            ratio = 0x8000
    elif ball == "ITEM_MOON_BALL":
        ratio = 0x4000 if t["species"] in MOON else 0x1000
    elif ball == "ITEM_SPORT_BALL":  # SPORT_BALL_GENERATION 4
        ratio = 0x1800 if t["battleType"] == "BATTLE_TYPE_BUG_CONTEST" else 0x1000
    elif ball == "ITEM_DREAM_BALL":
        ratio = 0x4000 if t["status"] in ("STATUS_SLEEP_0", "STATUS_SLEEP_1") or t["ability"] == "ABILITY_COMATOSE" else 0x1000
    if t["species"] in ULTRA_BEASTS:
        ratio = 0x5000 if ball == "ITEM_BEAST_BALL" else 0x19A
    elif ball == "ITEM_BEAST_BALL":
        ratio = 0x19A

    a = (3 * t["maxHp"] - 2 * t["hp"]) * 4096
    # Not copied: the reference adds heavyBallMod as a u32, so a rate under 20
    # wraps; here a rate pushed below nothing is 1.
    c = (rate + heavy if rate + heavy >= 0 else 1) * a
    d = qmul64_up(c, ratio)
    # Not copied: the reference sums the badge bitmasks; these are counts.
    badges = min(t["badges"], 8)
    missing = 0
    if level + 5 > BADGE_LEVELS[badges]:
        missing = sum(level > BADGE_LEVELS[i] for i in range(badges, 9))
    e = d * BADGE_PENALTIES[missing] // 4096 // (3 * t["maxHp"])
    f = (36 - 2 * level) * e // 10 if level <= 13 else e
    if t["status"] in ("STATUS_SLEEP_0", "STATUS_SLEEP_1", "STATUS_FREEZE"):
        g = qmul64_up(f, 0x2800)
    elif t["status"]:
        g = qmul64_up(f, 0x1800)
    else:
        g = f
    mcr = min(g, 255 * 4096)
    chance = 65536 if mcr == 255 * 4096 else table[mcr // 4096]
    if rate > 255:
        chance = 65536
    return chance


class BallMultiplierTests(unittest.TestCase):
    def test_native_capture_matches_the_reference(self):
        cases = throws()
        rows = []
        for t in cases:
            rows.append("    { " + ", ".join(str(t[f]) for f in FIELDS) + " },")
        program = PREFIX.replace("@NATIVE@", native_code()).replace("@THROWS@", "\n".join(rows))
        with tempfile.TemporaryDirectory(prefix="newgold-capture-") as temp:
            c, exe = Path(temp) / "check.c", Path(temp) / "check"
            c.write_text(program)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + ["-std=c11", "-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-Wno-unused-function", "-iquote", str(ROOT / "include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
        table = shake_table()
        got = [tuple(int(v) for v in line.split()) for line in result.stdout.splitlines()]
        self.assertEqual(len(got), len(cases))
        for t, (chance, caughtShakes, critical, friendship) in zip(cases, got):
            want = reference(t, table)
            self.assertEqual(chance, want, {k: v for k, v in t.items() if v != DEFAULT[k]})
            if chance:
                # With every roll at 0 it is caught: registered species show a
                # critical throw -- the Master Ball's single shake among them --
                # and a Friend Ball sets the friendship.
                self.assertEqual(caughtShakes, 4)
                self.assertEqual(critical, t["caught"])
                self.assertEqual(friendship, 150 if t["ball"] == "ITEM_FRIEND_BALL" else 0)
        print(f"PASS: {len(cases)} throws have the reference's shake chance.")

    def test_catch_odds_from_the_audit(self):
        # Full HP, a Poke Ball, no status, no badge missing: the odds the
        # audit worked out from the reference, four shakes each.
        table = shake_table()

        def odds(rate, level, badges=8):
            return round((reference({**DEFAULT, "rate": rate, "level": level, "badges": badges}, table) / 65536) ** 4, 3)
        self.assertEqual(odds(255, 5), 0.899)
        self.assertEqual(odds(255, 10), 0.624)
        self.assertEqual(odds(45, 3), 0.272)
        self.assertEqual(odds(45, 25), 0.119)
        # A level-25 Pokemon against a player without badges takes the 0.8.
        self.assertLess(odds(45, 25, badges=0), odds(45, 25))

    def test_shake_table_is_the_reference(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, "d0380a487", "src/individual/CalculateBallShakes.c")
        source = source[source.index("getShakeChancesLookupTable[] = {"):]
        entries = re.findall(r"\[(\d+)\] = (\d+)", source[:source.index("};")])
        self.assertEqual([int(i) for i, _ in entries], list(range(255)))
        self.assertEqual(shake_table(), [int(v) for _, v in entries])

    def test_moon_ball_follows_the_moon_stone(self):
        source = (ROOT / "src/battle/overlay_12_0226C3E8.c").read_text()
        table = source[source.index("const u16 sMoonBallPokemon["):]
        table = table[:table.index("};")]
        self.assertEqual(re.findall(r"SPECIES_\w+", table), MOON_BALL_SPECIES)
        # NELEMS walks the declaration in the header, which the definition
        # includes, so the compiler holds the two to one length.
        self.assertIn(f"const u16 sMoonBallPokemon[{len(MOON_BALL_SPECIES)}] = {{", source)
        self.assertIn('#include "battle/battle_command.h"', source)
        self.assertIn(f"extern const u16 sMoonBallPokemon[{len(MOON_BALL_SPECIES)}];",
                      (ROOT / "include/battle/battle_command.h").read_text())

    def test_moon_ball_matches_the_reference(self):
        if REFERENCE is None:
            self.skipTest("no reference checkout")
        source = revision(REFERENCE, "d0380a487", "src/individual/CalculateBallShakes.c")
        source = source[source.index("MoonBallSpecies[]"):]
        source = source[:source.index("};")]
        # MOON_BALL_GENERATION is GEN_LATEST, so the gen-4 families are not built.
        kept = source[:source.index("#if MOON_BALL_GENERATION == 4")]
        self.assertEqual(re.findall(r"SPECIES_\w+", kept), MOON_BALL_SPECIES)


if __name__ == "__main__":
    unittest.main()
