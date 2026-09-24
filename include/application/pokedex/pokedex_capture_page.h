#ifndef POKEHEARTGOLD_APPLICATION_POKEDEX_POKEDEX_CAPTURE_PAGE_H
#define POKEHEARTGOLD_APPLICATION_POKEDEX_POKEDEX_CAPTURE_PAGE_H

#include "global.h"

#include "overlay_18.h"

// The capture page's data. The first six fields are the UnkStruct_50C the
// battle hands ov18_021F8974, copied as they are.
struct PokedexCapturePage {
    BgConfig *bgConfig;             // 0x000
    PaletteData *paletteData;       // 0x004
    PokepicManager *pokepicManager; // 0x008
    Pokemon *mon;                   // 0x00C
    BOOL natDexEnabled;             // 0x010
    enum HeapID heapId;             // 0x014
    SysTask *task;                  // 0x018
    NARC *narc;                     // 0x01C
    Pokepic *pokepic;               // 0x020
    Window windows[9];              // 0x024
    SpriteList *spriteList;         // 0x0B4
    u8 unk0B8[0x188];
    u16 state;                      // 0x240
    u16 blinkTimer;                 // 0x242
    u32 species;                    // 0x244
    u32 unk248;
    u32 unk24C;
    u32 unk250;
    BOOL done;                      // 0x254: the cry has played
}; // size: 0x258

void ov18_021F8AB8(PokedexCapturePage *page);
void ov18_021F8B10(PokedexCapturePage *page);
void ov18_021F8BEC(PokedexCapturePage *page);
void ov18_021F8C0C(PokedexCapturePage *page);
BOOL ov18_021F8C48(PokedexCapturePage *page);
void ov18_021F8C68(PokedexCapturePage *page);
void ov18_021F8CCC(PokedexCapturePage *page);
void ov18_021F8F10(PokedexCapturePage *page);
void ov18_021F8FA0(PokedexCapturePage *page);
void ov18_021F91F0(PokedexCapturePage *page);
void ov18_021F95CC(PokedexCapturePage *page);

#endif // POKEHEARTGOLD_APPLICATION_POKEDEX_POKEDEX_CAPTURE_PAGE_H
