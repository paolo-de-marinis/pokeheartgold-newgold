#!/usr/bin/env python3
"""Check the type chart the ROM compiles with.

The chart is a sparse list of attacker, defender and multiplier triples, so the
change is data rather than logic: this reads the table out of
src/battle/overlay_12_0224E4FC.c and checks the Fairy matchups, Steel's lost
resistances and the invariants the lookup relies on.
"""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

NOT_EFFECTIVE = "TYPE_MUL_NOT_EFFECTIVE"
NORMAL = "TYPE_MUL_NORMAL"
SUPER = "TYPE_MUL_SUPER_EFFECTIVE"
NO_EFFECT = "TYPE_MUL_NO_EFFECT"

FAIRY_ATTACKING = {
    "TYPE_FIGHTING": SUPER,
    "TYPE_DRAGON": SUPER,
    "TYPE_DARK": SUPER,
    "TYPE_FIRE": NOT_EFFECTIVE,
    "TYPE_POISON": NOT_EFFECTIVE,
    "TYPE_STEEL": NOT_EFFECTIVE,
}

ATTACKING_FAIRY = {
    "TYPE_POISON": SUPER,
    "TYPE_STEEL": SUPER,
    "TYPE_FIGHTING": NOT_EFFECTIVE,
    "TYPE_BUG": NOT_EFFECTIVE,
    "TYPE_DARK": NOT_EFFECTIVE,
    "TYPE_DRAGON": NO_EFFECT,
}


def chart():
    source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
    table = source[source.index("static const u8 sTypeEffectiveness[][3] = {"):]
    table = table[:table.index("};")]
    return re.findall(r"\{\s*(\w+),\s*(\w+),\s*(\w+)\s*\}", table)


class FairyTypeTests(unittest.TestCase):
    def setUp(self):
        self.rows = chart()
        # Everything past the Foresight marker is the set those moves ignore.
        marker = self.rows.index(("TYPE_FORESIGHT", "TYPE_FORESIGHT", NO_EFFECT))
        self.ordinary = self.rows[:marker]
        self.matchups = {(a, d): m for a, d, m in self.ordinary}

    def test_fairy_attacks(self):
        for defender, multiplier in FAIRY_ATTACKING.items():
            self.assertEqual(self.matchups.get(("TYPE_FAIRY", defender)), multiplier, defender)

    def test_attacks_on_fairy(self):
        for attacker, multiplier in ATTACKING_FAIRY.items():
            self.assertEqual(self.matchups.get((attacker, "TYPE_FAIRY")), multiplier, attacker)

    def test_fairy_has_no_other_entries(self):
        listed = {(a, d) for a, d, _ in self.ordinary if "TYPE_FAIRY" in (a, d)}
        expected = {("TYPE_FAIRY", d) for d in FAIRY_ATTACKING}
        expected |= {(a, "TYPE_FAIRY") for a in ATTACKING_FAIRY}
        self.assertEqual(listed, expected)

    def test_steel_no_longer_resists_ghost_and_dark(self):
        # Removed in the generation the reference targets.
        self.assertNotIn(("TYPE_GHOST", "TYPE_STEEL"), self.matchups)
        self.assertNotIn(("TYPE_DARK", "TYPE_STEEL"), self.matchups)
        # The rest of Steel's defence is untouched.
        self.assertEqual(self.matchups[("TYPE_NORMAL", "TYPE_STEEL")], NOT_EFFECTIVE)
        self.assertEqual(self.matchups[("TYPE_FIRE", "TYPE_STEEL")], SUPER)

    def test_each_matchup_appears_once(self):
        pairs = [(a, d) for a, d, _ in self.ordinary]
        self.assertEqual(len(pairs), len(set(pairs)), "the lookup takes the first match")

    def test_table_is_terminated(self):
        self.assertEqual(self.rows[-1], ("TYPE_ENDTABLE", "TYPE_ENDTABLE", NO_EFFECT))



class FightButtonTests(unittest.TestCase):
    def test_a_fairy_move_has_a_fight_button_palette(self):
        """ov06_0221BA00 indexes the FIGHT buttons' palettes by the move's type
        with no bound. With eighteen entries, a Fairy move read the word after
        the table -- 0 in the built overlay -- and loaded a palette from
        address 0, a data abort on hardware the moment FIGHT opened."""
        header = (ROOT / "include/overlay_06.h").read_text()
        table = header[header.index("ov06_0221BDD0[NUMBER_OF_MON_TYPES] = {"):]
        table = table[:table.index("};")]
        self.assertIn("[TYPE_FAIRY] = sFightButtonPalette_Fairy", table)
        self.assertEqual(len(re.findall(r"^\s+(?:\[\w+\] = )?\w+,$", table, re.M)), 19)


