#include "move.h"

#include "global.h"

#include "constants/moves.h"

#include "filesystem.h"

void LoadMoveTbl(MoveTbl *dest) {
    ReadFromNarcMemberByIdPair(dest, NARC_poketool_waza_waza_tbl, 0, 0, (NUM_MOVES + 1) * sizeof(MoveTbl));
}

// The moves past what retail had, which a battle keeps separately because the
// table it keeps the others in is a fixed length.
void LoadAddedMoveTbl(MoveTbl *dest) {
    ReadFromNarcMemberByIdPair(dest, NARC_poketool_waza_waza_tbl, 0, (NUM_MOVES + 1) * sizeof(MoveTbl), NUM_ADDED_MOVES * sizeof(MoveTbl));
}

u32 GetMoveAttr(u16 moveId, MoveAttr attrno) {
    MoveTbl movedata;
    LoadMoveEntry(moveId, &movedata);
    return GetMoveTblAttr(&movedata, attrno);
}

u8 GetMoveMaxPP(u16 moveId, u8 ppUps) {
    u8 pp;
    if (ppUps > 3) {
        ppUps = 3;
    }
    pp = GetMoveAttr(moveId, MOVEATTR_PP);
    return pp + ((pp * 20 * ppUps) / 100);
}

u32 GetMoveTblAttr(const MoveTbl *moveTbl, MoveAttr attr) {
    switch (attr) {
    case MOVEATTR_EFFECT:
        return moveTbl->effect;
    case MOVEATTR_CLASS:
        return moveTbl->category;
    case MOVEATTR_POWER:
        return moveTbl->power;
    case MOVEATTR_TYPE:
        return moveTbl->type;
    case MOVEATTR_ACCURACY:
        return moveTbl->accuracy;
    case MOVEATTR_PP:
        return moveTbl->pp;
    case MOVEATTR_EFFECT_CHANCE:
        return moveTbl->effectChance;
    case MOVEATTR_RANGE:
        return moveTbl->range;
    case MOVEATTR_PRIORTY:
        return moveTbl->priority;
    case MOVEATTR_UNK9:
        return moveTbl->unkB;
    case MOVEATTR_UNK10:
        return moveTbl->unkC;
    case MOVEATTR_CONTEST_TYPE:
        return moveTbl->contestType;
    default:
        return (u32)moveTbl;
    }
}

void LoadMoveEntry(u16 moveId, MoveTbl *moveTbl) {
    ReadWholeNarcMemberByIdPair(moveTbl, NARC_poketool_waza_waza_tbl, moveId);
}

// The moves hg-engine flags FLAG_UNUSABLE_UNIMPLEMENTED (d0380a487,
// data/Moves.c): moves it has no effect for. With its
// BLOCK_LEARNING_UNIMPLEMENTED_MOVES on, a trainer's Pokemon is not given one.
// Written by tools/newgold/import/import_moves.py --unimplemented; do not edit
// it by hand.
static const u16 sUnimplementedMoves[] = {
    MOVE_ECHOED_VOICE,
    MOVE_RAGE_FIST,
    MOVE_DRAGON_CHEER,
    MOVE_WONDER_ROOM,
    MOVE_TELEKINESIS,
    MOVE_MAGIC_ROOM,
    MOVE_SYNCHRONOISE,
    MOVE_ROUND,
    MOVE_ALLY_SWITCH,
    MOVE_SKY_DROP,
    MOVE_REFLECT_TYPE,
    MOVE_WATER_PLEDGE,
    MOVE_FIRE_PLEDGE,
    MOVE_GRASS_PLEDGE,
    MOVE_FUSION_FLARE,
    MOVE_FUSION_BOLT,
    MOVE_ROTOTILLER,
    MOVE_TOPSY_TURVY,
    MOVE_FLOWER_SHIELD,
    MOVE_ELECTRIFY,
    MOVE_FAIRY_LOCK,
    MOVE_CONFIDE,
    MOVE_AROMATIC_MIST,
    MOVE_MAGNETIC_FLUX,
    MOVE_FLORAL_HEALING,
    MOVE_GEAR_UP,
    MOVE_SPEED_SWAP,
    MOVE_PURIFY,
    MOVE_CORE_ENFORCER,
    MOVE_INSTRUCT,
    MOVE_BEAK_BLAST,
    MOVE_SHELL_TRAP,
    MOVE_SPECTRAL_THIEF,
    MOVE_SUNSTEEL_STRIKE,
    MOVE_MOONGEIST_BEAM,
    MOVE_MIND_BLOWN,
    MOVE_NO_RETREAT,
    MOVE_TAR_SHOT,
    MOVE_TEATIME,
    MOVE_OCTOLOCK,
    MOVE_COURT_CHANGE,
    MOVE_MAX_FLARE,
    MOVE_MAX_FLUTTERBY,
    MOVE_MAX_LIGHTNING,
    MOVE_MAX_STRIKE,
    MOVE_MAX_KNUCKLE,
    MOVE_MAX_PHANTASM,
    MOVE_MAX_HAILSTORM,
    MOVE_MAX_OOZE,
    MOVE_MAX_GEYSER,
    MOVE_MAX_AIRSTREAM,
    MOVE_MAX_STARFALL,
    MOVE_MAX_WYRMWIND,
    MOVE_MAX_MINDSTORM,
    MOVE_MAX_ROCKFALL,
    MOVE_MAX_QUAKE,
    MOVE_MAX_DARKNESS,
    MOVE_MAX_OVERGROWTH,
    MOVE_MAX_STEELSPIKE,
    MOVE_STEEL_BEAM,
    MOVE_SHELL_SIDE_ARM,
    MOVE_BURNING_JEALOUSY,
    MOVE_CORROSIVE_GAS,
    MOVE_JUNGLE_HEALING,
    MOVE_EERIE_SPELL,
    MOVE_TRIPLE_ARROWS,
    MOVE_LUNAR_BLESSING,
    MOVE_TERA_BLAST,
    MOVE_LAST_RESPECTS,
    MOVE_ORDER_UP,
    MOVE_REVIVAL_BLESSING,
    MOVE_SALT_CURE,
    MOVE_DOODLE,
    MOVE_CHILLY_RECEPTION,
    MOVE_SYRUP_BOMB,
    MOVE_TERA_STARSTORM,
    MOVE_HARD_PRESS,
    MOVE_ALLURING_VOICE,
    MOVE_UPPER_HAND,
};

BOOL MoveIsUnimplemented(u16 moveId) {
    for (int i = 0; i < (int)NELEMS(sUnimplementedMoves); i++) {
        if (sUnimplementedMoves[i] == moveId) {
            return TRUE;
        }
    }
    return FALSE;
}
