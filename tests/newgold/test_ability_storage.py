#!/usr/bin/env python3
"""Exercise native saved-ability cases, locks, encryption and compact serialization.

Only the selected data-switch cases are compiled; unrelated text/game-data cases
are omitted. EXP curves and personal data are controlled inputs. Reference edited
cases come from the pinned NewGold checkout, not a second implementation here.
"""
import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile
import unittest

from test_repels import ROOT, REFERENCE, REFERENCE_COMMIT, function, revision, without_includes


def selected_cases(source, name, fields, variable="attr"):
    code = function(source, name)
    switch = "    switch (" + variable + ") {"
    start = code.index(switch)
    body = start + len(switch)
    end, depth = body, 1
    while depth:
        depth += (code[end] == "{") - (code[end] == "}")
        end += 1
    chunks = re.split(r"(?=^    (?:case \w+:|default:))", code[body:end - 1], flags=re.M)
    selected = []
    for chunk in chunks:
        match = re.match(r"    case (\w+):", chunk)
        if match and match[1] in fields:
            selected.append(chunk)
    assert len(selected) == len(fields), (name, fields)
    return code[:body] + "\n" + "".join(selected) + "    default: assert(0);\n    " + code[end - 1:]


PREFIX = r'''
#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include "constants/abilities.h"
#include "constants/pokemon.h"
#include "constants/species.h"
#include "constants/seals.h"
#include "constants/items.h"
#include "constants/heap.h"
#include "constants/balls.h"
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef uint64_t u64 __attribute__((aligned(4))); // DS scalar alignment
typedef int8_t s8; typedef int16_t s16; typedef int32_t s32;
typedef int BOOL; typedef void String; typedef int NarcId;
#define TRUE 1
#define FALSE 0
#define UNUSED __attribute__((unused))
static unsigned assertions;
#define GF_ASSERT(x) ((void)((x) ? 0 : ++assertions))
#define MI_CpuClearFast(p,n) memset(p,0,n)
#define MI_CpuCopy8(s,d,n) memcpy(d,s,n)
@TYPES@
typedef PokemonDataBlock *PokemonDataBlockPointer;
typedef BoxPokemon *BoxPokemonPointer;
_Static_assert(sizeof(PokemonDataBlockA) == 32, "Block A layout");
_Static_assert(sizeof(BoxPokemon) == 136, "Box layout");
_Static_assert(sizeof(Pokemon) == 236, "Party layout");
_Static_assert(sizeof(struct UnkPokemonStruct_02072A98) == 112, "Compact layout");
static void Mail_Copy(const Mail *s, Mail *d) { memcpy(d,s,sizeof(*d)); }
static void CopyCapsule(const CAPSULE *s, CAPSULE *d) { memcpy(d,s,sizeof(*d)); }
static void CopyU16StringArrayN(u16 *d, const u16 *s, u32 n) { memcpy(d,s,n*2); }
static u32 GetMonExpBySpeciesAndLevel(u16 species, int level) { (void)species; assert(level==100); return 1250000; }
#define PokeLevelExpGet GetMonExpBySpeciesAndLevel
static u32 CalcLevelBySpeciesAndExp(u16 species,u32 exp) { (void)species; assert(exp<=0x1FFFFF); return exp/12500; }
static int ability1=256, ability2=319;
static u32 GetMonBaseStat_HandleAlternateForm(int species,int form,int field) {
    (void)species; (void)form;
    return field==BASE_ABILITY_1 ? ability1 : field==BASE_ABILITY_2 ? ability2 : 0;
}
static u32 GetItemAttr(u16 item,int attr,enum HeapID heap) { (void)item;(void)attr;(void)heap;return 17; }
static u8 GetArceusTypeByHeldItemEffect(u16 effect) { assert(effect==17);return 10; }
static u8 GetSilvallyTypeByHeldItemEffect(u16 effect) { assert(effect==17);return 10; }
@MACROS@
@PROTOTYPES@
@NATIVE@
struct BoxMonSubstructs {
    PokemonDataBlockA *blockA; PokemonDataBlockB *blockB;
    PokemonDataBlockC *blockC; PokemonDataBlockD *blockD;
};
@REFERENCE@
'''

