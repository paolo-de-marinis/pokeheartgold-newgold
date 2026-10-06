#include "global.h"

#include "bg_window.h"
#include "dsprot.h"
#include "font.h"
#include "heap.h"
#include "message_format.h"
#include "msgdata.h"
#include "sprite_transfer.h"
#include "sprite.h"
#include "sys_task.h"
#include "systask_environment.h"
#include "unk_0200A090.h"

FS_EXTERN_OVERLAY(ds_protect);

// Overlay 27's state, the field's own bottom screen (the touch menu), from
// HEAP_ID_8. Only what the teardown reads is named; the assembly reaches the
// rest by offset.
typedef struct FieldBottomScreenSprite {
    SpriteResource *charRes;
    SpriteResource *plttRes;
    u8 unk8[8];
} FieldBottomScreenSprite;

typedef struct FieldBottomScreen {
    u8 unk0[0x18];
    SpriteList *spriteList;
    u8 unk1C[0x144 - 0x1C];
    GF_2DGfxResMan *resMan[4];
    FieldBottomScreenSprite sprites[11];
    u8 unk204[0x3D0 - 0x204];
    Window window3D0;
    Window window3E0;
    Window windows[8];
    u8 unk470[0x4A8 - 0x470];
    MsgData *msgData;
    MessageFormat *msgFormat;
    u8 unk4B0[0x520 - 0x4B0];
    u8 unk520[1];
} FieldBottomScreen;

void ov27_0225BEB0(void *a0);
void ov27_0225BC34(FieldBottomScreen *screen);
void ov27_0225C238(void);
void ov27_0225C248(void);
void ov27_0225C24C(void);
void ov27_0225A19C(BgConfig *bgConfig, SysTask *task);

void ov27_0225A19C(BgConfig *bgConfig, SysTask *task) {
    FieldBottomScreen *screen = SysTask_GetData(task);
    int i;

    FS_LoadOverlay(MI_PROCESSOR_ARM9, FS_OVERLAY_ID(ds_protect));
    if (DSProt_DetectFlashcart(ov27_0225C238)) {
        Heap_AllocAtEnd(HEAP_ID_3, 1000);
    }
    ov27_0225BEB0(screen->unk520);
    DestroyMsgData(screen->msgData);
    MessageFormat_Delete(screen->msgFormat);
    for (i = 0; i < 11; i++) {
        SpriteTransfer_DeleteCharTransferTask(screen->sprites[i].charRes);
    }
    for (i = 0; i < 11; i++) {
        SpriteTransfer_DeletePlttTransferTask(screen->sprites[i].plttRes);
    }
    for (i = 0; i < 4; i++) {
        Destroy2DGfxResObjMan(screen->resMan[i]);
    }
    if (!DSProt_DetectNotEmulator(ov27_0225C248)) {
        Heap_AllocAtEnd(HEAP_ID_3, 1000);
    }
    SpriteList_Delete(screen->spriteList);
    for (i = 0; i < 8; i++) {
        RemoveWindow(&screen->windows[i]);
    }
    RemoveWindow(&screen->window3E0);
    RemoveWindow(&screen->window3D0);
    ov27_0225BC34(screen);
    FontID_Release(4);
    DestroySysTaskAndEnvironment(task);
    FreeBgTilemapBuffer(bgConfig, GF_BG_LYR_SUB_1);
    FreeBgTilemapBuffer(bgConfig, GF_BG_LYR_SUB_0);
    Heap_Destroy(HEAP_ID_8);
    if (!DSProt_DetectNotDummy(ov27_0225C24C)) {
        Heap_AllocAtEnd(HEAP_ID_3, 1000);
    }
    FS_UnloadOverlay(MI_PROCESSOR_ARM9, FS_OVERLAY_ID(ds_protect));
}
