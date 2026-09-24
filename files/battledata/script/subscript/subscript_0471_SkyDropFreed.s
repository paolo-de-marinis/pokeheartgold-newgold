    .include "macros/btlcmd.inc"

    .data

// A Pokemon Sky Drop held, let go before the drop because its user stopped
// holding it (TrySkyDropRelease); its sprite comes back after this.
_000:
    // {0} was freed from the Sky Drop!
    PrintMessage msg_0197_01942, TAG_NICKNAME, BATTLER_CATEGORY_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
