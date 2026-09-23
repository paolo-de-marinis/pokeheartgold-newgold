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
IMPORTED_AND_UNREAD = 12


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


def effects_read():
    """Every hold effect named anywhere under src/ or in a battle script, by name."""
    read = set()
    for path in list(SRC.rglob("*.c")) + list(SCRIPTS.rglob("*.s")):
        read.update(re.findall(r"HOLD_EFFECT_[A-Z0-9_]+", path.read_text(errors="replace")))
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
        program = REDIRECT_TYPE_FIXTURE.replace("@FUNCTION@", function(OVERLAY.read_text(), "GetDynamicMoveType"))
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


if __name__ == "__main__":
    unittest.main()
