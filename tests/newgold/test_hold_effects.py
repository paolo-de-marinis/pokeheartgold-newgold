#!/usr/bin/env python3
"""Check that a hold effect this port added is a hold effect something reads.

An added held item is three separate things: a constant, a row of item data
naming a HOLD_EFFECT_, and battle code that switches on that effect. The first
two build and test clean on their own -- the item is in the bag, has a name, a
price and an icon, and a Pokemon holds it -- and the third can simply be
missing. Nine items shipped that way: the effects were defined, the records
pointed at them, and no line in src/ ever looked at one, so every one of them
was an ordinary rock to carry around.

Nothing else says so, because there is nothing to say it: an unread case in a
switch is not an error in any language.

Only the effects past retail's last are checked. The retail ones below it are
not all named in C -- the type-weakening Berries are one computed range, the
evolution items are read out of the evolution tables, the weather extenders go
by number -- and sorting those out is a different job from this one.

Then the whole of konefr's item range arrived, and sixty-four hold effects of
theirs came with it that nothing here reads yet. Those are deliberate: the
platform holds every item konefr could reach, and giving each of them its
behaviour is a pass of its own. They are let past the check above and counted
instead, so the block cannot quietly grow, an unread effect written by hand
still fails, and implementing one shows up as the number going down.

A battle script is as much a reader as a .c file. Techno Blast takes its type
from the Drive in effect_script_0312, Multi-Attack from the Memory in 0313, the
Roseli Berry is answered in the resist-berry subscript and Heavy-Duty Boots in
the hazards check -- the reference answers all four in its scripts too -- so
the scripts under files/battledata are read alongside src/, the way
test_ability_effects.py reads them for abilities.
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

HEADER = ROOT / "include/constants/items.h"
ITEM_DATA = ROOT / "files/itemtool/itemdata/item_data.csv"
SRC = ROOT / "src"
SCRIPTS = ROOT / "files/battledata"
OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"


def run_c(program):
    """Compile a fixture against the port's constants and run it; its stdout."""
    with tempfile.TemporaryDirectory(prefix="newgold-items-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Wextra", "-Werror", "-Wno-unused-function", "-Wno-unused-parameter",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test"),
        ], check=True)
        return subprocess.run([str(path / "test")], capture_output=True, text=True, check=True).stdout

# Eviolite's, the first effect this port added. Everything at or above it is
# New Gold's.
FIRST_ADDED = "HOLD_EFFECT_BOOST_IF_NOT_EVOLVED"
# The Douse Drive's, the first of konefr's own effects, renumbered here when
# the whole item range came in. Below it are the effects this port wrote by
# hand, and those have to be read by name somewhere. At or above it are the
# ones the range brought with it, which are counted instead.
FIRST_IMPORTED = "HOLD_EFFECT_DOUSE_DRIVE"
# How many of those an item carries and nothing reads. It was every one of them
# when the range came in; the nine held items that answer being hit or hitting
# took nine off it, and the thirteen that change a number rather than answer an
# event took thirteen more. Counting the battle scripts as readers took the
# twenty-three the scripts had been answering all along: the four Drives, the
# seventeen Memories, the Roseli Berry and Heavy-Duty Boots.
# The Blank Plate's power took one more.
# The three origin items and Ogerpon's three masks took six.
# The Gems took one, the Binding Band one, the Adrenaline Orb one, the
# Blunder Policy one, the Red Card and the Eject Button two, the Eject Pack
# one, the Mirror Herb one. The Rusted Sword and Shield are read as items
# (READ_AS_THE_ITEM) and took two, and the Sachet and the Whipped Dream, once
# the evolution table asked for them, the last two.
IMPORTED_AND_UNREAD = 0


def effects_defined():
    """Every hold effect constant, by name -> number."""
    return {name: int(value) for name, value
            in re.findall(r"#define (HOLD_EFFECT_[A-Z0-9_]+)\s+(\d+)", HEADER.read_text())}


def effects_added():
    """The hold effects this port added, by name."""
    defined = effects_defined()
    return {name for name, value in defined.items() if value >= defined[FIRST_ADDED]}


def effects_in_records():
    """Every hold effect an item record names, by name."""
    return {line.split(",")[2] for line in ITEM_DATA.read_text().splitlines()[1:] if line.strip()}


# Effects the game answers through the item rather than the effect: a Zacian
# or Zamazenta holding its Rusted Sword or Shield is crowned when a battle
# begins (Mon_ChangeToBattleForm), which asks for the item, as the reference's
# ChangeToBattleForm does (src/pokemon.c:2240 at d0380a487); a Spritzee or a
# Swirlix traded holding a Sachet or a Whipped Dream evolves, which the
# evolution table asks, as retail's evolution items are asked. None of the
# four effects is named by any line of either tree. Each counts as read only
# while its item is, by the C or by the evolution table.
READ_AS_THE_ITEM = {
    "HOLD_EFFECT_TRANSFORM_ZACIAN": "ITEM_RUSTED_SWORD",
    "HOLD_EFFECT_TRANSFORM_ZAMAZENTA": "ITEM_RUSTED_SHIELD",
    "HOLD_EFFECT_EVOLVE_SPRITZEE": "ITEM_SACHET",
    "HOLD_EFFECT_EVOLVE_SWIRLIX": "ITEM_WHIPPED_DREAM",
}
EVOLUTIONS = ROOT / "files/poketool/personal/evo.json"


def effects_read():
    """Every hold effect named anywhere under src/ or in a battle script, by
    name, and those READ_AS_THE_ITEM whose item src/ names."""
    read, items = set(), set()
    for path in list(SRC.rglob("*.c")) + list(SCRIPTS.rglob("*.s")):
        text = path.read_text(errors="replace")
        read.update(re.findall(r"HOLD_EFFECT_[A-Z0-9_]+", text))
        if path.suffix == ".c":
            items.update(re.findall(r"ITEM_[A-Z0-9_]+", text))
    items.update(re.findall(r"ITEM_[A-Z0-9_]+", EVOLUTIONS.read_text()))
    read.update(effect for effect, item in READ_AS_THE_ITEM.items() if item in items)
    return read


class HoldEffectTests(unittest.TestCase):
    def test_every_effect_a_record_names_is_defined(self):
        defined = effects_defined()
        for effect in sorted(effects_in_records() - {"HOLD_EFFECT_NONE"}):
            self.assertIn(effect, defined, f"{effect} is in item_data.csv and in no header")

    def test_every_added_effect_an_item_carries_is_read(self):
        defined = effects_defined()
        read = effects_read()
        for effect in sorted(effects_added() & effects_in_records()):
            if defined[effect] >= defined[FIRST_IMPORTED]:
                continue  # counted below instead
            self.assertIn(effect, read,
                          f"an item carries {effect} and nothing in src/ or the battle "
                          f"scripts reads it, "
                          f"so the item does nothing when it is held")

    def test_the_effects_the_item_range_brought_with_it_are_the_only_unread_ones(self):
        """The count is a pin, not a licence: it is the size of the block the
        import left behind, and it only ever goes down."""
        defined = effects_defined()
        unread = sorted(effects_added() & effects_in_records() - effects_read())
        self.assertEqual([e for e in unread if defined[e] < defined[FIRST_IMPORTED]], [],
                         "an effect below the imported block is unread; the test above "
                         "should have said so first")
        self.assertEqual(len(unread), IMPORTED_AND_UNREAD,
                         "the unread hold effects are no longer the block konefr's item "
                         "range brought with it:\n" + "\n".join(unread))

    def test_an_effect_read_as_its_item_is_that_items(self):
        records = item_records()
        for effect, item in READ_AS_THE_ITEM.items():
            self.assertEqual(records[item][0], effect, item)

    def test_every_added_effect_is_carried_by_an_item(self):
        records = effects_in_records()
        for effect in sorted(effects_added()):
            self.assertIn(effect, records,
                          f"{effect} is defined and no item record names it, so no "
                          f"Pokemon can ever have it")


class SoulDew(unittest.TestCase):
    def test_a_fifth_on_dragon_and_psychic_and_no_stat(self):
        """The reference's Soul Dew (CalcBaseDamage.c at d0380a487): x1.2 to a
        Latios or Latias's Dragon and Psychic moves, and nothing to either
        special stat, in the Frontier or not."""
        from test_terrain import overlay_function
        body = overlay_function("CalcMoveDamage")
        blocks = re.findall(r"if \(([^{]*HOLD_EFFECT_LATI_SPECIAL[^{]*)\) \{\n(.*?)\n    \}", body, re.S)
        self.assertEqual(len(blocks), 1, blocks)
        condition, action = blocks[0]
        self.assertIn("calcAttacker.item == HOLD_EFFECT_LATI_SPECIAL", condition)
        self.assertIn("moveType == TYPE_DRAGON || moveType == TYPE_PSYCHIC", condition)
        self.assertIn("calcAttacker.species == SPECIES_LATIOS || calcAttacker.species == SPECIES_LATIAS", condition)
        self.assertNotIn("BATTLE_TYPE_FRONTIER", condition)
        self.assertEqual(action.strip(), "movePower = movePower * 120 / 100;")


