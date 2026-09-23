    .include "macros/btlcmd.inc"

    .data

// A contact move that went through a Protect. The damage has already been
// quartered by then -- that part is in the damage calculation, where the
// reference keeps it too -- and this is the sentence that says why the guard
// did not hold. The reference's subscript 511, line for line.

_000:
    AbilityPopup BATTLER_CATEGORY_ATTACKER, -1
    // {0} couldn’t fully protect itself and got hurt!
    PrintMessage msg_0197_01765, TAG_NICKNAME, BATTLER_CATEGORY_DEFENDER
    Wait
    WaitButtonABTime 30
    End
