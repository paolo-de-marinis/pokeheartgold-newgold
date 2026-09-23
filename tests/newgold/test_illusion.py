#!/usr/bin/env python3
"""Illusion: a Pokemon with the ability comes out made up as the last Pokemon
after it in its party that can still fight (Party_GetIllusionImitatedIndex and
the send-out code, battle_pokemon.c at d0380a487; Pokemon Central,
Illusione), and the make-up drops when a move damages it or the ability goes."""

import os
import re
import shlex
import subprocess
import tempfile
import unittest
from pathlib import Path

from test_level_cap import ROOT
from test_repels import function

OVERLAY = ROOT / "src/battle/overlay_12_0224E4FC.c"
CONTROLLER = ROOT / "src/battle/battle_controller_player.c"
APPEAR = ROOT / "src/battle/battle_controller_mon_appear.c"
HEALTHBAR = ROOT / "src/battle/battle_controller_healthbar.c"
SYSTEM = ROOT / "src/battle/battle_system.c"
SUBSCRIPTS = ROOT / "files/battledata/script/subscript"

FIXTURE = r"""
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
typedef uint32_t u32;
typedef uint8_t u8;
typedef int BOOL;
enum { FALSE = 0, TRUE = 1 };
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/pokemon.h"
#include "constants/species.h"
typedef struct { int species, hp, egg; } Pokemon;
typedef struct { Pokemon party[2][6]; int count[2]; u32 battleType; } BattleSystem;
typedef struct { int ability; int neutralized; } BattleMon;
typedef struct { BattleMon battleMons[4]; } BattleContext;
static BOOL AbilitiesAreNeutralized(BattleContext *ctx, int battlerId) { return ctx->battleMons[battlerId].neutralized; }
static int BattleSystem_GetPartySize(BattleSystem *bs, int battlerId) { return bs->count[battlerId & 1]; }
static u32 BattleSystem_GetBattleType(BattleSystem *bs) { return bs->battleType; }
static void *BattleSystem_GetParty(BattleSystem *bs, int battlerId) { return bs->party[battlerId & 1]; }
static int BattleSystem_GetBattlerIdPartner(BattleSystem *bs, int battlerId) { (void)bs; return battlerId ^ 2; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *bs, int battlerId, int i) { return &bs->party[battlerId & 1][i]; }
static int GetMonData(Pokemon *mon, int id, void *data) {
    (void)data;
    return id == MON_DATA_SPECIES ? mon->species : id == MON_DATA_HP ? mon->hp : id == MON_DATA_IS_EGG ? mon->egg : 0;
}
@FUNCTIONS@
static BattleSystem bs;
static BattleContext ctx;
static void party(int count) {
    BattleSystem blank = { 0 };
    bs = blank;
    bs.count[1] = count;
    for (int i = 0; i < count; i++) {
        bs.party[1][i].species = SPECIES_BULBASAUR + i;
        bs.party[1][i].hp = 10;
    }
    ctx.battleMons[1].ability = ABILITY_ILLUSION;
    ctx.battleMons[1].neutralized = FALSE;
}
int main(void) {
    // The last one after it that can fight, as its slot plus one.
    party(6);
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 6);
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 2) == 6);
    bs.party[1][5].hp = 0;
    bs.party[1][4].egg = TRUE;
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 4);
    // Nothing after it, or the last, or nothing able to fight: no make-up.
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 5) == 0);
    party(3);
    bs.party[1][1].hp = bs.party[1][2].hp = 0;
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 0);
    // Another ability, or the gas already out.
    party(3);
    ctx.battleMons[1].ability = ABILITY_INTIMIDATE;
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 0);
    party(3);
    ctx.battleMons[1].neutralized = TRUE;
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 0);
    // One party behind both battlers of a double battle needs a third.
    party(2);
    bs.battleType = BATTLE_TYPE_DOUBLES;
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 0);
    party(3);
    bs.battleType = BATTLE_TYPE_DOUBLES;
    assert(Battler_IllusionDisguise(&bs, &ctx, 1, 0) == 3);
    return 0;
}
"""