REDIRECT_TYPE_FIXTURE = r"""
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { u32 hpIV, atkIV, defIV, speedIV, spAtkIV, spDefIV; } BattleMon;
typedef struct { u32 fieldCondition; int terrainOverlayType; BattleMon battleMons[4]; } BattleContext;
static int sItem;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sItem; }
static int GetNaturalGiftType(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return TYPE_NORMAL; }
static BOOL CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)ctx; (void)flag; (void)battlerId; (void)ability; return FALSE;
}
static BOOL BattlerIsGrounded(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return TRUE; }
static u32 BattlerMoveWeather(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)battlerId; return ctx->fieldCondition; }
@FUNCTION@
int main(void) {
    static const int items[] = { @ITEMS@ };
    static const int moves[] = { MOVE_TECHNO_BLAST, MOVE_MULTI_ATTACK };
    BattleSystem bs; BattleContext ctx = { 0 };
    for (unsigned m = 0; m < 2; m++) {
        for (unsigned i = 0; i < sizeof(items) / sizeof(items[0]); i++) {
            sItem = items[i];
            printf("%d %d %d\n", moves[m], items[i], GetDynamicMoveType(&bs, &ctx, 0, moves[m]));
        }
    }
    return 0;
}
"""

DRIVES = {"BURN": "FIRE", "DOUSE": "WATER", "SHOCK": "ELECTRIC", "CHILL": "ICE"}
MEMORIES = ["FIGHTING", "FLYING", "POISON", "GROUND", "ROCK", "BUG", "GHOST", "STEEL", "FIRE",
            "WATER", "GRASS", "ELECTRIC", "PSYCHIC", "ICE", "DRAGON", "DARK", "FAIRY"]


