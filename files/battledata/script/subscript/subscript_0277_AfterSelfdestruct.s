    .include "macros/btlcmd.inc"

    .data

// The user of Self-Destruct, Explosion, Misty Explosion or Memento fainting
// once the move is over (ov12_0224D1DC names it the fainted battler). Its HP
// went to 0 as the move began; its bar is emptied now, after the damage, as
// the reference's AFTER_SELFDESTRUCT does (subscript 277 at d0380a487, run
// from its post-move step 11.0). Memento's script has emptied it already.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_HP_CALC, S16_MAX
    UpdateHealthBar BATTLER_CATEGORY_FAINTED_MON
    Wait 
    Call BATTLE_SUBSCRIPT_FAINT_MON
    End 
