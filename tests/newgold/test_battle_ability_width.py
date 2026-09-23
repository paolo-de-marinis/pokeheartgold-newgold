#!/usr/bin/env python3
"""Run native battle ability storage, AI cache and packet code with host sanitizers.

Actual battle structs/functions are extracted. Game-data, RNG, script operands,
party access and transport are controlled inputs. DS offsets are checked by the
ROM build; host pointer layout is not asserted to match the DS.
"""
import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, function, without_includes
from test_ability_storage import selected_cases

PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "constants/abilities.h"
#include "constants/battle.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/species.h"
#include "constants/items.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32;
typedef int8_t s8; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL; typedef int NarcId; typedef void ItemData;
#define TRUE 1
#define FALSE 0
#define GF_ASSERT assert
#define NELEMS(x) ((int)(sizeof(x) / sizeof((x)[0])))
#define MI_CpuClear32(p,n) memset(p,0,n)
@TYPES@
_Static_assert(sizeof(BattleMon)==0xC0, "BattleMon stride");
_Static_assert(offsetof(BattleMon,ability)==0x7A, "Battle ability placement");
_Static_assert(sizeof(((MoveDamageCalc*)0)->ability)==2, "Damage calculation must keep full IDs");
typedef struct { u32 fields[200]; } Pokemon;
typedef struct { u32 type, random; int count; Pokemon party[6]; } BattleSystem;
static u32 ov10_02220AAC[1];
#ifndef ITEM_VAR_HOLD_EFFECT
#define ITEM_VAR_HOLD_EFFECT 1
#endif
// No Ability Shield in these fixtures.
static s32 GetItemVar(BattleContext *ctx,u16 itemNo,u16 var) { (void)ctx;(void)itemNo;(void)var;return 0; }
static int scriptValues[2], scriptPos, queriedBattler;
static int personalAbility1=319, personalAbility2=267;
static u8 packet[44]; static unsigned packetSize; static int packetBattler;
static void ov10_0221EF24(BattleContext *ctx,int n) { (void)ctx;assert(n==1);scriptPos=0; }
static int ov10_0221EEF0(BattleContext *ctx) { (void)ctx;assert(scriptPos<2);return scriptValues[scriptPos++]; }
static int ov10_0221EF34(BattleContext *ctx,int which) { (void)ctx;(void)which;return queriedBattler; }
static int GetMonBaseStat(int species,int field) { (void)species;assert(field==BASE_ABILITY_1||field==BASE_ABILITY_2);return field==BASE_ABILITY_1?personalAbility1:personalAbility2; }
static u32 BattleSystem_Random(BattleSystem *s) { return s->random; }
static u32 BattleSystem_GetBattleType(BattleSystem *s) { return s->type; }
static int BattleSystem_GetBattlerIDBySide(BattleSystem *s,BattleContext *c,int side) { (void)s;(void)c;return side; }
static u8 BattleSystem_GetFieldSide(BattleSystem *s,int battler) { (void)s;return battler&1; }
static int BattleSystem_GetBattlerIdPartner(BattleSystem *s,int battler) { (void)s;return battler^2; }
static int BattleSystem_GetPartySize(BattleSystem *s,int battler) { (void)battler;return s->count; }
static Pokemon *BattleSystem_GetPartyMon(BattleSystem *s,int battler,int i) { (void)battler;assert(i<s->count);return &s->party[i]; }
static u16 BattleSystem_GetTrainerItem(BattleSystem *s,int battler,int i) { (void)s;(void)battler;(void)i;return 0; }
static u32 GetMonData(Pokemon *mon,int attr,void *out) { (void)out;assert(attr<200);return mon->fields[attr]; }
static void SetMonData(Pokemon *mon,int attr,const void *value) { assert(attr==MON_DATA_HELD_ITEM);mon->fields[attr]=*(const u16*)value; }
static void BattleScriptIncrementPointer(BattleContext *ctx,int n) { (void)ctx;assert(n==1); }
static BOOL ov10_0221FD34(BattleSystem *s,BattleContext *c,int b,BOOL flag) { (void)s;(void)c;(void)b;(void)flag;return FALSE; }
static void ov12_02262240(BattleSystem *s,int buffer,int battler,void *data,u8 size) { (void)s;assert(buffer==1&&size<=sizeof(packet));memcpy(packet,data,size);packetSize=size;packetBattler=battler; }
// Controlled reward tables exercise eligibility; reward rebalancing is separate.
static const u16 sPickupTable1[18]={ITEM_POTION};
static const u16 sPickupTable2[11]={ITEM_POTION};
static const u8 sPickupWeightTable[9]={100};
static const u8 sHoneyGatherChanceTable[10]={100};
@PROTOTYPES@
@NATIVE@
'''

MAIN = r'''
int main(void) {
    BattleContext ctx;
    BattleSystem system={0};
    memset(&ctx,0xA5,sizeof(ctx));
    ov12_0224E384(&system,&ctx);
    for(int b=0;b<BATTLER_MAX;b++) assert(ctx.trainerAIAbilities[b]==ABILITY_NONE);
    for(u16 ability=0;ability<512;ability++) for(int battler=0;battler<BATTLER_MAX;battler++) {
        memset(&ctx,0,sizeof(ctx));
        ctx.battleMons[battler].unusedAbility=0x5A;
        BattleMon expected=ctx.battleMons[battler];expected.ability=ability;
        SetBattlerVar(&ctx,battler,BMON_DATA_ABILITY,&ability);
        assert(!memcmp(&ctx.battleMons[battler],&expected,sizeof(expected)));
        assert(GetBattlerVar(&ctx,battler,BMON_DATA_ABILITY,NULL)==ability);
        assert(GetBattlerAbility(&ctx,battler)==ability);
        ctx.battleMons[battler].moveEffectFlags=MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED;
        assert(GetBattlerAbility(&ctx,battler)==(ability==ABILITY_MULTITYPE?ability:ABILITY_NONE));
        ctx.battleMons[battler].moveEffectFlags=MOVE_EFFECT_FLAG_INGRAIN;
        assert(GetBattlerAbility(&ctx,battler)==(ability==ABILITY_LEVITATE?ABILITY_NONE:ability));
        ctx.battleMons[battler].moveEffectFlags=0;
        ctx.fieldCondition=FIELD_CONDITION_GRAVITY;
        assert(GetBattlerAbility(&ctx,battler)==(ability==ABILITY_LEVITATE?ABILITY_NONE:ability));
        ctx.fieldCondition=0;

        // Message revelation -> cache -> both actual AI handlers -> switch reset.
        for(int b=0;b<BATTLER_MAX;b++) ctx.trainerAIAbilities[b]=0x1FF;
        assert(ov12_0224819C(&system,&ctx,battler)==ability);
        for(int b=0;b<BATTLER_MAX;b++) assert(ctx.trainerAIAbilities[b]==(b==battler?ability:0x1FF));
        assert(ctx.trainerAIData.unusedAbilities[battler]==0);
        queriedBattler=battler;scriptValues[0]=AI_BATTLER_TARGET;scriptValues[1]=ability;
        ctx.trainerAIData.battlerIdAttacker=(battler+1)%BATTLER_MAX;
        if(ability) {
            ov10_0221D0A8(&system,&ctx);assert(ctx.trainerAIData.unk8==ability);
            ov10_0221D188(&system,&ctx);assert(ctx.trainerAIData.unk8==1);
            scriptValues[1]=ability^1;
            ov10_0221D188(&system,&ctx);assert(ctx.trainerAIData.unk8==0);
        }
        ov12_0225859C(&ctx,battler);
        assert(ctx.trainerAIAbilities[battler]==0);
        for(int b=0;b<BATTLER_MAX;b++) if(b!=battler)assert(ctx.trainerAIAbilities[b]==0x1FF);
        ctx.battleMons[battler].moveEffectFlags=MOVE_EFFECT_FLAG_ABILITY_SUPPRESSED;
        ov10_0221D0A8(&system,&ctx);assert(ctx.trainerAIData.unk8==ABILITY_NONE);
        ov10_0221D188(&system,&ctx);assert(ctx.trainerAIData.unk8==2);
        ctx.battleMons[battler].moveEffectFlags=0;
        scriptValues[0]=AI_BATTLER_ATTACKER;scriptValues[1]=ability;
        ctx.trainerAIData.battlerIdAttacker=battler;
        ov10_0221D0A8(&system,&ctx);assert(ctx.trainerAIData.unk8==ability);
        ov10_0221D188(&system,&ctx);assert(ctx.trainerAIData.unk8==(ability?1:2));

        // The existing 44-byte receiver packet carries all ability bits.
        ctx.battleMons[battler].hp=51;
        ctx.battleMons[battler].status=STATUS_POISON|STATUS_POISON_COUNT;
        ctx.battleStatus2=BATTLE_STATUS2_RECALC_MON_STATS|BATTLE_STATUS2_MOVE_SUCCEEDED;
        BattleController_EmitBattleMonToPartyMonCopy(&system,&ctx,battler);
        BattleMonToPartyCommand command;memcpy(&command,packet,sizeof(command));
        assert(packetSize==44 && packetBattler==battler && command.ability==ability);
        assert(command.status==STATUS_POISON && command.recalcStats && command.updateForm);
        assert(ctx.battleStatus2==BATTLE_STATUS2_MOVE_SUCCEEDED);
        BattleControl_EmitPartyStatusHeal(&system,&ctx,battler,MOVE_HEAL_BELL);
        assert(packetSize==4);
        if(ability<320) assert((packet[1]==ABILITY_MOLD_BREAKER)==(ability==ABILITY_MOLD_BREAKER));
    }
    // Unknown target abilities still use the ordinary guess path, without narrowing.
    memset(&ctx,0,sizeof(ctx));queriedBattler=1;scriptValues[0]=AI_BATTLER_TARGET;
    for(int parity=0;parity<2;parity++) {
        system.random=parity;ov10_0221D0A8(&system,&ctx);
        assert(ctx.trainerAIData.unk8==(parity?personalAbility1:personalAbility2));
    }
    scriptValues[1]=319;ov10_0221D188(&system,&ctx);assert(ctx.trainerAIData.unk8==2);

    // IDs266/267/274 must not masquerade as the old absorbing abilities10/11/18.
    const int types[]={TYPE_ELECTRIC,TYPE_WATER,TYPE_FIRE};
    const int absorbing[]={ABILITY_VOLT_ABSORB,ABILITY_WATER_ABSORB,ABILITY_FLASH_FIRE};
    memset(&ctx,0,sizeof(ctx));memset(&system,0,sizeof(system));system.count=3;system.random=1;
    ctx.moveNoHit[0]=1;ctx.trainerAIData.moveData[1].power=40;
    ctx.selectedMonIndex[0]=0;ctx.selectedMonIndex[2]=1;
    for(int b=0;b<BATTLER_MAX;b++)ctx.unk_21A4[b]=0xFF;
    system.party[2].fields[MON_DATA_HP]=100;system.party[2].fields[MON_DATA_SPECIES_OR_EGG]=SPECIES_PIKACHU;
    for(int type=0;type<3;type++) for(unsigned high=0;high<2;high++) {
        ctx.unk_21A4[0]=0xFF;ctx.trainerAIData.moveData[1].type=types[type];
        system.party[2].fields[MON_DATA_ABILITY]=absorbing[type]+high*256;
        assert(ov10_0221FE8C(&system,&ctx,0)==!high);
        assert(ctx.unk_21A4[0]==(high?0xFF:2));
    }
    // End-of-battle rewards use the complete party ability, too.
    memset(&system,0,sizeof(system));system.count=1;
    system.party[0].fields[MON_DATA_SPECIES_OR_EGG]=SPECIES_PIKACHU;
    system.party[0].fields[MON_DATA_LEVEL]=1;
    for(unsigned ability=0;ability<512;ability++) {
        system.party[0].fields[MON_DATA_ABILITY]=ability;
        system.party[0].fields[MON_DATA_HELD_ITEM]=ITEM_NONE;
        assert(!BtlCmd_GenerateEndOfBattleItem(&system,&ctx));
        unsigned expected=ability==ABILITY_PICKUP?ITEM_POTION:ability==ABILITY_HONEY_GATHER?ITEM_HONEY:ITEM_NONE;
        assert(system.party[0].fields[MON_DATA_HELD_ITEM]==expected);
    }
    // Neutralizing Gas turns off every ability but its own and the six that
    // are a Pokemon's form or nature, and not when it was only transformed into.
    memset(&ctx,0,sizeof(ctx));
    ctx.battleMons[1].ability=ABILITY_NEUTRALIZING_GAS;ctx.battleMons[1].hp=1;
    ctx.battleMons[0].ability=ABILITY_INTIMIDATE;
    assert(GetBattlerAbility(&ctx,0)==ABILITY_NONE && GetBattlerAbility(&ctx,1)==ABILITY_NEUTRALIZING_GAS);
    // The games' list (Pokemon Central, Gas Reagente); Commander is not on it.
    const u16 unsuppressible[]={ABILITY_MULTITYPE,ABILITY_COMATOSE,ABILITY_RKS_SYSTEM,ABILITY_GULP_MISSILE,
                                ABILITY_AS_ONE_GLASTRIER,ABILITY_AS_ONE_SPECTRIER,ABILITY_SHIELDS_DOWN,
                                ABILITY_BATTLE_BOND,ABILITY_TERA_SHIFT};
    for(unsigned i=0;i<sizeof(unsuppressible)/sizeof(*unsuppressible);i++) {
        ctx.battleMons[0].ability=unsuppressible[i];assert(GetBattlerAbility(&ctx,0)==unsuppressible[i]);
    }
    ctx.battleMons[0].ability=ABILITY_COMMANDER;assert(GetBattlerAbility(&ctx,0)==ABILITY_NONE);
    ctx.battleMons[0].ability=ABILITY_INTIMIDATE;ctx.battleMons[1].status2=STATUS2_TRANSFORM;
    assert(GetBattlerAbility(&ctx,0)==ABILITY_INTIMIDATE);
    puts("PASS: 2048 full-ID battle/cache/packet cases, suppression/guess/reset, absorbing aliases, 512 reward cases and the gas.");
}
'''


class BattleAbilityWidthTests(unittest.TestCase):
    def test_native_battle_ability_path(self):
        header = (ROOT / "include/battle/battle.h").read_text()
        types = header[header.index("typedef struct BattleMessage {"):header.index("} BattleContext;")+len("} BattleContext;")]
        move = (ROOT / "include/move.h").read_text()
        types = move[move.index("typedef struct MoveTbl {"):move.index("} MoveTbl;")+len("} MoveTbl;")] + types
        types = without_includes((ROOT / "include/constants/global.h").read_text()) + "\n" + types
        pokemon = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        types += pokemon[pokemon.index("typedef struct MoveDamageCalc {"):pokemon.index("} MoveDamageCalc;")+len("} MoveDamageCalc;")]
        command = (ROOT / "src/battle/battle_command.c").read_text()
        ai = (ROOT / "src/battle/trainer_ai_ability.c").read_text()
        ai_header = (ROOT / "include/battle/trainer_ai.h").read_text()
        types += ai_header[ai_header.index("enum {"):ai_header.index("};")+2]
        native = [selected_cases(pokemon, name, {"BMON_DATA_ABILITY"}, "id") for name in ("GetBattlerVar", "SetBattlerVar")]
        native += [function(pokemon, name) for name in ("AbilityIsUnsuppressable", "BattlerGivesOffGas", "AbilitiesAreNeutralized", "BattleMoveTbl", "GetBattlerAbility", "ov12_0225859C")]
        native += [function(command, name) for name in ("BattlerSetAbility", "ov12_0224819C", "BtlCmd_GenerateEndOfBattleItem")]
        native += [function(ai, name) for name in ("ov10_0221D0A8", "ov10_0221D188")]
        native += [function((ROOT / "src/battle/battle_controller_player.c").read_text(), "ov12_0224E384")]
        native += [function((ROOT / "src/battle/trainer_ai_switch_absorb.c").read_text(), "ov10_0221FE8C")]
        for file, name in (("battle_controller_mon_copy.c", "BattleController_EmitBattleMonToPartyMonCopy"), ("battle_controller_party_heal.c", "BattleControl_EmitPartyStatusHeal")):
            content = (ROOT / "src/battle" / file).read_text()
            types += content[content.index("typedef struct "):content.index("void " + name)]
            native.append(function(content, name))
        prototypes = "\n".join(code[:code.index(" {")]+";" for code in native)
        source = PREFIX.replace("@TYPES@", types).replace("@PROTOTYPES@", prototypes).replace("@NATIVE@", "\n".join(native)) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-battle-abilities-") as temp:
            c, exe = Path(temp)/"check.c", Path(temp)/"check"
            c.write_text(source)
            result = subprocess.run(shlex.split(os.environ.get("CC", "cc"))+["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT/"include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
