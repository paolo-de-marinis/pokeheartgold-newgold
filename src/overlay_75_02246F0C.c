#include "global.h"

#include "msgdata/msg.naix"

#include "bg_window.h"
#include "gf_gfx_planes.h"
#include "heap.h"
#include "message_format.h"
#include "msgdata.h"
#include "overlay_75.h"
#include "render_text.h"
#include "screen_fade.h"
#include "system.h"
#include "unk_020210A0.h"
#include "unk_02037C94.h"
#include "unk_0203A3B0.h"
#include "vram_transfer_manager.h"

extern void ov75_0224725C(BgConfig *bgConfig);
extern void ov75_02247450(Overlay75App *app);
extern void ov75_02247790(Overlay75App *app);
extern int ov75_02246BE8(Overlay75Parent *parent);
extern void ov75_02246BE0(Overlay75Parent *parent, int state);
extern void ov75_02247234(void *data);
extern BOOL ov00_021EC5B4(void);
extern void sub_02039528(SaveData *saveData);

// Overlay 75's second application starts: its heap and state, the screens,
// the text it prints -- its own lines, the species names and three more
// banks -- and the step it starts at.
BOOL ov75_02246F0C(OverlayManager *man, int *state) {
    Overlay75App *app;

    Main_SetVBlankIntrCB(NULL, NULL);
    HBlankInterruptDisable();
    GfGfx_DisableEngineAPlanes();
    GfGfx_DisableEngineBPlanes();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    GX_SetVisibleWnd(GX_WNDMASK_NONE);
    GXS_SetVisibleWnd(0);
    G2_BlendNone();
    G2S_BlendNone();
    Heap_Create(HEAP_ID_3, HEAP_ID_116, 0x70000);
    app = OverlayManager_CreateAndGetData(man, sizeof(Overlay75App), HEAP_ID_116);
    MI_CpuFill8(app, 0, sizeof(Overlay75App));
    app->parent = OverlayManager_GetArgs(man);
    app->bgConfig = BgConfig_Alloc(HEAP_ID_116);
    GF_CreateVramTransferManager(64, HEAP_ID_116);
    SetKeyRepeatTimers(4, 8);
    ov75_0224725C(app->bgConfig);
    sub_020210BC();
    sub_02021148(4);
    app->msgFormat = MessageFormat_New_Custom(11, 64, HEAP_ID_116);
    app->msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0775_bin, HEAP_ID_116);
    app->unk2C = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0778_bin, HEAP_ID_116);
    app->unk30 = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0800_bin, HEAP_ID_116);
    app->speciesNames = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0237_bin, HEAP_ID_116);
    app->unk34 = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0188_bin, HEAP_ID_116);
    app->unk38 = String_New(270, HEAP_ID_116);
    app->unk40 = String_New(256, HEAP_ID_116);
    app->unk3C = NewString_ReadMsgData(app->msgData, 31);
    ov75_02247450(app);
    ov75_02247790(app);
    switch (ov75_02246BE8(app->parent)) {
    case 12:
        if (ov00_021EC5B4() == FALSE && sub_0203A05C(app->parent->saveData) == TRUE) {
            app->state = 12;
            sub_02039528(app->parent->saveData);
            sub_0203A880();
        } else {
            app->state = 0;
        }
        break;
    case 22:
        app->unkE8 = 0;
        sub_0203A880();
        app->state = ov75_02246BE8(app->parent);
        break;
    default:
        app->state = ov75_02246BE8(app->parent);
        break;
    }
    ov75_02246BE0(app->parent, 0);
    BeginNormalPaletteFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, RGB_BLACK, 6, 1, HEAP_ID_116);
    GfGfx_EngineATogglePlanes(GX_PLANEMASK_BG0, GF_PLANE_TOGGLE_ON);
    GfGfx_EngineATogglePlanes(GX_PLANEMASK_BG1, GF_PLANE_TOGGLE_ON);
    GfGfx_EngineBTogglePlanes(GX_PLANEMASK_BG0, GF_PLANE_TOGGLE_ON);
    GfGfx_EngineBTogglePlanes(GX_PLANEMASK_BG1, GF_PLANE_TOGGLE_ON);
    GfGfx_EngineATogglePlanes(GX_PLANEMASK_OBJ, GF_PLANE_TOGGLE_ON);
    GfGfx_EngineBTogglePlanes(GX_PLANEMASK_OBJ, GF_PLANE_TOGGLE_ON);
    gSystem.screensFlipped = TRUE;
    GfGfx_SwapDisplay();
    TextFlags_SetCanABSpeedUpPrint(TRUE);
    TextFlags_SetAutoScrollParam(0);
    TextFlags_SetCanTouchSpeedUpPrint(FALSE);
    Main_SetVBlankIntrCB(ov75_02247234, app);
    return TRUE;
}
