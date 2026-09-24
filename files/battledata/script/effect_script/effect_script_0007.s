    .include "macros/btlcmd.inc"

    .data

// Self-Destruct, Explosion and Misty Explosion, the engine's script. Damp and
// the user's HP going to 0 come before the move, as the engine has them
// (DampStopsMove and TrySelfDestruct in ov12_0224C38C). The user's bar stays
// full until the move has done its damage: subscript 277 empties it and
// faints the user once the move is over, as the reference's post-move step
// 11.0 does. From the sixth generation the damage comes before the user
// faints (Pokemon Central, Esplosione); retail emptied the bar first.
_000:
    CalcCrit 
    CalcDamage 
    End 
