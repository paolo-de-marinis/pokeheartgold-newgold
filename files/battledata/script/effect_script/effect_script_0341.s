    .include "macros/btlcmd.inc"

    .data

// The reference's own SP_ATK_DOWN_3 script is a bare hit while its six
// siblings set the pointer -- an oversight, since the reference defines and
// maps the pointer this needs. The line its siblings have is the line it
// owes.
_000:
    UpdateVar OPCODE_SET, BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT, MOVE_SIDE_EFFECT_TO_DEFENDER|MOVE_SUBSCRIPT_PTR_SP_ATTACK_DOWN_3_STAGES
    End 