class IllusionTests(unittest.TestCase):
    def test_which_pokemon_it_is_made_up_as(self):
        body = function(OVERLAY.read_text(), "Battler_IllusionDisguise")
        with tempfile.TemporaryDirectory(prefix="newgold-illusion-") as directory:
            path = Path(directory)
            (path / "test.c").write_text(FIXTURE.replace("@FUNCTIONS@", body))
            subprocess.run(shlex.split(os.environ.get("CC", "cc")) + [
                "-std=c99", "-Wall", "-Werror", "-Wno-unused-function", "-iquote", str(ROOT / "include"),
                str(path / "test.c"), "-o", str(path / "test")], check=True)
            subprocess.run([str(path / "test")], check=True)

    def test_it_is_made_up_as_it_comes_in(self):
        load = function(OVERLAY.read_text(), "BattleSystem_GetBattleMon")
        self.assertIn("ctx->battleMons[battlerId].illusionMon = Battler_IllusionDisguise(battleSystem, ctx, battlerId, selectedMon);", load)
        self.assertGreater(load.index("illusionMon ="), load.index("MON_DATA_ABILITY"))

    def test_it_is_drawn_and_named_as_the_other_pokemon(self):
        appear = APPEAR.read_text()
        for name in ("BattleController_EmitPokemonEncounter", "BattleController_EmitPokemonSlideIn",
                     "BattleController_EmitPokemonSendOut"):
            body = function(appear, name)
            self.assertIn("disguise = Battler_IllusionMon(battleSystem, battlerId);", body, name)
            self.assertLess(body.index("ILLUSION_MAKE_UP(data, disguise);"), body.index("ov12_02262240("), name)
        for field in ("species", "form", "shiny", "gender", "personality", "nickname"):
            self.assertIn(f"(data).{field}", appear)
        box = function(HEALTHBAR.read_text(), "BattleController_EmitHealthbarSlideIn")
        self.assertIn("data.selectedMonIndex = ctx->battleMons[battlerId].illusionMon - 1;", box)
        self.assertNotIn("data.level", box[box.index("illusionMon)"):])
        names = SYSTEM.read_text()
        self.assertIn("index == battleSystem->ctx->selectedMonIndex[battlerId]", function(names, "BattleMessage_GetMon"))
        for name in ("BattleMessage_BufferNickname", "BattleMessage_BufferPokemon"):
            self.assertIn("BattleMessage_GetMon(battleSystem, param)", function(names, name))

    def test_the_faint_the_substitute_and_the_level_up_box_show_it(self):
        # A faint without a hit, the sprite a substitute gives back and the
        # health box after a level-up read the disguise too.
        battle = ROOT / "src/battle"
        for path, name in (("battle_controller_faint.c", "BattleController_EmitPlayFaintAnimation"),
                           ("battle_controller_substitute.c", "BattleController_EmitSwapToSubstituteSprite")):
            body = function((battle / path).read_text(), name)
            self.assertIn("disguise = Battler_IllusionMon(battleSystem, i);", body, name)
            for field in ("Species", "Shiny", "Form", "Gender", "Personality"):
                self.assertIn(f"data.battler{field}[i] = ", body[body.index("Battler_IllusionMon(battleSystem, i)"):], name)
        faint = function((battle / "battle_controller_faint.c").read_text(), "BattleController_EmitPlayFaintAnimation")
        self.assertIn("disguise = Battler_IllusionMon(battleSystem, battlerId);", faint)
        self.assertIn("data.species = GetMonData(disguise, MON_DATA_SPECIES, NULL);", faint)
        box = function((battle / "battle_controller_healthbar_refresh.c").read_text(), "ov12_02263A1C")
        self.assertIn("data.selectedMonIndex = ctx->battleMons[battlerId].illusionMon - 1;", box)
        self.assertLess(box.index("illusionMon)"), box.index("ov12_02262240("))

    def test_it_drops_on_damage_and_when_the_ability_goes(self):
        overlay = OVERLAY.read_text()
        hit = function(overlay, "CheckAbilityEffectOnHit")
        drop = hit.index("Battler_DropIllusion(ctx, ctx->battlerIdTarget, script);")
        self.assertLess(hit.index("BATTLE_SUBSCRIPT_DISGUISE_ICE_FACE"), drop)
        self.assertLess(drop, hit.index("ABILITY_POISON_TOUCH"))
        self.assertIn("physicalDamage || ctx->selfTurnData[ctx->battlerIdTarget].specialDamage", hit[:drop])
        lost = function(overlay, "TryDropLostIllusion")
        self.assertIn("GetBattlerAbility(ctx, battlerId) != ABILITY_ILLUSION", lost)
        self.assertIn("TryDropLostIllusion(battleSystem, ctx, &script) == TRUE", function(CONTROLLER.read_text(), "ov12_02249460"))
        self.assertIn("ctx->battleMons[battlerId].illusionMon = 0;", function(overlay, "Battler_DropIllusion"))
        header = (ROOT / "include/constants/battle_subscript.h").read_text()
        number = int(re.search(r"#define BATTLE_SUBSCRIPT_ILLUSION_FADED\s+(\d+)", header).group(1))
        script = (SUBSCRIPTS / f"subscript_{number:04d}_IllusionFaded.s").read_text()
        self.assertLess(script.index("ChangeForm BATTLER_CATEGORY_MSG_TEMP"), script.index("msg_0197_01348"))
        self.assertLess(script.index("HealthbarSlideIn BATTLER_CATEGORY_MSG_TEMP"), script.index("msg_0197_01348"))

    def test_transform_and_imposter_refuse_it(self):
        transform = (SUBSCRIPTS / "subscript_0092_Transform.s").read_text()
        for side in ("DEFENDER", "ATTACKER"):
            self.assertIn(f"OPCODE_NEQ, BATTLER_CATEGORY_{side}, BMON_DATA_ILLUSION_MON, 0, _023", transform)
        self.assertIn("!ctx->battleMons[battlerIdCopied].illusionMon", function(OVERLAY.read_text(), "TryAbilityOnEntry"))


if __name__ == "__main__":
    unittest.main()
