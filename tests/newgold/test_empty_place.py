#!/usr/bin/env python3
"""A place left empty in a double battle has no Pokemon to read.

When a battler faints and its party has nothing left to send in, the end of
the turn (ov12_0224D540) raises its switch-in flag and sets its
selectedMonIndex to 6, one past the party; SwitchAndUpdateMon puts both back
when something comes in again. Retail asks the flag before it reads such a
battler's Pokemon. The port's own code has to as well: Party_GetMonByIndex
asserts the slot, and asserts are on in every build, so a read of slot 6
resets the game. Each function that reads a battler's party Pokemon is
compiled here with a party that asserts the same way.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function

COMMANDS = (ROOT / "src/battle/battle_command.c").read_text()
OVERLAY = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()

HEADER = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef int8_t s8; typedef int32_t s32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct BattleSystem BattleSystem;
typedef struct { u16 species, speed; } Pokemon;

// Two parties, the player's and the opponent's, each of sCount[side]
// Pokemon; a slot past the count fails the way PARTY_ASSERT_SLOT does.
static Pokemon sParties[2][6];
static int sCount[2] = { 6, 6 };
static int sMaxBattlers = 4;
static u32 MaskOfFlagNo(int flagno) { return 1u << flagno; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { (void)bs; return sMaxBattlers; }
static int BattleSystem_GetFieldSide(BattleSystem *bs, int battlerId) { (void)bs; return battlerId & 1; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int index) {
    (void)bs;
    assert(index >= 0 && index < sCount[battlerId & 1] && "PARTY_ASSERT_SLOT");
    return &sParties[battlerId & 1][index];
}
"""


def run(test, program, functions):
    source = program.replace("@FUNCTIONS@", "\n".join(function(COMMANDS, name) for name in functions))
    with tempfile.TemporaryDirectory(prefix="newgold-empty-place-") as directory:
        path = Path(directory)
        (path / "test.c").write_text(HEADER + source)
        result = subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
            str(path / "test.c"), "-o", str(path / "test")], capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True)
    test.assertEqual(result.returncode, 0, result.stderr)


RAW_SPEED = r"""
typedef struct { u8 selectedMonIndex[4]; u8 switchInFlag; } BattleContext;
static u32 GetMonData(Pokemon *mon, int id, void *data) {
    (void)data;
    assert(id == MON_DATA_SPEED);
    return mon->speed;
}
@FUNCTIONS@

int main(void) {
    static BattleContext ctx;
    int order[BATTLER_MAX];

    // Twins, two Pokemon each: the player's Houndoom in 0 and Honchkrow in
    // 2, the Azumarill in 1 and the Flaaffy in 3.
    sCount[0] = 2;
    sCount[1] = 2;
    sParties[0][0].speed = 120;
    sParties[0][1].speed = 90;
    sParties[1][0].speed = 50;
    sParties[1][1].speed = 60;
    ctx.selectedMonIndex[0] = 0;
    ctx.selectedMonIndex[1] = 0;
    ctx.selectedMonIndex[2] = 1;
    ctx.selectedMonIndex[3] = 1;
    assert(RawSpeedOrder(0, &ctx, order) == 4);
    assert(order[0] == 0 && order[1] == 2 && order[2] == 3 && order[3] == 1);

    // The Houndoom has fainted and there is nothing to send in: its place
    // is empty, and the rest keep their order ahead of it.
    ctx.switchInFlag |= MaskOfFlagNo(0);
    ctx.selectedMonIndex[0] = 6;
    assert(RawSpeedOrder(0, &ctx, order) == 4);
    assert(order[0] == 2 && order[1] == 3 && order[2] == 1 && order[3] == 0);

    // And the Azumarill on the other side too.
    ctx.switchInFlag |= MaskOfFlagNo(1);
    ctx.selectedMonIndex[1] = 6;
    assert(RawSpeedOrder(0, &ctx, order) == 4);
    assert(order[0] == 2 && order[1] == 3);
    return 0;
}
"""


