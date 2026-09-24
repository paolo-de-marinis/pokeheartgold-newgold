#include "global.h"

#include "sprite_system.h"
#include "unk_02077678.h"

// The little icons the battle and the summary screen draw beside a move: the
// one for its type, and the one for whether it is physical, special or
// status. Both live in the same archive, and both are a pair of tables --
// which member of the archive to load, and which of the three palettes in it
// to draw with.
//
// The type table runs one entry a type, TYPE_NORMAL first, and then carries
// five more the contests used: Cool, Beauty, Cute, Smart and Tough, in that
// order, from a generation this game does not hold a contest in. The contest
// block therefore begins at NUMBER_OF_MON_TYPES, which is what the move
// relearner and the battle party menu add to a move's contest type -- the two
// callers that ask this table for something that is not a type.
static const u8 sMoveSplitIconPalettes[] = { 0, 1, 0 };

static const int sMoveSplitIconFiles[] = { 0xF4, 0xF6, 0xF5 };

static const int sTypeIconFiles[] = {
    0xEA,
    0xE1,
    0xE3,
    0xEB,
    0xE5,
    0xED,
    0xE7,
    0xE4,
    0xEE,
    0xEC,
    0xE2,
    0xF1,
    0xE9,
    0xDE,
    0xDF,
    0xE6,
    0xDD,
    0xE0,
    // TYPE_FAIRY. Every icon above is a member of the battle graphics archive
    // that shipped with the game; this one was added to the end of it.
    0x15A,
    0xF0,
    0xDB,
    0xDC,
    0xE8,
    0xEF,
};

static const u8 sTypeIconPalettes[] = {
    0, 0, 1, 1, 0, 0, 2, 1, 0, 2, 0, 1,
    2, 0, 1, 1, 2, 0,
    2, // TYPE_FAIRY, the palette the reference draws its icon against
    0, 1, 1, 2, 0
};

int sub_02077678(int moveType) {
    GF_ASSERT(moveType < NELEMS(sTypeIconFiles));
    return sTypeIconFiles[moveType];
}

int sub_02077690(void) {
    return 0x4A;
}

int sub_02077694(void) {
    return 0xF2;
}

int sub_02077698(void) {
    return 0xF3;
}

int sub_0207769C(int moveType) {
    GF_ASSERT(moveType < NELEMS(sTypeIconPalettes));
    return sTypeIconPalettes[moveType];
}

NarcId sub_020776B4(void) {
    return NARC_a_0_0_8;
}

void sub_020776B8(SpriteSystem *spriteSystem, SpriteManager *spriteManager, NNS_G2D_VRAM_TYPE vramType, int type, int resId) {
    NarcId narcId = sub_020776B4();

    SpriteSystem_LoadCharResObj(spriteSystem, spriteManager, narcId, sub_02077678(type), TRUE, vramType, resId);
}

void sub_020776EC(SpriteSystem *spriteSystem, SpriteManager *spriteManager, NNS_G2D_VRAM_TYPE vramType, int resId) {
    NarcId narcId = sub_020776B4();

    SpriteSystem_LoadPlttResObj(spriteSystem, spriteManager, narcId, sub_02077690(), FALSE, 3, vramType, resId);
}

void sub_02077720(PaletteData *paletteData, PaletteBufferId bufferId, SpriteSystem *spriteSystem, SpriteManager *spriteManager, int vramType, int resId) {
    NarcId narcId = sub_020776B4();

    SpriteSystem_LoadPaletteBuffer(paletteData, bufferId, spriteSystem, spriteManager, narcId, sub_02077690(), FALSE, 3, vramType, resId);
}

void sub_0207775C(SpriteSystem *spriteSystem, SpriteManager *spriteManager, int cellResId, int animResId) {
    SpriteSystem_LoadCellResObj(spriteSystem, spriteManager, sub_020776B4(), sub_02077694(), TRUE, cellResId);
    SpriteSystem_LoadAnimResObj(spriteSystem, spriteManager, sub_020776B4(), sub_02077698(), TRUE, animResId);
}

void sub_020777A4(SpriteManager *spriteManager, int character) {
    SpriteManager_UnloadCharObjById(spriteManager, character);
}

void sub_020777AC(SpriteManager *spriteManager, int pal) {
    SpriteManager_UnloadPlttObjById(spriteManager, pal);
}

void sub_020777B4(SpriteManager *spriteManager, int cell, int animation) {
    SpriteManager_UnloadCellObjById(spriteManager, cell);
    SpriteManager_UnloadAnimObjById(spriteManager, animation);
}

ManagedSprite *sub_020777C8(SpriteSystem *spriteSystem, SpriteManager *spriteManager, int type, ManagedSpriteTemplate *spriteTemplate) {
    ManagedSpriteTemplate template = *spriteTemplate;

    template.pal = sub_0207769C(type);
    return SpriteSystem_NewSprite(spriteSystem, spriteManager, &template);
}

void thunk_ManagedSprite_DeleteAndFreeResources(ManagedSprite *managedSprite) {
    Sprite_DeleteAndFreeResources(managedSprite);
}

int sub_02077800(int split) {
    GF_ASSERT(split < NELEMS(sMoveSplitIconFiles));
    return sMoveSplitIconFiles[split];
}

int sub_02077818(int split) {
    GF_ASSERT(split < NELEMS(sMoveSplitIconPalettes));
    return sMoveSplitIconPalettes[split];
}

NarcId sub_02077830(void) {
    return NARC_a_0_0_8;
}

void sub_02077834(SpriteSystem *spriteSystem, SpriteManager *spriteManager, NNS_G2D_VRAM_TYPE vramType, int split, int resId) {
    NarcId narcId = sub_02077830();

    SpriteSystem_LoadCharResObj(spriteSystem, spriteManager, narcId, sub_02077800(split), TRUE, vramType, resId);
}

void sub_02077868(SpriteManager *spriteManager, int character) {
    SpriteManager_UnloadCharObjById(spriteManager, character);
}

void sub_02077870(ManagedSprite *managedSprite) {
    Sprite_DeleteAndFreeResources(managedSprite);
}
