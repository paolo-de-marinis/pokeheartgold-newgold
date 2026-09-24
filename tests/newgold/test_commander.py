#!/usr/bin/env python3
"""Commander (Pokemon Central, Torre di Comando) and Order Up (Alta Cucina).

In a double battle that is not a Multi Battle, a Tatsugiri with Commander
beside a Dondozo of the same trainer goes into its mouth: the Dondozo's
Attack, Defense, Sp. Atk, Sp. Def and Speed rise by two, the Tatsugiri skips
its turns and every move aimed at it fails, neither can leave the field or be
made to, and the Tatsugiri comes back out when the Dondozo faints. Order Up
raises one of the Dondozo's stats by its Tatsugiri's form. Who goes into the
mouth runs natively; the places that ask are read from the source.
"""

import re
import sys
import unittest

from test_hold_effects import run_c
from test_level_cap import ROOT
from test_repels import function

sys.path.insert(0, str(ROOT / "tools/newgold/import"))
import import_battle_messages  # noqa: E402

BATTLE = ROOT / "src/battle"
OVERLAY = (BATTLE / "overlay_12_0224E4FC.c").read_text()
CONTROLLER = (BATTLE / "battle_controller_player.c").read_text()
COMMANDS = (BATTLE / "battle_command.c").read_text()
SCRIPTS = ROOT / "files/battledata/script"