FAINT = r"""
typedef struct { s32 hp; u16 species, item; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdAttacker, battlerIdFainted, script;
    u32 battleStatus;
    u8 totalTimesFainted[4];
    u8 selectedMonIndex[4];
    u8 switchInFlag;
} BattleContext;
typedef struct Party Party;
static Pokemon *sCounted;
static int sCounts;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { return ctx->script; }
static int BattleSystem_GetBattlerIDBySide(BattleSystem *bs, BattleContext *ctx, int side) { (void)bs; (void)ctx; return side; }
static void UpdateFriendshipFainted(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; }
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { (void)bs; return (Party *)&sParties[battlerId & 1]; }
static void Mon_CountDefeatedMon(Pokemon *mon, u16 species, u16 heldItem) { (void)species; (void)heldItem; sCounted = mon; sCounts++; }
@FUNCTIONS@

int main(void) {
    static BattleContext ctx;

    // The player's two Pokemon in 0 and 2, the opponent's in 1 and 3.
    sCount[0] = 2;
    ctx.selectedMonIndex[0] = 0;
    ctx.selectedMonIndex[2] = 1;

    // The Pokemon in 2 knocks out the one in 3: its own count goes up.
    ctx.battlerIdAttacker = 2;
    ctx.script = 3;
    BtlCmd_TryFaintMon(0, &ctx);
    assert(sCounts == 1 && sCounted == &sParties[0][1]);

    // The one in 0 used Future Sight and fell, and the party had nothing to
    // send in: its place is empty when the move lands two turns on and
    // knocks out the one in 1, from that place. Nobody's count goes up.
    ctx.switchInFlag |= MaskOfFlagNo(0);
    ctx.selectedMonIndex[0] = 6;
    ctx.battlerIdAttacker = 0;
    ctx.script = 1;
    BtlCmd_TryFaintMon(0, &ctx);
    assert(ctx.battlerIdFainted == 1 && ctx.totalTimesFainted[1] == 1);
    assert(sCounts == 1);
    return 0;
}
"""
SWITCH = r"""
#include "constants/abilities.h"
typedef struct { s32 hp; u32 maxHp, status2; u16 species, ability; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdAttacker, battlerIdSwitch, battlerIdTarget, script, hpTemp;
    u8 unk_13C[4];
    u8 selectedMonIndex[4];
    u8 unk_21A0[4];
    u8 switchInFlag;
} BattleContext;
static Pokemon *sReverted;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { return ctx->script; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static void CopyBattleMonToPartyMon(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; }
static u16 Species_GetBattleFormReversion(u16 species) { return species == SPECIES_AEGISLASH_BLADE ? SPECIES_AEGISLASH : SPECIES_NONE; }
static BOOL Mon_RevertFormChange(Pokemon *mon) { sReverted = mon; return TRUE; }
static void Mon_ChangeFormSpecies(Pokemon *mon, int species) { (void)mon; (void)species; assert(0); }
static void BattleSystem_GetBattleMon(BattleSystem *bs, BattleContext *ctx, int battlerId, int index) {
    ctx->battleMons[battlerId].species = BattleSystem_GetPartyMon(bs, battlerId, index)->species;
    ctx->battleMons[battlerId].hp = 50;
}
static void ov12_02256F78(BattleSystem *bs, BattleContext *ctx, int battlerId, int index) { (void)bs; (void)ctx; (void)battlerId; (void)index; }
static void InitSwitchWork(BattleSystem *bs, BattleContext *ctx, int battlerId) { (void)bs; (void)ctx; (void)battlerId; }
@FUNCTIONS@

int main(void) {
    static BattleContext ctx;

    // The player's Aegislash in 0, in its Blade Forme, and a Pikachu in 2;
    // the party's third, a Snorlax, fainted earlier.
    sCount[0] = 3;
    sParties[0][0].species = SPECIES_AEGISLASH_BLADE;
    sParties[0][1].species = SPECIES_PIKACHU;
    sParties[0][2].species = SPECIES_SNORLAX;
    ctx.selectedMonIndex[0] = 0;
    ctx.selectedMonIndex[2] = 1;
    ctx.battleMons[0].species = SPECIES_AEGISLASH_BLADE;
    ctx.battleMons[2].species = SPECIES_PIKACHU;
    ctx.battleMons[2].hp = 40;
    ctx.unk_21A0[0] = ctx.unk_21A0[2] = 6;

    // The Aegislash faints with nothing to follow it: its place is empty.
    ctx.battleMons[0].hp = 0;
    ctx.switchInFlag |= MaskOfFlagNo(0);
    ctx.selectedMonIndex[0] = 6;

    // A Revive from the bag brings the Snorlax back, and the end of the
    // turn sends it into the empty place.
    ctx.battlerIdSwitch = 0;
    ctx.unk_21A0[0] = 2;
    ctx.script = BATTLER_CATEGORY_SWITCHED_MON;
    BtlCmd_SwitchAndUpdateMon(0, &ctx);
    assert(sReverted == NULL);
    assert(!(ctx.switchInFlag & MaskOfFlagNo(0)) && ctx.selectedMonIndex[0] == 2 && ctx.unk_21A0[0] == 6);
    assert(ctx.battleMons[0].species == SPECIES_SNORLAX);

    // A Blade Forme leaving a place that is not empty still goes back.
    ctx.battleMons[2].species = SPECIES_AEGISLASH_BLADE;
    ctx.battlerIdAttacker = 2;
    ctx.unk_21A0[2] = 0;
    ctx.script = BATTLER_CATEGORY_ATTACKER;
    BtlCmd_SwitchAndUpdateMon(0, &ctx);
    assert(sReverted == &sParties[0][1]);
    return 0;
}
"""
PARADOX = r"""
#include "constants/abilities.h"
#include "constants/battle_subscript.h"
#define NARC_a_0_0_1 1
typedef struct { s32 hp; u16 ability; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdTemp, subscript;
    u8 turnOrder[4];
    u8 paradoxBoostedStat[4];
    u8 boosterEnergyActivated[4];
    u8 selectedMonIndex[4];
    u8 switchInFlag;
} BattleContext;
static void BattleScriptIncrementPointer(BattleContext *ctx, int n) { (void)ctx; (void)n; }
static int BattleScriptReadWord(BattleContext *ctx) { (void)ctx; return ABILITY_PROTOSYNTHESIS; }
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static void BattleScriptGotoSubscript(BattleContext *ctx, int narc, int subscript) { (void)narc; ctx->subscript = subscript; }
@FUNCTIONS@

int main(void) {
    static BattleContext ctx;
    int i;

    for (i = 0; i < 4; i++) {
        ctx.turnOrder[i] = i;
        ctx.battleMons[i].hp = 30;
    }
    // Two Protosynthesis holders boosted by the sun, in 1 and 3. The one in
    // 1 has fainted and its place is empty.
    ctx.battleMons[1].ability = ctx.battleMons[3].ability = ABILITY_PROTOSYNTHESIS;
    ctx.paradoxBoostedStat[1] = ctx.paradoxBoostedStat[3] = STAT_ATK;
    ctx.battleMons[1].hp = 0;
    ctx.switchInFlag |= MaskOfFlagNo(1);
    ctx.selectedMonIndex[1] = 6;

    // The sun ends: the line is for the one in 3 alone.
    BtlCmd_ResetParadoxAbility(0, &ctx);
    assert(ctx.subscript == BATTLE_SUBSCRIPT_PARADOX_ABILITY_END && ctx.battlerIdTemp == 3);
    assert(ctx.paradoxBoostedStat[3] == 0);
    ctx.subscript = 0;
    BtlCmd_ResetParadoxAbility(0, &ctx);
    assert(ctx.subscript == 0);
    return 0;
}
"""
FLOWER_VEIL = r"""
#include "constants/abilities.h"
typedef struct { s32 hp; u16 ability; u8 type1, type2, type3; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdAttacker, battlerIdStatChange;
    u8 selectedMonIndex[4];
    u8 switchInFlag;
} BattleContext;
static int GetBattlerVar(BattleContext *ctx, int battlerId, int id, void *data) {
    (void)data;
    switch (id) {
    case BMON_DATA_TYPE_1: return ctx->battleMons[battlerId].type1;
    case BMON_DATA_TYPE_2: return ctx->battleMons[battlerId].type2;
    case BMON_DATA_TYPE_3: return ctx->battleMons[battlerId].type3;
    }
    assert(0);
    return 0;
}
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) { (void)bs; return sMaxBattlers == 4 ? battlerId ^ 2 : battlerId; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int battlerIdAttacker, int battlerIdTarget, int ability) {
    (void)battlerIdAttacker;
    return ctx->battleMons[battlerIdTarget].ability == ability;
}
// The lines of BtlCmd_ChangeStatStage that find who, if anyone, holds a
// Flower Veil over the Pokemon whose stat is to fall; the message that
// follows names that holder.
static int FlowerVeilHolder(BattleSystem *battleSystem, BattleContext *ctx) {
@FLOWER_VEIL@
    return flowerVeilHolder;
}

int main(void) {
    static BattleContext ctx;

    // Intimidate from the other side at a Grass type in 1, a Comfey with
    // Flower Veil beside it in 3.
    ctx.battlerIdAttacker = 0;
    ctx.battlerIdStatChange = 1;
    ctx.battleMons[1] = (BattleMon){ 40, ABILITY_OVERGROW, TYPE_GRASS, TYPE_GRASS, TYPE_NONE };
    ctx.battleMons[3] = (BattleMon){ 40, ABILITY_FLOWER_VEIL, TYPE_FAIRY, TYPE_FAIRY, TYPE_NONE };
    assert(FlowerVeilHolder(0, &ctx) == 3);

    // The Comfey has fainted with nothing to follow it: its place is empty,
    // and its ability, still in battleMons, shelters nobody.
    ctx.battleMons[3].hp = 0;
    ctx.switchInFlag |= MaskOfFlagNo(3);
    ctx.selectedMonIndex[3] = 6;
    assert(FlowerVeilHolder(0, &ctx) == -1);

    // Its own Flower Veil still counts.
    ctx.battleMons[1].ability = ABILITY_FLOWER_VEIL;
    assert(FlowerVeilHolder(0, &ctx) == 1);
    return 0;
}
"""
ENTRY = r"""
#include "constants/abilities.h"
#include "constants/battle_subscript.h"
typedef struct { s32 hp; u32 status2; u16 ability; } BattleMon;
typedef struct {
    BattleMon battleMons[4];
    int battlerIdTemp, sendOutState;
    u32 fieldCondition;
    u8 terrainOverlayType;
    u8 turnOrder[4];
    u8 selectedMonIndex[4];
    u8 switchInFlag;
    u8 done[2][6];
} BattleContext;
static int GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
// The record of a Pokemon's party slot, which slot 6 is past.
static u8 *OnceOnlyEntryAbilityDone(BattleSystem *bs, BattleContext *ctx, int battlerId) {
    (void)bs;
    assert(ctx->selectedMonIndex[battlerId] < 6 && "a place left empty has no party slot");
    return &ctx->done[battlerId & 1][ctx->selectedMonIndex[battlerId]];
}
// Supersweet Syrup's and Teraform Zero's states of TryAbilityOnEntry.
static int Entry(BattleSystem *battleSystem, BattleContext *ctx, int state) {
    int i, battlerId, maxBattlers = sMaxBattlers, script = 0, flag = FALSE;

    switch (state) {
@CASES@
    }
    return flag ? script : 0;
}

int main(void) {
    static BattleContext ctx;

    // The opposing Pokemon in 1 has fainted with nothing to follow it, and
    // comes first in the order; the player's in 0 has the ability.
    ctx.turnOrder[0] = 1;
    ctx.turnOrder[1] = 0;
    ctx.turnOrder[2] = 2;
    ctx.turnOrder[3] = 3;
    ctx.switchInFlag |= MaskOfFlagNo(1);
    ctx.selectedMonIndex[1] = 6;
    ctx.battleMons[0].hp = ctx.battleMons[2].hp = ctx.battleMons[3].hp = 30;
    ctx.selectedMonIndex[2] = 1;
    ctx.selectedMonIndex[3] = 1;

    ctx.battleMons[0].ability = ABILITY_SUPERSWEET_SYRUP;
    assert(Entry(0, &ctx, 15) == BATTLE_SUBSCRIPT_SUPERSWEET_SYRUP && ctx.battlerIdTemp == 0 && ctx.done[0][0]);
    assert(Entry(0, &ctx, 15) == 0 && ctx.sendOutState == 1);

    ctx.battleMons[0].ability = ABILITY_TERAFORM_ZERO;
    ctx.done[0][0] = FALSE;
    ctx.terrainOverlayType = ELECTRIC_TERRAIN;
    assert(Entry(0, &ctx, 28) == BATTLE_SUBSCRIPT_TERAFORM_ZERO && ctx.battlerIdTemp == 0 && ctx.done[0][0]);
    assert(Entry(0, &ctx, 28) == 0 && ctx.sendOutState == 2);
    return 0;
}
"""


