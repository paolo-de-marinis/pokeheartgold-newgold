#include "gf_gfx_planes.h"
#include "heap.h"
#include "overlay_14.h"
#include "system.h"
#include "unk_020210A0.h"

// Sets the PC box application's screens up and allocates its graphics state.
int ov14_021EAFAC(PCBoxApp *app) {
    Main_SetVBlankIntrCB(NULL, NULL);
    HBlankInterruptDisable();
    GfGfx_EngineASetPlanes(0);
    GfGfx_EngineBSetPlanes(0);
    G2_BlendNone();
    G2S_BlendNone();
    sub_020210BC();
    sub_02021148(4);
    GX_SetDispSelect(GX_DISP_SELECT_SUB_MAIN);
    Heap_Create(HEAP_ID_3, HEAP_ID_10, 0x80000);
    app->graphics = Heap_Alloc(HEAP_ID_10, 0x88E0);
    MI_CpuFill8(app->graphics, 0, 0x88E0);
    app->graphics->narc450 = NARC_New(NARC_poketool_personal_personal, HEAP_ID_10);
    app->graphics->narc454 = NARC_New(NARC_poketool_icongra_poke_icon, HEAP_ID_10);
    ov14_021E5A60();
    ov14_021E5A70(app);
    ov14_021E5E74(app);
    ov14_021E5C54(app);
    ov14_021E5D78(app);
    ov14_021E5DE0(app);
    ov14_021F4ED0(app);
    ov14_021F297C(app);
    ov14_021F2F20(app);
    ov14_021F2F3C(app);
    ov14_021E783C(app, ov14_021E7930(app, app->curBox), 2);
    ov14_021E7BA4(app);
    if (app->args->unk8 != 1 && app->args->unk8 != 0) {
        ov14_021E81FC(app);
        ov14_021E825C(app);
    }
    ov14_021E82BC(app);
    ov14_021E5ED0(app);
    ov14_021F5620(app);
    ov14_021F566C(app);
    ov14_021F49C8(app);
    ov14_021F6A44(app);
    app->graphics->vblankTask = SysTask_CreateOnVBlankQueue(ov14_021E59AC, app, 0);
    ov14_021E5EAC(1);
    return app->unk30;
}