class DexTypeIconTests(unittest.TestCase):
    def test_a_fairy_species_has_a_dex_type_icon(self):
        """ov18_021F967C and ov18_021F9688 give the Pokedex a type's icon and
        palette with no bound; at eighteen entries a Fairy species loaded
        zukan_gra member 0, a screen file, as its icon."""
        source = (ROOT / "src/application/pokedex/ov18_021F967C.c").read_text()
        self.assertIn("ov18_021FBDFC[NUMBER_OF_MON_TYPES]", source)
        self.assertIn("ov18_021FBE10[NUMBER_OF_MON_TYPES]", source)
        self.assertIn("[TYPE_FAIRY] = 123", source)
        self.assertIn("[TYPE_FAIRY] = 3", source)
        rules = (ROOT / "files/graphic/zukan_gra.mk").read_text()
        self.assertIn("zukan_gra_00000123.NCGR.lz", rules)
        self.assertTrue((ROOT / "files/graphic/zukan_gra/zukan_gra_00000123.png").exists())

# The three places an Arceus's plate becomes a type, the real functions run on
# the host: its form and its type out of battle, its type in battle, and
# Judgment's type.
ARCEUS = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT(x) assert(x)
typedef struct {
    u16 species, ability, item;
    u8 type1, type2, type3;
    u32 hpIV : 5, atkIV : 5, defIV : 5, speedIV : 5, spAtkIV : 5, spDefIV : 5;
} BattleMon;
typedef struct { BattleMon battleMons[4]; u32 fieldCondition; u8 terrainOverlayType; } BattleContext;
typedef struct BattleSystem BattleSystem;
static int GetItemVar(BattleContext *ctx, u16 item, u16 var) { (void)ctx; assert(var == ITEM_VAR_HOLD_EFFECT); return item; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].item; }
static int GetNaturalGiftType(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return 0; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int a, int b, int c) { (void)bs; (void)ctx; (void)a; (void)b; (void)c; return 0; }
static BOOL BattlerIsGrounded(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return TRUE; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)battlerId; return ctx->fieldCondition & FIELD_CONDITION_WEATHER; }
@FUNCTIONS@
int main(void) {
    BattleContext ctx = { 0 };
    // The item's hold effect stands for the item here.
    ctx.battleMons[0] = (BattleMon){ SPECIES_ARCEUS, ABILITY_MULTITYPE, HOLD_EFFECT_ARCEUS_FAIRY, TYPE_NORMAL, TYPE_NORMAL, TYPE_NONE };
    assert(GetArceusTypeByHeldItemEffect(HOLD_EFFECT_ARCEUS_FAIRY) == TYPE_FAIRY);
    assert(GetArceusTypeByHeldItemEffect(HOLD_EFFECT_ARCEUS_STEEL) == TYPE_STEEL);
    assert(GetArceusTypeByHeldItemEffect(0) == TYPE_NORMAL);
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_FAIRY);
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_2) == TYPE_FAIRY);
    assert(GetDynamicMoveType(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_FAIRY);
    ctx.battleMons[0].item = HOLD_EFFECT_ARCEUS_DRAGON;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_DRAGON);
    assert(GetDynamicMoveType(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_DRAGON);
    ctx.battleMons[0].item = 0;
    assert(Battler_GetType(&ctx, 0, BMON_DATA_TYPE_1) == TYPE_NORMAL);
    puts("PASS: a Pixie Plate makes Arceus and its Judgment Fairy.");
    return 0;
}
"""


# The three places the trainer AI types a move for itself, the real functions
# run on the host: the damage estimate, a battler's move type and a party
# Pokemon's move type.
AI = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
typedef struct {
    u16 item;
    u32 hpIV : 5, atkIV : 5, defIV : 5, speedIV : 5, spAtkIV : 5, spDefIV : 5;
    u8 level, friendship;
    int weight;
} BattleMon;
typedef struct { u8 battlerIdTarget; } TrainerAIData;
typedef struct {
    BattleMon battleMons[4];
    u32 fieldCondition, fieldSideConditionFlags[2], battleStatus, effectiveSpeed[4];
    TrainerAIData trainerAIData;
} BattleContext;
typedef struct BattleSystem BattleSystem;
typedef struct Pokemon Pokemon;
static const u16 ov10_0222B068[][2] = { { 0xFFFF, 0xFFFF } };
static u16 sMonItem;
static int sDamageType;
// The item's hold effect stands for the item here.
static int GetItemVar(BattleContext *ctx, u16 item, u16 var) { (void)ctx; return var == ITEMATTR_HOLD_EFFECT ? item : 0; }
static u32 GetMonData(Pokemon *mon, int id, void *data) { (void)mon; (void)data; assert(id == MON_DATA_HELD_ITEM); return sMonItem; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].item; }
static int GetNaturalGiftType(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return 0; }
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int a, int b, int c) { (void)bs; (void)ctx; (void)a; (void)b; (void)c; return 0; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; (void)battlerId; return 1; }
static u16 BattleSystem_Random(BattleSystem *bs) { (void)bs; return 0; }
static int BeatUp_TotalPower(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; return 0; }
static int CalcMoveDamage(BattleSystem *bs, BattleContext *ctx, u32 move, u32 side, u32 field, u16 power, u8 type, u8 attacker, u8 target, u8 crit) {
    (void)bs; (void)ctx; (void)move; (void)side; (void)field; (void)power; (void)attacker; (void)target; (void)crit;
    sDamageType = type;
    return 100;
}
static int ov12_02251D28(BattleSystem *bs, BattleContext *ctx, int move, int type, int attacker, int target, int damage, u32 *flags) {
    (void)bs; (void)ctx; (void)move; (void)attacker; (void)target; (void)flags;
    assert(type == sDamageType);
    return damage;
}
static int DamageDivide(int num, int denom) { return num / denom; }
@FUNCTIONS@
int main(void) {
    static BattleContext ctx;
    u8 ivs[6] = { 0 };
    ctx.battleMons[0].item = HOLD_EFFECT_ARCEUS_FAIRY;
    sMonItem = HOLD_EFFECT_ARCEUS_FAIRY;
    assert(ov10_0221F47C(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_FAIRY);
    assert(ov12_02258BB4(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_FAIRY);
    assert(ov10_0221F084(0, &ctx, MOVE_JUDGMENT, HOLD_EFFECT_ARCEUS_FAIRY, ivs, 0, ABILITY_MULTITYPE, 0, 100) == 100);
    assert(sDamageType == TYPE_FAIRY);
    // Another plate its own type, none Normal, and Klutz none at all.
    ctx.battleMons[0].item = HOLD_EFFECT_ARCEUS_DRAGON;
    sMonItem = HOLD_EFFECT_ARCEUS_DRAGON;
    assert(ov10_0221F47C(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_DRAGON);
    assert(ov12_02258BB4(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_DRAGON);
    ov10_0221F084(0, &ctx, MOVE_JUDGMENT, HOLD_EFFECT_ARCEUS_DRAGON, ivs, 0, ABILITY_MULTITYPE, 0, 100);
    assert(sDamageType == TYPE_DRAGON);
    ctx.battleMons[0].item = 0;
    sMonItem = 0;
    assert(ov10_0221F47C(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_NORMAL);
    assert(ov12_02258BB4(0, &ctx, 0, MOVE_JUDGMENT) == TYPE_NORMAL);
    ov10_0221F084(0, &ctx, MOVE_JUDGMENT, HOLD_EFFECT_ARCEUS_FAIRY, ivs, 0, ABILITY_KLUTZ, 0, 100);
    assert(sDamageType == TYPE_NORMAL);
    puts("PASS: the trainer AI types Judgment with a Pixie Plate as Fairy, at all three sites.");
    return 0;
}
"""


