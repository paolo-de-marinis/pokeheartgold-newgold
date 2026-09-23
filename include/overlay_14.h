#ifndef POKEHEARTGOLD_OVY_14_H
#define POKEHEARTGOLD_OVY_14_H

#include "constants/pokemon.h"

#include "menu_input_state.h"
#include "overlay_manager.h"
#include "filesystem.h"
#include "save.h"
#include "sys_task_api.h"
#include "unk_02019BA4.h"

typedef struct PCBoxArgs {
    SaveData *saveData;
    MenuInputStateMgr *menuInputStatePtr;
    int unk8;
} PCBoxArgs;

#define PC_BOX_THUMBNAIL_SIZE 0x400

// The PC box application's graphics state. Only the fields the routines
// decompiled so far read are named; the rest is still addressed by offset in
// the assembly. Its size is the whole state, which ov14_021EAFAC allocates.
typedef struct PCBoxAppGraphics {
    SysTask *vblankTask;
    u8 unk4[0x28];
    GridInputHandler *gridInput; // 0x2C
    u8 unk30[0x2C0];
    void *unk2F0;
    u8 unk2F4[0x148];
    int lastGridInput; // 0x43C
    u8 unk440[0xB];
    u8 unk44B;
    u8 unk44C[4];
    NARC *narc450;
    NARC *narc454;
    u8 unk458[0x3C70];
    // Retail's eighteen box pictures, from 0x40C8 to the fields at 0x88C8.
    // Thirty do not fit there, so the pictures are at the end instead, as in
    // hg-engine, and this is left unused.
    u8 unk40C8[18 * PC_BOX_THUMBNAIL_SIZE];
    u8 unk88C8[0x18];
    // What a box looks like in the box list, one picture per box, past the
    // end of retail's 0x88E0 bytes.
    u8 boxThumbnails[NUM_BOXES][PC_BOX_THUMBNAIL_SIZE]; // 0x88E0
} PCBoxAppGraphics;

// The prefix of the application itself that those routines read; nothing may
// allocate or copy this by its size.
typedef struct PCBoxApp {
    PCBoxArgs *args;
    u8 unk4[0x1B];
    u8 curBox; // 0x1F
    u8 unk20[5];
    u8 listBox; // 0x25, the box the cursor is on in the box list
    u8 unk26[8];
    u8 unk2E[2];
    int unk30;
    PCBoxAppGraphics *graphics; // 0x34
} PCBoxApp;

BOOL PCBox_Init(OverlayManager *man, int *state);
BOOL PCBox_Main(OverlayManager *man, int *state);
BOOL PCBox_Exit(OverlayManager *man, int *state);

void ov14_021E59AC(SysTask *task, void *data);
void ov14_021E5A50(PCBoxAppGraphics *graphics, void (*func)(PCBoxApp *app));
void ov14_021E5A60(void);
void ov14_021E5A70(PCBoxApp *app);
void ov14_021E5C54(PCBoxApp *app);
void ov14_021E5D78(PCBoxApp *app);
void ov14_021E5DE0(PCBoxApp *app);
void ov14_021E5E74(PCBoxApp *app);
void ov14_021E5EAC(int a0);
void ov14_021E5ED0(PCBoxApp *app);
void ov14_021E783C(PCBoxApp *app, void *boxData, int direction);
void *ov14_021E7930(PCBoxApp *app, int box);
void ov14_021E7BA4(PCBoxApp *app);
void ov14_021E81FC(PCBoxApp *app);
void ov14_021E8248(void *a0);
void ov14_021E825C(PCBoxApp *app);
void ov14_021E82A8(void *a0);
void ov14_021E82BC(PCBoxApp *app);
void ov14_021E84A4(void *a0);
int ov14_021E8544(void *a0);
void ov14_021E92AC(PCBoxApp *app);
void ov14_021E9370(PCBoxApp *app);
void ov14_021E9F20(PCBoxApp *app);
int ov14_021EAFAC(PCBoxApp *app);
void ov14_021F0234(PCBoxApp *app, void (*func)(PCBoxApp *app), int a2);
void ov14_021F028C(PCBoxApp *app, int a1);
void ov14_021F0314(PCBoxApp *app, int a1);
void ov14_021F1004(PCBoxApp *app, int direction);
void ov14_021F297C(PCBoxApp *app);
void ov14_021F29E4(PCBoxAppGraphics *graphics, int a1, int a2);
void ov14_021F2C1C(PCBoxAppGraphics *graphics, int a1, void *src, u32 size);
void ov14_021F2DE8(PCBoxApp *app, int box);
void ov14_021F2F20(PCBoxApp *app);
void ov14_021F2F3C(PCBoxApp *app);
void ov14_021F4848(PCBoxApp *app);
void ov14_021F48B4(PCBoxApp *app);
void ov14_021F46B0(PCBoxApp *app, void *dest, void *boxData, int a3, u32 size);
void ov14_021F4958(PCBoxApp *app, u32 box);
void ov14_021F49C8(PCBoxApp *app);
void ov14_021F49E0(PCBoxApp *app);
void ov14_021F4A20(PCBoxApp *app, u32 box);
void ov14_021F4A64(PCBoxApp *app, u32 box, void *dest);
void ov14_021F4ED0(PCBoxApp *app);
void ov14_021F5620(PCBoxApp *app);
void ov14_021F566C(PCBoxApp *app);
void ov14_021F57B8(PCBoxApp *app);
void ov14_021F6A44(PCBoxApp *app);
void ov14_021F6D14(void *data, int newTarget, int prevTarget);
void ov14_021F7184(void *data, int newTarget, int prevTarget);
void ov14_021F7700(void *data, int newTarget, int prevTarget);
void ov14_021F7AC4(PCBoxAppGraphics *graphics, int newTarget, int prevTarget);

#endif // POKEHEARTGOLD_OVY_14_H
