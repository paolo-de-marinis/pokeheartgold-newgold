#include "global.h"

#include "application/pokedex/pokedex_capture_page.h"

#include "filesystem.h"
#include "heap.h"
#include "sound_02004A44.h"
#include "sprite.h"
#include "sys_task_api.h"
#include "unk_02005D10.h"

static void ov18_021F89F8(SysTask *task, void *data);

// The page opens with the battle's data, and runs as a task of its own until
// the battle ends it.
PokedexCapturePage *ov18_021F8974(UnkStruct_50C *unkStruct) {
    PokedexCapturePage *page = Heap_Alloc(unkStruct->heapID, sizeof(PokedexCapturePage));

    memset(page, 0, sizeof(PokedexCapturePage));
    memcpy(page, unkStruct, sizeof(UnkStruct_50C));
    page->narc = NARC_New(NARC_graphic_zukan_gra, page->heapId);
    page->state = 0;
    page->done = FALSE;
    page->task = SysTask_CreateOnMainQueue(ov18_021F89F8, page, 0);
    return page;
}

BOOL ov18_021F89C8(PokedexCapturePage *page) {
    return page->done;
}

void ov18_021F89D0(PokedexCapturePage *page) {
    DexEntryPages_Stop(&page->entryPages);
    ov18_021F91F0(page);
    ov18_021F8F10(page);
    ov18_021F8BEC(page);
    NARC_Delete(page->narc);
    SysTask_Destroy(page->task);
    Heap_Free(page);
}

// Draws the page and fades it in, then plays the species' cry; the battle
// waits for the cry before it lets the player dismiss the page. The entry
// turns its pages meanwhile, and until the battle ends the page.
static void ov18_021F89F8(SysTask *task, void *data) {
    PokedexCapturePage *page = data;

    switch (page->state) {
    case 0:
        G2_BlendNone();
        ov18_021F8AB8(page);
        ov18_021F8B10(page);
        ov18_021F8CCC(page);
        ov18_021F8FA0(page);
        ov18_021F95CC(page);
        ov18_021F8C0C(page);
        page->state = 1;
        break;
    case 1:
        if (ov18_021F8C48(page) == TRUE) {
            page->state = 2;
        }
        break;
    case 2:
        PlayCryEx(14, (u16)page->species, 0x1FF, 0x1FF, 0x1FF, 0);
        page->state = 3;
        break;
    case 3:
        if (IsCryFinished() == FALSE) {
            page->done = TRUE;
            page->state = 4;
        }
        break;
    case 4:
        break;
    }
    DexEntryPages_Update(&page->entryPages);
    SpriteList_RenderAndAnimateSprites(page->spriteList);
    ov18_021F8C68(page);
}
