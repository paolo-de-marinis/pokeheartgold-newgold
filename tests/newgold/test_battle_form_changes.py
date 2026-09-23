#!/usr/bin/env python3
"""The forms a Pokemon changes into during a battle, and when.

hg-engine (d0380a487) changes a battler's form from its ability, its HP or the
move it uses: Zen Mode, Schooling, Stance Change and the rest, each keyed on
the species and switched through BattleFormChange. None of them was here. A
form is a species here, so each rule picks the species to become; the rules
are extracted from src/battle and compiled natively, and the places that act
on them are read from the source.
"""

import os
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_repels import ROOT, function

PREFIX = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/items.h"
#include "constants/moves.h"
#include "constants/species.h"
typedef uint8_t u8;
typedef int8_t s8;
typedef uint16_t u16;
typedef int32_t s32;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0

typedef struct {
    u16 species;
    u16 ability;
    s32 hp;
    u32 maxHp;
    u32 status2;
    u8 level;
    u16 item;
} BattleMon;
typedef struct {
    BattleMon battleMons[4];
    u32 fieldCondition;
    u8 iceFaceWeatherSeen;
    u8 relicSongTracker;
    int battlerIdAttacker;
    u32 moveNoCur;
    u32 moveStatusFlag;
    u8 multiHitCount;
    BOOL moldBreaker, cloudNine;
} BattleContext;
typedef struct BattleSystem BattleSystem;
typedef struct { u16 power; u8 category; } MoveTbl;

static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
static MoveTbl sMoves[] = {
    [MOVE_TACKLE] = { 40, CATEGORY_PHYSICAL }, [MOVE_EMBER] = { 40, CATEGORY_SPECIAL },
    [MOVE_STRUGGLE] = { 50, CATEGORY_PHYSICAL },
    [MOVE_SWORDS_DANCE] = { 0, CATEGORY_STATUS }, [MOVE_KINGS_SHIELD] = { 0, CATEGORY_STATUS } };
static const MoveTbl *BattleMoveTbl(BattleContext *ctx, u16 move) { (void)ctx; return &sMoves[move]; }
static BOOL CheckBattlerAbilityIfNotIgnored(BattleContext *ctx, int attacker, int target, int ability) {
    (void)attacker;
    return !ctx->moldBreaker && ctx->battleMons[target].ability == ability;
}
static int CheckAbilityActive(BattleSystem *bs, BattleContext *ctx, int flag, int battlerId, int ability) {
    (void)bs; (void)flag; (void)battlerId;
    return ctx->cloudNine && (ability == ABILITY_CLOUD_NINE || ability == ABILITY_AIR_LOCK);
}
static u32 MaskOfFlagNo(int flagNo) { return 1u << flagNo; }