class RedirectTypeTests(unittest.TestCase):
    """GetDynamicMoveType is the type Lightning Rod and Storm Drain are asked
    about. The reference's (other_battle_calculators.c:3434, 3466 at
    d0380a487) answers Techno Blast with the held Drive's type and
    Multi-Attack with the held Memory's; a hold effect of the other kind, or
    none, leaves both Normal."""

    def test_the_drives_and_the_memories_type_their_moves(self):
        items = ["HOLD_EFFECT_NONE"] + [f"HOLD_EFFECT_{d}_DRIVE" for d in DRIVES] + \
            [f"HOLD_EFFECT_{m}_MEMORY" for m in MEMORIES]
        memory = function((ROOT / "src/pokemon.c").read_text(), "GetSilvallyTypeByHeldItemEffect")
        overlay = OVERLAY.read_text()
        program = REDIRECT_TYPE_FIXTURE.replace("@FUNCTION@", memory + "\n" + function(overlay, "GetDriveOrMemoryType") + "\n"
                                                + function(overlay, "WeatherBallWeather") + "\n" + function(overlay, "WeatherBallType") + "\n"
                                                + function(overlay, "GetDynamicMoveType"))
        program = program.replace("@ITEMS@", ", ".join(items))
        out = [tuple(map(int, line.split())) for line in run_c(program).splitlines()]
        defined = effects_defined()
        header = (ROOT / "include/constants/pokemon.h").read_text()
        types = {name: int(value) for name, value in re.findall(r"#define TYPE_(\w+)\s+(\d+)", header)}
        moves = {name: int(value) for name, value
                 in re.findall(r"#define (MOVE_\w+)\s+(\d+)", (ROOT / "include/constants/moves.h").read_text())}
        got = {(move, item): kind for move, item, kind in out}
        effect = {name: defined.get(name, 0) for name in items}
        for drive, kind in DRIVES.items():
            self.assertEqual(got[moves["MOVE_TECHNO_BLAST"], effect[f"HOLD_EFFECT_{drive}_DRIVE"]], types[kind], drive)
            self.assertEqual(got[moves["MOVE_MULTI_ATTACK"], effect[f"HOLD_EFFECT_{drive}_DRIVE"]], types["NORMAL"], drive)
        for memory in MEMORIES:
            self.assertEqual(got[moves["MOVE_MULTI_ATTACK"], effect[f"HOLD_EFFECT_{memory}_MEMORY"]], types[memory], memory)
            self.assertEqual(got[moves["MOVE_TECHNO_BLAST"], effect[f"HOLD_EFFECT_{memory}_MEMORY"]], types["NORMAL"], memory)
        self.assertEqual(got[moves["MOVE_TECHNO_BLAST"], 0], types["NORMAL"])
        self.assertEqual(got[moves["MOVE_MULTI_ATTACK"], 0], types["NORMAL"])

    def test_the_trainer_ai_types_them_too(self):
        """The trainer AI works a move's type out in three places of its own:
        its damage estimate (ov10_0221F084), a battler's move type
        (ov10_0221F47C, for its switch and Wonder Guard checks) and a party
        Pokemon's (ov12_02258BB4, for whom to send out). They knew Judgment's
        plates and took a Drive's Techno Blast or a Memory's Multi-Attack for
        a Normal move. The reference leaves them retail's; the games type the
        move by the item wherever it is asked."""
        from test_fairy_type import AI
        ai = (ROOT / "src/battle/trainer_ai_0221F084.c").read_text()
        functions = "\n".join([function((ROOT / "src/pokemon.c").read_text(), "GetSilvallyTypeByHeldItemEffect"),
                               function(OVERLAY.read_text(), "GetDriveOrMemoryType"),
                               function(OVERLAY.read_text(), "WeatherBallWeather"), function(OVERLAY.read_text(), "WeatherBallType"),
                               function(ai, "ov10_0221F084"), function(ai, "ov10_0221F47C"),
                               function((ROOT / "src/battle/overlay_12_02258800.c").read_text(), "ov12_02258BB4")])
        program = AI[:AI.index("int main(void) {")].replace("@FUNCTIONS@", functions) + r"""
int main(void) {
    static BattleContext ctx;
    static const int cases[][3] = {
        { MOVE_TECHNO_BLAST, HOLD_EFFECT_SHOCK_DRIVE, TYPE_ELECTRIC },
        { MOVE_TECHNO_BLAST, HOLD_EFFECT_CHILL_DRIVE, TYPE_ICE },
        { MOVE_MULTI_ATTACK, HOLD_EFFECT_FAIRY_MEMORY, TYPE_FAIRY },
        { MOVE_MULTI_ATTACK, HOLD_EFFECT_STEEL_MEMORY, TYPE_STEEL },
        { MOVE_MULTI_ATTACK, HOLD_EFFECT_SHOCK_DRIVE, TYPE_NORMAL },
        { MOVE_TECHNO_BLAST, 0, TYPE_NORMAL },
    };
    u8 ivs[6] = { 0 };
    for (unsigned i = 0; i < sizeof(cases) / sizeof(cases[0]); i++) {
        ctx.battleMons[0].item = cases[i][1];
        sMonItem = cases[i][1];
        assert(ov10_0221F47C(0, &ctx, 0, cases[i][0]) == cases[i][2]);
        assert(ov12_02258BB4(0, &ctx, 0, cases[i][0]) == cases[i][2]);
        ov10_0221F084(0, &ctx, cases[i][0], cases[i][1], ivs, 0, ABILITY_DOWNLOAD, 0, 100);
        assert(sDamageType == cases[i][2]);
    }
    // Klutz keeps the item out of it, as it does Judgment's plate.
    ov10_0221F084(0, &ctx, MOVE_TECHNO_BLAST, HOLD_EFFECT_SHOCK_DRIVE, ivs, 0, ABILITY_KLUTZ, 0, 100);
    assert(sDamageType == TYPE_NORMAL);
    puts("PASS: the trainer AI types Techno Blast by its Drive and Multi-Attack by its Memory, at all three sites.");
    return 0;
}
"""
        with tempfile.TemporaryDirectory(prefix="newgold-drive-ai-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-Wno-maybe-uninitialized",
                "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())


def item_records():
    """item_data.csv by item name: the hold effect and its parameter."""
    rows = {}
    for line in ITEM_DATA.read_text().splitlines()[1:]:
        fields = line.split(",")
        if len(fields) > 3:
            rows[fields[0]] = (fields[2], int(fields[3]))
    return rows


class BlankPlateTests(unittest.TestCase):
    def test_the_blank_plate_powers_normal_moves(self):
        """HeldItemPowerUpTable at d0380a487 (other_battle_calculators.c:81)
        pairs the Blank Plate with Normal like every other plate with its
        type, x1.2 in CalcBaseDamage; the table here multiplies by the
        item's own parameter, 20."""
        source = OVERLAY.read_text()
        table = source[source.index("static const u8 sTypeEnhancingItems[][2] = {"):]
        rows = re.findall(r"\{\s*(HOLD_EFFECT_\w+),\s*(TYPE_\w+)\s*\}", table[:table.index("};")])
        self.assertIn(("HOLD_EFFECT_ARCEUS_NORMAL", "TYPE_NORMAL"), rows)
        self.assertEqual(item_records()["ITEM_BLANK_PLATE"], ("HOLD_EFFECT_ARCEUS_NORMAL", 20))


def power_blocks(effect):
    """The CalcMoveDamage if-blocks that name a hold effect: (condition, body)."""
    from test_terrain import overlay_function
    body = overlay_function("CalcMoveDamage")
    return [(condition, action.strip()) for condition, action
            in re.findall(r"\n    if \(((?:[^{]|\n)*?)\) \{\n(.*?)\n    \}", body, re.S)
            if effect in condition]


class OriginItemsAndMasksTests(unittest.TestCase):
    """CalcBaseDamage.c:879-946 at d0380a487: x1.2 to Dialga's Dragon and
    Steel moves with the Adamant Crystal, Palkia's Dragon and Water with the
    Lustrous Globe, Giratina's Dragon and Ghost with the Griseous Core, and to
    every move of an Ogerpon wearing its own mask."""

    ITEMS = {
        "HOLD_EFFECT_DIALGA_BOOST_AND_TRANSFORM": ("ITEM_ADAMANT_CRYSTAL", ["TYPE_DRAGON", "TYPE_STEEL"],
                                                   ["SPECIES_DIALGA", "SPECIES_DIALGA_ORIGIN"]),
        "HOLD_EFFECT_PALKIA_BOOST_AND_TRANSFORM": ("ITEM_LUSTROUS_GLOBE", ["TYPE_DRAGON", "TYPE_WATER"],
                                                   ["SPECIES_PALKIA", "SPECIES_PALKIA_ORIGIN"]),
        "HOLD_EFFECT_GIRATINA_BOOST_AND_TRANSFORM": ("ITEM_GRISEOUS_CORE", ["TYPE_DRAGON", "TYPE_GHOST"],
                                                     ["SPECIES_GIRATINA"]),
        "HOLD_EFFECT_WELLSPRING_MASK": ("ITEM_WELLSPRING_MASK", [],
                                        ["SPECIES_OGERPON_WELLSPRING_MASK", "SPECIES_OGERPON_WELLSPRING_MASK_TERASTAL"]),
        "HOLD_EFFECT_HEARTHFLAME_MASK": ("ITEM_HEARTHFLAME_MASK", [],
                                         ["SPECIES_OGERPON_HEARTHFLAME_MASK", "SPECIES_OGERPON_HEARTHFLAME_MASK_TERASTAL"]),
        "HOLD_EFFECT_CORNERSTONE_MASK": ("ITEM_CORNERSTONE_MASK", [],
                                         ["SPECIES_OGERPON_CORNERSTONE_MASK", "SPECIES_OGERPON_CORNERSTONE_MASK_TERASTAL"]),
    }

    def test_each_item_gives_its_holder_a_fifth(self):
        records = item_records()
        for effect, (item, types, species) in self.ITEMS.items():
            self.assertEqual(records[item], (effect, 20), item)
            blocks = power_blocks(effect)
            self.assertEqual(len(blocks), 1, effect)
            condition, action = blocks[0]
            self.assertEqual(action, "movePower = movePower * (100 + calcAttacker.mod) / 100;", effect)
            clause = condition
            if "||" in condition and not types:
                # The three masks share one if; take this mask's clause.
                clause = next(c for c in condition.split("\n") if effect in c)
            self.assertIn(f"calcAttacker.item == {effect}", clause)
            for kind in types:
                self.assertIn(f"moveType == {kind}", clause, effect)
            if not types:
                self.assertNotIn("moveType", clause, effect)
            self.assertEqual(sorted(re.findall(r"calcAttacker\.species == (SPECIES_\w+)", clause)), sorted(species), effect)


COMMANDS = ROOT / "src/battle/battle_command.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
SUBSCRIPTS = SCRIPTS / "script/subscript"

GEM_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u8 category; } MoveTbl;
typedef struct { int battlerIdAttacker; u32 moveNoCur; u8 gemBoostingMove; } BattleContext;
static int sEffect, sParam, sType;
static MoveTbl sMove;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sEffect; }
static int GetHeldItemModifier(BattleContext *ctx, int battlerId, int flag) { (void)ctx; (void)battlerId; (void)flag; return sParam; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &sMove; }
static u8 BattleMoveAdjustedType(BattleContext *ctx, int battlerId, u32 moveNo) { (void)ctx; (void)battlerId; (void)moveNo; return sType; }
@FUNCTIONS@
static int boosted(int effect, int param, int type, int category, u32 move) {
    BattleContext ctx = { 0, move, FALSE };
    sEffect = effect; sParam = param; sType = type; sMove.category = category;
    TrySetGemBoost(&ctx);
    return ctx.gemBoostingMove;
}
int main(void) {
    int gem = HOLD_EFFECT_POWERING_UP_MOVE_ONCE;
    assert(boosted(gem, TYPE_FIRE, TYPE_FIRE, CATEGORY_SPECIAL, MOVE_EMBER));
    assert(boosted(gem, TYPE_NORMAL, TYPE_NORMAL, CATEGORY_PHYSICAL, MOVE_TACKLE));
    assert(!boosted(gem, TYPE_WATER, TYPE_FIRE, CATEGORY_SPECIAL, MOVE_EMBER));
    assert(!boosted(gem, TYPE_FIRE, TYPE_FIRE, CATEGORY_STATUS, MOVE_WILL_O_WISP));
    assert(!boosted(gem, TYPE_NORMAL, TYPE_NORMAL, CATEGORY_PHYSICAL, MOVE_STRUGGLE));
    assert(!boosted(gem, TYPE_WATER, TYPE_WATER, CATEGORY_SPECIAL, MOVE_WATER_PLEDGE));
    assert(!boosted(gem, TYPE_FIRE, TYPE_FIRE, CATEGORY_SPECIAL, MOVE_FIRE_PLEDGE));
    assert(!boosted(gem, TYPE_GRASS, TYPE_GRASS, CATEGORY_SPECIAL, MOVE_GRASS_PLEDGE));
    assert(!boosted(HOLD_EFFECT_STRENGTHEN_FIRE, TYPE_FIRE, TYPE_FIRE, CATEGORY_SPECIAL, MOVE_EMBER));
    // Once set, a later hit with the Gem gone keeps the boost.
    BattleContext ctx = { 0, MOVE_EMBER, TRUE };
    sEffect = HOLD_EFFECT_NONE;
    TrySetGemBoost(&ctx);
    assert(ctx.gemBoostingMove);
    return 0;
}
"""


class GemTests(unittest.TestCase):
    """The Gems (BattleController_BeforeMove.c:1103, CalcBaseDamage.c:913 and
    subscript_0452 at d0380a487): x1.3 to the holder's first damaging move of
    the Gem's type that hits, not Struggle or a Pledge, the Gem spent with a
    line when the move connects, and no Thief, Covet or Magician theft on a
    move a Gem powered."""

    def test_which_moves_a_gem_powers(self):
        source = COMMANDS.read_text()
        functions = "\n".join(function(source, name) for name in ("BattlerGemPowersMove", "TrySetGemBoost"))
        run_c(GEM_FIXTURE.replace("@FUNCTIONS@", functions))
        for command in ("BtlCmd_CalcDamage", "BtlCmd_CalcDamageRaw"):
            body = function(source, command)
            self.assertLess(body.index("TrySetGemBoost(ctx);"), body.index("DamageCalcDefault("), command)

    def test_every_gem_names_its_type(self):
        types = {name: int(value) for name, value
                 in re.findall(r"#define (TYPE_\w+)\s+(\d+)", (ROOT / "include/constants/pokemon.h").read_text())}
        gems = {item: param for item, (effect, param) in item_records().items()
                if effect == "HOLD_EFFECT_POWERING_UP_MOVE_ONCE"}
        self.assertEqual(len(gems), 18)
        for item, param in gems.items():
            kind = item[len("ITEM_"):-len("_GEM")]
            self.assertEqual(param, types[f"TYPE_{kind}"], item)

    def test_three_tenths_on_the_power(self):
        blocks = power_blocks("ctx->gemBoostingMove")
        self.assertEqual(len(blocks), 1)
        self.assertIn("battlerIdAttacker == ctx->battlerIdAttacker", blocks[0][0])
        self.assertEqual(blocks[0][1], "movePower = movePower * 13 / 10;")
        self.assertIn("ctx->gemBoostingMove = FALSE;", function(OVERLAY.read_text(), "BattleContext_Init"))

    def test_the_gem_is_spent_as_the_move_connects(self):
        body = function(CONTROLLER.read_text(), "ov12_0224C678")
        spend = body.index("BATTLE_SUBSCRIPT_GEM")
        # A move CalcDamage never saw -- a fixed amount of damage -- is asked
        # about the Gem here, before it is spent.
        self.assertLess(body.index("if (!ctx->gemBoostingMove) {\n        TrySetGemBoost(ctx);\n    }"), spend)
        self.assertLess(body.index("ctx->gemBoostingMove && GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_POWERING_UP_MOVE_ONCE"), spend)
        self.assertLess(spend, body.index("BATTLE_SUBSCRIPT_USE_MOVE"))
        self.assertIn("ctx->commandNext = CONTROLLER_COMMAND_27;", body[spend:body.index("BATTLE_SUBSCRIPT_USE_MOVE")])
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_GEM\s+(\d+)",
                               (ROOT / "include/constants/battle_subscript.h").read_text()).group(1))
        script = (SUBSCRIPTS / f"subscript_{number:04d}_Gem.s").read_text()
        order = ["PrintAttackMessage", "BATTLE_ANIMATION_HELD_ITEM",
                 "PrintMessage msg_0197_01570, TAG_ITEM_MOVE, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_ATTACKER",
                 "RemoveItem BATTLER_CATEGORY_ATTACKER"]
        self.assertEqual(sorted(order, key=script.index), order)
        gmm = (ROOT / "files/msgdata/msg/msg_0197.gmm").read_text()
        row = gmm[gmm.index('<row id="msg_0197_01570"'):]
        self.assertIn("strengthened", row[:row.index("</row>")])

    def test_no_theft_on_a_move_a_gem_powered(self):
        thief = function(COMMANDS.read_text(), "BtlCmd_TryStealItem")
        self.assertRegex(thief, r"\} else if \(ctx->gemBoostingMove\) \{\n(?:\s*//[^\n]*\n)*\s*BattleScriptIncrementPointer\(ctx, adrs1\);")
        self.assertRegex(OVERLAY.read_text(), r"== ABILITY_MAGICIAN && !ctx->gemBoostingMove &&")


BIND_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include "constants/battle.h"
#include "constants/items.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define FALSE 0
#define TRUE 1
typedef struct BattleSystem BattleSystem;
typedef struct { u32 status2; struct { u32 battlerIdBinding : 2; u16 bindingMove; } unk88; } BattleMon;
typedef struct { u8 bindEighthTurn : 1; } MoveConditions;
typedef struct {
    BattleMon battleMons[4]; MoveConditions moveConditions[4];
    int battlerIdAttacker, battlerIdTarget, moveNoCur; u8 bindingBandBinds;
} BattleContext;
static int sItem[4];
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; return sItem[battlerId]; }
static int MaskOfFlagNo(int n) { return 1 << n; }
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return 0; }
static int BattleSystem_Random(BattleSystem *bs) { (void)bs; return 0; }
@FUNCTION@
int main(void) {
    BattleContext ctx = { 0 };
    @CHECKS@
    return 0;
}
"""