PROGRAM = r"""
#include <assert.h>
#include <stdint.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/battle_subscript.h"
#include "constants/species.h"
typedef uint8_t u8; typedef uint16_t u16; typedef int32_t s32; typedef uint32_t u32;
typedef int BOOL;
#define TRUE 1
#define FALSE 0
typedef struct { int trainer; } Party;
typedef struct { u32 battleType; Party *party[4]; } BattleSystem;
typedef struct { u16 species; u16 ability; s32 hp; u32 status2; } BattleMon;
typedef struct { u8 commanding : 1; u8 commanderForm : 2; } MoveConditions;
typedef struct { int command; } PlayerActions;
typedef struct {
    BattleMon battleMons[4];
    MoveConditions moveConditions[4];
    PlayerActions playerActions[4];
    u8 turnOrder[4];
    int battlerIdTemp, battlerIdStatChange, statChangeType;
} BattleContext;
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->battleType; }
static int BattleSystem_GetMaxBattlers(BattleSystem *bs) { return (bs->battleType & BATTLE_TYPE_DOUBLES) ? 4 : 2; }
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) { (void)bs; return battlerId ^ 2; }
static Party *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return bs->party[battlerId]; }
static u16 GetBattlerAbility(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].ability; }
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static Party player, foe, partner;

// A double battle against one trainer: the player's Tatsugiri in slot 0 and
// Dondozo in slot 2, the foe's Pokemon in 1 and 3.
static void setUp(u16 tatsugiri) {
    memset(&ctx, 0, sizeof(ctx));
    bs.battleType = BATTLE_TYPE_TRAINER | BATTLE_TYPE_DOUBLES;
    bs.party[0] = bs.party[2] = &player;
    bs.party[1] = bs.party[3] = &foe;
    for (int i = 0; i < 4; i++) {
        ctx.turnOrder[i] = i;
        ctx.battleMons[i] = (BattleMon){ SPECIES_MAGIKARP, ABILITY_SWIFT_SWIM, 100, 0 };
        ctx.playerActions[i].command = CONTROLLER_COMMAND_FIGHT_INPUT;
    }
    ctx.battleMons[0] = (BattleMon){ tatsugiri, ABILITY_COMMANDER, 100, 0 };
    ctx.battleMons[2] = (BattleMon){ SPECIES_DONDOZO, ABILITY_UNAWARE, 100, 0 };
}

static BOOL commands(void) {
    int script = BATTLE_SUBSCRIPT_NONE;
    BOOL acted = TryCommander(&bs, &ctx, &script);
    assert(acted == (script == BATTLE_SUBSCRIPT_COMMANDER));
    return acted;
}

int main(void) {
    // Into the mouth: the state on both, the Tatsugiri's turn given up, and
    // the subscript told who is who.
    setUp(SPECIES_TATSUGIRI);
    assert(commands());
    assert(ctx.moveConditions[0].commanding && ctx.moveConditions[2].commanderForm == 1);
    assert(!ctx.moveConditions[2].commanding && !ctx.moveConditions[0].commanderForm);
    assert(ctx.playerActions[0].command == CONTROLLER_COMMAND_40);
    assert(ctx.playerActions[2].command == CONTROLLER_COMMAND_FIGHT_INPUT);
    assert(ctx.battlerIdTemp == 0 && ctx.battlerIdStatChange == 2 && ctx.statChangeType == SIDE_EFFECT_TYPE_INDIRECT);
    assert(Battler_HeldByCommander(&ctx, 0) && Battler_HeldByCommander(&ctx, 2));
    assert(!Battler_HeldByCommander(&ctx, 1) && !Battler_HeldByCommander(&ctx, 3));
    // Once only.
    assert(!commands());
    // The form is what Order Up reads: Curly 1, Droopy 2, Stretchy 3.
    setUp(SPECIES_TATSUGIRI_DROOPY);
    assert(commands() && ctx.moveConditions[2].commanderForm == 2);
    setUp(SPECIES_TATSUGIRI_STRETCHY);
    assert(commands() && ctx.moveConditions[2].commanderForm == 3);
    // The foe's pair as well.
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[0].ability = ABILITY_NONE;
    ctx.battleMons[1] = (BattleMon){ SPECIES_TATSUGIRI_DROOPY, ABILITY_COMMANDER, 50, 0 };
    ctx.battleMons[3] = (BattleMon){ SPECIES_DONDOZO, ABILITY_OBLIVIOUS, 50, 0 };
    assert(commands() && ctx.moveConditions[1].commanding && ctx.moveConditions[3].commanderForm == 2);
    // Not in a single battle, nor in a Multi Battle, nor beside a partner
    // trainer's Dondozo.
    setUp(SPECIES_TATSUGIRI);
    bs.battleType = BATTLE_TYPE_TRAINER;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    bs.battleType |= BATTLE_TYPE_MULTI;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    bs.battleType |= BATTLE_TYPE_TAG;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    bs.party[2] = &partner;
    assert(!commands());
    // Not without the ability -- suppressed, or under Neutralizing Gas, as
    // GetBattlerAbility answers -- nor from a copy of either, nor from or
    // into a fainted one, nor beside another species.
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[0].ability = ABILITY_NONE;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[0].status2 = STATUS2_TRANSFORM;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[2].status2 = STATUS2_TRANSFORM;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[0].hp = 0;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[2].hp = 0;
    assert(!commands());
    setUp(SPECIES_TATSUGIRI);
    ctx.battleMons[2].species = SPECIES_WAILORD;
    assert(!commands());
    setUp(SPECIES_MAGIKARP);
    assert(!commands());
    // A Dondozo keeps the Tatsugiri it took in, fainted or not, and takes in
    // no other: the second Tatsugiri stays out.
    setUp(SPECIES_TATSUGIRI);
    ctx.moveConditions[2].commanderForm = 3;
    assert(!commands() && !ctx.moveConditions[0].commanding);
    // Held on the field only while standing.
    ctx.battleMons[2].hp = 0;
    assert(!Battler_HeldByCommander(&ctx, 2));
    return 0;
}
"""


def script(name):
    return next(SCRIPTS.rglob(name)).read_text()


def code(text):
    return "\n".join(line for line in text.splitlines() if not line.strip().startswith("//"))


