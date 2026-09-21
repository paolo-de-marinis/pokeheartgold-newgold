#include "error_handling.h"

#include "global.h"

#include "error_message_reset.h"
#include "unk_02037C94.h"

u32 gAssertCount;
u32 gAssertLine;
const char *gAssertFile;
u32 gAllocFailCount;
u32 gAllocFailSize;
u32 gAllocFailHeap;
u32 gBattleState;
u32 gBattleTicks;
u32 gBattleStateSeen;

void GF_AssertFail(void) {
    if (!sub_02037D78()) {
        return;
    }

    if (OS_GetProcMode() != OS_PROCMODE_IRQ) {
        PrintErrorMessageAndReset();
    }
}
