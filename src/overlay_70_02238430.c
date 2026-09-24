#include "global.h"

#include "constants/sndseq.h"

#include "msgdata/msg.naix"

#include "bg_window.h"
#include "font.h"
#include "gf_gfx_planes.h"
#include "heap.h"
#include "message_format.h"
#include "msgdata.h"
#include "overlay_70.h"
#include "render_text.h"
#include "sound_02004A44.h"
#include "system.h"
#include "unk_02034B0C.h"
#include "unk_02037C94.h"
#include "unk_020915B0.h"

typedef struct Overlay70Globals {
    u8 unk0[4];
    GtsWork *work;
    u8 unk8[0x1C - 0x8];
} Overlay70Globals;

extern Overlay70Globals ov70_02246944;
extern const GraphicsModes ov70_022451F8;
extern void ov70_02238880(void);
extern void ov70_02238818(GtsWork *work, OverlayManager *man);
extern void ov70_02238E70(GtsWork *work);
extern void LoadOVY38(void);

// The Global Trade Station starts: its heap, the DWC library and its heap,
// the state, the screens and the text it prints -- its own lines, the
// species names and three more banks. The species names are opened lazily,
// a line at a time: whole, the bank is a line per species and form (36,302
// bytes, retail's 12,180), and the station prints one name at a time.
BOOL ov70_02238430(OverlayManager *man, int *state) {
    GtsWork *work;

    switch (*state) {
    case 0: {
        Main_SetVBlankIntrCB(NULL, NULL);
        HBlankInterruptDisable();
        GfGfx_DisableEngineAPlanes();
        GfGfx_DisableEngineBPlanes();
        GX_SetVisiblePlane(0);
        GXS_SetVisiblePlane(0);
        ov70_02238880();
        Heap_Create(HEAP_ID_3, HEAP_ID_61, 0x70000);
        LoadDwcOverlay();
        LoadOVY38();
        sub_02039FD8(HEAP_ID_61);
        work = OverlayManager_CreateAndGetData(man, sizeof(GtsWork), HEAP_ID_61);
        memset(work, 0, sizeof(GtsWork));
        work->bgConfig = BgConfig_Alloc(HEAP_ID_61);
        ov70_02246944.work = work;
        GraphicsModes modes = ov70_022451F8;
        SetBothScreensModesAndDisable(&modes);
        FontID_Alloc(4, HEAP_ID_61);
        work->msgFormat = MessageFormat_New_Custom(11, 64, HEAP_ID_61);
        work->msgData = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0775_bin, HEAP_ID_61);
        work->unkBA8 = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0778_bin, HEAP_ID_61);
        work->unkBAC = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0800_bin, HEAP_ID_61);
        work->speciesNames = NewMsgDataFromNarc(MSGDATA_LOAD_LAZY, NARC_msgdata_msg, NARC_msg_msg_0237_bin, HEAP_ID_61);
        work->unkBB0 = NewMsgDataFromNarc(MSGDATA_LOAD_DIRECT, NARC_msgdata_msg, NARC_msg_msg_0798_bin, HEAP_ID_61);
        SetKeyRepeatTimers(4, 8);
        ov70_02238818(work, man);
        ov70_02238E70(work);
        Sound_SetSceneAndPlayBGM(11, SEQ_GS_WIFI_ACCESS, 1);
        work->dwcHeapMemory = Heap_Alloc(HEAP_ID_61, 0x20020);
        work->dwcHeap = NNS_FndCreateExpHeapEx((void *)(((u32)work->dwcHeapMemory + 31) & ~31), 0x20000, 0);
        *state = 1;
        break;
    }
    case 1:
        sub_02034D8C();
        TextFlags_SetCanTouchSpeedUpPrint(TRUE);
        *state = 0;
        return TRUE;
    }
    return FALSE;
}