class CommanderTests(unittest.TestCase):
    def test_who_goes_into_the_mouth(self):
        functions = "\n".join(function(OVERLAY, name) for name in ("Battler_HeldByCommander", "TryCommander"))
        run_c(PROGRAM.replace("@FUNCTIONS@", functions))

    def test_it_is_a_switch_in_step(self):
        entry = function(OVERLAY, "TryAbilityOnEntry")
        step = entry[entry.index("// Commander"):]
        self.assertIn("flag = TryCommander(battleSystem, ctx, &script);", step[:step.index("break;")])
        self.assertLess(entry.index("TrySymbiosisHandOver"), entry.index("TryCommander"))
        self.assertLess(entry.index("TryCommander"), entry.index("// end"))

    def test_the_mouth_is_shown_and_the_dondozo_rises(self):
        text = script("subscript_*_Commander.s")
        row = import_battle_messages.port_row("commander")
        self.assertIn(f"PrintMessage msg_0197_{row:05d}, TAG_NICKNAME_NICKNAME, BATTLER_CATEGORY_MSG_BATTLER_TEMP, BATTLER_CATEGORY_SIDE_EFFECT_MON", text)
        self.assertIn("ToggleVanish BATTLER_CATEGORY_MSG_BATTLER_TEMP, TRUE", text)
        raised = re.findall(r"MOVE_SUBSCRIPT_PTR_(\w+)_UP_2_STAGES\n    Call BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE", text)
        self.assertEqual(raised, ["ATTACK", "DEFENSE", "SP_ATTACK", "SP_DEFENSE", "SPEED"])

    def test_the_line_is_the_games(self):
        from test_battle_messages import rows
        table = rows()
        row = import_battle_messages.port_row("commander")
        self.assertEqual(table[row].replace("\\n", " ").replace("\\f", " "),
                         "{STRVAR_1 1, 0, 0} was swallowed by {STRVAR_1 1, 1, 0} and became {STRVAR_1 1, 1, 0}’s commander!")
        self.assertIn("The opposing {STRVAR_1 1, 0, 0}", table[row + 6])
        self.assertIn("opposing {STRVAR_1 1, 1, 0}’s commander!", table[row + 6])
        self.assertIn("The wild {STRVAR_1 1, 0, 0}", table[row + 4])

    def test_the_tatsugiri_neither_acts_nor_is_hit(self):
        select = function(CONTROLLER, "BattleControllerPlayer_SelectionScreenInput")
        self.assertIn("if ((ctx->switchInFlag & MaskOfFlagNo(battlerId)) || ctx->moveConditions[battlerId].commanding) {\n"
                      "                ctx->unk_0[battlerId] = SSI_STATE_13;\n"
                      "                ctx->playerActions[battlerId].command = CONTROLLER_COMMAND_40;", select)
        effect = function(CONTROLLER, "BattleSystem_CheckMoveEffect")
        guard = effect.index("if (ctx->moveConditions[battlerIdTarget].commanding")
        # Before the sure hits: No Guard, Lock-On, a Poison type's Toxic.
        self.assertLess(guard, effect.index("move == MOVE_TOXIC"))
        self.assertLess(guard, effect.index("ABILITY_NO_GUARD"))
        self.assertIn("MOVE_STATUS_SEMI_INVULNERABLE", effect[guard:guard + 400])
        perish = function(COMMANDS, "BtlCmd_TryPerishSong")
        self.assertIn("ctx->moveConditions[battlerId].commanding", perish)

    def test_neither_leaves_the_field(self):
        for name in ("BattlerCanSwitch", "Battler_WillBeDraggedOut", "BattlerIsAnchored"):
            self.assertIn("Battler_HeldByCommander(ctx, battlerId)", function(OVERLAY, name), name)
        # Nor do the post-move questions count a switch the scripts refuse:
        # Emergency Exit's and U-turn's would shut the Eject Packs.
        self.assertIn("(CanSwitchMon(battleSystem, ctx, battlerId) && !Battler_HeldByCommander(ctx, battlerId))",
                      function(OVERLAY, "Battler_Retreats"))
        self.assertIn("|| Battler_HeldByCommander(ctx, ctx->battlerIdAttacker)", function(CONTROLLER, "PivotSwitchPending"))
        self.assertIn("case BMON_DATA_COMMANDER:\n        return Battler_HeldByCommander(ctx, battlerId);", function(OVERLAY, "GetBattlerVar"))
        ai = (BATTLE / "trainer_ai_0222036C.c").read_text()
        self.assertIn("|| Battler_HeldByCommander(ctx, battlerId)", function(ai, "ov10_022203A4"))
        # Every way out a script takes asks first: the user's own switch, the
        # items and Emergency Exit, and the moves and the card that drag.
        for name, battler, before in (
            ("subscript_0175_PivotMove.s", "ATTACKER", "TryReplaceFaintedMon"),
            ("subscript_0114_BatonPass.s", "ATTACKER", "TryReplaceFaintedMon"),
            ("subscript_0343_HandleShedTail.s", "ATTACKER", "TryReplaceFaintedMon"),
            ("subscript_0438_HandlePartingShot.s", "SWITCHED_MON", "TryReplaceFaintedMon"),
            ("effect_script_0153.s", "ATTACKER", "TryReplaceFaintedMon"),
            ("effect_script_0436.s", "ATTACKER", "TryReplaceFaintedMon"),
            ("subscript_0431_SwitchOutItem.s", "MSG_BATTLER_TEMP", "TryReplaceFaintedMon"),
            ("subscript_0411_EmergencyExit.s", "MSG_BATTLER_TEMP", "TryReplaceFaintedMon"),
            ("subscript_0091_ForceSwitchOrFlee.s", "DEFENDER", "TryWhirlwind"),
            ("subscript_0432_RedCard.s", "DEFENDER", "DeletePokemon"),
        ):
            text = code(script(name))
            ask = f"CompareMonDataToValue OPCODE_NEQ, BATTLER_CATEGORY_{battler}, BMON_DATA_COMMANDER, 0, _"
            self.assertIn(ask, text, name)
            self.assertLess(text.index(ask), text.index(before), name)
        card = code(script("subscript_0432_RedCard.s"))
        self.assertLess(card.index("RemoveItem"), card.index("BMON_DATA_COMMANDER"))
        # Healing Wish and Lunar Dance faint their user rather than switch it,
        # and are not held back.
        for name in ("effect_script_0220.s", "effect_script_0270.s", "subscript_0159_HealingWish.s", "subscript_0261_LunarDance.s"):
            self.assertNotIn("BMON_DATA_COMMANDER", script(name), name)

    def test_the_dondozo_fainting_lets_the_tatsugiri_out(self):
        work = function(OVERLAY, "InitFaintedWork")
        release = work.index("if (ctx->moveConditions[battlerId].commanderForm) {")
        self.assertLess(release, work.index("MI_CpuClear8(&ctx->moveConditions[battlerId], sizeof(MoveConditions));"))
        self.assertIn("ctx->moveConditions[i].commanding = FALSE;\n            BattleController_EmitToggleVanish(battleSystem, i, FALSE);",
                      work[release:])


