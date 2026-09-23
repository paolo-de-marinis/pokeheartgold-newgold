    .include "macros/btlcmd.inc"

    .data

_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_FLINCH
    // The doubling against Minimize is the final modifier's now, for every
    // stamping move (BattleMoveStampsOnMinimize), not this effect's power.
    CalcCrit 
    CalcDamage 
    End 
