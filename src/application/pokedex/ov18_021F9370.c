#include "global.h"

#include "application/pokedex/ov18_021F967C.h"
#include "application/pokedex/pokedex_capture_page.h"

#include "constants/pokemon.h"

typedef char PokedexCapturePageTypeIconsCheck[offsetof(PokedexCapturePage, type2Icon) == 0x218 && offsetof(PokedexCapturePage, type2) == 0x250 ? 1 : -1];

// The capture page's type icons, the first beside the second, which shares the
// first's palette: none for a second type that is the first, nor for a Normal
// one.
void ov18_021F9370(PokedexCapturePage *page) {
    SimpleSpriteTemplate template;
    SpriteResourcesHeader header;

    ov18_021F9310(page->type1IconResources, page->resourceManagers, &header, 1);
    template.spriteList = page->spriteList;
    template.header = &header;
    template.whichScreen = NNS_G2D_VRAM_TYPE_2DMAIN;
    template.priority = 0;
    template.heapID = page->heapId;
    template.position.x = FX32_CONST(168);
    template.position.y = FX32_CONST(72);
    page->type1Icon = Sprite_Create(&template);
    Sprite_SetPalIndexRespectVramOffset(page->type1Icon, ov18_021F9688(page->type1));

    CreateSpriteResourcesHeader(&header, GF2DGfxResObj_GetResID(page->type2IconResources[0]), GF2DGfxResObj_GetResID(page->type1IconResources[1]), GF2DGfxResObj_GetResID(page->type2IconResources[2]), GF2DGfxResObj_GetResID(page->type2IconResources[3]), -1, -1, 0, 1, page->resourceManagers[0], page->resourceManagers[1], page->resourceManagers[2], page->resourceManagers[3], NULL, NULL);
    template.spriteList = page->spriteList;
    template.header = &header;
    template.whichScreen = NNS_G2D_VRAM_TYPE_2DMAIN;
    template.priority = 0;
    template.heapID = page->heapId;
    template.position.x = FX32_CONST(217);
    template.position.y = FX32_CONST(72);
    page->type2Icon = Sprite_Create(&template);
    if (page->type2 == TYPE_NORMAL || page->type1 == page->type2) {
        Sprite_SetDrawFlag(page->type2Icon, FALSE);
    } else {
        Sprite_SetPalIndexRespectVramOffset(page->type2Icon, ov18_021F9688(page->type2));
    }
}