class ArceusFairyTests(unittest.TestCase):
    def test_the_pixie_plate_makes_arceus_fairy(self):
        """An Arceus holding a Pixie Plate is Fairy -- its form, its type in
        battle and Judgment -- as in hg-engine (armips/asm/fairy.s and
        other_battle_calculators.c:3387); here all three stayed Normal."""
        battle = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        pokemon = (ROOT / "src/pokemon.c").read_text()
        functions = "\n".join([function(pokemon, "GetArceusTypeByHeldItemEffect"), function(pokemon, "GetSilvallyTypeByHeldItemEffect"),
                               function(battle, "Battler_GetType"), function(battle, "GetDriveOrMemoryType"),
                               function(battle, "GetDynamicMoveType")])
        with tempfile.TemporaryDirectory(prefix="newgold-arceus-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(ARCEUS.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())

    def test_the_ai_types_judgment_with_the_pixie_plate(self):
        """The trainer AI works out Judgment's type in three places of its own,
        which hg-engine sends through the same plate routine
        (armips/asm/fairy.s, 0x0221F172, 0x0221F4C0, 0x02258C1A)."""
        ai = (ROOT / "src/battle/trainer_ai_0221F084.c").read_text()
        functions = "\n".join([function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "GetDriveOrMemoryType"),
                               function(ai, "ov10_0221F084"), function(ai, "ov10_0221F47C"),
                               function((ROOT / "src/battle/overlay_12_02258800.c").read_text(), "ov12_02258BB4")])
        with tempfile.TemporaryDirectory(prefix="newgold-arceus-ai-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(AI.replace("@FUNCTIONS@", functions))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-maybe-uninitialized",
                "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
