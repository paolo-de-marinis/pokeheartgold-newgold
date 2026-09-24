#include "global.h"

#include "constants/moves.h"
#include "constants/pokemon.h"

#include "move.h"
#include "sprite_system.h"

#define MOVE_TYPES_SPRITES_OFFSET          21
#define MOVE_TO_LEARN_TYPE_SPRITE_INDEX    (MOVE_TYPES_SPRITES_OFFSET + MAX_MON_MOVES)
#define MOVE_TYPES_CHAR_RESOURCE_ID_OFFSET 0xB010

// The battle's party menu, as far as its move pages use it. The names are
// Platinum's (pret/pokeplatinum, battle_party.h), whose menu this is.
typedef struct BattlePartyPokemonMove {
    u16 move;
    u8 currentPP;
    u8 maxPP;
    u8 type;
    u8 class;
    u8 accuracy;
    u8 power;
} BattlePartyPokemonMove;

typedef struct BattlePartyPokemon {
    u8 filler_00[0x30];
    BattlePartyPokemonMove moves[MAX_MON_MOVES];
} BattlePartyPokemon; // size: 0x50

typedef struct BattlePartyContext {
    u8 filler_00[0x11];
    u8 selectedPartyIndex;
    u8 filler_12[0x12];
    u16 moveToLearn;
} BattlePartyContext;

typedef struct BattleParty {
    BattlePartyContext *context;
    BattlePartyPokemon partyPokemon[PARTY_SIZE];
    u8 filler_1E4[0x1DD0];
    SpriteManager *spriteManager;
    ManagedSprite *sprites[MOVE_TO_LEARN_TYPE_SPRITE_INDEX + 1]; // and more past these
} BattleParty;

typedef struct SpritePosition {
    int x;
    int y;
} SpritePosition;

extern const SpritePosition ov08_0222550C[MAX_MON_MOVES + 1];

void ov08_02220A8C(ManagedSprite *sprite, const int x, const int y);
void ov08_02220AEC(BattleParty *battleParty, ManagedSprite *sprite, u32 resourceID, u8 type);
void ov08_02221328(BattleParty *battleParty);

// The icons of the move pages in contest mode: each move's contest condition
// instead of its type. They come from the type icon table (sub_02077678),
// which holds the five conditions after the types, so a condition is looked
// up past the last type -- NUMBER_OF_MON_TYPES, as the move relearner does.
// Retail added 18, its count of types, which with the Fairy type at 18 gave
// Cool the Fairy icon and every other condition the icon of the one before
// it. This game never shows them: the pages switch to contest mode only when
// the high nibble of the byte at 0x2077 is set (Platinum's
// hasVisitedContestHall), and ov08_0221BE20 clears it and nothing sets it.
void ov08_02221328(BattleParty *battleParty) {
    BattlePartyPokemon *pokemon = &battleParty->partyPokemon[battleParty->context->selectedPartyIndex];

    for (u16 i = 0; i < MAX_MON_MOVES; i++) {
        if (pokemon->moves[i].move == MOVE_NONE) {
            continue;
        }
        ov08_02220AEC(battleParty, battleParty->sprites[MOVE_TYPES_SPRITES_OFFSET + i], MOVE_TYPES_CHAR_RESOURCE_ID_OFFSET + i, GetMoveAttr(pokemon->moves[i].move, MOVEATTR_CONTEST_TYPE) + NUMBER_OF_MON_TYPES);
        ov08_02220A8C(battleParty->sprites[MOVE_TYPES_SPRITES_OFFSET + i], ov08_0222550C[i].x, ov08_0222550C[i].y);
    }

    if (battleParty->context->moveToLearn != MOVE_NONE) {
        ov08_02220AEC(battleParty, battleParty->sprites[MOVE_TO_LEARN_TYPE_SPRITE_INDEX], MOVE_TYPES_CHAR_RESOURCE_ID_OFFSET + MAX_MON_MOVES, GetMoveAttr(battleParty->context->moveToLearn, MOVEATTR_CONTEST_TYPE) + NUMBER_OF_MON_TYPES);
        ov08_02220A8C(battleParty->sprites[MOVE_TO_LEARN_TYPE_SPRITE_INDEX], 88, 176);
    }
}
