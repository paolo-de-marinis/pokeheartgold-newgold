#include "global.h"

#include "constants/sprites.h"

#include "map_object.h"
#include "overlay_01_021F72DC.h"

Sprite *sub_02064084(LocalMapObject *obj);

// The sprite a map object is drawn with. The object's sub data keeps it in
// one of two places: a Pokemon walking behind the player keeps it first, and
// everything else second, except the handful of sprites sub_02064084 draws.
// Which is which is decided by the object's sprite ID, and a follower is any
// ID from Bulbasaur's to the last Arceus, or one of the added species'
// after the static Pokemon.
Sprite *ov01_021F72DC(LocalMapObject *obj) {
    int spriteId = MapObject_GetSpriteID(obj);

    switch (spriteId) {
    case 0:
    case 0x15:
    case 0x61:
    case 0x62:
    case 0xB0:
    case 0xB1:
    case 0xB2:
    case 0xB3:
    case 0xB4:
    case 0xB5:
    case 0xBC:
    case 0xBD:
    case 0xC4:
    case 0xC5:
    case 0xC6:
    case 0xC7:
    case 0xC8:
    case 0xC9:
    case 0xF8:
    case 0xF9:
    case 0x102:
    case 0x103:
    case 0x104:
    case 0x105:
        return ((Sprite **)sub_0205F40C(obj))[1];
    }
    if ((spriteId >= SPRITE_FOLLOWER_MON_BULBASAUR && spriteId <= SPRITE_FOLLOWER_MON_ARCEUS_DARK)
        || (spriteId >= SPRITE_FOLLOWER_MON_ADDED_FIRST && spriteId <= SPRITE_FOLLOWER_MON_ADDED_LAST)) {
        return ((Sprite **)sub_0205F40C(obj))[0];
    }
    if (spriteId >= 0x106 && spriteId <= 0x10D) {
        return sub_02064084(obj);
    }
    return ((Sprite **)sub_0205F40C(obj))[1];
}
