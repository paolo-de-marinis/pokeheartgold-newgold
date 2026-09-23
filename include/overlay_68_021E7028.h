#ifndef POKEHEARTGOLD_OVERLAY_68_021E7028_H
#define POKEHEARTGOLD_OVERLAY_68_021E7028_H

#include "move_relearner.h"
#include "sprite_system.h"

typedef struct MoveRelearnerApp {
    MoveRelearnerArgs *args;
    u8 filler_004[0x118];
    SpriteSystem *spriteSystem;
    SpriteManager *spriteManager;
    ManagedSprite *sprites[];
} MoveRelearnerApp;

void ov68_021E7028(MoveRelearnerApp *app, u16 move, u16 idx);

#endif // POKEHEARTGOLD_OVERLAY_68_021E7028_H
