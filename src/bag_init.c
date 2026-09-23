#include "global.h"

#include "constants/sndseq.h"

#include "bag_app_state.h"
#include "bg_window.h"
#include "gf_gfx_planes.h"
#include "heap.h"
#include "overlay_15.h"
#include "render_text.h"
#include "screen_fade.h"
#include "sound_02004A44.h"
#include "system.h"
#include "unk_020210A0.h"
#include "unk_0203A3B0.h"

extern void BagApp_GetSaveStructPtrs(BagAppState *bagApp);
extern void ov15_021F995C(void *bagApp);
extern void ov15_021F9984(void);
extern void ov15_021F99A4(BgConfig *bgConfig);
extern void ov15_021F9AE4(BagAppState *bagApp);
extern void ov15_021F9CBC(BagAppState *bagApp);
extern void ov15_021F9D28(BagAppState *bagApp);
extern void ov15_021F9DB4(BagAppState *bagApp);
extern void ov15_021FA044(s16 *scroll, u16 *position, u8 count);
extern void ov15_021FA070(s16 *scroll, u16 *position, u8 count, int rows);
extern int ov15_021FA074(BagAppState *bagApp);
extern void ov15_021FA170(BagAppState *bagApp);
extern void ov15_021FA620(BagAppState *bagApp);
extern void ov15_021FD404(BagAppState *bagApp, int a1, u8 pocket);
extern void ov15_021FD574(BagAppState *bagApp, int a1, int a2, int a3);
extern void ov15_021FD93C(BagAppState *bagApp);
extern void ov15_021FE020(BagAppState *bagApp);
extern void ov15_021FE4C8(BagAppState *bagApp);
extern void ov15_021FE528(BagAppState *bagApp);
extern void ov15_021FE874(BagAppState *bagApp);
extern void ov15_021FEA5C(BagAppState *bagApp);
extern void ov15_021FF1E0(BagAppState *bagApp);
extern void ov15_021FF29C(BagAppState *bagApp, int a1);
extern void ov15_021FF6BC(BagAppState *bagApp, u8 count, s16 scroll, int a3);
extern void ov15_021FF850(BagAppState *bagApp);
extern void ov15_021FFECC(BagAppState *bagApp, int a1);
extern void ov15_02200030(BagAppState *bagApp, u8 pocket);

BOOL Bag_Init(OverlayManager *manager, int *state) {
    BagAppState *bagApp;

    Main_SetVBlankIntrCB(NULL, NULL);
    HBlankInterruptDisable();
    GfGfx_DisableEngineAPlanes();
    GfGfx_DisableEngineBPlanes();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    G2_BlendNone();
    G2S_BlendNone();
    // hg-engine's heap for the bag, 0x65000 where HeartGold's was 0x42000: the
    // list's strings are 255 of 22 halfwords now, not 165 of 18.
    Heap_Create(HEAP_ID_3, HEAP_ID_6, 0x65000);
    bagApp = OverlayManager_CreateAndGetData(manager, sizeof(BagAppState), HEAP_ID_6);
    memset(bagApp, 0, sizeof(BagAppState));
    bagApp->bagView = OverlayManager_GetArgs(manager);
    BagApp_GetSaveStructPtrs(bagApp);
    bagApp->bgConfig = BgConfig_Alloc(HEAP_ID_6);
    bagApp->trainerGender = PlayerProfile_GetTrainerGender(bagApp->profile);
    BeginNormalPaletteFade(FADE_SUB_THEN_MAIN, FADE_TYPE_DOWNWARD_IN, FADE_TYPE_DOWNWARD_IN, RGB_BLACK, 6, 1, HEAP_ID_6);
    SetKeyRepeatTimers(3, 8);
    ov15_021F9DB4(bagApp);
    ov15_021F9CBC(bagApp);
    ov15_021FA008(bagApp);
    ov15_021F9D28(bagApp);
    ov15_021FA620(bagApp);
    ov15_021F9984();
    ov15_021F99A4(bagApp->bgConfig);
    ov15_021F9AE4(bagApp);
    sub_020210BC();
    sub_02021148(4);
    ov15_021FE020(bagApp);
    TextFlags_SetCanTouchSpeedUpPrint(TRUE);
    ov15_021FE4C8(bagApp);
    ov15_021FE528(bagApp);
    ov15_021FEA5C(bagApp);
    ov15_021FE874(bagApp);
    ov15_021F9F08(bagApp);
    ov15_021FF29C(bagApp, 0);
    ov15_021FA044(&bagApp->bagView->pockets[bagApp->bagView->unk64].scroll, &bagApp->bagView->pockets[bagApp->bagView->unk64].position, bagApp->bagView->pockets[bagApp->bagView->unk64].count);
    ov15_021FA070(&bagApp->bagView->pockets[bagApp->bagView->unk64].scroll, &bagApp->bagView->pockets[bagApp->bagView->unk64].position, bagApp->bagView->pockets[bagApp->bagView->unk64].count, 6);
    ov15_021FF850(bagApp);
    ov15_021FD574(bagApp, 0, ov15_021FA074(bagApp), 0);
    ov15_021FF364(bagApp, bagApp->bagView->pockets[bagApp->bagView->unk64].scroll, -1, FALSE);
    ov15_02200030(bagApp, bagApp->bagView->unk64);
    ov15_021FD404(bagApp, 1, bagApp->bagView->unk64);
    ov15_021FF6BC(bagApp, bagApp->bagView->pockets[bagApp->bagView->unk64].count, bagApp->bagView->pockets[bagApp->bagView->unk64].scroll, 0);
    ov15_02200140(bagApp, &bagApp->bagView->pockets[bagApp->bagView->unk64], ov15_021FA074(bagApp), TRUE);
    bagApp->unk644 = bagApp->bagView->pockets[bagApp->bagView->unk64].position + 8;
    ov15_021FFECC(bagApp, bagApp->unk644);
    ov15_021FA170(bagApp);
    if (bagApp->bagView->unk65 == 4 || bagApp->bagView->unk65 == 5) {
        ov15_021FF1E0(bagApp);
    }
    ov15_021FD93C(bagApp);
    Main_SetVBlankIntrCB(ov15_021F995C, bagApp);
    Sound_SetSceneAndPlayBGM(0x33, SEQ_NONE, 0);
    sub_0203A964();
    GX_SetDispSelect(GX_DISP_SELECT_MAIN_SUB);
    ToggleBgLayer(GF_BG_LYR_SUB_0, GF_PLANE_TOGGLE_ON);
    return TRUE;
}