MAIN = r'''
static void check(unsigned permutation, u16 ability, int locked) {
    Pokemon mon, restored;
    memset(&mon,0,sizeof(mon));
    mon.box.personality=(permutation<<13)|(ability&1);
    PokemonDataBlockA *a=&GetSubstruct(&mon.box,mon.box.personality,0)->blockA;
    a->species=SPECIES_ARCEUS;
    a->expAndAbility=(permutation*0x10203040u)^0x7FE12345u;
    a->friendship=219; a->ability=17; a->markings=5; a->originLanguage=2;
    PokemonDataBlockA expected=*a;
    u32 reserved=a->expAndAbility&0x7FE00000u;
    PokemonDataBlockB b={0}; PokemonDataBlockC c={0}; PokemonDataBlockD d={0};
    struct BoxMonSubstructs blocks={&expected,&b,&c,&d};
    mon.box.checksum=CHECKSUM(&mon.box);
    ENCRYPT_BOX(&mon.box); ENCRYPT_PTY(&mon);
    BOOL lock=locked ? AcquireMonLock(&mon) : FALSE;
    SetMonData(&mon,MON_DATA_ABILITY,&ability);
    assert(SetBoxMonData_EditedCases(&blocks,MON_DATA_ABILITY,&ability));
    assert(GetMonData(&mon,MON_DATA_ABILITY,NULL)==ability);
    // Ability setting must not change any of the original EXP/reserved bits.
    assert(GetBoxMonData(&mon.box,MON_DATA_EXPERIENCE,NULL)==expected.exp);
    u32 exp=(ability*7919u)^0xFEDCBA98u;
    SetBoxMonData(&mon.box,MON_DATA_EXPERIENCE,&exp);
    assert(SetBoxMonData_EditedCases(&blocks,MON_DATA_EXPERIENCE,&exp));
    assert(GetBoxMonData(&mon.box,MON_DATA_EXPERIENCE,NULL)==(exp&0x1FFFFF));
    assert(GetBoxMonData(&mon.box,MON_DATA_ABILITY,NULL)==ability);
    assert(GetBoxMonData(&mon.box,MON_DATA_LEVEL,NULL)==expected.exp/12500);
    assert(GetBoxMonData(&mon.box,MON_DATA_TYPE_1,NULL)==(ability==ABILITY_MULTITYPE ? 10u : 0u));
    const int deltas[]={0,1,-1,1250000,INT_MAX,INT_MIN,-2000000};
    for(unsigned i=0;i<sizeof(deltas)/sizeof(*deltas);i++) {
        AddMonData(&mon,MON_DATA_EXPERIENCE,deltas[i]);
        assert(AddBoxMonData_EditedCases(&blocks,MON_DATA_EXPERIENCE,deltas[i]));
        assert(GetBoxMonData(&mon.box,MON_DATA_EXPERIENCE,NULL)==expected.exp);
        assert(GetBoxMonData(&mon.box,MON_DATA_ABILITY,NULL)==ability);
    }
    int assigned=(ability+257)&511;
    AddMonData(&mon,MON_DATA_ABILITY,assigned);
    assert(AddBoxMonData_EditedCases(&blocks,MON_DATA_ABILITY,assigned));
    BOOL handled=FALSE;
    assert(GetBoxMonData(&mon.box,MON_DATA_ABILITY,NULL)==GetBoxMonData_EditedCases(&blocks,MON_DATA_ABILITY,NULL,&handled));
    assert(handled);
    if(locked) assert(ReleaseMonLock(&mon,lock));
    BOOL boxLock=AcquireBoxMonLock(&mon.box);
    assert(!memcmp(a,&expected,sizeof(expected)));
    assert((a->expAndAbility&0x7FE00000u)==reserved);
    assert((a->expAndAbility>>31)==((unsigned)assigned>>8));
    assert(a->ability==(assigned&255));
    assert(ReleaseBoxMonLock(&mon.box,boxLock));
    struct UnkPokemonStruct_02072A98 compact;
    memset(&compact,0,sizeof(compact));
    sub_02072A98(&mon,&compact);
    assert(compact.exp==expected.expAndAbility);
    sub_02072D64(&compact,&restored);
    assert(GetBoxMonData(&restored.box,MON_DATA_ABILITY,NULL)==(unsigned)assigned);
    assert(GetBoxMonData(&restored.box,MON_DATA_EXPERIENCE,NULL)==expected.exp);
    assert(!restored.box.checksumFailed);
    assert(AcquireBoxMonLock(&restored.box));
    PokemonDataBlockA *restoredA=&GetSubstruct(&restored.box,restored.box.personality,0)->blockA;
    assert(restoredA->expAndAbility==expected.expAndAbility);
    assert(restored.box.checksum==CHECKSUM(&restored.box));
    assert(ReleaseBoxMonLock(&restored.box,TRUE));
    // Existing form-based reassignment can pass a widened result without damaging EXP.
    UpdateBoxMonAbility(&mon.box);
    assert(GetBoxMonData(&mon.box,MON_DATA_ABILITY,NULL)==(unsigned)((mon.box.personality&1)?ability2:ability1));
    assert(GetBoxMonData(&mon.box,MON_DATA_EXPERIENCE,NULL)==expected.exp);
    assert(!assertions);
}
int main(void) {
    for(unsigned permutation=0;permutation<32;permutation++)
    for(unsigned ability=0;ability<512;ability++)
    for(int locked=0;locked<2;locked++) check(permutation,ability,locked);
    Pokemon corrupt;
    ZeroMonData(&corrupt);
    ((u8*)corrupt.box.dataBlocks)[0]^=1;
    u8 before[sizeof(corrupt.box.dataBlocks)];memcpy(before,corrupt.box.dataBlocks,sizeof(before));
    u16 ability=319;
    SetBoxMonData(&corrupt.box,MON_DATA_ABILITY,&ability);
    assert(assertions==1 && corrupt.box.checksumFailed);
    assert(!memcmp(before,corrupt.box.dataBlocks,sizeof(before)));
    puts("PASS: 32768 encrypted/locked cases, all 512 encoded abilities, 32 shuffles, EXP boundaries, compact roundtrips and checksum rejection.");
}
'''