class BindingTests(unittest.TestCase):
    def run_divisor(self, checks):
        body = function(CONTROLLER.read_text(), "BindDamageDivisor") + "\n" + function(COMMANDS.read_text(), "BtlCmd_SetBindingTurns")
        run_c(BIND_FIXTURE.replace("@FUNCTION@", body).replace("@CHECKS@", checks))

    def test_a_binding_move_takes_an_eighth(self):
        """ServerFieldConditionCheck.c:870 at d0380a487 divides by 8;
        HeartGold divided by 16."""
        self.run_divisor("ctx.battlerIdAttacker = 1; BtlCmd_SetBindingTurns(NULL, &ctx);"
                         "assert(BindDamageDivisor(&ctx, 0) == 8);")
        self.assertIn("DamageDivide(ctx->battleMons[battlerId].maxHp * -1, BindDamageDivisor(ctx, battlerId))",
                      function(CONTROLLER.read_text(), "BattleControllerPlayer_UpdateMonCondition"))

    def test_a_binding_band_on_the_binder_makes_it_a_sixth(self):
        """The reference reads no Binding Band; Pokemon Central (Legafascia):
        a sixth instead of an eighth from the sixth generation on, for the
        binding moves the band's holder uses. The band is read as the bind
        begins: the binder losing it later keeps the sixth, and one on the
        bound Pokemon counts for nothing."""
        self.run_divisor("ctx.battlerIdAttacker = 1; sItem[1] = HOLD_EFFECT_TRAPPING_DAMAGE_UP;"
                         "BtlCmd_SetBindingTurns(NULL, &ctx);"
                         "assert(BindDamageDivisor(&ctx, 0) == 6);"
                         "sItem[1] = HOLD_EFFECT_NONE; assert(BindDamageDivisor(&ctx, 0) == 6);"
                         "ctx.battlerIdTarget = 2; sItem[2] = HOLD_EFFECT_TRAPPING_DAMAGE_UP;"
                         "BtlCmd_SetBindingTurns(NULL, &ctx);"
                         "assert(BindDamageDivisor(&ctx, 2) == 8 && BindDamageDivisor(&ctx, 0) == 6);"
                         "sItem[1] = HOLD_EFFECT_TRAPPING_DAMAGE_UP; assert(BindDamageDivisor(&ctx, 2) == 8);")


def subscript_named(define):
    """The source of the subscript a BATTLE_SUBSCRIPT_ define numbers."""
    number = int(re.search(rf"#define {define}\s+(\d+)",
                           (ROOT / "include/constants/battle_subscript.h").read_text()).group(1))
    matches = sorted(SUBSCRIPTS.glob(f"subscript_{number:04d}_*.s"))
    assert len(matches) == 1, (define, matches)
    return matches[0].read_text()


def walk(script, answer):
    """Follow a subscript's branches and return the subscripts it calls.

    Only the commands that choose a path are understood: a CheckAbility or
    CheckItemHoldEffect jumps when answer(...) says so, a CompareMonDataToValue
    jumps when answer(field) equals the value (OPCODE_EQU) or answer(flag) is
    true (OPCODE_FLAG_SET), TryReplaceFaintedMon jumps unless
    answer("REPLACEMENT"), GoTo jumps, End stops. Call, GoToSubscript (which
    also stops) and SwitchAndUpdateMon are recorded. Everything else is walked
    past."""
    lines = [line.split("//")[0].strip() for line in script.splitlines()]
    labels = {line[:-1]: i for i, line in enumerate(lines) if line.endswith(":")}
    calls, i = [], 0
    while i < len(lines):
        words = lines[i].replace(",", " ").split()
        i += 1
        if not words:
            continue
        op, args = words[0], words[1:]
        if op == "End":
            break
        if op == "GoTo":
            i = labels[args[0]]
        elif op == "Call":
            calls.append(args[0])
        elif op in ("CheckAbility", "CheckItemHoldEffect"):
            if (args[0] == "CHECK_OPCODE_HAVE") == bool(answer(args[2])):
                i = labels[args[3]]
        elif op == "CompareMonDataToValue" and args[0] == "OPCODE_EQU":
            value = int(args[3], 0) if args[3][0].isdigit() else args[3]
            if answer(args[2]) == value:
                i = labels[args[4]]
        elif op == "CompareMonDataToValue" and args[0] == "OPCODE_FLAG_SET":
            if answer(args[3]):
                i = labels[args[4]]
        elif op == "TryReplaceFaintedMon":
            if not answer("REPLACEMENT"):
                i = labels[args[2]]
        elif op == "GoToSubscript":
            calls.append(args[0])
            break
        elif op == "SwitchAndUpdateMon":
            calls.append(f"{op} {args[0]}")
    return calls