def entry_case(title):
    """One state of TryAbilityOnEntry, from its case label to the next."""
    body = function(OVERLAY, "TryAbilityOnEntry")
    start = body.rindex("\n", 0, body.index(f": // {title}\n")) + 1
    return body[start:body.index("\n        case ", start) + 1]


class EmptyPlaceTests(unittest.TestCase):
    def test_the_final_modifier_orders_an_empty_place_without_reading_it(self):
        run(self, RAW_SPEED, ("RawSpeedGoesFirst", "RawSpeedOrder"))

    def test_a_defeat_from_an_empty_place_counts_for_nobody(self):
        run(self, FAINT, ("BtlCmd_TryFaintMon",))

    def test_a_pokemon_sent_into_an_empty_place_reverts_nothing(self):
        run(self, SWITCH, ("Battler_TurnsHero", "BtlCmd_SwitchAndUpdateMon"))

    def test_a_paradox_boost_ends_without_a_word_for_the_fallen(self):
        run(self, PARADOX, ("BtlCmd_ResetParadoxAbility",))

    def test_a_fallen_ally_s_flower_veil_shelters_nobody(self):
        body = function(COMMANDS, "BtlCmd_ChangeStatStage")
        start = body.index("                int flowerVeilHolder = -1;")
        lines = body[start:body.index("                // Mist.", start)]
        run(self, FLOWER_VEIL.replace("@FLOWER_VEIL@", lines), ())

    def test_the_once_only_entry_abilities_ask_for_hp_first(self):
        cases = entry_case("Supersweet Syrup") + entry_case("Teraform Zero")
        run(self, ENTRY.replace("@CASES@", cases), ())


if __name__ == "__main__":
    unittest.main()