static BattleContext ctx;
static void set(u16 species, u16 ability, s32 hp, u32 maxHp) {
    ctx.battleMons[0] = (BattleMon){ species, ability, hp, maxHp, 0, 50 };
    ctx.moldBreaker = ctx.cloudNine = FALSE;
}
"""


def run(functions, body, prefix, path="src/battle/overlay_12_0224E4FC.c"):
    source = (ROOT / path).read_text()
    program = PREFIX + "\n".join(function(source, name) for name in functions) + "\nint main(void) {\n" + body + "\n    return 0;\n}\n"
    with tempfile.TemporaryDirectory(prefix=prefix) as directory:
        path = Path(directory)
        (path / "test.c").write_text(program)
        subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-fsanitize=address,undefined",
            "-iquote", str(ROOT / "include"), str(path / "test.c"), "-o", str(path / "test")], check=True)
        result = subprocess.run([str(path / "test")], capture_output=True, text=True,
                                env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0"})
    if result.returncode:
        raise AssertionError(result.stdout + result.stderr)
    return result.stdout.strip()


class FormChangeTests(unittest.TestCase):
    def setUp(self):
        self.check = function((ROOT / "src/battle/overlay_12_0224E4FC.c").read_text(), "Battler_CheckWeatherFormChange")

    def test_zen_mode(self):
        """At half its HP or less a Darmanitan is in its Zen Mode, above half
        or without the ability it is not; the Galarian one likewise."""
        print(run(["Battler_ZenModeForm"], r"""
    set(SPECIES_DARMANITAN, ABILITY_ZEN_MODE, 51, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_DARMANITAN, ABILITY_ZEN_MODE, 50, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN_ZEN_MODE);
    set(SPECIES_DARMANITAN, ABILITY_SHEER_FORCE, 10, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_DARMANITAN_GALARIAN, ABILITY_ZEN_MODE, 1, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN_ZEN_MODE_GALARIAN);
    set(SPECIES_DARMANITAN_ZEN_MODE, ABILITY_ZEN_MODE, 50, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_DARMANITAN_ZEN_MODE, ABILITY_ZEN_MODE, 51, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN);
    set(SPECIES_DARMANITAN_ZEN_MODE_GALARIAN, ABILITY_NONE, 1, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_DARMANITAN_GALARIAN);
    set(SPECIES_SLOWPOKE, ABILITY_ZEN_MODE, 1, 100);
    assert(Battler_ZenModeForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Zen Mode comes at half HP and goes above it or without the ability.");""", "newgold-zen-"))
        self.assertIn("form = Battler_ZenModeForm(ctx, ctx->battlerIdTemp);", self.check)

    def test_schooling(self):
        """A Wishiwashi of level 20 or more schools above a quarter of its HP
        and breaks up at a quarter; below 20, or without the ability, it does
        not school."""
        print(run(["Battler_SchoolingForm"], r"""
    set(SPECIES_WISHIWASHI, ABILITY_SCHOOLING, 26, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_WISHIWASHI_SCHOOL);
    set(SPECIES_WISHIWASHI, ABILITY_SCHOOLING, 25, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_WISHIWASHI_SCHOOL, ABILITY_SCHOOLING, 25, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_WISHIWASHI);
    set(SPECIES_WISHIWASHI_SCHOOL, ABILITY_SCHOOLING, 26, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_WISHIWASHI, ABILITY_SCHOOLING, 100, 100);
    ctx.battleMons[0].level = 19;
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_WISHIWASHI, ABILITY_NONE, 100, 100);
    assert(Battler_SchoolingForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Schooling above a quarter of the HP, from level 20.");""", "newgold-schooling-"))
        self.assertIn("form = Battler_SchoolingForm(ctx, ctx->battlerIdTemp);", self.check)

    def test_stance_change(self):
        """Before an Aegislash moves, a move with power puts it in its Blade
        Forme and King's Shield in its Shield Forme; a status move changes
        nothing, nor does the move of a transformed battler."""
        print(run(["Battler_StanceChangeForm"], r"""
    set(SPECIES_AEGISLASH, ABILITY_STANCE_CHANGE, 1, 1);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_AEGISLASH_BLADE);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_SWORDS_DANCE) == SPECIES_NONE);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_KINGS_SHIELD) == SPECIES_NONE);
    set(SPECIES_AEGISLASH_BLADE, ABILITY_STANCE_CHANGE, 1, 1);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_KINGS_SHIELD) == SPECIES_AEGISLASH);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_NONE);
    set(SPECIES_AEGISLASH, ABILITY_STANCE_CHANGE, 1, 1);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_NONE);
    set(SPECIES_AEGISLASH, ABILITY_NONE, 1, 1);
    assert(Battler_StanceChangeForm(&ctx, 0, MOVE_TACKLE) == SPECIES_NONE);
    puts("PASS: Stance Change to Blade for a move with power, to Shield for King's Shield.");""",
                  "newgold-stance-", "src/battle/battle_controller_player.c"))
        before = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224C38C")
        self.assertLess(before.index("TryStanceChange(battleSystem, ctx)"), before.index("ov12_0224B1FC(battleSystem, ctx)"))

    def test_hunger_switch(self):
        """At the end of every turn a Morpeko turns Hangry, or back; not a
        fainted one, a transformed one or one that has lost the ability. The
        change is the last thing at the end of the turn."""
        print(run(["Battler_HungerSwitchForm"], r"""
    set(SPECIES_MORPEKO, ABILITY_HUNGER_SWITCH, 1, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_MORPEKO_HANGRY);
    set(SPECIES_MORPEKO_HANGRY, ABILITY_HUNGER_SWITCH, 1, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_MORPEKO);
    set(SPECIES_MORPEKO, ABILITY_HUNGER_SWITCH, 0, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_MORPEKO, ABILITY_NONE, 1, 1);
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_MORPEKO, ABILITY_HUNGER_SWITCH, 1, 1);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_HungerSwitchForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Hunger Switch at the end of every turn.");""",
                  "newgold-hunger-", "src/battle/battle_controller_player.c"))
        extra = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_UpdateFieldConditionExtra")
        self.assertLess(extra.index("case UFCE_STATE_TRICK_ROOM:"), extra.index("case UFCE_STATE_HUNGER_SWITCH:"))
        self.assertIn("form = Battler_HungerSwitchForm(ctx, battlerId);", extra)

    def test_disguise_and_ice_face(self):
        """A disguised Mimikyu takes no move, an Eiscue with its face no
        physical one, and each breaks into its other form; Mold Breaker goes
        through. The Ice Face comes back once when hail or snow begins, or on
        the way in while it lasts."""
        print(run(["Battler_BrokenFaceForm", "Battler_RestoredFaceForm"], r"""
    ctx.battleMons[1] = (BattleMon){ SPECIES_PIKACHU, ABILITY_STATIC, 1, 1, 0, 50 };
    set(SPECIES_MIMIKYU, ABILITY_DISGUISE, 1, 1);
    ctx.battleMons[1] = (BattleMon){ SPECIES_MIMIKYU, ABILITY_DISGUISE, 1, 1, 0, 50 };
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_EMBER) == SPECIES_MIMIKYU_BUSTED);
    ctx.battleMons[1].species = SPECIES_MIMIKYU_LARGE;
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_TACKLE) == SPECIES_MIMIKYU_BUSTED_LARGE);
    ctx.battleMons[1].species = SPECIES_MIMIKYU_BUSTED;
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_TACKLE) == SPECIES_NONE);
    ctx.battleMons[1].species = SPECIES_MIMIKYU;
    ctx.moldBreaker = TRUE;
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_TACKLE) == SPECIES_NONE);
    ctx.moldBreaker = FALSE;
    ctx.battleMons[1].status2 = STATUS2_TRANSFORM;
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_TACKLE) == SPECIES_NONE);
    ctx.battleMons[1] = (BattleMon){ SPECIES_EISCUE, ABILITY_ICE_FACE, 1, 1, 0, 50 };
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_TACKLE) == SPECIES_EISCUE_NOICE_FACE);
    assert(Battler_BrokenFaceForm(&ctx, 0, 1, MOVE_EMBER) == SPECIES_NONE);

    set(SPECIES_EISCUE_NOICE_FACE, ABILITY_ICE_FACE, 1, 1);
    ctx.iceFaceWeatherSeen = 0;
    ctx.fieldCondition = 0;
    assert(Battler_RestoredFaceForm(0, &ctx, 0) == SPECIES_NONE);
    ctx.fieldCondition = FIELD_CONDITION_SNOW_TEMP;
    assert(Battler_RestoredFaceForm(0, &ctx, 0) == SPECIES_EISCUE);
    // Still snowing at the next check: the face came back once already.
    assert(Battler_RestoredFaceForm(0, &ctx, 0) == SPECIES_NONE);
    ctx.fieldCondition = 0;
    assert(Battler_RestoredFaceForm(0, &ctx, 0) == SPECIES_NONE);
    ctx.fieldCondition = FIELD_CONDITION_HAIL;
    ctx.cloudNine = TRUE;
    assert(Battler_RestoredFaceForm(0, &ctx, 0) == SPECIES_NONE);
    ctx.cloudNine = FALSE;
    ctx.iceFaceWeatherSeen = 0;
    assert(Battler_RestoredFaceForm(0, &ctx, 0) == SPECIES_EISCUE);
    puts("PASS: Disguise and Ice Face take a hit and break; the Ice Face comes back with the snow.");""",
                  "newgold-face-"))
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        self.assertIn("form = Battler_BrokenFaceForm(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur);",
                      function(overlay, "CheckAbilityEffectOnHit"))
        self.assertIn("form = Battler_RestoredFaceForm(battleSystem, ctx, ctx->battlerIdTemp);", self.check)
        self.assertIn("ctx->iceFaceWeatherSeen &= ~MaskOfFlagNo(battlerId);", function(overlay, "BattleSystem_GetBattleMon"))
        damage = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224B498")
        self.assertRegex(damage, r"Battler_BrokenFaceForm\(ctx, ctx->battlerIdAttacker, ctx->battlerIdTarget, ctx->moveNoCur\) != SPECIES_NONE\) \{\s*ctx->damage = 0;")
        script = next((ROOT / "files/battledata/script/subscript").glob("subscript_*_DisguiseIceFace.s")).read_text()
        for line in ("PrintMessage msg_0197_01131", "ChangeForm BATTLER_CATEGORY_MSG_TEMP", "PrintMessage msg_0197_01351",
                     "DivideVarByValue BSCRIPT_VAR_HP_CALC, 8", "PrintMessage msg_0197_00721"):
            self.assertIn(line, script)

    def test_zero_to_hero(self):
        """A Palafin that leaves the field of its own accord comes back in
        its Hero Form, and says so the first time it does; not a fainted one,
        a transformed one, or one forced out."""
        print(run(["Battler_TurnsHero"], r"""
    set(SPECIES_PALAFIN, ABILITY_ZERO_TO_HERO, 1, 1);
    assert(Battler_TurnsHero(&ctx, 0));
    set(SPECIES_PALAFIN, ABILITY_ZERO_TO_HERO, 0, 1);
    assert(!Battler_TurnsHero(&ctx, 0));
    set(SPECIES_PALAFIN_HERO, ABILITY_ZERO_TO_HERO, 1, 1);
    assert(!Battler_TurnsHero(&ctx, 0));
    set(SPECIES_PALAFIN, ABILITY_NONE, 1, 1);
    assert(!Battler_TurnsHero(&ctx, 0));
    set(SPECIES_PALAFIN, ABILITY_ZERO_TO_HERO, 1, 1);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(!Battler_TurnsHero(&ctx, 0));
    puts("PASS: Zero to Hero on the way out.");""", "newgold-hero-", "src/battle/battle_command.c"))
        switch = function((ROOT / "src/battle/battle_command.c").read_text(), "BtlCmd_SwitchAndUpdateMon")
        self.assertIn("if (side != BATTLER_CATEGORY_FORCED_OUT && Battler_TurnsHero(ctx, battlerId)) {", switch)
        self.assertIn("&& ctx->battleMons[battlerId].species != SPECIES_PALAFIN_HERO) {", switch)
        self.assertLess(switch.index("SPECIES_PALAFIN_HERO"), switch.index("ctx->selectedMonIndex[battlerId] = ctx->unk_21A0[battlerId];"))
        entry = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        entry = entry[entry.index("case 19: // Intrepid Sword"):entry.index("case 20: // Hospitality")]
        self.assertIn("script = BATTLE_SUBSCRIPT_ZERO_TO_HERO;", entry)
        self.assertIn("PrintMessage msg_0197_01780, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP",
                      next((ROOT / "files/battledata/script/subscript").glob("subscript_*_ZeroToHero.s")).read_text())

    def test_relic_song(self):
        """A Meloetta whose Relic Song reached a target turns Pirouette, or
        back to Aria; not for another move, another battler, a failed move,
        before the last hit, or a transformed one."""
        print(run(["Battler_RelicSongForm"], r"""
    set(SPECIES_MELOETTA, ABILITY_SERENE_GRACE, 1, 1);
    ctx.battlerIdAttacker = 0;
    ctx.moveNoCur = MOVE_RELIC_SONG;
    ctx.relicSongTracker = 1;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_MELOETTA_PIROUETTE);
    ctx.battleMons[0].species = SPECIES_MELOETTA_PIROUETTE;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_MELOETTA);
    ctx.relicSongTracker = 0;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_NONE);
    ctx.relicSongTracker = 1;
    ctx.moveNoCur = MOVE_TACKLE;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_NONE);
    ctx.moveNoCur = MOVE_RELIC_SONG;
    ctx.battlerIdAttacker = 1;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_NONE);
    ctx.battlerIdAttacker = 0;
    ctx.moveStatusFlag = MOVE_STATUS_FAILED;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_NONE);
    ctx.moveStatusFlag = 0;
    ctx.multiHitCount = 2;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_NONE);
    ctx.multiHitCount = 0;
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_RelicSongForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Relic Song turns Meloetta once it has reached a target.");""", "newgold-relic-"))
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        self.assertIn("ctx->relicSongTracker |= MaskOfFlagNo(battlerIdAttacker);",
                      function(overlay, "BattleContext_CheckMoveImmunityFromAbility"))
        self.assertIn("form = Battler_RelicSongForm(ctx, ctx->battlerIdTemp);", self.check)

    def test_genesect(self):
        """Genesect takes the form of the Drive it holds, and goes back to its
        own without one; the battler changes, the Pokemon does not."""
        print(run(["Battler_GenesectForm"], r"""
    set(SPECIES_GENESECT, ABILITY_DOWNLOAD, 1, 1);
    assert(Battler_GenesectForm(&ctx, 0) == SPECIES_NONE);
    ctx.battleMons[0].item = ITEM_DOUSE_DRIVE;
    assert(Battler_GenesectForm(&ctx, 0) == SPECIES_GENESECT_DOUSE_DRIVE);
    ctx.battleMons[0].item = ITEM_CHILL_DRIVE;
    assert(Battler_GenesectForm(&ctx, 0) == SPECIES_GENESECT_CHILL_DRIVE);
    ctx.battleMons[0].species = SPECIES_GENESECT_CHILL_DRIVE;
    assert(Battler_GenesectForm(&ctx, 0) == SPECIES_NONE);
    ctx.battleMons[0].item = ITEM_NONE;
    assert(Battler_GenesectForm(&ctx, 0) == SPECIES_GENESECT);
    set(SPECIES_PIKACHU, ABILITY_STATIC, 1, 1);
    ctx.battleMons[0].item = ITEM_BURN_DRIVE;
    assert(Battler_GenesectForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Genesect follows its Drive.");""", "newgold-genesect-"))
        self.assertIn("form = Battler_GenesectForm(ctx, ctx->battlerIdTemp);", self.check)

    def test_power_construct(self):
        """A Power Construct Zygarde at half its HP or less becomes its
        Complete Forme, and gains what its maximum HP grew by."""
        print(run(["Battler_PowerConstructForm"], r"""
    set(SPECIES_ZYGARDE_10_POWER_CONSTRUCT, ABILITY_POWER_CONSTRUCT, 50, 100);
    assert(Battler_PowerConstructForm(&ctx, 0) == SPECIES_ZYGARDE_10_COMPLETE);
    set(SPECIES_ZYGARDE_50_POWER_CONSTRUCT, ABILITY_POWER_CONSTRUCT, 50, 100);
    assert(Battler_PowerConstructForm(&ctx, 0) == SPECIES_ZYGARDE_50_COMPLETE);
    set(SPECIES_ZYGARDE_50_POWER_CONSTRUCT, ABILITY_POWER_CONSTRUCT, 51, 100);
    assert(Battler_PowerConstructForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_ZYGARDE_50_COMPLETE, ABILITY_POWER_CONSTRUCT, 10, 100);
    assert(Battler_PowerConstructForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_ZYGARDE, ABILITY_AURA_BREAK, 10, 100);
    assert(Battler_PowerConstructForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_ZYGARDE_10_POWER_CONSTRUCT, ABILITY_POWER_CONSTRUCT, 0, 100);
    assert(Battler_PowerConstructForm(&ctx, 0) == SPECIES_NONE);
    puts("PASS: Power Construct at half HP.");""", "newgold-construct-"))
        self.assertIn("form = Battler_PowerConstructForm(ctx, ctx->battlerIdTemp);", self.check)
        self.assertIn("ctx->hpCalc = ctx->battleMons[ctx->battlerIdTemp].maxHp - maxHp;", self.check)
        script = next((ROOT / "files/battledata/script/subscript").glob("subscript_*_PowerConstruct.s")).read_text()
        for line in ("PrintMessage msg_0197_01360", "Call BATTLE_SUBSCRIPT_UPDATE_HP", "PrintMessage msg_0197_01361"):
            self.assertIn(line, script)

    def test_neutralizing_gas_leaves_the_form_abilities_alone(self):
        """Neutralizing Gas suppresses every ability on the field but the ones
        nothing suppresses: a Darmanitan keeps its Zen Mode under the gas,
        where an Intimidate is gone."""
        source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        program = r"""
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "constants/abilities.h"
typedef uint16_t u16;
typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
#define NELEMS(a) (sizeof(a) / sizeof(*(a)))
#define MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED 1
#define STATUS2_TRANSFORM 2
#define ITEM_VAR_HOLD_EFFECT 1
#define HOLD_EFFECT_PREVENT_ABILITY_CHANGES 210
#define ITEM_ABILITY_SHIELD 1892
typedef struct { u16 ability; int hp; u32 moveEffectFlags; u32 status2; u16 item; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;
static int GetItemVar(BattleContext *ctx, u16 item, u16 var) { (void)ctx; (void)var; return item == ITEM_ABILITY_SHIELD ? HOLD_EFFECT_PREVENT_ABILITY_CHANGES : 0; }
""" + function(source, "AbilityIsUnsuppressable") + "\n" + function(source, "BattlerGivesOffGas") + "\n" + function(source, "AbilitiesAreNeutralized") + r"""
int main(void) {
    BattleContext ctx = { { { ABILITY_ZEN_MODE, 1, 0 }, { ABILITY_NEUTRALIZING_GAS, 1, 0 }, { ABILITY_INTIMIDATE, 1, 0 } } };
    // The games' list (Pokemon Central, Gas Reagente), fifteen and the gas.
    static const u16 kept[] = { ABILITY_STANCE_CHANGE, ABILITY_SCHOOLING, ABILITY_DISGUISE, ABILITY_ICE_FACE,
        ABILITY_GULP_MISSILE, ABILITY_BATTLE_BOND, ABILITY_MULTITYPE, ABILITY_POWER_CONSTRUCT, ABILITY_SHIELDS_DOWN,
        ABILITY_AS_ONE_GLASTRIER, ABILITY_AS_ONE_SPECTRIER, ABILITY_RKS_SYSTEM, ABILITY_COMATOSE, ABILITY_ZEN_MODE,
        ABILITY_ZERO_TO_HERO, ABILITY_TERA_SHIFT };
    for (unsigned i = 0; i < NELEMS(kept); i++) {
        ctx.battleMons[0].ability = kept[i];
        assert(!AbilitiesAreNeutralized(&ctx, 0));
    }
    assert(AbilitiesAreNeutralized(&ctx, 2));
    ctx.battleMons[0].ability = ABILITY_HUNGER_SWITCH;
    assert(AbilitiesAreNeutralized(&ctx, 0));
    ctx.battleMons[0].ability = ABILITY_COMMANDER;
    assert(AbilitiesAreNeutralized(&ctx, 0));
    ctx.battleMons[0].item = ITEM_ABILITY_SHIELD;
    assert(!AbilitiesAreNeutralized(&ctx, 0));
    ctx.battleMons[0].item = 0;
    ctx.battleMons[1].status2 = STATUS2_TRANSFORM;
    assert(!AbilitiesAreNeutralized(&ctx, 0));
    puts("PASS: Neutralizing Gas leaves the abilities nothing suppresses.");
    return 0;
}
"""
        with tempfile.TemporaryDirectory(prefix="newgold-gas-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(program)
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            result = subprocess.run([str(path / "test")], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        print(result.stdout.strip())

    def test_confusion_into_a_disguise(self):
        """A confused Mimikyu or Eiscue that hits itself breaks its own face
        and takes nothing (btl_scr_cmd_FE_calcconfusiondamage)."""
        print(run(["Battler_BrokenFaceForm"], r"""
    set(SPECIES_MIMIKYU, ABILITY_DISGUISE, 1, 1);
    assert(Battler_BrokenFaceForm(&ctx, 0, 0, MOVE_STRUGGLE) == SPECIES_MIMIKYU_BUSTED);
    set(SPECIES_EISCUE, ABILITY_ICE_FACE, 1, 1);
    assert(Battler_BrokenFaceForm(&ctx, 0, 0, MOVE_STRUGGLE) == SPECIES_EISCUE_NOICE_FACE);
    puts("PASS: a confusion self-hit breaks a face.");""", "newgold-confusion-"))
        status = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224B528")
        self.assertRegex(status, r"form = Battler_BrokenFaceForm\(ctx, ctx->battlerIdAttacker, ctx->battlerIdAttacker, MOVE_STRUGGLE\);\s*"
                                 r"if \(form != SPECIES_NONE\) \{\s*ctx->hpCalc = 0;")
        self.assertIn("BATTLE_SUBSCRIPT_HURT_SELF_DISGUISED", status)
        script = next((ROOT / "files/battledata/script/subscript").glob("subscript_*_HurtSelfDisguised.s")).read_text()
        self.assertLess(script.index("PrintMessage msg_0197_00797"), script.index("Call BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE"))


class ShieldsDownTests(unittest.TestCase):
    def test_the_shell_is_on_above_half_and_off_at_half(self):
        """Every colour's Meteor Form breaks into its own Core Form at half its
        HP, and back above it; not without the ability, nor Transformed."""
        print(run(["Battler_ShieldsDownForm", "Battler_ShieldsUp"], r"""
    set(SPECIES_MINIOR, ABILITY_SHIELDS_DOWN, 51, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_NONE);
    assert(Battler_ShieldsUp(&ctx, 0));
    set(SPECIES_MINIOR, ABILITY_SHIELDS_DOWN, 50, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_MINIOR_CORE_RED);
    set(SPECIES_MINIOR_CORE_RED, ABILITY_SHIELDS_DOWN, 51, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_MINIOR);
    assert(!Battler_ShieldsUp(&ctx, 0));
    set(SPECIES_MINIOR_METEOR_ORANGE, ABILITY_SHIELDS_DOWN, 1, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_MINIOR_CORE_ORANGE);
    set(SPECIES_MINIOR_METEOR_VIOLET, ABILITY_SHIELDS_DOWN, 1, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_MINIOR_CORE_VIOLET);
    assert(Battler_ShieldsUp(&ctx, 0));
    set(SPECIES_MINIOR_CORE_INDIGO, ABILITY_SHIELDS_DOWN, 100, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_MINIOR_METEOR_INDIGO);
    set(SPECIES_MINIOR_CORE_INDIGO, ABILITY_SHIELDS_DOWN, 50, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_NONE);
    set(SPECIES_MINIOR, ABILITY_NONE, 1, 100);
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_NONE);
    assert(!Battler_ShieldsUp(&ctx, 0));
    set(SPECIES_MINIOR, ABILITY_SHIELDS_DOWN, 1, 100);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(Battler_ShieldsDownForm(&ctx, 0) == SPECIES_NONE);
    assert(!Battler_ShieldsUp(&ctx, 0));
    puts("PASS: Shields Down: Meteor above half, Core at half, for each colour.");""", "newgold-shields-"))

    def test_on_the_way_in_and_at_the_end_of_the_turn(self):
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        entry = function(overlay, "TryAbilityOnEntry")
        first = entry[entry.index("case 0:"):entry.index("case 1:")]
        self.assertIn("j = Battler_ShieldsDownForm(ctx, battlerId);", first)
        # Once per entry: set after the change, which clears it.
        self.assertLess(first.index("BattleSystem_ChangeBattlerForm(battleSystem, ctx, battlerId, j, FALSE);"),
                        first.index("ctx->battleMons[battlerId].abilityActivatedFlag = TRUE;"))
        # Not after every action, where the other HP forms are checked.
        self.assertNotIn("Battler_ShieldsDownForm", function(overlay, "Battler_CheckWeatherFormChange"))
        extra = function((ROOT / "src/battle/battle_controller_player.c").read_text(), "BattleControllerPlayer_UpdateFieldConditionExtra")
        self.assertIn("form = Battler_ShieldsDownForm(ctx, battlerId);", extra)

    def test_no_status_reaches_the_shell(self):
        subscripts = ROOT / "files/battledata/script/subscript"
        for name, paths in (("FallAsleep", 2), ("Poison", 2), ("Burn", 2), ("Freeze", 1), ("Paralyze", 1), ("BadPoison", 3)):
            script = next(subscripts.glob(f"subscript_*_{name}.s")).read_text()
            self.assertEqual(script.count("BATTLER_CATEGORY_SIDE_EFFECT_MON, BMON_DATA_SHIELDS_UP, 1, _"), paths, name)
        overlay = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        self.assertIn("case BMON_DATA_SHIELDS_UP:\n        return Battler_ShieldsUp(ctx, battlerId);", function(overlay, "GetBattlerVar"))
        refusal = function(overlay, "BattleContext_CheckMoveImmunityFromAbility")
        self.assertIn("(givesStatus || moveEffect == MOVE_EFFECT_RECOVER_HEALTH_AND_SLEEP) && Battler_ShieldsUp(ctx, battlerIdTarget) == TRUE", refusal)


if __name__ == "__main__":
    unittest.main()