class AdrenalineOrbTests(unittest.TestCase):
    """No reference reader; Pokemon Central (Fifasfera): Intimidate on the
    holder raises its Speed a stage and spends the orb, also when an ability
    kept the Attack up, but not when the Attack was already at its limit or the
    Speed has no room. The Attack drop itself is always tried."""

    DROP = "BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE"
    RAISE = "BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT"

    def orb(self, contrary=False, atk=6, speed=6):
        state = {"ABILITY_CONTRARY": contrary, "BMON_DATA_STAT_CHANGE_ATK": atk,
                 "BMON_DATA_STAT_CHANGE_SPEED": speed}
        return walk(subscript_named("BATTLE_SUBSCRIPT_ADRENALINE_ORB"), state.get)

    def test_intimidate_sends_the_holder_through_the_orb(self):
        script = subscript_named("BATTLE_SUBSCRIPT_INTIMIDATE")
        self.assertEqual(walk(script, {}.get), [self.DROP])
        self.assertEqual(walk(script, {"HOLD_EFFECT_INTIMIDATE_BOOST_SPEED": True}.get),
                         ["BATTLE_SUBSCRIPT_ADRENALINE_ORB"])

    def test_when_the_orb_raises_speed(self):
        self.assertEqual(self.orb(), [self.DROP, self.RAISE])
        self.assertEqual(self.orb(atk=0), [self.DROP])
        self.assertEqual(self.orb(speed=12), [self.DROP])
        self.assertEqual(self.orb(speed=11), [self.DROP, self.RAISE])
        self.assertEqual(self.orb(contrary=True), [self.DROP, self.RAISE])
        self.assertEqual(self.orb(contrary=True, atk=12), [self.DROP])
        self.assertEqual(self.orb(contrary=True, speed=0), [self.DROP])
        self.assertEqual(self.orb(contrary=True, speed=12), [self.DROP, self.RAISE])

    def test_the_raise_is_the_holders_speed_and_credits_the_orb(self):
        script = subscript_named("BATTLE_SUBSCRIPT_ADRENALINE_ORB")
        raise_at = script.index("Call BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT")
        setup = script[:raise_at]
        self.assertIn("UpdateVar OPCODE_SET, BSCRIPT_VAR_MESSAGE, STAT_SPEED", setup)
        self.assertIn("UpdateVarFromVar OPCODE_SET, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_STAT_CHANGE", setup)
        self.assertIn("BMON_DATA_HELD_ITEM, BSCRIPT_VAR_MSG_ITEM_TEMP", setup)


BLUNDER_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/move_effects.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef int8_t s8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { u16 effect; } MoveTbl;
typedef struct { int hp; s8 statChanges[8]; } BattleMon;
typedef struct { int battlerIdAttacker; u32 moveNoCur; u32 moveStatusFlag; BattleMon battleMons[4]; } BattleContext;
static int sItem, sAbility;
static MoveTbl sMove;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sItem; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sAbility; }
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return &sMove; }
@FUNCTION@
static int answers(int item, u32 flags, int effect, int hp, int speed, int ability) {
    BattleContext ctx = { 0 };
    sItem = item; sAbility = ability; sMove.effect = effect;
    ctx.moveStatusFlag = flags;
    ctx.battleMons[0].hp = hp;
    ctx.battleMons[0].statChanges[STAT_SPEED] = speed;
    return BlunderPolicyAnswersMiss(&ctx);
}
int main(void) {
    int bp = HOLD_EFFECT_BOOST_SPEED_ON_MISS;
    assert(answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 50, 6, ABILITY_NONE));
    assert(answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 50, 11, ABILITY_NONE));
    assert(!answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 50, 12, ABILITY_NONE));
    assert(answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 50, 12, ABILITY_CONTRARY));
    assert(!answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 50, 0, ABILITY_CONTRARY));
    assert(!answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_ONE_HIT_KO, 50, 6, ABILITY_NONE));
    assert(!answers(bp, MOVE_STATUS_MISSED | MOVE_STATUS_SEMI_INVULNERABLE, MOVE_EFFECT_HIT, 50, 6, ABILITY_NONE));
    assert(!answers(bp, MOVE_STATUS_MISSED | MOVE_STATUS_PROTECTED, MOVE_EFFECT_HIT, 50, 6, ABILITY_NONE));
    assert(!answers(bp, MOVE_STATUS_NO_EFFECT, MOVE_EFFECT_HIT, 50, 6, ABILITY_NONE));
    assert(!answers(bp, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 0, 6, ABILITY_NONE));
    assert(!answers(HOLD_EFFECT_NONE, MOVE_STATUS_MISSED, MOVE_EFFECT_HIT, 50, 6, ABILITY_NONE));
    return 0;
}
"""


class BlunderPolicyTests(unittest.TestCase):
    """The reference has a TODO where the Blunder Policy goes; Pokemon Central
    (Fiascopolizza): a miss on the accuracy roll alone raises the holder's
    Speed two stages and spends the policy -- not for a one-hit KO, a target
    out of reach, a guard or an immunity, and not at Speed +6 (-6 with
    Contrary)."""

    def test_which_misses_it_answers(self):
        body = function(CONTROLLER.read_text(), "BlunderPolicyAnswersMiss")
        run_c(BLUNDER_FIXTURE.replace("@FUNCTION@", body))

    def test_the_missed_branch_hands_it_the_miss(self):
        body = function(CONTROLLER.read_text(), "ov12_0224C5F8")
        self.assertIn("BlunderPolicyAnswersMiss(ctx) == TRUE ? BATTLE_SUBSCRIPT_BLUNDER_POLICY : BATTLE_SUBSCRIPT_MISSED",
                      body)

    def test_the_miss_is_told_then_speed_rises_two_and_the_policy_goes(self):
        script = subscript_named("BATTLE_SUBSCRIPT_BLUNDER_POLICY")
        self.assertEqual(walk(script, {}.get), ["BATTLE_SUBSCRIPT_MISSED", "BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE"])
        self.assertEqual(walk(script, {"BMON_DATA_HP": 0}.get), ["BATTLE_SUBSCRIPT_MISSED"])
        raise_at = script.index("Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE")
        for line in ("SIDE_EFFECT_TYPE_HELD_ITEM", "MOVE_SUBSCRIPT_PTR_SPEED_UP_2_STAGES",
                     "BSCRIPT_VAR_BATTLER_STAT_CHANGE, BSCRIPT_VAR_BATTLER_ATTACKER",
                     "BMON_DATA_HELD_ITEM, BSCRIPT_VAR_MSG_ITEM_TEMP"):
            self.assertIn(line, script[:raise_at])
        self.assertIn("RemoveItem BATTLER_CATEGORY_ATTACKER", script[raise_at:])


SWITCH_ITEM_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/moves.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { int hp; u32 moveEffectFlags; u8 hitCount; } BattleMon;
typedef struct { int physicalDamage, specialDamage; u32 sheerForceTraded : 1; } SelfTurnData;
typedef struct {
    int battlerIdAttacker, battlerIdTemp; u32 moveNoCur; u32 battleStatus2;
    BattleMon battleMons[4]; SelfTurnData selfTurnData[4];
} BattleContext;
static struct { int item[4], ability[4]; u32 battleType; int suppressible, replacements, picked; } S;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; return S.item[battlerId]; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return S.ability[battlerId]; }
static BOOL IsSuppressibleSecondaryEffect(BattleContext *ctx, u32 moveNo) { (void)ctx; (void)moveNo; return S.suppressible; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { (void)bs; return S.battleType; }
static BOOL TryPickForcedSwitchIn(BattleSystem *bs, BattleContext *ctx, int battlerId) {
    (void)bs; (void)ctx; S.picked = battlerId + 1; return S.replacements;
}
static BOOL CanSwitchMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; return S.replacements; }
@FUNCTION@
static BattleContext ctx;
static BattleSystem bs;
static void reset(void) {
    for (int i = 0; i < 4; i++) { S.item[i] = HOLD_EFFECT_NONE; S.ability[i] = ABILITY_NONE; }
    S.battleType = BATTLE_TYPE_TRAINER; S.suppressible = 0; S.replacements = 1; S.picked = 0;
    ctx = (BattleContext){ 0 };
    ctx.battlerIdAttacker = 0; ctx.battlerIdTemp = -1;
    for (int i = 0; i < 4; i++) { ctx.battleMons[i].hp = 50; ctx.battleMons[i].hitCount = 1; }
    ctx.selfTurnData[1].physicalDamage = -20;
}
static int ask(int battlerId) { return CheckSwitchItemOnHit(&bs, &ctx, battlerId, S.item[battlerId]); }
int main(void) {
    // Eject Button: a battler the move hurt, standing, goes back.
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT;
    assert(ask(1) == BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM && ctx.battlerIdTemp == 1);
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; ctx.selfTurnData[1].physicalDamage = 0; ctx.selfTurnData[1].specialDamage = -3;
    assert(ask(1) == BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM);
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; ctx.selfTurnData[1].physicalDamage = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; ctx.battleMons[1].hp = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    // After a Red Card has dragged the user out (U-turn's flag) the button
    // still answers; the card does not, the user being gone.
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; ctx.battleStatus2 = BATTLE_STATUS2_UTURN;
    assert(ask(1) == BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; ctx.battleStatus2 = BATTLE_STATUS2_UTURN;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    // Each walk asks only its own item.
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE;
    assert(CheckSwitchItemOnHit(&bs, &ctx, 1, HOLD_EFFECT_SWITCH_OUT_WHEN_HIT) == BATTLE_SUBSCRIPT_NONE && S.picked == 0);
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT;
    assert(CheckSwitchItemOnHit(&bs, &ctx, 1, HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE) == BATTLE_SUBSCRIPT_NONE);
    // A pivot move's user stays when the button or the card will act, and
    // goes when nobody could come in, the card could not move it, or there is
    // no such item.
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT;
    assert(SwitchItemWillAnswerPivot(&bs, &ctx, 1));
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; S.replacements = 0;
    assert(!SwitchItemWillAnswerPivot(&bs, &ctx, 1));
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE;
    assert(SwitchItemWillAnswerPivot(&bs, &ctx, 1) && S.picked == 0);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; S.ability[0] = ABILITY_SUCTION_CUPS;
    assert(!SwitchItemWillAnswerPivot(&bs, &ctx, 1));
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; S.battleType = 0;
    assert(!SwitchItemWillAnswerPivot(&bs, &ctx, 1));
    reset();
    assert(!SwitchItemWillAnswerPivot(&bs, &ctx, 1));
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; S.ability[0] = ABILITY_SHEER_FORCE; S.suppressible = 1;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; S.ability[0] = ABILITY_SHEER_FORCE;
    assert(ask(1) == BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM);
    reset(); S.item[0] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; ctx.selfTurnData[0].physicalDamage = -5;
    assert(ask(0) == BATTLE_SUBSCRIPT_NONE);
    // Dragged in by the move after its predecessor took the hit.
    reset(); S.item[1] = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT; ctx.battleMons[1].hitCount = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; ctx.battleMons[1].hitCount = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    // Red Card: the attacker is dragged out for someone chosen at random.
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE;
    assert(ask(1) == BATTLE_SUBSCRIPT_RED_CARD && ctx.battlerIdTemp == 1 && S.picked == 1);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; S.replacements = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; S.battleType = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; ctx.battleMons[0].hp = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; ctx.battleMons[1].hp = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_NONE);
    // Anchored: the card is still played, and nobody is chosen.
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; S.ability[0] = ABILITY_SUCTION_CUPS; S.replacements = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_RED_CARD && S.picked == 0);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; ctx.battleMons[0].moveEffectFlags = MOVE_EFFECT_FLAG_INGRAIN; S.replacements = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_RED_CARD && S.picked == 0);
    reset(); S.item[1] = HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE; S.ability[0] = ABILITY_GUARD_DOG; S.replacements = 0;
    assert(ask(1) == BATTLE_SUBSCRIPT_RED_CARD && S.picked == 0);
    return 0;
}
"""


