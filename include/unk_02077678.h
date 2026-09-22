#ifndef POKEHEARTGOLD_UNK_02077678_H
#define POKEHEARTGOLD_UNK_02077678_H

#include "sprite_system.h"

int sub_02077678(int moveType);
int sub_02077690(void);
int sub_02077694(void);
int sub_02077698(void);
int sub_0207769C(int moveType);
NarcId sub_020776B4(void);
void sub_020776EC(SpriteSystem *spriteSystem, SpriteManager *spriteManager, NNS_G2D_VRAM_TYPE vramType, int resId);
void sub_02077720(PaletteData *paletteData, PaletteBufferId a1, SpriteSystem *spriteSystem, SpriteManager *spriteManager, int a4, int a5);
void sub_0207775C(SpriteSystem *spriteSystem, SpriteManager *spriteManager, int a2, int a3);
void sub_020776B8(SpriteSystem *spriteSystem, SpriteManager *spriteManager, NNS_G2D_VRAM_TYPE vramType, int type, int a4); // load type icon graphics?
int sub_02077800(int split);
int sub_02077818(int split);
NarcId sub_02077830(void);
void sub_02077834(SpriteSystem *spriteSystem, SpriteManager *spriteManager, NNS_G2D_VRAM_TYPE vramType, int split, int resId);
void sub_020777A4(SpriteManager *spriteManager, int a1);
void sub_020777AC(SpriteManager *spriteManager, int a1);
void sub_020777B4(SpriteManager *spriteManager, int a1, int a2);
ManagedSprite *sub_020777C8(SpriteSystem *spriteSystem, SpriteManager *spriteManager, int type, ManagedSpriteTemplate *spriteTemplate);
void thunk_ManagedSprite_DeleteAndFreeResources(ManagedSprite *managedSprite);
void sub_02077870(ManagedSprite *managedSprite);
void sub_02077868(SpriteManager *spriteManager, int a1);

#endif // POKEHEARTGOLD_UNK_02077678_H