class AbilityStorageTests(unittest.TestCase):
    @unittest.skipUnless(REFERENCE, "Pinned NewGold reference is required")
    def test_native_storage_and_reference_cases(self):
        pokemon = (ROOT / "src/pokemon.c").read_text()
        math = (ROOT / "src/math_util.c").read_text()
        # Typedef aliases let the existing extractor handle pointer return types.
        pokemon = pokemon.replace("PokemonDataBlock *GetSubstruct(", "PokemonDataBlockPointer GetSubstruct(").replace("BoxPokemon *Mon_GetBoxMon(", "BoxPokemonPointer Mon_GetBoxMon(")
        wanted = {"MON_DATA_PERSONALITY", "MON_DATA_SPECIES", "MON_DATA_FORM", "MON_DATA_EXPERIENCE", "MON_DATA_ABILITY", "MON_DATA_LEVEL", "MON_DATA_TYPE_1", "MON_DATA_TYPE_2", "MON_DATA_UNUSED_113", "MON_DATA_UNUSED_114"}
        native = [selected_cases(pokemon, "GetBoxMonDataInternal", wanted),
                  selected_cases(pokemon, "SetBoxMonDataInternal", {"MON_DATA_EXPERIENCE", "MON_DATA_ABILITY"}),
                  selected_cases(pokemon, "AddBoxMonDataInternal", {"MON_DATA_EXPERIENCE", "MON_DATA_ABILITY"})]
        native += [function(math, name) for name in ("MonEncryptionLCRNG", "_MonEncryptSegment", "_MonDecryptSegment")]
        native += [function(pokemon, name) for name in ("MonEncryptSegment", "MonDecryptSegment", "CalcMonChecksum", "GetSubstruct", "Mon_GetBoxMon", "ZeroMonData", "AcquireMonLock", "ReleaseMonLock", "AcquireBoxMonLock", "ReleaseBoxMonLock", "GetBoxMonData", "GetMonData", "GetMonDataInternal", "SetBoxMonData", "SetMonData", "SetMonDataInternal", "AddMonData", "AddMonDataInternal", "UpdateBoxMonAbility", "sub_02072A98", "sub_02072D64")]
        reference = revision(REFERENCE, REFERENCE_COMMIT, "src/pokemon.c").replace(")\n{", ") {")
        reference = "\n".join(function(reference, name) for name in ("SetBoxMonData_EditedCases", "GetBoxMonData_EditedCases", "AddBoxMonData_EditedCases"))
        seals = (ROOT / "include/seal_case.h").read_text()
        types = seals[seals.index("typedef struct SEAL {"):seals.index("} CAPSULE;")+len("} CAPSULE;")]
        types = without_includes((ROOT / "include/constants/global.h").read_text()) + "\n" + types
        types += "\n" + without_includes((ROOT / "include/pokemon_types_def.h").read_text())
        macros = pokemon[pokemon.index("#define ENCRY_ARGS_PTY"):pokemon.index("#define SHINY_CHECK")]
        prototypes = "\n".join(code[:code.index(" {")]+";" for code in native)
        source = PREFIX.replace("@TYPES@", types).replace("@MACROS@", macros).replace("@PROTOTYPES@", prototypes).replace("@NATIVE@", "\n".join(native)).replace("@REFERENCE@", reference) + MAIN
        with tempfile.TemporaryDirectory(prefix="newgold-ability-storage-") as temp:
            c, exe = Path(temp)/"check.c", Path(temp)/"check"
            c.write_text(source)
            compiler = shlex.split(os.environ.get("CC", "cc"))
            compiled = subprocess.run(compiler+["-std=c11", "-O1", "-g", "-fno-strict-aliasing", "-fsanitize=address,undefined", "-fno-omit-frame-pointer", "-iquote", str(ROOT/"include"), str(c), "-o", str(exe)], capture_output=True, text=True)
            self.assertEqual(compiled.returncode, 0, compiled.stderr)
            result = subprocess.run([str(exe)], capture_output=True, text=True, env={**os.environ, "ASAN_OPTIONS": "detect_leaks=0", "UBSAN_OPTIONS": "halt_on_error=1"})
            self.assertEqual(result.returncode, 0, result.stderr)
            print(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