class SwitchItemTests(unittest.TestCase):
    """Red Card and Eject Button (ServerDoPostMoveEffects.c:1799-1850 and
    subscripts 340 and 491 at d0380a487; Pokemon Central's Cartelrosso and
    Pulsantefuga for the card spent on an anchored attacker)."""

    def test_who_answers_a_hit(self):
        overlay = OVERLAY.read_text()
        body = "\n".join(function(overlay, name) for name in (
            "SheerForceTradedEffect", "Battler_CameInAfterTheHit", "SwitchItemAnswersHit", "BattlerIsAnchored", "CheckSwitchItemOnHit",
            "SwitchItemWillAnswerPivot"))
        run_c(SWITCH_ITEM_FIXTURE.replace("@FUNCTION@", body))

    def test_a_red_card_holder_s_own_pivot_move_keeps_it_in(self):
        """Pokemon Central (Cartelrosso) and Bulbapedia's U-turn, Volt Switch
        and Flip Turn: the three do not switch a user holding a Red Card."""
        dispatch = function(OVERLAY.read_text(), "ov12_02250490")
        self.assertIn("if (*out == BATTLE_SUBSCRIPT_ATTACK_THEN_SWITCH_OUT && GetBattlerHeldItemEffect(ctx, ctx->battlerIdAttacker) == HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE) {\n"
                      "            ret = FALSE;", dispatch)

    def test_asked_after_the_move_before_the_users_own_items(self):
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        ask = body.index("CheckSwitchItemOnHit(battleSystem, ctx, ctx->turnOrder[walk % maxBattlers],")
        # The cards' walk, then the buttons', one of each.
        self.assertIn("card ? HOLD_EFFECT_FORCE_SWITCH_ON_DAMAGE : HOLD_EFFECT_SWITCH_OUT_WHEN_HIT", body)
        # A card leaves the Eject Pack its turn; a button does not (Pokemon
        # Central, Zainofuga and Pulsantefuga).
        self.assertIn("ctx->unk_34 = card ? maxBattlers : (2 * maxBattlers | SWITCH_ITEM_USED);", body)
        # And a pivot move asks ahead.
        dispatch = function(OVERLAY.read_text(), "ov12_02250490")
        self.assertIn("SwitchItemWillAnswerPivot(battleSystem, ctx, ctx->battlerIdTarget)", dispatch)
        self.assertLess(ask, body.index("HOLD_EFFECT_HP_RESTORE_ON_DMG"))
        self.assertLess(ask, body.index("HOLD_EFFECT_HP_DRAIN_ON_ATK"))
        self.assertIn("SWITCH_ITEM_USED", body)
        spray = body[body.index("HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE"):]
        self.assertIn("!(ctx->battleStatus2 & BATTLE_STATUS2_UTURN)", spray[:spray.index("{")])
        self.assertIn("TryPickForcedSwitchIn(battleSystem, ctx, ctx->battlerIdTarget)",
                      function(COMMANDS.read_text(), "BtlCmd_TryWhirlwind"))

    def test_the_eject_button_sends_its_holder_back(self):
        script = subscript_named("BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM")
        self.assertEqual(walk(script, {}.get), [])
        self.assertEqual(walk(script, {"REPLACEMENT": True}.get),
                         ["BATTLE_SUBSCRIPT_PURSUIT", "BATTLE_SUBSCRIPT_SHOW_PARTY_LIST"])
        self.assertEqual(walk(script, {"REPLACEMENT": True, "BMON_DATA_HP": 0}.get), ["BATTLE_SUBSCRIPT_PURSUIT"])
        before = script[:script.index("Call BATTLE_SUBSCRIPT_PURSUIT")]
        self.assertIn("PrintMessage msg_0197_01622, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP", before)
        self.assertIn("RemoveItem BATTLER_CATEGORY_MSG_BATTLER_TEMP", before)
        self.assertIn("BSCRIPT_VAR_BATTLER_SWITCH, BSCRIPT_VAR_MSG_BATTLER_TEMP", before)

    def test_the_red_card_drags_the_attacker_out(self):
        script = subscript_named("BATTLE_SUBSCRIPT_RED_CARD")
        push, pop = "BATTLE_SUBSCRIPT_PUSH_ATTACKER_AND_DEFENDER", "BATTLE_SUBSCRIPT_POP_ATTACKER_AND_DEFENDER"
        self.assertEqual(walk(script, {}.get),
                         [push, "SwitchAndUpdateMon BATTLER_CATEGORY_FORCED_OUT", "BATTLE_SUBSCRIPT_HAZARDS_CHECK", pop])
        self.assertEqual(walk(script, {"ABILITY_SUCTION_CUPS": True}.get), [push, pop])
        self.assertEqual(walk(script, {"ABILITY_GUARD_DOG": True}.get), [push, pop])
        self.assertEqual(walk(script, {"MOVE_EFFECT_FLAG_INGRAIN": True}.get), [push, pop])
        card = script[:script.index("CheckAbility")]
        self.assertIn("BSCRIPT_VAR_BATTLER_TARGET, BSCRIPT_VAR_BATTLER_ATTACKER", card)
        self.assertIn("BSCRIPT_VAR_BATTLER_ATTACKER, BSCRIPT_VAR_MSG_BATTLER_TEMP", card)
        self.assertIn("PrintMessage msg_0197_01716, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_ATTACKER, BATTLER_CATEGORY_DEFENDER", card)
        self.assertIn("RemoveItem BATTLER_CATEGORY_ATTACKER", card)
        dragged = script[script.index("Call BATTLE_SUBSCRIPT_HAZARDS_CHECK"):script.index("_SUCTION_CUPS:")]
        self.assertIn("BATTLE_STATUS2_UTURN", dragged)