class OrderUpTests(unittest.TestCase):
    """Pokemon Central (Alta Cucina): a user holding a Tatsugiri in its mouth
    raises its Attack, Defense or Speed by one, by the Curly, Droopy or
    Stretchy form, the Tatsugiri fainted or not, once the move has hit (from
    Scarlet and Violet 1.2.0); Sheer Force boosts it and takes nothing."""

    def test_the_raise_follows_the_form(self):
        step = function(CONTROLLER, "TryAdditionalMoveEffect")
        order = step[step.index("if (ctx->moveNoCur == MOVE_ORDER_UP"):]
        order = order[:order.index("return TRUE;")]
        self.assertIn("ctx->moveConditions[ctx->battlerIdAttacker].commanderForm", order)
        self.assertIn("ctx->statChangeParam = MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE + ctx->moveConditions[ctx->battlerIdAttacker].commanderForm - 1;", order)
        self.assertIn("RunPostMoveScript(ctx, BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE);", order)
        # Only once the move has hit.
        self.assertLess(step.index("if (target == BATTLER_NONE || (ctx->moveStatusFlag & MOVE_STATUS_FAIL)) {"),
                        step.index("MOVE_ORDER_UP"))
        # Curly, Droopy and Stretchy are TryCommander's 1, 2 and 3, and the
        # three one-stage raises follow each other in that order.
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        ptr = {name: int(re.search(rf"#define MOVE_SUBSCRIPT_PTR_{name}_UP_1_STAGE\s+(\d+)", header).group(1))
               for name in ("ATTACK", "DEFENSE", "SPEED")}
        self.assertEqual((ptr["DEFENSE"], ptr["SPEED"]), (ptr["ATTACK"] + 1, ptr["ATTACK"] + 2))
        commander = function(OVERLAY, "TryCommander")
        for species, form in (("SPECIES_TATSUGIRI", 1), ("SPECIES_TATSUGIRI_DROOPY", 2), ("SPECIES_TATSUGIRI_STRETCHY", 3)):
            self.assertIn(f"case {species}:\n            form = {form};", commander)


if __name__ == "__main__":
    unittest.main()
