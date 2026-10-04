#include "global.h"

#include "ev_iv_trainer.h"
#include "field_system.h"
#include "heap.h"
#include "scrcmd.h"
#include "script.h"
#include "script_manager.h"

FS_EXTERN_OVERLAY(ev_iv_trainer);

// EvIvTrainer VAR: the EV/IV trainer, from its party menu to the last Pokemon
// trained; VAR is how many were. The script leaves the overworld first and
// restores it after, as it does for the party menu.
BOOL ScrCmd_EvIvTrainer(ScriptContext *ctx) {
    static const OverlayManagerTemplate sTemplate = {
        EvIvTrainer_Init,
        EvIvTrainer_Main,
        EvIvTrainer_Exit,
        FS_OVERLAY_ID(ev_iv_trainer),
    };
    EvIvTrainerArgs **args = FieldSysGetAttrAddr(ctx->fieldSystem, SCRIPTENV_RUNNING_APP_DATA);
    u16 *trained = ScriptGetVarPointer(ctx);

    *args = Heap_Alloc(HEAP_ID_FIELD2, sizeof(EvIvTrainerArgs));
    (*args)->fieldSystem = ctx->fieldSystem;
    (*args)->trained = trained;
    FieldSystem_LaunchApplication(ctx->fieldSystem, &sTemplate, *args);
    SetupNativeScript(ctx, ScrNative_WaitApplication_DestroyTaskData);
    return TRUE;
}