WHIRLWIND_LEVEL_FIXTURE = r"""
#include <assert.h>
#include <stdlib.h>
typedef int BOOL;
typedef struct { int unused; } BattleSystem;
typedef struct { int level; } BattleMon;
typedef struct { int battlerIdAttacker, battlerIdTarget; BattleMon battleMons[4]; } BattleContext;
static int BattleSystem_Random(BattleSystem *bs) { (void)bs; abort(); }
@FUNCTION@
int main(void) {
    BattleSystem bs;
    BattleContext ctx = { 0, 1, { { 50 }, { 51 } } };
    assert(!WhirlwindCheck(&bs, &ctx));      // lower: always fails, no roll
    ctx.battleMons[1].level = 50;
    assert(WhirlwindCheck(&bs, &ctx));
    ctx.battleMons[1].level = 5;
    assert(WhirlwindCheck(&bs, &ctx));
    (void)BattleSystem_Random;
    return 0;
}
"""


class ForcedSwitchLevelTests(unittest.TestCase):
    """Roar, Whirlwind, Dragon Tail and Circle Throw ask no level in a trainer
    battle, and against a wild Pokemon fail whenever the user's level is the
    lower, with no roll (Pokemon Central, Turbine and Ruggito, from the fifth
    generation); retail's fourth generation asked with a roll in both."""

    def test_the_wild_test_is_the_levels_alone(self):
        source = OVERLAY.read_text().replace("#pragma unused(battleSystem)\n", "(void)battleSystem;\n")
        run_c(WHIRLWIND_LEVEL_FIXTURE.replace("@FUNCTION@", function(source, "WhirlwindCheck")))

    def test_a_trainer_battle_asks_no_level(self):
        commands = COMMANDS.read_text()
        self.assertNotIn("WhirlwindCheck", function(commands, "TryPickForcedSwitchIn"))
        body = function(commands, "BtlCmd_TryWhirlwind")
        trainer = body[body.index("if (battleType & BATTLE_TYPE_TRAINER) {"):body.index("} else if")]
        self.assertIn("TryPickForcedSwitchIn(battleSystem, ctx, ctx->battlerIdTarget) == FALSE", trainer)
        self.assertNotIn("WhirlwindCheck", trainer)
        self.assertIn("} else if (WhirlwindCheck(battleSystem, ctx) == FALSE) {", body)

class ReplacedUserTests(unittest.TestCase):
    """What takes the user's slot in the middle of its move -- after U-turn,
    Volt Switch, Flip Turn, Parting Shot, Teleport, a Red Card, Baton Pass,
    Shed Tail, or the user's own Eject Pack or Emergency Exit -- did not use
    the move: no Choice item locks it into it and nothing remembers it as its
    last move (Pokemon Central, Scelta; retail excused U-turn and Baton Pass
    from the lock alone)."""

    def test_the_departed_user_s_move_is_not_the_newcomer_s(self):
        body = function(CONTROLLER.read_text(), "ov12_0224D23C")
        self.assertIn("BOOL userGone = (ctx->battleStatus2 & BATTLE_STATUS2_UTURN) || (ctx->battleStatus & BATTLE_STATUS_BATON_PASS);", body)
        self.assertIn("if (!userGone && copyLocks && ", body)
        self.assertNotIn("MOVE_U_TURN", body)
        self.assertNotIn("MOVE_BATON_PASS", body)
        self.assertIn("if (!copied && !userGone) {", body)
        self.assertIn("if (!copied && !userGone && ctx->battleStatus2 & BATTLE_STATUS2_DISPLAY_ATTACK_MESSAGE) {", body)
        self.assertEqual(body.count("if (!userGone) {"), 2)

    def test_the_user_leaving_by_its_own_item_or_ability_says_so(self):
        for name in ("BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM", "BATTLE_SUBSCRIPT_EMERGENCY_EXIT"):
            script = subscript_named(name)
            tail = script[script.index("_SWITCH_OUT:"):]
            self.assertIn("CompareVarToVar OPCODE_NEQ, BSCRIPT_VAR_MSG_BATTLER_TEMP, BSCRIPT_VAR_BATTLER_ATTACKER, _NOT_THE_ATTACKER\n"
                          "    UpdateVar OPCODE_FLAG_ON, BSCRIPT_VAR_BATTLE_STATUS_2, BATTLE_STATUS2_UTURN", tail, name)
            self.assertLess(tail.index("BATTLE_STATUS2_UTURN"), tail.index("GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST"), name)

EJECT_PACK_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/battle_subscript.h"
#include "constants/items.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
typedef struct { int hp; } BattleMon;
typedef struct { int battlerIdTemp; u8 statLoweredBattlers; BattleMon battleMons[4]; } BattleContext;
static int sItem;
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; (void)battlerId; return sItem; }
static u32 MaskOfFlagNo(int flagNo) { return 1u << flagNo; }
@FUNCTION@
int main(void) {
    BattleContext ctx = { -1, 1 << 2, { { 10 }, { 10 }, { 10 }, { 10 } } };
    sItem = HOLD_EFFECT_SWITCH_OUT_ON_STAT_DROP;
    assert(CheckEjectPack(&ctx, 2) == BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM && ctx.battlerIdTemp == 2);
    assert(CheckEjectPack(&ctx, 1) == BATTLE_SUBSCRIPT_NONE);
    ctx.battleMons[2].hp = 0;
    assert(CheckEjectPack(&ctx, 2) == BATTLE_SUBSCRIPT_NONE);
    ctx.battleMons[2].hp = 10;
    sItem = HOLD_EFFECT_SWITCH_OUT_WHEN_HIT;
    assert(CheckEjectPack(&ctx, 2) == BATTLE_SUBSCRIPT_NONE);
    return 0;
}
"""


class EjectPackTests(unittest.TestCase):
    """The Eject Pack (ServerDoPostMoveEffects.c:1755 and subscript 340 at
    d0380a487; Pokemon Central's Zainofuga): a stat lowered during the move,
    and once the move is over its holder goes back."""

    def test_who_goes_back(self):
        body = function(OVERLAY.read_text(), "CheckEjectPack")
        run_c(EJECT_PACK_FIXTURE.replace("@FUNCTION@", body))

    def test_a_lowered_stat_is_written_down_for_the_move(self):
        change = function(COMMANDS.read_text(), "BtlCmd_ChangeStatStage")
        decrease = change[change.index("} else { // Stat Decrease"):]
        self.assertIn("ctx->statLoweredBattlers |= MaskOfFlagNo(ctx->battlerIdStatChange);", decrease)
        self.assertIn("ctx->statLoweredBattlers = 0;", function(CONTROLLER.read_text(), "ov12_02249460"))
        self.assertIn("ctx->statLoweredBattlers &= ~MaskOfFlagNo(battlerId);",
                      function(OVERLAY.read_text(), "BattleSystem_GetBattleMon"))

    def test_asked_after_the_users_items_and_not_after_another_switch(self):
        body = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        ask = body.index("CheckEjectPack(ctx, ctx->turnOrder[ctx->unk_34++])")
        self.assertLess(body.index("HOLD_EFFECT_BOOST_SPATK_ON_SOUND_MOVE"), ask)
        self.assertLess(body.index("CheckSwitchItemOnHit"), ask)
        self.assertIn("if (!(ctx->unk_34 & SWITCH_ITEM_USED)) {\n                ctx->unk_34 = 0;", body)

    def test_an_entry_s_drop_is_answered_once_the_action_is_over(self):
        """Pokemon Central (Zainofuga): Intimidate and Sticky Web on entry set
        the Pack off; the reference has that check commented out. Asked after
        the entry abilities and Emergency Exit, once an action is over; the
        move's own drops are spent by then, answered or given up."""
        end = function(CONTROLLER.read_text(), "ov12_0224D368")
        ask = end.index("script = CheckEjectPack(ctx, ctx->turnOrder[i]);")
        self.assertLess(end.index("script = TryAbilityOnEntry(battleSystem, ctx);"), ask)
        self.assertLess(end.index("TryRetreatAbilityOutsideMove(battleSystem, ctx, &script)"), ask)
        self.assertIn("ctx->statLoweredBattlers = 0;", end[ask:end.index("ov12_0224E130(battleSystem, ctx)")])
        move = function(CONTROLLER.read_text(), "ov12_0224E1BC")
        # The button, the Parting Shot and the Pack each spend the move's drops.
        self.assertEqual(move.count("ctx->statLoweredBattlers = 0;"), 3)

    def test_the_pack_has_its_own_line(self):
        script = subscript_named("BATTLE_SUBSCRIPT_SWITCH_OUT_ITEM")
        self.assertEqual(walk(script, {"REPLACEMENT": True, "BMON_DATA_HELD_ITEM": "ITEM_EJECT_PACK"}.get),
                         ["BATTLE_SUBSCRIPT_PURSUIT", "BATTLE_SUBSCRIPT_SHOW_PARTY_LIST"])
        pack = script[script.index("_EJECT_PACK:"):script.index("_SWITCHED:")]
        self.assertIn("PrintMessage msg_0197_01625, TAG_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP", pack)
        self.assertIn("BMON_DATA_HELD_ITEM, ITEM_EJECT_PACK, _EJECT_PACK", script)


MIRROR_HERB_FIXTURE = r"""
#include <assert.h>
#include <stdint.h>
#include "constants/abilities.h"
#include "constants/battle_subscript.h"
#include "constants/items.h"
#include "constants/pokemon.h"
typedef uint8_t u8; typedef int8_t s8; typedef uint16_t u16; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int unused; } BattleSystem;
typedef struct { int hp; s8 statChanges[NUM_BATTLE_STATS]; } BattleMon;
typedef struct { BattleMon battleMons[4]; u8 mirrorHerbStages[4][NUM_BATTLE_STATS]; int tempData; } BattleContext;
static int sItem[4], sAbility[4];
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return 4; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static int GetBattlerHeldItemEffect(BattleContext *ctx, int battlerId) { (void)ctx; return sItem[battlerId]; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { (void)ctx; return sAbility[battlerId]; }
@FUNCTIONS@
int main(void) {
    BattleSystem bs;
    BattleContext ctx = { 0 };
    for (int i = 0; i < 4; i++) {
        ctx.battleMons[i].hp = 30;
        for (int s = 0; s < NUM_BATTLE_STATS; s++) ctx.battleMons[i].statChanges[s] = 6;
    }
    sItem[1] = HOLD_EFFECT_COPY_STAT_INCREASE;   // the herb, on the other side from 0 and 2
    sItem[2] = HOLD_EFFECT_COPY_STAT_INCREASE;   // a herb beside the one who rose: not told
    sItem[3] = HOLD_EFFECT_NONE;
    RecordMirrorHerbStages(&bs, &ctx, 0, STAT_ATK, 2);
    RecordMirrorHerbStages(&bs, &ctx, 2, STAT_SPEED, 1);
    assert(ctx.mirrorHerbStages[1][STAT_ATK] == 2 && ctx.mirrorHerbStages[1][STAT_SPEED] == 1);
    assert(ctx.mirrorHerbStages[2][STAT_ATK] == 0 && ctx.mirrorHerbStages[3][STAT_ATK] == 0);
    // Every stage copied at once, and the record emptied.
    assert(MirrorHerbCopiesStages(&ctx, 1) == TRUE);
    assert(ctx.battleMons[1].statChanges[STAT_ATK] == 8 && ctx.battleMons[1].statChanges[STAT_SPEED] == 7);
    assert(ctx.mirrorHerbStages[1][STAT_ATK] == 0 && ctx.mirrorHerbStages[1][STAT_SPEED] == 0);
    assert(MirrorHerbCopiesStages(&ctx, 1) == FALSE);
    // Up to +6 and no further; nothing when every stat to copy is there.
    ctx.battleMons[1].statChanges[STAT_DEF] = 11;
    ctx.mirrorHerbStages[1][STAT_DEF] = 3;
    assert(MirrorHerbCopiesStages(&ctx, 1) == TRUE && ctx.battleMons[1].statChanges[STAT_DEF] == 12);
    ctx.mirrorHerbStages[1][STAT_DEF] = 2;
    assert(MirrorHerbCopiesStages(&ctx, 1) == FALSE && ctx.mirrorHerbStages[1][STAT_DEF] == 0);
    assert(ctx.tempData == BATTLE_ANIMATION_STAT_BOOST);
    // Contrary copies the gains as drops, down to -6, with a drop's animation.
    sAbility[1] = ABILITY_CONTRARY;
    ctx.battleMons[1].statChanges[STAT_SPDEF] = 7;
    ctx.mirrorHerbStages[1][STAT_SPDEF] = 2;
    assert(MirrorHerbCopiesStages(&ctx, 1) == TRUE && ctx.battleMons[1].statChanges[STAT_SPDEF] == 5);
    assert(ctx.tempData == BATTLE_ANIMATION_STAT_DROP);
    ctx.battleMons[1].statChanges[STAT_SPDEF] = 1;
    ctx.mirrorHerbStages[1][STAT_SPDEF] = 3;
    assert(MirrorHerbCopiesStages(&ctx, 1) == TRUE && ctx.battleMons[1].statChanges[STAT_SPDEF] == 0);
    ctx.mirrorHerbStages[1][STAT_SPDEF] = 1;
    assert(MirrorHerbCopiesStages(&ctx, 1) == FALSE);
    sAbility[1] = ABILITY_NONE;
    // A fainted holder is not told.
    ctx.battleMons[1].hp = 0;
    RecordMirrorHerbStages(&bs, &ctx, 0, STAT_SPATK, 1);
    assert(ctx.mirrorHerbStages[1][STAT_SPATK] == 0);
    return 0;
}
"""


class MirrorHerbTests(unittest.TestCase):
    """The reference has a TODO where the Mirror Herb goes; Pokemon Central
    (Foglia carbone): the other side's stat gains, all copied at once, the
    herb spent, nothing if every stat to copy is at +6."""

    def test_what_is_recorded_and_copied(self):
        source = OVERLAY.read_text()
        functions = "\n".join(function(source, name) for name in ("RecordMirrorHerbStages", "MirrorHerbCopiesStages"))
        run_c(MIRROR_HERB_FIXTURE.replace("@FUNCTIONS@", functions))

    def test_where_it_is_told_and_asked(self):
        change = function(COMMANDS.read_text(), "BtlCmd_ChangeStatStage")
        rise = change[:change.index("} else { // Stat Decrease")]
        self.assertIn("RecordMirrorHerbStages(battleSystem, ctx, ctx->battlerIdStatChange, stat + 1, "
                      "mon->statChanges[stat + 1] - stagesBefore);", rise)
        # Not an Opportunist's copy (Pokemon Central, Foglia carbone).
        self.assertIn("if (!(ctx->statChangeType == SIDE_EFFECT_TYPE_ABILITY && GetBattlerAbility(ctx, ctx->battlerIdStatChange) == ABILITY_OPPORTUNIST)) {\n"
                      "                RecordMirrorHerbStages(", rise)
        source = OVERLAY.read_text()
        use = function(source, "CheckUseHeldItem")
        case = use[use.index("case HOLD_EFFECT_COPY_STAT_INCREASE:"):]
        self.assertIn("MirrorHerbCopiesStages(ctx, battlerId) == TRUE", case[:case.index("break;")])
        self.assertIn("*script = BATTLE_SUBSCRIPT_MIRROR_HERB;", case[:case.index("break;")])
        self.assertIn("MI_CpuClear8(ctx->mirrorHerbStages[battlerId]", function(source, "BattleSystem_GetBattleMon"))

    def test_a_stage_a_script_raises_is_told_too(self):
        """Pokemon Central (Foglia carbone) copies Belly Drum as far as the
        stage really rose; Anger Point, Rage, Motor Drive, Steam Engine and a
        Starf Berry raise theirs from a script, not the stat command."""
        update = function(COMMANDS.read_text(), "BtlCmd_UpdateMonData")
        self.assertIn("int stage = varId == BMON_DATA_TEMP ? ctx->tempData : varId;", update)
        self.assertIn("if (stage >= BMON_DATA_STAT_CHANGE_ATK && stage <= BMON_DATA_STAT_CHANGE_EVASION && !(opcode == 7 && val == 6) && var > before) {\n"
                      "        RecordMirrorHerbStages(battleSystem, ctx, battlerId, stage - BMON_DATA_STAT_CHANGE_HP, var - before);", update)
        # Written after the stage is kept within +6, so what is copied is
        # what the stage really gained.
        self.assertLess(update.index("var = var < 0 ? 0 : var > 12 ? 12 : var;"), update.index("RecordMirrorHerbStages("))
        rage = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "TryBuildRage")
        self.assertIn("RecordMirrorHerbStages(battleSystem, ctx, ctx->battlerIdTarget, STAT_ATK, 1);", rage)

    def test_the_herb_is_shown_and_spent(self):
        script = subscript_named("BATTLE_SUBSCRIPT_MIRROR_HERB")
        self.assertIn("PrintMessage msg_0197_01824, TAG_NICKNAME_ITEM, BATTLER_CATEGORY_MSG_TEMP, BATTLER_CATEGORY_MSG_TEMP", script)
        self.assertIn("RemoveItem BATTLER_CATEGORY_MSG_TEMP", script)
        self.assertIn("PlayBattleAnimationFromVar BATTLER_CATEGORY_MSG_TEMP, BSCRIPT_VAR_TEMP_DATA", script)


if __name__ == "__main__":
    unittest.main()
